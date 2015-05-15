package org.mozilla.geckoviewexample;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;
import org.mozilla.gecko.GeckoView;

public class GeckoViewExample extends Activity implements GeckoView.ChromeDelegate {
    private static final String TAG = GeckoViewExample.class.getSimpleName();
    private GeckoView browser;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        browser = (GeckoView) findViewById(R.id.gecko_view);
        browser.importScript("resource://android/assets/android.js");
        browser.setChromeDelegate(this);
    }

    @Override
    public void onReady(GeckoView geckoView) {
        geckoView.addBrowser("resource://android/assets/index.html");
    }

    @Override
    public void onAlert(GeckoView geckoView, GeckoView.Browser browser, String s, GeckoView.PromptResult promptResult) {

    }

    @Override
    public void onConfirm(GeckoView geckoView, GeckoView.Browser browser, String s, GeckoView.PromptResult promptResult) {

    }

    @Override
    public void onPrompt(GeckoView geckoView, GeckoView.Browser browser, String s, String s2, GeckoView.PromptResult promptResult) {

    }

    @Override
    public void onDebugRequest(GeckoView geckoView, GeckoView.PromptResult promptResult) {

    }

    @Override
    public void onScriptMessage(GeckoView view, Bundle data, GeckoView.MessageResult result) {
        Log.v(TAG, "Message: " + data.toString());
        String message = data.getString("message");
        Toast.makeText(this, "Message from browser: " + message, Toast.LENGTH_LONG).
                show();
        Bundle res = new Bundle();
        res.putString("message", "pong: " + message);
        result.success(res);
    }
}
