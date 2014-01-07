amp
===

An HTML parsifier. Adds classes to elements in an HTML file.
It replaces hpricot or nokogiri, and attempts to do the impossible: parse HTML using a regular expression.
Not really, of course - it just adds classes to a few certain elements. But there exists a special circle
of hell for people who parse HTML with regular expressions, and I thought it a shame to miss out.
The name Amp, of course, is an electrical pun - the amp, or ampere, being a measure of electrical current.

# Usage

    Amp.parse(text, filename, 'current', 'current-parent')