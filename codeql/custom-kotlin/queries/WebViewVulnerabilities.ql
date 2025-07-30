/**
 * @name Detect risky WebView configurations in Android apps
 * @description Finds Android WebView usage that enables JavaScript or loads URLs insecurely.
 * @kind problem
 * @language java
 * @id java/android/webview/insecure-usage
 */

import java
import semmle.code.java.dataflow.TaintTracking

// Find calls to WebView.loadUrl with a hardcoded string URL
class WebViewLoadUrlCall extends MethodCall {
  WebViewLoadUrlCall() {
    this.getMethod().hasName("loadUrl") and
    this.getMethod().getDeclaringType().hasQualifiedName("android.webkit", "WebView")
  }
}

// Find calls to enable JavaScript: webSettings.javaScriptEnabled = true
class JavaScriptEnabled extends Expr {
  JavaScriptEnabled() {
    exists(AssignExpr assign |
      assign.getLValue() instanceof FieldAccess fa and
      fa.getField().hasName("javaScriptEnabled") and
      assign.getRValue() instanceof BooleanLiteralExpr ble and
      ble.getValue() = true and
      assign = this
    )
  }
}

// Find WebViewClient instantiations assigned to WebView.webViewClient property
class WebViewClientAssigned extends Expr {
  WebViewClientAssigned() {
    exists(AssignExpr assign |
      assign.getLValue() instanceof FieldAccess fa and
      fa.getField().hasName("webViewClient") and
      assign.getRValue() instanceof NewExpr ne and
      ne.getType().hasQualifiedName("android.webkit", "WebViewClient") and
      assign = this
    )
  }
}

from WebViewLoadUrlCall call, Expr urlArg
where
  urlArg = call.getArgument(0) and
  urlArg instanceof LiteralExpr
select call, "WebView.loadUrl called with a hardcoded URL."

from JavaScriptEnabled js
select js, "JavaScript is enabled on WebView. This can be risky if loading untrusted content."

from WebViewClientAssigned wvc
select wvc, "Custom WebViewClient assigned, make sure it's configured securely (e.g., override shouldOverrideUrlLoading)."
