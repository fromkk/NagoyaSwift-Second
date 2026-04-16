import Foundation
import Markdown
import Testing

@testable import MarkdownToSlide

@Suite("Paragraph.singleURL")
struct ParagraphURLDetectionTests {

  // MARK: - Returns URL

  @Test("Autolink <https://...> returns URL")
  func autolinkParagraph() {
    let doc = Document(parsing: "<https://example.com>")
    let para = doc.children.first as! Paragraph
    #expect(para.singleURL == URL(string: "https://example.com"))
  }

  @Test("Explicit Markdown link returns URL")
  func explicitLinkParagraph() {
    let doc = Document(parsing: "[https://example.com](https://example.com)")
    let para = doc.children.first as! Paragraph
    #expect(para.singleURL == URL(string: "https://example.com"))
  }

  @Test("Named link returns URL")
  func namedLinkParagraph() {
    let doc = Document(parsing: "[Visit Example](https://example.com)")
    let para = doc.children.first as! Paragraph
    #expect(para.singleURL == URL(string: "https://example.com"))
  }

  @Test("http:// link returns URL")
  func httpLinkParagraph() {
    let doc = Document(parsing: "[link](http://example.com)")
    let para = doc.children.first as! Paragraph
    #expect(para.singleURL == URL(string: "http://example.com"))
  }

  // MARK: - Returns nil

  @Test("Plain text returns nil")
  func plainTextParagraph() {
    let doc = Document(parsing: "Hello, world!")
    let para = doc.children.first as! Paragraph
    #expect(para.singleURL == nil)
  }

  @Test("Text with embedded link returns nil (multiple children)")
  func textWithEmbeddedLink() {
    let doc = Document(parsing: "See [example](https://example.com) for details")
    let para = doc.children.first as! Paragraph
    #expect(para.singleURL == nil)
  }

  @Test("Non-URL scheme (ftp) returns nil")
  func ftpSchemeParagraph() {
    let doc = Document(parsing: "[ftp link](ftp://example.com)")
    let para = doc.children.first as! Paragraph
    #expect(para.singleURL == nil)
  }
}

@Suite("ListItem.containedURL")
struct ListItemURLDetectionTests {

  // MARK: - Returns URL

  @Test("List item with explicit link returns URL")
  func listItemWithExplicitLink() {
    let doc = Document(parsing: "- [https://example.com](https://example.com)")
    let list = doc.children.first as! UnorderedList
    let item = Array(list.listItems)[0]
    #expect(item.containedURL == URL(string: "https://example.com"))
  }

  @Test("List item with named link returns URL")
  func listItemWithNamedLink() {
    let doc = Document(parsing: "- [Visit](https://example.com)")
    let list = doc.children.first as! UnorderedList
    let item = Array(list.listItems)[0]
    #expect(item.containedURL == URL(string: "https://example.com"))
  }

  @Test("List item with autolink returns URL")
  func listItemWithAutolink() {
    let doc = Document(parsing: "- <https://example.com>")
    let list = doc.children.first as! UnorderedList
    let item = Array(list.listItems)[0]
    #expect(item.containedURL == URL(string: "https://example.com"))
  }

  @Test("Only the item containing a URL has containedURL")
  func onlyURLItemMatches() {
    let markdown = """
      - something
      - [link](https://example.com)
      - more text
      """
    let doc = Document(parsing: markdown)
    let list = doc.children.first as! UnorderedList
    let items = Array(list.listItems)
    #expect(items[0].containedURL == nil)
    #expect(items[1].containedURL == URL(string: "https://example.com"))
    #expect(items[2].containedURL == nil)
  }

  // MARK: - Returns nil

  @Test("Plain text list item returns nil")
  func plainTextListItem() {
    let doc = Document(parsing: "- just some text")
    let list = doc.children.first as! UnorderedList
    let item = Array(list.listItems)[0]
    #expect(item.containedURL == nil)
  }

  @Test("All non-URL items return nil")
  func allNonURLItems() {
    let markdown = """
      - something
      - more text
      - last item
      """
    let doc = Document(parsing: markdown)
    let list = doc.children.first as! UnorderedList
    for item in list.listItems {
      #expect(item.containedURL == nil)
    }
  }
}
