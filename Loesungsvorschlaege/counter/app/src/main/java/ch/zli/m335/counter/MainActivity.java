package ch.zli.m335.counter;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private static final String COUNTER_STATE = "counter";
    private SharedPreferences preferences;
    private int counter = 0;
    private TextView counterTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        this.counterTextView = findViewById(R.id.counter);
        this.preferences = getPreferences(MODE_PRIVATE);

        // Preserve UI state
        if(savedInstanceState != null && savedInstanceState.containsKey(COUNTER_STATE)) {
            this.counter = savedInstanceState.getInt(COUNTER_STATE);
        } else {
            // Restore saved application data
            this.counter = preferences.getInt(COUNTER_STATE, this.counter);
        }


        Button minusOneButton = findViewById(R.id.minusOne);
        minusOneButton.setOnClickListener(view -> decrementCounter());
        Button plusOneButton = findViewById(R.id.plusOne);
        plusOneButton.setOnClickListener(view -> incrementCounter());
        Button resetButton = findViewById(R.id.reset);
        resetButton.setOnClickListener(view -> resetCounter());

        renderCount();
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        outState.putInt(COUNTER_STATE, this.counter);
        super.onSaveInstanceState(outState);
    }

    private void decrementCounter() {
        this.counter--;
        renderCount();
    }

    private void incrementCounter() {
        this.counter++;
        renderCount();
    }

    private void resetCounter() {
        this.counter = 0;
        renderCount();
    }

    private void saveCount() {
        SharedPreferences.Editor preferencesEditor = this.preferences.edit();
        preferencesEditor.putInt(COUNTER_STATE, this.counter);
        preferencesEditor.apply();
    }

    private void renderCount() {
        if (this.counterTextView != null) {
            this.counterTextView.setText(String.valueOf(this.counter));
            saveCount();
        }
    }
}