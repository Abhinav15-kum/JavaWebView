package com.example.webviewapp


import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.example.javawebview.R

class MainActivity : AppCompatActivity() {
    private var webView: WebView? = null

    protected override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize WebView
        webView = findViewById(R.id.webview)


        // Enable JavaScript (if needed)
        val webSettings = webView!!.settings
        webSettings.javaScriptEnabled = true

        // Load URL inside the app, not default browser
        webView!!.webViewClient = WebViewClient()

        // Load a webpage
        webView!!.loadUrl("https://www.example.com")
    }

}