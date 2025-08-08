package com.example.alarm_clock

import android.app.PendingIntent
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.os.Build
import androidx.core.app.NotificationCompat

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
    // Start the AlarmService which plays the alarm sound and shows the full screen activity
        val serviceIntent = Intent(context, AlarmService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
    // For Android 8.0 and above, start service as a foreground service
            context.startForegroundService(serviceIntent)
        } else {
    // For older versions, start it normally
            context.startService(serviceIntent)
        }

    // Create an Intent to stop the alarm when the user taps the "Stop" button in the notification
        val stopIntent = Intent(context, StopAlarmReceiver::class.java)
        val stopPendingIntent = PendingIntent.getBroadcast(
            context,
            0,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val channelId = "alarm_channel"
    // Create a notification channel if we're on Android 8 or higher
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Alarm Channel",
                NotificationManager.IMPORTANCE_HIGH
            )
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    // Build the notification shown when the alarm triggers
        val notification = NotificationCompat.Builder(context, channelId)
            .setContentTitle("Alarm Ringing")
            .setContentText("Tap to stop")
            .setSmallIcon(R.drawable.alarm_icon)
            .addAction(R.drawable.ic_stop, "Stop Alarm", stopPendingIntent)
            .setSound(null) 
            .build()
    // Show the notification
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(1, notification)
    }
}
