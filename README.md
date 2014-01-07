amp
===

An HTML parsifier. Adds classes to elements in an HTML file.
It replaces hpricot or nokogiri, and attempts to do the impossible: parse HTML using a regular expression.
Not really, of course - it just adds classes to a few certain elements. But there exists a special circle
of hell for people who parse HTML with regular expressions, and I thought it a shame to miss out.
The name Amp, of course, is an electrical pun - the amp, or ampere, being a measure of electrical current.

# What does it do?

Say you're in index.html. You have this link:

    <a href='index.html'>Home</a>

But, because it links to the *current page*, you want it to say

    <a class='current' href='index.html'>Home</a>

Bingo! You can now have HTML menus that automatically have the right class.

Better yet, Amp also adds a "current" class to the parent <li> if there is one.

    <li class='current'><a class='current' href='index.html'>Home</a></li>

Amp also finds links to ../index.html and adds a class of 'current-parent'.

    <a class='current-parent' href='../index.html'>Home</a>

# How do I use it?

Given text (HTML), a filename (index.html), and the classes you want to use:

    Amp.parse(text, filename, 'current', 'current-parent')

# Y U No-kogiri?

Hammer for Mac uses system Ruby to do its compilation thing, and has to be standalone. I tried to get Nokogiri/Hpricot to play nice with statically linked libraries, but no dice. That's how Amp was born.