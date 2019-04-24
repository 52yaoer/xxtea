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

- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        
    }
    return self;
}

- (void)dispose {
    //do clean
}

- (void)setKey:(NSDictionary *)paramDict {
    NSInteger cbId = [paramDict integerValueForKey:@"cbId" defaultValue:0];
    NSString *key = [paramDict stringValueForKey:@"key" defaultValue:nil];
    if(key.length<=0){
        NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        NSMutableDictionary * errdict = [NSMutableDictionary dictionaryWithObject:@"key is not null" forKey:@"msg"];
        
        [self sendResultEventWithCallbackId:cbId dataDict:ret errDict:errdict doDelete:YES];
        return;
    }
    
    mKey = key;
    
    //succ
    NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    [self sendResultEventWithCallbackId:cbId dataDict:ret errDict:nil doDelete:YES];
}

/**
 * 同步设置key
 * @param moduleContext
 * @return
 */
- (NSNumber *)setKeySync:(NSDictionary *)paramDict {
    NSString *key = [paramDict stringValueForKey:@"key" defaultValue:nil];
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
- (void)encrypt:(NSDictionary *)paramDict {
    NSInteger cbId = [paramDict integerValueForKey:@"cbId" defaultValue:0];
    NSString *data = [paramDict stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [paramDict stringValueForKey:@"key" defaultValue:nil];
    if(key.length>0){
        mKey = key;
    }
    if(mKey.length<=0 || data.length<=0){
        NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        NSMutableDictionary * errdict = [NSMutableDictionary dictionaryWithObject:@"key or data is not null" forKey:@"msg"];
        
        [self sendResultEventWithCallbackId:cbId dataDict:ret errDict:errdict doDelete:YES];
        return;
    }
    
    NSString *encrypt_data = [XXTEA encryptStringToHexString:data stringKey:mKey];
    //succ
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    [ret setObject:encrypt_data.length<=0?@"":encrypt_data forKey:@"result"];
    [self sendResultEventWithCallbackId:cbId dataDict:ret errDict:nil doDelete:YES];
}


/**
 同步加密
 **/
- (NSString *)encryptSync:(NSDictionary *)paramDict {
    NSString *data = [paramDict stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [paramDict stringValueForKey:@"key" defaultValue:nil];
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
- (void)decrypt:(NSDictionary *)paramDict {
    NSInteger cbId = [paramDict integerValueForKey:@"cbId" defaultValue:0];
    NSString *data = [paramDict stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [paramDict stringValueForKey:@"key" defaultValue:nil];
    if(key.length>0){
        mKey = key;
    }
    if(mKey.length<=0 || data.length<=0){
        NSDictionary *ret = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        NSMutableDictionary * errdict = [NSMutableDictionary dictionaryWithObject:@"key or data is not null" forKey:@"msg"];
        
        [self sendResultEventWithCallbackId:cbId dataDict:ret errDict:errdict doDelete:YES];
        return;
    }
    
    NSString *decrypt_data = [XXTEA decryptHexStringToString:data stringKey:mKey];

    //succ
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    [ret setObject:decrypt_data.length<=0?@"":decrypt_data forKey:@"result"];
    [self sendResultEventWithCallbackId:cbId dataDict:ret errDict:nil doDelete:YES];
}

/**
 同步解密
 **/
- (NSString *)decryptSync:(NSDictionary *)paramDict {
    NSString *data = [paramDict stringValueForKey:@"data" defaultValue:nil];
    NSString *key = [paramDict stringValueForKey:@"key" defaultValue:nil];
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
