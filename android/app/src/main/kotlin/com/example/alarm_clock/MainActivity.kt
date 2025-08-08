package com.example.alarm_clock

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Intent
import android.os.SystemClock
import java.util.*
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.alarm_clock/alarm"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                // Handle "startAlarmService" method from Flutter
                "startAlarmService" -> {
                    val intent = Intent(this, AlarmService::class.java)
                    startForegroundService(intent)
                    result.success("Alarm started")
                }

                // Handle "stopAlarmService" method from Flutter
                "stopAlarmService" -> {
                    val intent = Intent(this, AlarmService::class.java)
                    stopService(intent)
                    result.success("Alarm stopped")
                }

                // Handle "scheduleNativeAlarm" method from Flutter
                "scheduleNativeAlarm" -> {
                    // Get the alarm time in milliseconds from Flutter
                    val timeInMillis = call.argument<Long>("time") ?: 0L

                    // Get Android AlarmManager system service
                    val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager

                    // Create intent to trigger AlarmReceiver
                    val intent = Intent(this, AlarmReceiver::class.java)

                    // Create pending broadcast intent to be triggered by AlarmManager
                    val pendingIntent = PendingIntent.getBroadcast(
                        this,
                        0,
                        intent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )

                   // Schedule an exact alarm even while the device is idle
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        timeInMillis,
                        pendingIntent
                    )

                    result.success("Alarm scheduled at $timeInMillis")
                  }

                // Handle "cancelNativeAlarm" method from Flutter
                "cancelNativeAlarm" -> {
                    val alarmManager = getSystemService(ALARM_SERVICE) as AlarmManager
                    val intent = Intent(this, AlarmReceiver::class.java)

                    val pendingIntent = PendingIntent.getBroadcast(
                        this,
                        0,
                        intent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    // Cancel any scheduled alarm
                    alarmManager.cancel(pendingIntent)
                    result.success("Alarm cancelled")
                }

                // Handle unknown method calls
                else -> result.notImplemented()
            }
        }
    }
}
