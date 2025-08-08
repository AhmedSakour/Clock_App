package com.example.alarm_clock

import android.app.Service
import android.content.Intent
import android.media.MediaPlayer
import android.os.IBinder
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.app.NotificationCompat
import android.app.PendingIntent
import android.app.KeyguardManager 
import android.content.Context 
class AlarmService : Service() {
    companion object {
    // Shared media player instance to control alarm sound
        var mediaPlayer: MediaPlayer? = null
    }

    private val CHANNEL_ID = "alarm_channel_v1" // Unique channel ID for the alarm notification

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

    // Create the notification channel for Android 8 and above
        createNotificationChannel()

    // Intent to launch the full screen activity (used when phone is locked)
        val fullScreenIntent = Intent(this, FullScreenAlarmActivity::class.java)
        val fullScreenPendingIntent = PendingIntent.getActivity(
            this,
            0,
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

    // Intent to stop the alarm from the notification action
        val stopIntent = Intent(this, StopAlarmReceiver::class.java)
        val stopPendingIntent = PendingIntent.getBroadcast(
            this,
            0,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

    // Build the notification for the alarm
        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Alarm Ringing")
            .setContentText("Tap Stop to dismiss")
            .setSmallIcon(R.drawable.alarm_icon)
            .setOngoing(true) // Prevent swipe dismissal
            .setAutoCancel(false)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .addAction(R.drawable.alarm_icon, "Stop", stopPendingIntent)
            .setSound(null) 

    // Check if device is locked         
            val km = getSystemService(Context.KEYGUARD_SERVICE) as android.app.KeyguardManager
            if (km.isKeyguardLocked) {
                builder.setFullScreenIntent(fullScreenPendingIntent, true)
            }
    // Start the service in the foreground using the built notification
            val notification = builder.build()
                    startForeground(1, notification)

    // Start alarm sound if not already playing
            if (mediaPlayer == null) {
                mediaPlayer = MediaPlayer.create(this, R.raw.a_long_cold_sting)
                mediaPlayer?.isLooping = true
                mediaPlayer?.start()
            }

    // Automatically stop the alarm after 3 minutes to avoid infinite ringing
            Handler(Looper.getMainLooper()).postDelayed({
                stopSelf()
            }, 3 * 60 * 1000) // 3 minutes

        return START_STICKY
    }

    override fun onDestroy() {
    // Stop and release the media player when service is destroyed     
        mediaPlayer?.stop()
        mediaPlayer?.release()
        mediaPlayer = null
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
    
    // Function to create the notification channel for Android 8+
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Alarm Channel",
                NotificationManager.IMPORTANCE_HIGH
            )
            serviceChannel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            serviceChannel.setSound(null, null) // System will use mediaPlayer for sound
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }
}
