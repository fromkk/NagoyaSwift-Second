import Foundation
import Markdown
import SwiftUI

// MARK: - Public API

public struct MarkdownToView {
  @MainActor
  public static func convert(_ markdown: String) -> AnyView {
    let document = Document(parsing: markdown)
    return AnyView(MarkdownDocumentView(document: document))
  }
}

// MARK: - Document View

private struct MarkdownDocumentView: View {
  let document: Document

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      ForEach(Array(document.children.enumerated()), id: \.offset) { _, child in
        BlockView(markup: child)
      }
    }
  }
}

// MARK: - Block View

private struct BlockView: View {
  let markup: any Markup

  var body: some View {
    switch markup {
    case let heading as Heading:
      HeadingView(heading: heading)
    case let paragraph as Paragraph:
      ParagraphView(paragraph: paragraph)
    case let codeBlock as CodeBlock:
      CodeBlockView(codeBlock: codeBlock)
    case let unorderedList as UnorderedList:
      UnorderedListView(list: unorderedList)
    case let orderedList as OrderedList:
      OrderedListView(list: orderedList)
    case let blockQuote as BlockQuote:
      BlockQuoteView(blockQuote: blockQuote)
    case let table as Markdown.Table:
      MarkdownTableView(table: table)
    case is ThematicBreak:
      Divider()
    default:
      EmptyView()
    }
  }
}

// MARK: - Heading

private struct HeadingView: View {
  let heading: Heading

  var body: some View {
    heading.children
      .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
      .font(fontForLevel(heading.level))
      .fontWeight(.bold)
  }

  private func fontForLevel(_ level: Int) -> Font {
    switch level {
    case 1: return .largeTitle
    case 2: return .title
    case 3: return .title2
    case 4: return .title3
    case 5: return .headline
    default: return .subheadline
    }
  }
}

// MARK: - Paragraph

private struct ParagraphView: View {
  let paragraph: Paragraph

  var body: some View {
    let images = paragraph.children.compactMap { $0 as? Markdown.Image }
    let hasText = paragraph.children.contains { child in
      !(child is Markdown.Image) && !(child is SoftBreak) && !(child is LineBreak)
    }

    if !images.isEmpty && !hasText {
      ForEach(Array(images.enumerated()), id: \.offset) { _, image in
        MarkdownImageView(image: image)
      }
    } else {
      paragraph.children
        .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
        .font(.body)
    }
  }
}

// MARK: - Code Block

private struct CodeBlockView: View {
  let codeBlock: CodeBlock

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      Text(codeBlock.code.trimmingCharacters(in: .whitespacesAndNewlines))
        .font(.system(.body, design: .monospaced))
        .padding(12)
    }
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)
  }
}

// MARK: - Unordered List

private struct UnorderedListView: View {
  let list: UnorderedList

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      ForEach(Array(list.listItems.enumerated()), id: \.offset) { _, item in
        UnorderedListItemView(item: item)
      }
    }
  }
}

private struct UnorderedListItemView: View {
  let item: ListItem

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .top, spacing: 8) {
        Text("•")
        listItemTextView(item)
          .font(.body)
      }

      // Nested lists
      ForEach(Array(item.children.enumerated()), id: \.offset) { _, child in
        if let nested = child as? UnorderedList {
          UnorderedListView(list: nested)
            .padding(.leading, 20)
        } else if let nested = child as? OrderedList {
          OrderedListView(list: nested)
            .padding(.leading, 20)
        }
      }
    }
  }
}

// MARK: - Ordered List

private struct OrderedListView: View {
  let list: OrderedList

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      ForEach(Array(list.listItems.enumerated()), id: \.offset) { index, item in
        OrderedListItemView(item: item, index: index + Int(list.startIndex))
      }
    }
  }
}

private struct OrderedListItemView: View {
  let item: ListItem
  let index: Int

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .top, spacing: 8) {
        Text("\(index).")
          .monospacedDigit()
        listItemTextView(item)
          .font(.body)
      }

      // Nested lists
      ForEach(Array(item.children.enumerated()), id: \.offset) { _, child in
        if let nested = child as? UnorderedList {
          UnorderedListView(list: nested)
            .padding(.leading, 20)
        } else if let nested = child as? OrderedList {
          OrderedListView(list: nested)
            .padding(.leading, 20)
        }
      }
    }
  }
}

