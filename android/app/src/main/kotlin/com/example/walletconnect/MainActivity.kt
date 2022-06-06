package com.example.walletconnect

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.gson.Gson
import com.walletconnect.walletconnectv2.client.Sign
import com.walletconnect.walletconnectv2.client.SignClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

@Suppress("UNCHECKED_CAST")
class MainActivity : FlutterActivity(), SignClient.WalletDelegate, EventChannel.StreamHandler {
    private val PROJECT_ID = "d5b20589d5b166384f5969fd816959e8"
    private val EVENT_CHANNEL = "flutter.native/event"
    private val METHOD_CHANNEL = "flutter.native/method"
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var eventChannel: EventChannel
    private lateinit var methodChannel: MethodChannel
    private val uiThreadHandler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        val initString = Sign.Params.Init(
            application = application,
            relayServerUrl = "wss://relay.walletconnect.com?projectId=$PROJECT_ID",
            metadata = Sign.Model.AppMetaData(
                name = "Example Wallet",
                description = "Wallet description",
                url = "test.wconnect",
                icons = listOf("https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media")
            )
        )
        SignClient.initialize(initString) { error ->
            Log.e("WALLETLOG", error.throwable.stackTraceToString())
        }
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //event channel
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
        eventChannel.setStreamHandler(this)
        //method channel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "pair" -> {
                    val args = call.arguments() as String?
                    val pairCode = args ?: ""
                    val pairingParams = Sign.Params.Pair(pairCode)
                    SignClient.pair(pairingParams) { error ->
                        Log.e("WALLETLOG", error.throwable.stackTraceToString())
                        eventSink?.error("400", error.throwable.stackTraceToString(), null)
                    }
                }
                "approveSession" -> {
                    val args = call.arguments() as Map<String, Any>?
                    if (args != null) {
                        val proposerPublicKey = args["proposerPublicKey"] as String
                        val namespace = args["namespace"] as String
                        val accounts = args["accounts"] as List<String>
                        val methods = args["methods"] as List<String>
                        val events = args["events"] as List<String>
                        val namespaces: Map<String, Sign.Model.Namespace.Session> = mapOf(
                            namespace to Sign.Model.Namespace.Session(
                                accounts,
                                methods,
                                events,
                                null
                            )
                        )
                        val approveProposal = Sign.Params.Approve(
                            proposerPublicKey = proposerPublicKey,
                            namespaces = namespaces
                        )
                        SignClient.approveSession(approveProposal) { error ->
                            Log.e("WALLETLOG", error.throwable.stackTraceToString())
                            eventSink?.error("400", error.throwable.stackTraceToString(), null)
                        }
                    }
                }
                "rejectSession" -> {
                    val args = call.arguments() as Map<String, Any>?
                    if (args != null) {
                        val proposerPublicKey = args["proposerPublicKey"] as String
                        val rejectionReason = args["rejectionReason"] as String
                        val rejectionCode = args["rejectionCode"] as String
                        val rejectProposal = Sign.Params.Reject(
                            proposerPublicKey = proposerPublicKey,
                            reason = rejectionReason,
                            code = rejectionCode.toInt()
                        )
                        SignClient.rejectSession(rejectProposal) { error ->
                            Log.e("WALLETLOG", error.throwable.stackTraceToString())
                            eventSink?.error("400", error.throwable.stackTraceToString(), null)
                        }
                    }
                }
                "disconnect" -> {
                    val args = call.arguments() as Map<String, Any>?
                    if (args != null) {
                        val disconnectionReason = args["disconnectionReason"] as String
                        val sessionTopic = args["sessionTopic"] as String
                        val disconnectParams = Sign.Params.Disconnect(
                            sessionTopic = sessionTopic,
                            reason = disconnectionReason,
                            reasonCode = 1000
                        )
                        Log.e("WALLETLOG", "topic = $sessionTopic")

                        SignClient.disconnect(disconnectParams) { error ->
                            Log.e("WALLETLOG", error.throwable.stackTraceToString())
                            eventSink?.error("400", error.throwable.stackTraceToString(), null)
                        }
                    }
                }
                "requestApprove" -> {
                    val args = call.arguments() as Map<String, Any>?
                    if (args != null) {
                        val sessionTopic = args["sessionTopic"] as String
                        val requestId = args["requestId"] as String
                        val jsonRpcResponse: Sign.Model.JsonRpcResponse.JsonRpcResult =
                            Sign.Model.JsonRpcResponse.JsonRpcResult(
                                id = requestId.toLong(),
                                result = "this is result"
//                                result = "0xa3f20717a250c2b0b729b7e5becbff67fdaef7e0699da4de7ca5895b02a170a12d887fd3b17bfdce3481f10bea41f45ba9f709d39ce8325427b57afcfc994cee1b"
                            )
                        val resultRes = Sign.Params.Response(
                            sessionTopic = sessionTopic,
                            jsonRpcResponse = jsonRpcResponse
                        )
                        SignClient.respond(resultRes) { error ->
                            Log.e("WALLETLOG", error.throwable.stackTraceToString())
                            eventSink?.error("400", error.throwable.stackTraceToString(), null)
                        }
                    }
                }
                "requestReject" -> {
                    val args = call.arguments() as Map<String, Any>?
                    if (args != null) {
                        val sessionTopic = args["sessionTopic"] as String
                        val requestId = args["requestId"] as String
                        val jsonRpcResponse: Sign.Model.JsonRpcResponse.JsonRpcError =
                            Sign.Model.JsonRpcResponse.JsonRpcError(
                                id = requestId.toLong(),
                                code = 1000,
                                message = "Rejecting by app"
                            )
                        val resultRes = Sign.Params.Response(
                            sessionTopic = sessionTopic,
                            jsonRpcResponse = jsonRpcResponse
                        )
                        SignClient.respond(resultRes) { error ->
                            Log.e("WALLETLOG", error.throwable.stackTraceToString())
                            eventSink?.error("400", error.throwable.stackTraceToString(), null)
                        }
                    }
                }
            }
            result.success(true)
        }
        SignClient.setWalletDelegate(this)
    }

    private fun toJson(obj: Any): String {
        val gson = Gson()
        return gson.toJson(obj)
    }

    override fun onConnectionStateChange(state: Sign.Model.ConnectionState) {
        emit("onConnectionStateChange", state)
    }

    override fun onSessionDelete(deletedSession: Sign.Model.DeletedSession) {
        emit("onSessionDelete", deletedSession)
    }

    override fun onSessionProposal(sessionProposal: Sign.Model.SessionProposal) {
        emit("onSessionProposal", sessionProposal)
    }

    override fun onSessionRequest(sessionRequest: Sign.Model.SessionRequest) {
        emit("onSessionRequest", sessionRequest)
    }

    override fun onSessionSettleResponse(settleSessionResponse: Sign.Model.SettledSessionResponse) {
        emit("onSessionSettleResponse", settleSessionResponse)
    }

    override fun onSessionUpdateResponse(sessionUpdateResponse: Sign.Model.SessionUpdateResponse) {
        emit("onSessionUpdateResponse", sessionUpdateResponse)
    }

    private fun emit(state: String, payload: Any) {
        uiThreadHandler.post {
            val hashMap: HashMap<String, Any> = hashMapOf()
            hashMap["state"] = state
            hashMap["payload"] = payload
            //Log.d("WALLETLOG", "$state(${toJson(payload)})")
            eventSink?.success(toJson(hashMap))
        }
    }

    //Stream
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        if (eventSink == null) return
        eventSink = null
    }
}
