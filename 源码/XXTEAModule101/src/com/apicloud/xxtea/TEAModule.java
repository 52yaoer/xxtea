package com.apicloud.xxtea;

import org.json.JSONException;
import org.json.JSONObject;

import android.text.TextUtils;

import com.uzmap.pkg.uzcore.UZWebView;
import com.uzmap.pkg.uzcore.uzmodule.ModuleResult;
import com.uzmap.pkg.uzcore.uzmodule.UZModule;
import com.uzmap.pkg.uzcore.uzmodule.UZModuleContext;

public class TEAModule extends UZModule {
	private static String charset = "UTF-8";
	private String mKey;
	
	public TEAModule(UZWebView webView) {
		super(webView);
	}
	
	/**
     * 设置密钥
     * @param k 密钥
     * @return 密钥长度为16个byte时， 设置密钥并返回true，否则返回false
     */
	public void jsmethod_setKey(final UZModuleContext moduleContext){
		String key = moduleContext.optString("key");
		if(TextUtils.isEmpty(key)){
			JSONObject ret = new JSONObject();
			JSONObject err = new JSONObject();
			try {
				ret.put("status", false);
				err.put("msg", "key is not null");
				
				moduleContext.error(ret, err, false);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return;
		}
		
		mKey = key;
		
		try {
			JSONObject ret = new JSONObject();
			ret.put("status", true);
			moduleContext.success(ret, true);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 同步设置key
	 * @param moduleContext
	 * @return
	 */
	public ModuleResult jsmethod_setKeySync_sync(final UZModuleContext moduleContext){
		String key = moduleContext.optString("key");
		if(TextUtils.isEmpty(key)){
			return new ModuleResult(false);
		}
		mKey = key;
		return new ModuleResult(true);
	}
	
	/**
	 * 加密
	 * @param moduleContext
	 */
	public void jsmethod_encrypt(final UZModuleContext moduleContext){
		String data = moduleContext.optString("data");
		String key = moduleContext.optString("key");
		if(!TextUtils.isEmpty(key)){
			mKey = key;
		}
		if(TextUtils.isEmpty(data) || TextUtils.isEmpty(mKey)){
			JSONObject ret = new JSONObject();
			JSONObject err = new JSONObject();
			try {
				ret.put("status", false);
				err.put("msg", "key or data is not null");
				
				moduleContext.error(ret, err, false);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return;
		}
		
		String hexResult = "";
		try {
			hexResult = XXTeaUtil.encryptStr(data, charset, mKey);
		} catch (Exception e) {
			e.printStackTrace();
			hexResult = "";
		}
		
		try {
			JSONObject ret = new JSONObject();
			ret.put("status", true);
			ret.put("result", hexResult);
			moduleContext.success(ret, true);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 同步加密
	 * @param moduleContext
	 */
	public ModuleResult jsmethod_encryptSync_sync(final UZModuleContext moduleContext){
		String data = moduleContext.optString("data");
		String key = moduleContext.optString("key");
		if(!TextUtils.isEmpty(key)){
			mKey = key;
		}
		if(TextUtils.isEmpty(data) || TextUtils.isEmpty(mKey)){
			return new ModuleResult("");
		}
		
		try {
			String hexResult = XXTeaUtil.encryptStr(data, charset, mKey);
			return new ModuleResult(hexResult);
		} catch (Exception e) {
			e.printStackTrace();
			
			return new ModuleResult("");
		}
	}
	
	/**
	 * 解密
	 * @param moduleContext
	 */
	public void jsmethod_decrypt(final UZModuleContext moduleContext){
		String data = moduleContext.optString("data");
		String key = moduleContext.optString("key");
		if(!TextUtils.isEmpty(key)){
			mKey = key;
		}
		
		if(TextUtils.isEmpty(data) || TextUtils.isEmpty(mKey)){
			JSONObject ret = new JSONObject();
			JSONObject err = new JSONObject();
			try {
				ret.put("status", false);
				err.put("msg", "key or data is not null");
				
				moduleContext.error(ret, err, false);
			} catch (JSONException e) {
				e.printStackTrace();
			}
			return;
		}
		
		String hexResult = "";
		try {
			hexResult = XXTeaUtil.decryptStr(data, charset, mKey);
		} catch (Exception e) {
			e.printStackTrace();
			hexResult = "";
		}
		
		try {
			JSONObject ret = new JSONObject();
			ret.put("status", true);
			ret.put("result", TextUtils.isEmpty(hexResult)?"":hexResult);
			moduleContext.success(ret, true);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 同步解密
	 * @param moduleContext
	 */
	public ModuleResult jsmethod_decryptSync_sync(final UZModuleContext moduleContext){
		String data = moduleContext.optString("data");
		String key = moduleContext.optString("key");
		if(!TextUtils.isEmpty(key)){
			mKey = key;
		}
		
		if(TextUtils.isEmpty(data) || TextUtils.isEmpty(mKey)){
			return new ModuleResult("");
		}
		
		try {
			String hexResult = XXTeaUtil.decryptStr(data, charset, mKey);
			return new ModuleResult(TextUtils.isEmpty(hexResult)?"":hexResult);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModuleResult("");
		}
	}
}
