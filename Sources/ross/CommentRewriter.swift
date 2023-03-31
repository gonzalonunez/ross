import Foundation
import SwiftSyntax

/// A `SyntaxRewriter` that removes comments from `DeclModifierSyntax` and `EnumCaseDeclSyntax` nodes.
final class CommentRewriter: SyntaxRewriter {

  init(shouldRemovePlainComments: Bool) {
    self.shouldRemovePlainComments = shouldRemovePlainComments
    super.init()
  }

  // MARK: Internal

  /// Whether or not to remove plain comments.
  let shouldRemovePlainComments: Bool

  override func visit(_ node: DeclModifierSyntax) -> DeclModifierSyntax {
    node.cleaned(shouldRemovePlainComments: shouldRemovePlainComments)
  }

  override func visit(_ node: EnumCaseDeclSyntax) -> DeclSyntax {
    DeclSyntax(node.cleaned(shouldRemovePlainComments: shouldRemovePlainComments))
  }

  override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
    DeclSyntax(node.cleaned(shouldRemovePlainComments: shouldRemovePlainComments))
  }

  override func visit(_ node: InitializerDeclSyntax) -> DeclSyntax {
    DeclSyntax(node.cleaned(shouldRemovePlainComments: shouldRemovePlainComments))
  }

  // Imports are a special case. We want to preserve header comments.
  override func visit(_ node: ImportDeclSyntax) -> DeclSyntax {
    DeclSyntax(node)
  }

  override func visit(_ node: DeinitializerDeclSyntax) -> DeclSyntax {
    DeclSyntax(node.cleaned(shouldRemovePlainComments: shouldRemovePlainComments))
  }

  override func visit(_ node: TokenSyntax) -> TokenSyntax {
    node.cleaned(shouldRemovePlainComments: shouldRemovePlainComments)
  }
}

extension SyntaxProtocol {

  func cleaned(shouldRemovePlainComments: Bool) -> Self {
    var newNode = self
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return newNode
  }
}

extension Trivia {

  /// Removes all comments from the trivia.
  ///
  /// - parameter shouldRemovePlainComments: Whether or not to remove plain comments or only DocC comments.
  mutating func removeComments(shouldRemovePlainComments: Bool) {
    self = .init(pieces: pieces.filter({ shouldRemovePlainComments ? !$0.isComment : !$0.isDocCComment }))
  }
}

extension TriviaPiece {

  /// Returns `true` if the trivia piece is a comment.
  var isComment: Bool {
    switch self {
    case .blockComment, .lineComment, .docBlockComment, .docLineComment:
      return true
    default:
      return false
    }
  }

  /// Returns `true` if the trivia piece is a DocC comment.
  var isDocCComment: Bool {
    switch self {
    case .docBlockComment, .docLineComment:
      return true
    default:
      return false
    }
  }
}
