---
date: 2017-07-16 17:30
description: Jenkins likes JUnit
tags: xcode, junit, ios, command-line
---
# Convert Xcode Plist Test Reports To JUnit XML

Let’s say you are an iOS developer, working on an amazing app for your company. You use [Jenkins](https://jenkins.io/) for continuous integration. So you like having your unit tests automated and Jenkins displaying beautiful charts and trends, right ?

## The Problem

The thing is Xcode likes to export its unit tests reports as [property list](https://en.wikipedia.org/wiki/Property_list) (plist) files and Jenkins prefers to ingest JUnit XML reports. You have to find the missing link.

## Solutions

## The Obvious (Lazy) One

You might think :

> let’s just use `fastlane`. It’s a great tool, it packages everything a mobile developer could wish for when it comes to automating builds.  

You are right : there is `fastlane scan` for testing and it uses [xcpretty](https://github.com/supermarin/xcpretty) to format `xcodebuild` output. `Xcpretty` does a really good job at keeping Jenkins happy by converting tests reports to the JUnit XML format. 

There’s also [trainer](https://github.com/KrauseFx/trainer), which does exactly what you want here. Hell, it was even made by [KrauseFx](https://github.com/KrauseFx), creator of [fastlane](https://fastlane.tools/) ! But you should be familiar with [Ruby](https://www.ruby-lang.org/en/) first to understand the code and the installation process is similar to `fastlane`, obviously.

You could find a Jenkins plug-in, too, but it already handles JUnit so well it would be sad to go down this road.

## The Brave One

However, for reasons like the cost of dependency to third party code - or some other I should write about in another post - , you might prefer going deeper in understanding what needs to be achieved, and you feel confident that you can fulfill the requirements on your own, quenching your thirst of knowledge. You are brave. Let’s clap to that 👏.

### What does an Xcode unit test report look like ?

1. First, run your unit test by pressing `cmd+U`. 
2. Then, locate the plist report at  `[DERIVED_DATA_PATH]/[YOUR_PROJECT]-[SOMETHING]/Logs/Tests/[STUFF]_TestSummaries.plist`
3. Open it with your favorite text editor.

What you are currently looking at is an XML file. Since JUnit reports are obviously in an XML format, all we need is a tool which takes in XML, adapts it to suit the desired XML destination format, and outputs it.

### How to adapt to the right XML format ?

After some research,  the `xsltproc` command could help you. From its `man` entry :

> `xsltproc` is a command line tool for applying XSLT stylesheets to XML documents.  

Yes, well, thank you sir - errr `man` - but what does [XSLT](https://en.wikipedia.org/wiki/XSLT) mean ?
If you have not clicked on the link to the wikipedia page yet :

> XSLT (Extensible Stylesheet Language Transformations) is a language for transforming XML documents into other XML documents […].  

Bingo ! Using `xsltproc`, you will transform your `[STUFF]_TestSummaries.plist` file provided by Xcode into `report.junit` to feed Jenkins on, by applying an XSLT stylesheet.

### The « implementation »

Here is the anatomy of the `xsltproc` command :

```no-highlight
xsltproc [{-o | --output} {DESTINATION-FILE | DIRECTORY}] [STYLESHEET] {XML-SOURCE-FILE | -}
```

Thus, the full command will look like the following :

```no-highlight
xsltproc -o [DESTINATION_PATH]/report.junit \
[WHERE_YOU_WANT]/plist_to_junit.xsl \
[DERIVED_DATA_PATH]/Logs/Test/*_TestSummaries.plist
```

All you need now is a nice stylesheet.
Let's cut to the chase and let me provide you with some magical stylesheet that - although imperfect - should work :

```no-highlight
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="1.0">
  <xsl:output omit-xml-declaration="no" indent="yes" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/*">
    <testsuites>
      <xsl:apply-templates select="//dict[key = 'Tests']"/>
    </testsuites>
  </xsl:template>  

  <xsl:template match="//dict[key = 'Tests']">
    <testsuite name="{string[2]}">
      <xsl:apply-templates select="//dict[key = 'Tests']//dict[key = 'TestStatus']"/>
    </testsuite>
  </xsl:template>

  <xsl:template match="//dict[key = 'Tests']//dict[key = 'TestStatus']">
    <testcase classname="{../../string[1]}" name="{string[1]}" time="{real[1]}">
      <xsl:if test="key[2] = 'FailureSummaries'">    
        <failure message="{array/dict/string[2]}">
          <xsl:value-of select="concat(array/dict/string[1], ':', array/dict/integer[1])"/>
          </failure>
      </xsl:if>
    </testcase>
  </xsl:template>
</xsl:stylesheet>
```
Save this code in a file named `plist_to_junit.xsl`.

Now in your unit test script, which will be executed by Jenkins :

```no-highlight
#!/bin/bash -e

xcodebuild [PARAMS] clean build test
xsltproc -o [DESTINATION_PATH]/report.junit \
[WHERE_YOU_WANT]/plist_to_junit.xsl \
[DERIVED_DATA_PATH]/Logs/Test/*_TestSummaries.plist
```

## Conclusion (for the brave)

There you go !  The plist file generated by Xcode is now converted into a proper JUnit XML report, using a simple command line tool already installed on you mac,  and a small transformation file. No third party tool necessary.

Yet, the xsl file is definitely perfectible, so feel free to try it out and tell me what you think, and how you made it even better.

## Edit (March 15th, 2018)

Here is a simpler and more accurate stylesheet which will avoid counting tests twice when you have multiple test targets :

```no-highlight
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="1.0">
  <xsl:output omit-xml-declaration="no" indent="yes" />
  <xsl:strip-space elements="*" />
  
  <xsl:template match="/*">
    <testsuites>
      <testsuite name="All Unit Tests">
        <xsl:apply-templates select="//dict[key = 'TestStatus']"/>
      </testsuite>
    </testsuites>
  </xsl:template>

  <xsl:template match="//dict[key = 'TestStatus']">
    <testcase classname="{../../string[1]}" name="{string[1]}" time="{real[1]}">
    </testcase>
  </xsl:template>  
</xsl:stylesheet>
```
