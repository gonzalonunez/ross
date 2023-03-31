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

  override func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: AssociatedtypeDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: DeclModifierSyntax) -> DeclModifierSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return newNode
  }

  override func visit(_ node: DeinitializerDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: EnumCaseDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: ExtensionDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: InitializerDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: MissingDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: TypealiasDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
  }

  override func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
    var newNode = node
    newNode.leadingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    newNode.trailingTrivia?.removeComments(shouldRemovePlainComments: shouldRemovePlainComments)
    return DeclSyntax(newNode)
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
