angular.module("firebase.offline", [
]).value("firebaseOffline", firebaseBackup =
  users:
    "simplelogin:2":
      name: "Test"
      email: "test@test.com"

    "simplelogin:1":
      name: "Thakker"
      email: "thakker@gmail.com"

  links:
    v1:
      "-JDgs007jpAtvgcj6uvV":
        description: "Test Reading"

      "-JDlpQYF3O7Ki7zdGTzv":
        url: "http://www.dontfeartheinternet.com/the-basics/not-tubes"
        description: "Don't Fear the Internet: The Basics"

      "-JDgoGgTzuwqoYrTtZGK":
        url: "http://"
        description: "Testing"

      "-JDgodcdYeeSIdVn1eFh":
        url: "http://"
        description: "Test"

      "-JDgxYbYJEbd54_seRIB":
        url: ""
        description: "[examples for semantics]"

      "-JDgp37-2VHsSC2wTw9b":
        url: "Test!!"
        description: "Test3"

      "-JDgrStxVoRCmC4thtuR":
        url: "test"
        description: "Test"

      "-JDgxTQ5nbew9ED-ZE7w":
        url: "http://www.codecademy.com/courses/web-beginner-en-HZA3b/1/1"
        description: "Codecademy: HTML Basics 6-8"

      "-JDgogfX_M0LsuJMzG-E":
        url: "http://2"
        description: "Test2"

      "-JDgo7G6S2OZEAP18P1Q":
        url: "http://blah."
        description: "Testing."

      "-JDgupQWXMLXE3cqUNEW":
        url: "asdfasdfads"
        description: "asdfasdf"

      "-JDgoKRB33A6r4azeFm1":
        url: "http;"
        description: "Testing"

      "-JDgoGzp4o4RM4WYQWw8":
        url: "http://"
        description: "Testing"

      "-JDgsEp5MPnhTl94JFiM":
        url: "blah 2"
        description: "Test another reading"

      "-JDgxQ4bTcPzMSoUrVTK":
        description: "Duckett, Chapter 2"

      "-JDldedGAnNB1OKnwU-P":
        description: "HTML&CSS: Chapter 1: Structure p. 13-28"

      "-JDlpWZVJp4QitdA4dUc":
        url: "http://www.ted.com/talks/andrew_blum_what_is_the_internet_really.html"
        description: "What is the Internet Really? (Andrew Blum)"

      "-JDguUMQqfUsqvCpd1Mw":
        url: "test2"
        description: "Test1"

      "-JDgs56f-9-sD7fyjyAw":
        url: "blah"
        description: "Test reading"

      "-JDgsM0561ilQwyLGbMd":
        url: "test 1"
        description: "Test 1"

      "-JDgxW7SBXnMCQUlc_8t":
        url: "http://en.wikiversity.org/wiki/Web_Design/HTML_Challenges#Challenge_1:_Which_heading_to_choose.3F"
        description: "Wikiversity: HTML Challenges"

      "-JDlpTe6tcYtiruB0gLl":
        url: "https://www.youtube.com/watch?v=V2QdEj8UjBc&feature=plcphttps://www.youtube.com/watch?v=V2QdEj8UjBc&feature=plcphttps://www.youtube.com/watch?v=V2QdEj8UjBc&feature=plcp"
        description: "History of the Internet (Ethan Zuckerman)"

      "-JDldhKO3qm22kQKb-9A":
        url: "https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Introduction"
        description: "MDN: Introduction to HTML"

      "-JDle9dmOLnVmZ820WVF":
        url: "http://www.codecademy.com/courses/web-beginner-en-HZA3b/0/1"
        description: "Codecademy: HTML Basics, parts 1-5"

      "-JDgsbngBxK0AAquLsv7":
        url: "test 2"
        description: "Test 2"

      "-JDgrsNKT2ri9Y-Jz6zY":
        url: "testing"
        description: "Test"

  skills:
    v1:
      borders:
        prereqs: [
          "box-model"
          "color"
        ]
        title: "Borders"
        content: "<div><br></div><div>border style</div><div>border width</div><div>border color</div><div><br></div><div>(top, right, bottom, left)</div><div><br></div><div>border</div>"
        tags: ["CSS"]

      "basic-typography":
        prereqs: [
          "what-is-css"
          "marking-text"
        ]
        title: "Basic Typography"
        content: ""
        tags: ["CSS"]

      lists:
        prereqs: ["what-is-html"]
        title: "Lists"
        content: "<div><br></div><div>Ordered lists</div><div>Unordered lists</div><div>Definition lists</div><div><br></div><div><br></div>"
        tags: ["HTML"]

      "relational-selectors":
        prereqs: ["what-is-css"]
        title: "Relational Selectors"
        content: "<div><br></div><div><br></div><div>descendant</div><div>child</div><div>sibling</div>"
        tags: ["CSS"]

      "what-is-css":
        prereqs: ["what-is-html"]
        title: "What is CSS?"
        content: "element, id, and class selectors<div><br></div><div><br></div><div><br></div><div><br></div>"
        tags: ["CSS"]

      "what-is-the-internet":
        reading: [
          "-JDlpQYF3O7Ki7zdGTzv"
          "-JDlpTe6tcYtiruB0gLl"
          "-JDlpWZVJp4QitdA4dUc"
        ]
        title: "What is the Internet?"
        content: ""

      "css-inheritance":
        prereqs: [
          "what-is-css"
          "document-structure"
        ]
        title: "CSS Inheritance"
        content: "<div><br></div><div><br></div><div><br></div><div>https://developer.mozilla.org/en-US/docs/CSS/inheritance&nbsp;<br></div>"
        tags: ["CSS"]

      "box-model":
        prereqs: [
          "what-is-css"
          "document-structure"
        ]
        title: "Box Model"
        content: "<div><br></div><div><br></div><div>margin, padding, border</div>"
        tags: ["CSS"]

      "what-is-html":
        reading: [
          "-JDldedGAnNB1OKnwU-P"
          "-JDldhKO3qm22kQKb-9A"
        ]
        prereqs: ["what-is-the-internet"]
        title: "What is HTML?"
        content: "<h2><span>Highlights</span><br></h2><ul><li>The basic purpose of HTML is&nbsp;<i>to represent structured content</i>.</li><li>HTML documents are made of elements</li><li>Elements: tags, attributes, contents</li><li>Specific elements: html, head, title, body</li><li>Doctype declaration</li><li>Specific tags: html, head, body, title, p</li></ul>"
        practice: ["-JDle9dmOLnVmZ820WVF"]
        tags: ["HTML"]

      "css-specificity":
        prereqs: [
          "pseudoclass-selectors"
          "relational-selectors"
        ]
        title: "CSS Specificity"
        content: ""
        tags: ["CSS"]

      color:
        prereqs: ["what-is-css"]
        title: "Color"
        content: "<div><br></div><div>hex color</div><div><br></div><div>rgb / rgba color</div><div><br></div><div>hsl color</div><div><br></div><div><br></div><div><br></div><div>Fun: http://www.hexinvaders.com/&nbsp;</div><div><br></div>"
        tags: ["CSS"]

      images:
        prereqs: ["what-is-html"]
        title: "Images"
        content: "<div><br></div><div><br></div><h2>Reading</h2><div>Duckett, chapter 5</div>"
        tags: ["HTML"]

      "style-a-basic-page":
        prereqs: [
          "make-a-basic-web-page"
          "basic-typography"
          "styling-lists"
          "background"
          "borders"
          "css-inheritance"
        ]
        title: "Style a Basic Page"
        content: ""
        tags: ["making"]

      "media-queries":
        prereqs: ["what-is-css"]
        title: "Media Queries"
        content: ""
        tags: ["CSS"]

      "document-structure":
        prereqs: ["what-is-html"]
        title: "Document Structure"
        content: ""
        tags: ["HTML"]

      "pseudoclass-selectors":
        prereqs: ["what-is-css"]
        title: "Pseudoclass Selectors"
        content: ""
        tags: ["CSS"]

      "build-a-responsive-layout":
        prereqs: [
          "positioning"
          "media-queries"
        ]
        title: "Build a Responsive Layout"
        content: ""
        tags: ["making"]

      "page-flow":
        prereqs: ["box-model"]
        title: "Page Flow"
        content: ""
        tags: [
          "CSS"
          "HTML"
        ]

      "html-links":
        prereqs: ["what-is-html"]
        title: "HTML Links"
        content: "<div><br></div><div><br></div><div><h2>Reading</h2><div>Duckett, chapter 4</div></div>"
        tags: ["HTML"]

      "css-transitions":
        prereqs: ["pseudoclass-selectors"]
        title: "CSS Transitions"
        content: ""
        tags: ["CSS"]

      "html-metadata":
        prereqs: ["what-is-html"]
        title: "HTML Metadata"
        content: ""
        tags: ["HTML"]

      positioning:
        prereqs: ["page-flow"]
        title: "Positioning"
        content: ""
        tags: ["CSS"]

      "css-resets":
        title: "CSS Resets"
        content: ""
        tags: [
          "CSS"
          "crossbrowser"
          "hidden"
        ]

      "make-a-basic-web-page":
        prereqs: [
          "marking-text"
          "lists"
          "html-links"
          "images"
          "document-structure"
        ]
        title: "Make a Basic Web Page"
        content: ""
        tags: ["making"]

      "css-fallbacks":
        title: "CSS Fallbacks"
        content: "<div><br></div><div>The basic idea of a CSS fallback.</div>"
        tags: [
          "crossbrowser"
          "CSS"
          "hidden"
        ]

      background:
        prereqs: [
          "what-is-css"
          "color"
        ]
        title: "Background"
        content: "<div><br></div><div>background-color</div><div><br></div><div>background-image</div><div>background-repeat</div><div>background-position</div>"
        tags: ["CSS"]

      "restyle-an-existing-site":
        prereqs: [
          "css-specificity"
          "positioning"
          "build-a-basic-multi-page-website"
        ]
        title: "Restyle an Existing Site"
        content: ""
        tags: ["making"]

      "marking-text":
        reading: ["-JDgxQ4bTcPzMSoUrVTK"]
        prereqs: ["what-is-html"]
        title: "Marking Text"
        content: "<div><ul><li><span>Paragraphs and headings (p, h1-h6)</span></li><li><span>Semantics: em, strong, q, blockquote, cite, abbr, dfn</span></li></ul></div>"
        practice: [
          "-JDgxTQ5nbew9ED-ZE7w"
          "-JDgxW7SBXnMCQUlc_8t"
          "-JDgxYbYJEbd54_seRIB"
        ]
        tags: ["HTML"]

      "build-a-basic-multi-page-website":
        prereqs: [
          "build-a-responsive-layout"
          "style-a-basic-page"
          "css-specificity"
          "css-transitions"
          "pseudoclass-selectors"
          "relational-selectors"
        ]
        title: "Build a Basic Multi-page Website"
        content: ""
        tags: ["making"]

      "styling-lists":
        prereqs: [
          "what-is-css"
          "lists"
        ]
        title: "Styling Lists"
        content: "<div><br></div><div><br></div>"
        tags: ["CSS"]

  roles:
    "simplelogin:1": "admin"
)
