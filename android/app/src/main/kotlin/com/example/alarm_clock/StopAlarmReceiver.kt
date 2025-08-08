package com.example.alarm_clock

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.AlarmManager
import android.app.PendingIntent
import android.util.Log

// This BroadcastReceiver handles the "Stop" action from the notification or system intent
class StopAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        Log.d("StopAlarmReceiver", "Stop action received")

        // Step 1: Stop the AlarmService which is playing the sound
        val stopIntent = Intent(context, AlarmService::class.java)
        context.stopService(stopIntent)

        // Step 2: Create an intent to match the one used to schedule the alarm
        val alarmIntent = Intent(context, AlarmReceiver::class.java)

        // Step 3: Create the same PendingIntent used in AlarmManager
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            0,
            alarmIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Step 4: Get the AlarmManager service
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        
        // Step 5: Cancel the alarm so it won't trigger again
        alarmManager.cancel(pendingIntent)

        Log.d("StopAlarmReceiver", "Alarm canceled and service stopped")
    }
}
