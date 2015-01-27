---
title: "Vodafone Spain's web blocking system"
published: true
tags:
- censorship
---



Vodafone Spain is deploying a new web blocking system dubbed Castor. This is the first time that a Spanish ISP has taken the web blocking beyond the DNS or IP level. They're performing large-scale [Man-in-the-Middle attacks](http://en.wikipedia.org/wiki/Man-in-the-middle_attack), intercepting HTTP requests to some website's IPs and serving an HTML redirect to their blocking system instead.

The blocking system has received a lot of public exposure when [The Pirate Bay](https://thepiratebay.se) was included in the blocking list. The block affected only a few broadband customers since December 2014, but on January 26th the block was deployed to the whole Vodafone network, affecting most (if not all) customers.

*Update: as of January 27th, the Vodafone Spain unblocked The Pirate Bay until it receives a court order.*

Vodafone Spain has depoloyed a [Deep Packet Inspection (DPI)](http://en.wikipedia.org/wiki/Deep_packet_inspection) for *parental control* by [Optenet](http://www.optenet.es/en-us/) under codename [Castor](http://castor.vodafone.es). This system inspects HTTP traffic from every Vodafone customer looking for patterns that match some rules. In this case, it intercepted HTTP request with the header `Host: thepiratebay.se`.

In a way, this is much more sophisticated than the traditional DNS or IP block. However, it's still completely ineffective: HTTPS traffic is not affected, http://thepiratebay.se is blocked, but http**s**://thepiratebay.se is not.

## More info

**More on the TPB block by Vodafone Spain:**

- [TorrentFreak: Spanish Government orders Pirate Bay blockade](http://torrentfreak.com/spanish-government-orders-pirate-bay-blockade-150127/) ([archive](https://archive.today/uHWJw))
- [Bitcloud: Censura de Vodafone Fibra](http://www.bitcloud.es/2014/12/censura-de-vodafone-fibra.html?m=1) ([archive](https://archive.today/Xd32N)) *(Spanish)*

**More on Optenet's and Vodafone's DPI systems:**

- [Optenet: WebFilter - Internet Filtering & Application Management](http://www.optenet.es/en-us/webfilter.asp) ([archive](https://archive.today/tYmk2)
- [Optenet: Multitenant Internet Security Solutions for Telco](http://www.optenet.es/en-us/solutions-telecom.asp) ([archive](https://archive.today/Sjt3G)
- [Broadband Traffic Management: DPI Deployments (74): Vodafone Turkey Uses Optenet and Allot for Web Filtering](http://broabandtrafficmanagement.blogspot.com.es/2011/06/dpi-deployments-74-vodafone-turkey-uses.html) ([archive](https://archive.today/LqinI))

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

The redirection goes to [castor.vodafone.es](castor.vodafone.es) (212.73.40.87) a server running Optenet Web Server.

A request to google.com adding the HTTP header "Host: thepiratebay.org" triggers the redirection too:

```bash
$ curl -v -H "Host: thepiratebay.org" http://google.com
* About to connect() to google.com port 80 (#0)
*   Trying 216.58.211.206... connected
> GET / HTTP/1.1
> User-Agent: curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3
> Accept: */*
> Host: thepiratebay.org
> 
< HTTP/1.1 200 OK
< Pragma: no-cache
< Cache-Control: no-cache
< Expires: -1
< Content-Length: 640
< Content-Type: text/html
< 
<html><head><meta http-equiv="refresh" content="0; url=http://castor.vodafone.es/public/stoppages/stop.htmopt?CAT=%5Bp2p_servers-lg%7CVDFLegal-lu%5D&RULE=%5BPoliticaLegal%5D&DATETIME=%5B27/Jan/2015:00:03:57%5D&FILE=-&CODE=06de8af1c97a80496a77a83eba063d40fee3f29ce9f246546bf8b3237503f730a902db232a8b86f9d577b9f62db0c7e8e959f5fd91ea8f8e3607d4c824db1d8f79ef996cba9b33da07a38f63c32211bd39275e99f61120df&LANG=esp&optcheckwfsp=%29%3E%E8%05%EB%E5%A5%2C%2BA%AF%A8u%F7%C1%17%B87%C1e&URL=http://thepiratebay.org/&ui=D6Ime4pzx5jhP%2FHbLzMZomjBakeo0jkVKrJXvhphCbORHbWu7q6J638wQ702CwB1&IP=077.231.234.167&USER=-&CLIENTID=-"></head><body></body></html>
* Connection #0 to host google.com left intact
* Closing connection #0
```
