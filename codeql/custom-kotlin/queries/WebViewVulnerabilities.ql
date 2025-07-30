/**
 * @name WebView JavaScript Enabled (Kotlin)
 * @description Detects when JavaScript is explicitly enabled in Kotlin WebView settings
 * @kind problem
 * @problem.severity warning
 * @id custom-kotlin/webview-javascript-enabled
 * @tags security, android, webview
 */

import kotlin
import semmle.code.kotlin.expressions

from Assignment assign, PropertyAccessExpr prop, Literal lit
where
  assign.getLeft() = prop and
  prop.getName() = "javaScriptEnabled" and
  prop.getQualifier().getType().getQualifiedName() = "android.webkit.WebSettings" and
  lit = assign.getRight() and
  lit instanceof BooleanLiteral and
  lit.getValue() = true
select assign, "JavaScript is enabled in WebView. Ensure this is necessary and properly secured."
