--- 
title: "galimatias — The URL Parser For Java"
published: true
tags:
- galimatias
- open-source
- projects
- java
- url
- whatwg
- standards
- web
---

Today, I have released the 0.1.0 version of [galimatias](http://galimatias.mola.io) — The URL Parser For Java. Now that I left the 0.0.x world behind, it's a good time for a post.

Parsing a URL is supposed to be an easy task. It's supposed to be working out of the box by the standard libraries of most programming languages. But the fact is that it isn't something widely supported.

Over the years, web authors have produced all kind of URLs using different features, funky characters, unescaped non-ASCII characters, partially broken constructs, internationalized domain names (AKA [IDNA Hell](http://annevankesteren.nl/2014/06/url-unicode)), etcetera. StackOverflow is [full](http://stackoverflow.com/questions/161738/what-is-the-best-regular-expression-to-check-if-a-string-is-a-valid-url/190405#190405) [of](http://stackoverflow.com/questions/3138941/how-to-verify-that-url-is-valid-in-java-1-6/22482467#22482467) [cases](http://stackoverflow.com/questions/1178024/can-a-url-contain-a-semi-colon/1178053#1178053) [illustrating](http://stackoverflow.com/questions/6868373/url-error-exceptionillegal-character-in-query-at-index-185) [this](http://stackoverflow.com/questions/1547899/which-characters-make-a-url-invalid/13500078#13500078).

Web browsers have added more and more cases in order to support all cases. And now, there is finally a proper [URL Standard](http://url.spec.whatwg.org) by the WHATWG which is gaining traction among web browser vendors. But non-browser libraries are falling behind.

[galimatias](http://galimatias.mola.io) born to fill this gap in the JVM world. Some highlights:

- If a web browser can parse a URL as found in the wild, galimatias can parse it too.
- Provides efficient tools for further normalization of URL beyond parsing,
  which are particularly useful for web crawlers.
- It's used by the [HTML5 validator](http://validator.nu/) (thanks to [Michael
  Smith](http://people.w3.org/mike//)!).
- It's the first implementation of the URL Standard in Java.
- To the best of my knowledge, it's the second idependent implementation of the URL Standard (the first being the [JavaScript implementation](https://github.com/annevk/url) by [Anne van Kesteren](http://annevankesteren.nl/).

And finally, an example:

```java
// Let's get a funky URL
String urlString = " http:/日本.jp:80//.././[ FÜNKY ] ";

// Parse it
URL url = URL.parse(urlString);

System.out.println(url);
// OUTPUT: http://xn--wgv71a.jp/[%20F%C3%9CNKY%20]

System.out.println(url.toHumanString());
// OUTPUT: http://日本.jp/[ FÜNKY ]


// URLs can be modified with a fluent API
URL modifiedURL = url.withQuery(" let's do some query about 日本 ").withFragment(" and a fragment");

System.out.println(modifiedURL);
// OUTPUT: http://xn--wgv71a.jp/[%20F%C3%9CNKY%20]?let's%20do%20some%20query%20about%20%E6%97%A5%E6%9C%AC#and a fragment

System.out.println(modifiedURL.toHumanString());
// OUTPUT: http://日本.jp/[ FÜNKY ]?let's do some query about 日本#and a fragment


// And there are convenient canonicalizers to get URLs to a standard form

String differentUrlString = "http:/日本.jp/[20%46%c3%9c%4e%4B%59%20]";
URL differentURL = URL.parse(differentUrlString);
System.out.println(differentURL);
// OUTPUT: http://xn--wgv71a.jp/[%20%46%C3%9C%4E%4B%59%20]

URLCanonicalizer canonicalizer = new DecodeUnreservedCanonicalizer();
URL canonicalizedURL = canonicalizer.canonicalize(differentURL);
System.out.println(canonicalizedURL.toString());
// OUTPUT: http://xn--wgv71a.jp/[%20%46%C3%9C%4E%4B%59%20]
System.out.println(canonicalizedURL.toHumanString());
// OUTPUT: http://日本.jp/[ FÜNKY ]
```

That's it! Go get it at [GitHub](https://github.com/smola/galimatias) or [Maven
Central](https://search.maven.org/#search%7Cga%7C1%7Ca%3A%22galimatias%22)!

