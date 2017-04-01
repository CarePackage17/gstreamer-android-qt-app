package net.armsofsorrow.gstreamerandroidqtapp;

import org.qtproject.qt5.android.bindings.QtActivity;
import org.freedesktop.gstreamer.GStreamer;
import android.os.Bundle;
import android.widget.Toast;

public class MainActivity extends QtActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        try {
            GStreamer.init(this);
        } catch(Exception e) {

            Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
            finish();
            return;
        }
    }

}
