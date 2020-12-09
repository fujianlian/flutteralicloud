package com.example.flutteralicloud

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import com.jarvanmo.rammus.RammusPlugin
import io.flutter.app.FlutterApplication
import android.graphics.Color
import android.os.Build.VERSION.SDK_INT
import android.os.Build


class MyApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel();
        RammusPlugin.initPushService(this)
    }

    private fun createNotificationChannel() {
        if (SDK_INT >= Build.VERSION_CODES.O) {
            val mNotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            // 通知渠道的id。
            val id = "1"
            // 用户可以看到的通知渠道的名字。
            val name = "notification channel"
            // 用户可以看到的通知渠道的描述。
            val description = "notification description"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel(id, name, importance)
            // 配置通知渠道的属性。
            mChannel.setDescription(description)
            // 设置通知出现时的闪灯（如果Android设备支持的话）。
            mChannel.enableLights(true)
            mChannel.setLightColor(Color.RED)
            // 设置通知出现时的震动（如果Android设备支持的话）。
            mChannel.enableVibration(true)
            mChannel.setVibrationPattern(longArrayOf(100, 200, 300, 400, 500, 400, 300, 200, 400))
            // 最后在notificationmanager中创建该通知渠道。
            mNotificationManager!!.createNotificationChannel(mChannel)
        }

    }
}