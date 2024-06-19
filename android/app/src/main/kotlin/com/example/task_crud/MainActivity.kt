package com.example.task_crud

import android.annotation.SuppressLint
import android.os.BatteryManager
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class MainActivity: FlutterActivity() {
    private val eventChannel = "timeHandlerEvent"
    private val channel = "my_channel"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            TimeHandler
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->
            if (call.method == "getDataFromNative") {
                // Perform platform-specific operations and obtain the result
                val data = getDataFromNative()

                // Send the result back to Flutter
                result.success(data)
            }
            if (call.method.equals("getBatteryLevel")) {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        }

    object TimeHandler : EventChannel.StreamHandler {
        // Handle event in main thread.
        private var handler = Handler(Looper.getMainLooper())

        // Declare our eventSink later it will be initialized
        private var eventSink: EventChannel.EventSink? = null

        @SuppressLint("SimpleDateFormat")
        override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
            eventSink = sink
            // every second send the time
            val r: Runnable = object : Runnable {
                override fun run() {
                    handler.post {
                        val dateFormat = SimpleDateFormat("HH:mm:ss")
                        val time = dateFormat.format(Date())
                        eventSink?.success(time)
                    }
                    handler.postDelayed(this, 1000)
                }
            }
            handler.postDelayed(r, 1000)
        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }
    }

    private fun getDataFromNative(): String {
        // Perform platform-specific operations to fetch the data
        return "Data from Native"
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

        return batteryLevel
    }

}