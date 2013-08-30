--- 
title: "Unlocking data: Power generation statistics in Spain"
published: true
tags:
- unlocking-data
- open-data
- projects
- graphs
- soap
---

*TL;DR: Spanish Government has a web service to query power generation statistics. But it is locked behind some obscurity and lack of docs. I have put together some scripts to fetch all raw data. [Fork it on GitHub](http://smola.github.io/ree-demanda) or [download a CSV with all historic data](http://smola.github.io/ree-demanda/generation_demand_full.csv).*

For some time, I have been increasingly interested in electricity demand statistics. Some witty folks are using **[demanda.ree.es](http://demanda.ree.es/demanda.html), a Flash visualizer for power generation and demand in Spain**, to measure interesting stuff such as the impact of turn-off-the-lights protests or solidarity acts ([1](http://rinzewind.org/archives/2007/02/01/felicidades-han-sido-ustedes-un-glitch-en-el-sistema/)) or the success of a general strike ([1](http://politikon.es/2012/03/29/estimando-el-seguimiento-de-la-huelga-en-tiempo-real/), [2](http://rinzewind.org/archives/2012/11/14/y-asi-va-la-huelga-respecto-a-huelgas-anteriores/), [3](http://politikon.es/2012/11/29/como-estimar-el-impacto-de-una-huelga-via-demanda-electrica/)). These uses are really exciting and I think we can get much more out of this kind of data. **So I decided to provide easy access to it.**

## How?

Let's go to [http://demanda.ree.es/demanda.html](http://demanda.ree.es/demanda.html) and fire up Google Developer Tools.

```
GET https://demanda.ree.es/WSVisionaV01/wsDemanda30Service?WSDL
GET https://demanda.ree.es/WSVisionaV01/wsDemanda30FinoService?WSDL
GET https://demanda.ree.es/WSVisionaV01/wsDemanda30Service?xsd=1
GET https://demanda.ree.es/WSVisionaV01/wsDemanda30FinoService?xsd=1
POST https://demanda.ree.es/WSVisionaV01/wsDemanda30FinoService
POST https://demanda.ree.es/WSVisionaV01/wsDemanda30Service
POST https://demanda.ree.es/WSVisionaV01/wsDemanda30FinoService
POST https://demanda.ree.es/WSVisionaV01/wsDemanda30FinoService
```

Great! It's just a SOAP web service. This is going to be easy. A Python script using [suds](https://fedorahosted.org/suds/) will do... well, *not so fast*.

The first request is a call to the `consultaTiempo`, a method that returns the current time. It works. But the rest of methods require a parameter `clave` (Spanish for `key`). *Dammit*. And it's not just some constant API key that I can copy from Developer Tools to my script. It changes every few seconds and the older ones are no longer valid. Every time there is a call to `consultaTiempo`, the key changes. Hey! That means it's time-based!

After a quick analysis between some timestamps and their corresponding times, I realize that keys increase at a constant rate and they are strongly correlated to the timestamp. Each unit increase in the key corresponds to roughly 1 second in time. But I cannot figure it out.

So I downloaded the [swf](https://demanda.ree.es/VisionaFlexCO2.swf) and disasembled the code with [swftools](http://swftools.org/)'s swfdump.

Here it is. It always calls the `consultaTiempo` method just before retrieving some data:

```
00024) + 1:1 pushstring "consultaTiempo"
00025) + 2:1 findpropstrict <q>[private]VisionaFlexCO2::_VisionaFlexCO2_Operation2_c
00026) + 3:1 callproperty <q>[private]VisionaFlexCO2::_VisionaFlexCO2_Operation2_c, 0 params
00027) + 3:1 pushstring "prevProgFino"
...
00030) + 5:1 pushstring "valoresMaxMinFino"
```

Following the function calls, I get to a function called `prueba` (Spanish for `test`). That's funny. It looks as if they "ofuscated" the key-generation function under a non-important name. But the key is generated there, and it seems an easy operation:

```
00023) + 0:1 getlocal_2
00024) + 1:1 pushbyte 5
00025) + 2:1 dup.
00026) + 3:1 callproperty <q>[namespace]http://adobe.com/AS3/2006/builtin::substr, 2 params
00027) + 1:1 coerce_s
00028) + 1:1 setlocal_2
00030) + 0:1 findpropstrict <q>[public]::parseFloat
00031) + 1:1 getlocal_2
00032) + 2:1 callproperty <q>[public]::parseFloat, 1 params
00033) + 1:1 convert_d
00034) + 1:1 setlocal_3
00036) + 0:1 getlocal_3
00037) + 1:1 pushdouble 1.307000
00038) + 2:1 divide.
00039) + 1:1 convert_d
00040) + 1:1 setlocal_3
00042) + 0:1 getlocal_3
00043) + 1:1 convert_i
00044) + 1:1 setlocal r4
00046) + 0:1 findproperty <q>[private]VisionaFlexCO2::clave
```

Ok. Got it. So I already have the Python equivalent:

```python
key = str(int(float(timestamp[5:10])/ 1.307000))
```

Yay! It works! The only thing missing are a few SOAP calls and some boring JSON dumping code.

## Show me the code!

The resulting script for fetching all historic data and generatic some graphs can be found in [ree-demanda repo at GitHub](https://github.com/smola/ree-demanda). Everything it's pretty basic, but it gets the job done.

## Data, NOW

I fetched all historic data from the web service and consolidated it in a single CSV file. You can find it at [https://github.com/smola/ree-demanda](https://github.com/smola/ree-demanda). I plan to update it regularly and, eventually, set up a simple REST API to query it. In the mean time, if you find it is outdated, poke me at santi@mola.io and I will update it.

## Visualization example

Here is a visual example of the data. Power generated since 2007 in Spain. Each line is a different power source. Data is relative to the total power demand at a given time.

![Power generation by source in Spain; 2007-2013](/img/ree_monthly_relative.png)

## Ideas?

What would you do with this data? Are you interested in a specific graph, crossing it with other data sources? Would it be useful for an online service? What knowledge can be obtained out of it?

If you have any idea, please, use the comments or write me at santi@mola.io.