// MARK: - Block Quote

private struct BlockQuoteView: View {
  let blockQuote: BlockQuote

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(Array(blockQuote.children.enumerated()), id: \.offset) { _, child in
        BlockView(markup: child)
      }
    }
    .padding(.leading, 16)
    .overlay(alignment: .leading) {
      Rectangle()
        .fill(Color.gray)
        .frame(width: 4)
    }
    .opacity(0.8)
  }
}

// MARK: - Table

private struct MarkdownTableView: View {
  let table: Markdown.Table

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
      // Header
      GridRow {
        ForEach(Array(table.head.children.enumerated()), id: \.offset) { _, cell in
          cell.children
            .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
            .font(.headline)
            .frame(minWidth: 60, alignment: .leading)
            .padding(6)
        }
      }

      Divider()

      // Body rows
      ForEach(Array(table.body.children.enumerated()), id: \.offset) { _, child in
        if let row = child as? Markdown.Table.Row {
          GridRow {
            ForEach(Array(row.children.enumerated()), id: \.offset) { _, cell in
              cell.children
                .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
                .font(.body)
                .frame(minWidth: 60, alignment: .leading)
                .padding(6)
            }
          }
        }
      }
    }
    .padding(12)
    .background(Color.gray.opacity(0.05))
    .cornerRadius(8)
  }
}

// MARK: - Image

private struct MarkdownImageView: View {
  let image: Markdown.Image

  var body: some View {
    if let source = image.source, let url = URL(string: source) {
      AsyncImage(url: url) { phase in
        switch phase {
        case .success(let loadedImage):
          loadedImage
            .resizable()
            .scaledToFit()
        case .failure:
          Text("Failed to load image")
            .foregroundColor(.red)
            .font(.caption)
        case .empty:
          ProgressView()
        @unknown default:
          EmptyView()
        }
      }
    }
  }
}

// MARK: - Inline Text

private func inlineText(for markup: any Markup) -> SwiftUI.Text {
  switch markup {
  case let text as Markdown.Text:
    return SwiftUI.Text(text.string)
  case let strong as Strong:
    return strong.children
      .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
      .bold()
  case let emphasis as Emphasis:
    return emphasis.children
      .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
      .italic()
  case let inlineCode as InlineCode:
    return SwiftUI.Text(inlineCode.code)
      .font(.system(.body, design: .monospaced))
  case let strikethrough as Strikethrough:
    return strikethrough.children
      .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
      .strikethrough()
  case let link as Markdown.Link:
    let linkText = extractPlainText(from: link.children)
    let destination = link.destination ?? ""
    return SwiftUI.Text(.init("[\(linkText)](\(destination))"))
  case is LineBreak:
    return SwiftUI.Text("\n")
  case is SoftBreak:
    return SwiftUI.Text(" ")
  case _ as Markdown.Image:
    return SwiftUI.Text("")
  default:
    return SwiftUI.Text("")
  }
}

// MARK: - Helper

private func listItemTextView(_ listItem: ListItem) -> SwiftUI.Text {
  listItem.children
    .compactMap { child -> SwiftUI.Text? in
      if let paragraph = child as? Paragraph {
        return paragraph.children
          .reduce(SwiftUI.Text("")) { Text("\($0)\(inlineText(for: $1))") }
      }
      return nil
    }
    .reduce(SwiftUI.Text("")) { result, text in
      result == SwiftUI.Text("") ? text : result + SwiftUI.Text(" ") + text
    }
}

private func extractPlainText(from children: MarkupChildren) -> String {
  children.compactMap { child -> String? in
    switch child {
    case let text as Markdown.Text:
      return text.string
    case let strong as Strong:
      return extractPlainText(from: strong.children)
    case let emphasis as Emphasis:
      return extractPlainText(from: emphasis.children)
    case let inlineCode as InlineCode:
      return inlineCode.code
    case let strikethrough as Strikethrough:
      return extractPlainText(from: strikethrough.children)
    case let link as Markdown.Link:
      return extractPlainText(from: link.children)
    default:
      return nil
    }
  }.joined()
}
