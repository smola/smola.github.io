--- 
title: "Swapping languages in a Gettext PO file"
published: true
tags:
- python
- i18n
---

*TL;DR: Here you have a script for swapping the source and target language of a Gettext PO file. [Grab it.](https://gist.github.com/smola/6600778)*

For the first time, I'm working on a project that requires full internationalization (*i.e.* [Chívalo!](http://chivalo.com)).
So far, I have learned 3 things: 1) Internationalization is much harder than I've ever thought, 2) most tools suck,
3) most Java developers seem to live in a bubble where Gettext never happened. Those will be interesting topics for
other posts, but today I'll just explain how to solve a simple problem: swapping source and target languages
of a Gettext PO file.

We started [Chívalo!](http://chivalo.com) as a Spanish-only website, but we always kept in mind that it would
go international, eventually. We externalized messages to a file referenced by keys (*e.g.* `nav.home=Home`).
This is what most people seem to be doing with Play and the [officially encouraged mechanism](http://www.playframework.com/documentation/2.1.x/JavaI18N).
We quickly realized that this approach sucks big time.<sup><a class="fn-ref" id="fn1-ref1" href="#fn1">1</a></sup> Then we switched to using Spanish strings as keys, and decided that we would find or create the proper tool to use them at some point.

The point of starting real internationalization arrived. We picked Gettext, extracted the strings,
and translated everything to English in a PO file. Now it's time to switch the development to English-first.
So we wrote a script to replace every Spanish string with the English equivalent by using the `en-US.po` file.

The only thing missing is swapping the source language (Spanish) and the target language (English) in `en-US.po`
so that we get the new `es-ES.po`. I'd thought this would be the easiest part. I was surprised to find out
that there seems to be no quick way of doing this.<sup><a class="fn-ref" id="fn2-ref1" href="#fn2">2</a></sup>

Here's a script for doing this with just a simple command:

<script src="https://gist.github.com/smola/6600778.js"></script>

<aside class="footnotes">

<div class="fn">
  <sup><a id="fn1" class="fn-backref" href="#fn1-ref1">1</a></sup> Using logic keys for localized strings involves one of the two hardest things in Computer Science: naming things. This is particularly bad for the Web. After around three months of development, we needed a couple of scripts just to periodically check untranslated strings, unused strings, take care of renaming keys so that they remain consistent... The added indirection layer of localization keys (hundreds of them) was something that we had to keep always in mind without getting any real benefit for it.
</div>

<div class="fn">
  <sup><a id="fn2" class="fn-backref" href="#fn2-ref1">2</a></sup> Gettext does not seem to support it. [StackOverlow had an answer](http://stackoverflow.com/questions/4700189/switch-gettext-translated-language-with-original-language) providing a convoluted method that just did not work on Ubuntu Precise.
</div>

</aside>

