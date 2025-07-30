/**
 * @name Detect risky WebView usage in Java Android apps
 * @description Finds WebView.loadUrl calls with hardcoded URLs and JavaScript enabling
 * @kind problem
 * @language java
 */

import java

// Detect calls to WebView.loadUrl
class WebViewLoadUrlCall extends MethodCall {
  WebViewLoadUrlCall() {
    this.getMethod().hasName("loadUrl") and
    this.getMethod().getDeclaringType().hasQualifiedName("android.webkit", "WebView")
  }
}

// Detect assignments enabling JavaScript on WebSettings
class JavaScriptEnabled extends Expr {
  JavaScriptEnabled() {
    exists(AssignExpr assign |
      assign.getTarget() instanceof FieldAccess fa and
      fa.getField().hasName("javaScriptEnabled") and
      assign.getValue() instanceof BooleanLiteralExpr ble and
      ble.getValue() = true and
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
