
package com.example.alarm_clock
import android.content.Intent
import android.app.Activity
import android.os.Bundle
import android.view.WindowManager
import android.widget.Button

class FullScreenAlarmActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // These flags make sure the activity is shown:
        // - even when the phone is locked
        // - even if the screen is off
        // - as a fullscreen activity (hiding the status bar)
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )

       // Set the layout from XML (activity_fullscreen_alarm.xml)
        setContentView(R.layout.activity_fullscreen_alarm)

       // Set a click listener for the stop button
       // When pressed:
       // 1. Stop the AlarmService (which stops the sound)
       // 2. Close this fullscreen activity
        findViewById<Button>(R.id.stop_button).setOnClickListener {
            stopService(Intent(this, AlarmService::class.java))
            finish()
        }
    }
}
