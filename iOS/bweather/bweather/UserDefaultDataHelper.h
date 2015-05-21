//
//  UserDefaultDataHelper.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/18.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>

#define SETTING_DIC @"setting_dic"
#define SETTING_U_C @"setting_u"
#define SETTING_CITY_ARRAY @"setting_city_array"

#define USER_GPS_DATA @"user_gps_data"
#define HAVE_GPS_DATA @"have_gps_data"
#define GPS_CITY @"gps_city"
#define GPS_WOEID @"gps_woeid"
#define GPS_LOCATION @"gps_location"

#define UUID @"uuid"

@interface UserDefaultDataHelper : NSObject

+ (void) addUserDefaultCityArray: (NSString *) string;
+ (void) deleteUserDefaultCityArrayAtIndex: (NSInteger) index;
+ (void) updateUserDefaultUnit: (NSNumber *) toggle;
+ (NSArray *) getUserDefaultCityArray;
+ (NSNumber *) getUserDefaultUnit;
+ (NSString *) getGPSWoeid;
+ (NSString *) getGPSCityName;
+ (NSString *) getGPSLocation;
+ (NSString *) getUUID;
@end
