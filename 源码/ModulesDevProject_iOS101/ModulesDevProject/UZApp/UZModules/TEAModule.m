//
//  UZModuleDemo.m
//  UZModule
//
//  Created by kenny on 14-3-5.
//  Copyright (c) 2014年 APICloud. All rights reserved.
//

#import "TEAModule.h"
#import "UZAppDelegate.h"
#import "NSDictionaryUtils.h"
#import "XXTEA.h"

@interface TEAModule ()
<UIAlertViewDelegate>
{
    NSString *mKey;
}

@end

@implementation TEAModule

#pragma mark - Override
+ (void)onAppLaunch:(NSDictionary *)launchOptions {
    // 方法在应用启动时被调用
}
    
- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        
    }
    return self;
}

- (void)dispose {
    //do clean
}

JS_METHOD(setKey:(UZModuleMethodContext *)context) {
    NSDictionary *param = context.param;
    NSString *key = [param stringValueForKey:@"key" defaultValue:nil];
    if(key.length<=0){
        NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        NSMutableDictionary * errdict = [NSMutableDictionary dictionaryWithObject:@"key is not null" forKey:@"msg"];
        [context callbackWithRet:ret err:errdict delete:YES];
        return;
    }
    
    mKey = key;
    
    //succ
    NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    [context callbackWithRet:ret err:nil delete:YES];
}

/**
 * 同步设置key
 * @param moduleContext
 * @return
 */
JS_METHOD_SYNC(setKeySync:(UZModuleMethodContext *)context) {
    NSDictionary *param = context.param;
    NSString *key = [param stringValueForKey:@"key" defaultValue:nil];
    if(key.length<=0){
        return [NSNumber numberWithBool:NO];
    }
    mKey = key;
    //succ
    return [NSNumber numberWithBool:YES];
}

/**
 加密
 **/
JS_METHOD(encrypt:(UZModuleMethodContext *)context) {
    NSDictionary *param = context.param;
    NSString *data = [param stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [param stringValueForKey:@"key" defaultValue:nil];
    if(key.length>0){
        mKey = key;
    }
    if(mKey.length<=0 || data.length<=0){
        NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        NSMutableDictionary * errdict = [NSMutableDictionary dictionaryWithObject:@"key or data is not null" forKey:@"msg"];
        [context callbackWithRet:ret err:errdict delete:YES];
        return;
    }
    
    NSString *encrypt_data = [XXTEA encryptStringToHexString:data stringKey:mKey];
    //succ
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    [ret setObject:encrypt_data.length<=0?@"":encrypt_data forKey:@"result"];
    [context callbackWithRet:ret err:nil delete:YES];
}


/**
 同步加密
 **/
JS_METHOD_SYNC(encryptSync:(UZModuleMethodContext *)context) {
    NSDictionary *param = context.param;
    NSString *data = [param stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [param stringValueForKey:@"key" defaultValue:nil];
    if(key.length>0){
        mKey = key;
    }
    if(mKey.length<=0 || data.length<=0){
        return @"";
    }
    
    NSString *encrypt_data = [XXTEA encryptStringToHexString:data stringKey:mKey];
    //succ
    return encrypt_data.length<=0?@"":encrypt_data;
}

/**
 解密
 **/
JS_METHOD(decrypt:(UZModuleMethodContext *)context) {
    NSDictionary *param = context.param;
    NSString *data = [param stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [param stringValueForKey:@"key" defaultValue:nil];
    if(key.length>0){
        mKey = key;
    }
    if(mKey.length<=0 || data.length<=0){
        NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        NSMutableDictionary * errdict = [NSMutableDictionary dictionaryWithObject:@"key or data is not null" forKey:@"msg"];
        [context callbackWithRet:ret err:errdict delete:YES];
        return;
    }
    
    NSString *decrypt_data = [XXTEA decryptHexStringToString:data stringKey:mKey];

    //succ
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    [ret setObject:decrypt_data.length<=0?@"":decrypt_data forKey:@"result"];
    [context callbackWithRet:ret err:nil delete:YES];
}

/**
 同步解密
 **/
JS_METHOD_SYNC(decryptSync:(UZModuleMethodContext *)context) {
    NSDictionary *param = context.param;
    NSString *data = [param stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [param stringValueForKey:@"key" defaultValue:nil];
    if(key.length>0){
        mKey = key;
    }
    if(mKey.length<=0 || data.length<=0){
        return @"";
    }
    
    NSString *decrypt_data = [XXTEA decryptHexStringToString:data stringKey:mKey];
    
    //succ
    return decrypt_data.length<=0?@"":decrypt_data;
}

@end
