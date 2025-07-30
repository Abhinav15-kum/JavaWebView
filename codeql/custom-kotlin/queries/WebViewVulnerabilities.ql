/**
 * @name Detect insecure WebView usage in Android apps
 * @description Detects hardcoded URLs in WebView.loadUrl() and enabling of JavaScript.
 * @kind problem
 * @language java
 * @id java/android/webview/insecure-usage
 */

import java
import semmle.code.java.dataflow.TaintTracking

/**
 * Matches WebView.loadUrl("hardcoded") calls
 */
from MethodAccess call, Expr urlArg
where
  call.getMethod().hasName("loadUrl") and
  call.getMethod().getDeclaringType().hasQualifiedName("android.webkit", "WebView") and
  urlArg = call.getArgument(0) and
  urlArg instanceof LiteralExpr and
  urlArg.getType().getName() = "java.lang.String"
select call, "WebView.loadUrl is called with a hardcoded URL."

/**
 * Matches webSettings.javaScriptEnabled = true
 */
from AssignExpr assign, FieldAccess fa, BooleanLiteralExpr ble
where
  assign.getTarget() = fa and
  fa.getField().hasName("javaScriptEnabled") and
  assign.getValue() = ble and
  ble.getValue()
select assign, "JavaScript is enabled on a WebView. This can be dangerous if content is untrusted."
