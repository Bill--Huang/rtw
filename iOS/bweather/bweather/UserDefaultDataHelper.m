//
//  UserDefaultDataHelper.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/18.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "UserDefaultDataHelper.h"
#import "ConstantData.h"

@implementation UserDefaultDataHelper

+ (void) addUserDefaultCityArray: (NSString *) string {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldUserDic = [userDefault objectForKey: SETTING_DIC];
    NSMutableDictionary *newUserDic = [[NSMutableDictionary alloc] init];
    NSArray *oldwoeidArray = oldUserDic[SETTING_CITY_ARRAY];
    // udpate
    if(![oldwoeidArray containsObject:string]) {
        NSMutableArray *newWoeidArray = [[NSMutableArray alloc] initWithArray: oldwoeidArray];
        
        [newWoeidArray addObject: string];
        [newUserDic setValue:newWoeidArray forKey:SETTING_CITY_ARRAY];
        
        [newUserDic setObject:oldUserDic[SETTING_U_C] forKey: SETTING_U_C];
        [userDefault setValue:newUserDic forKey: SETTING_DIC];
        [userDefault synchronize];
    }
}

+ (void) deleteUserDefaultCityArrayAtIndex: (NSInteger) index {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldUserDic = [userDefault objectForKey: SETTING_DIC];
    NSMutableDictionary *newUserDic = [[NSMutableDictionary alloc] init];
    
    // udpate
    NSArray *oldwoeidArray = oldUserDic[SETTING_CITY_ARRAY];
    NSMutableArray *newWoeidArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < oldwoeidArray.count; i++) {
        if(i != index) {
            [newWoeidArray addObject: [oldwoeidArray objectAtIndex:i]];
        }
    }
    [newUserDic setValue:newWoeidArray forKey:SETTING_CITY_ARRAY];
    
    
    [newUserDic setObject:oldUserDic[SETTING_U_C] forKey: SETTING_U_C];
    [userDefault setValue:newUserDic forKey: SETTING_DIC];
    [userDefault synchronize];
}

+ (void) updateUserDefaultUnit: (NSNumber *) toggle {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldUserDic = [userDefault objectForKey: SETTING_DIC];
    NSMutableDictionary *newUserDic = [[NSMutableDictionary alloc] init];
    
    // update
    [newUserDic setObject:toggle forKey: SETTING_U_C];
    
    // store
    [newUserDic setValue:oldUserDic[SETTING_CITY_ARRAY] forKey:SETTING_CITY_ARRAY];
    [userDefault setValue:newUserDic forKey: SETTING_DIC];
    [userDefault synchronize];
}

+ (NSArray *) getUserDefaultCityArray {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldUserDic = [userDefault objectForKey: SETTING_DIC];

    return oldUserDic[SETTING_CITY_ARRAY];
}

+ (NSNumber *) getUserDefaultUnit {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldUserDic = [userDefault objectForKey: SETTING_DIC];
    
    return oldUserDic[SETTING_U_C];
}

+ (NSString *) getUUID {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefault objectForKey: UUID];
    
    if(uid == nil) {
        uid = [UserDefaultDataHelper uuid];
        
        [userDefault setValue:uid forKey: UUID];
        [userDefault synchronize];
    }
    
    return uid;
}

+ (NSString *) uuid {
    
    NSString *result = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
//    CFUUIDRef puuid = CFUUIDCreate( nil );
//    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//    CFRelease(puuid);
//    CFRelease(uuidString);
    return result;
}

@end
