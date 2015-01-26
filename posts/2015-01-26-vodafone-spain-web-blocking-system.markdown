--- 
title: "Vodafone Spain's web blocking system"
published: true
tags:
- censorship
---

**This is a work in progress. I'll update it with more info as soon as I get it. If you have more info, you can tell me at [@mola_io](http://twitter.com/mola_io), at the comments section or at santi@mola.io.**

Vodafone Spain is deploying a web blocking system dubbed Castor. This is the first time that a Spanish ISP has taken the web blocking beyond the DNS level: they're performing large-scale [Man-in-the-Middle attacks](http://en.wikipedia.org/wiki/Man-in-the-middle_attack), intercepting HTTP requests to some website's IPs and serving an HTML redirect to their blocking system instead.

**Read more about the technical details at the end of this post.**

Here's a compilation of the sites blocked by Vodafone Spain.

## Category: p2p\_servers-lg

- [The Pirate Bay](http://thepiratebay.org): thepiratebay.org, thepiratebay.se.


## More info

- [Bitcloud: Censura de Vodafone Fibra](http://www.bitcloud.es/2014/12/censura-de-vodafone-fibra.html?m=1) *(Spanish)*

## The technical details

Here's a sample of what we get when we perform a request to thepiratebay.org (with DNS resolving to the right IP):

```bash
$ curl -v http://thepiratebay.org
* About to connect() to thepiratebay.org port 80 (#0)
*   Trying 80.92.65.144... connected
> GET / HTTP/1.1
> User-Agent: curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
> Host: thepiratebay.org
> Accept: */*
> 
< HTTP/1.1 200 OK
< Pragma: no-cache
< Cache-Control: no-cache
< Expires: -1
< Content-Length: 640
< Content-Type: text/html
< 
<html><head><meta http-equiv="refresh" content="0; url=http://castor.vodafone.es/public/stoppages/stop.htmopt?CAT=%5Bp2p_servers-lg%7CVDFLegal-lu%5D&RULE=%5BPoliticaLegal%5D&DATETIME=%5B26/Jan/2015:23:32:14%5D&FILE=-&CODE=06de8af1c97a7e4a6a74a83eba063d40fee3f29ce9f246546bf8b3237503f730a902db232a8b86f9d577b9f62db0c7e8e959f5fd91ea8f8e3607d4c824db1d8f79ef996cba9b33da07a38f63c32211bd39275e99f61120df&LANG=esp&optcheckwfsp=%29%3E%E8%05%EB%E5%A5%2C%2BA%AF%A8u%F7%C1%17%B87%C1e&URL=http://thepiratebay.org/&ui=D6Ime4pzx5jhP%2FHbLzMZomjBakeo0jkVKrJXvhphCbORHbWu7q6J638wQ702CwB1&IP=077.231.234.167&USER=-&CLIENTID=-"></head><body></body></html>
* Connection #0 to host thepiratebay.org left intact
* Closing connection #0
```
