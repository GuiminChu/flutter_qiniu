package cn.fg.flutter_qiniu;

import android.util.Log;

import com.qiniu.android.common.FixedZone;
import com.qiniu.android.common.Zone;
import com.qiniu.android.http.ResponseInfo;
import com.qiniu.android.storage.Configuration;
import com.qiniu.android.storage.UpCompletionHandler;
import com.qiniu.android.storage.UploadManager;

import org.json.JSONObject;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterQiniuPlugin
 */
public class FlutterQiniuPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_qiniu");
        channel.setMethodCallHandler(new FlutterQiniuPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("upload")) {
            upload(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void upload(MethodCall call, final Result result) {
        String filePath = call.argument("filePath");
        String key = call.argument("key");
        String token = call.argument("token");
        String zoneRaw = call.argument("zone");

        Configuration config = new Configuration.Builder()
                .chunkSize(512 * 1024)        // 分片上传时，每片的大小。 默认256K
                .putThreshhold(1024 * 1024)   // 启用分片上传阀值。默认512K
                .connectTimeout(10)           // 链接超时。默认10秒
                .useHttps(true)               // 是否使用https上传域名
                .responseTimeout(60)          // 服务器响应超时。默认60秒
                .zone(getZone(zoneRaw))        // 设置区域，指定不同区域的上传域名、备用域名、备用IP。
                .build();

        // 重用uploadManager。一般地，只需要创建一个uploadManager对象
        UploadManager uploadManager = new UploadManager(config);

        uploadManager.put(filePath, key, token,
                new UpCompletionHandler() {
                    @Override
                    public void complete(String key, ResponseInfo info, JSONObject res) {
                        //res包含hash、key等信息，具体字段取决于上传策略的设置
                        if (info.isOK()) {
                            Log.i("qiniu", "Upload Success");
                        } else {
                            Log.i("qiniu", "Upload Fail");
                            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
                        }
                        Log.i("qiniu", key + ",\r\n " + info + ",\r\n " + res);

                        result.success(info.isOK());
                    }
                }, null);
    }

    private Zone getZone(String raw) {
        Zone zone = FixedZone.zone0;

        switch (raw) {
            case "0":
                zone = FixedZone.zone0;
                break;
            case "1":
                zone = FixedZone.zone1;
                break;
            case "2":
                zone = FixedZone.zone2;
                break;
            case "3":
                zone = FixedZone.zoneNa0;
                break;
            case "4":
                zone = FixedZone.zoneAs0;
                break;
        }

        return zone;
    }
}
