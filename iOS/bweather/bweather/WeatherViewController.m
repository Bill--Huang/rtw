//
//  ViewController.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/2.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "WeatherViewController.h"
#import "YForecastDataEntity.h"
#import "NSDate+Date.h"
#import "DayForecastCell.h"
#import "YQL.h"
#import "RequestHelper.h"
#import "EnumCollection.h"
#import "ConstantData.h"
#import "UserDefaultDataHelper.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self initSetting];
    // init userdefault
    self.forecastEntityArray = [[NSMutableArray alloc] init];
    
    // init pagecontrol and scrollview
    self.pageControl.numberOfPages = 1;
    self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);

    // set up gps
    [self getGPSLocation];
    
//    self.tabBarController.delegate = self;
//    self.tabBarController.tabBar.delegate = self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) initSetting {
//    NSString *uuid = [UserDefaultDataHelper getUUID];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary* userDic = [userDefault objectForKey: SETTING_DIC];
    
    if(userDic == nil) {
        // first set
        self.woeidArray = [[NSMutableArray alloc] init];
        [self.woeidArray addObject: @"12578012-上海"]; // shanghai
        [self.woeidArray addObject: @"2151330-北京"];  // beijing
        
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setValue:self.woeidArray forKey: SETTING_CITY_ARRAY];
       
        [temp setValue: [NSNumber numberWithInt:1] forKey:SETTING_U_C];
        
        [userDefault setValue:temp forKey: SETTING_DIC];
        [userDefault synchronize];
        
        //store user gps data
        NSDictionary* gpsDic = [userDefault objectForKey: USER_GPS_DATA];
        
        if(gpsDic == nil) {
            NSMutableDictionary *gpsTemp = [[NSMutableDictionary alloc] init];
            [gpsTemp setValue:[NSNumber numberWithInt: 0] forKey:HAVE_GPS_DATA];
            [gpsTemp setValue:@"" forKey:GPS_CITY];
            [gpsTemp setValue:@"" forKey:GPS_LOCATION];
            [gpsTemp setValue:@"" forKey:GPS_WOEID];
            
            [userDefault setValue:gpsTemp forKey: USER_GPS_DATA];
            [userDefault synchronize];
        }
    } else {
        // get city list
        self.woeidArray = userDic[SETTING_CITY_ARRAY];
    }
}


- (void) getGPSLocation {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 1000;
    [self.locationManager startUpdatingLocation];
}

- (void) getWeather {
    // clean subview in scrollview
    for (UIView * subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.labelText = @"更新天气";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSNumber * haveGPS = [[NSUserDefaults standardUserDefaults] objectForKey: USER_GPS_DATA][HAVE_GPS_DATA];
        if( [haveGPS intValue] == 1) {
            [self.locationManager stopUpdatingLocation];
        }
        // generate woeid array
        self.weatherHelper = [[WeatherHelper alloc] init];
        
        NSMutableArray * tempArray = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < self.woeidArray.count;  i++) {
            [tempArray addObject: [self getWoeidFromString: [self.woeidArray objectAtIndex:i]]];
        }
        self.forecastEntityArray = [self.weatherHelper getYForecastWeatherEntityWithArray: tempArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.forecastEntityArray.count, self.scrollView.frame.size.height);
            self.pageControl.numberOfPages = self.forecastEntityArray.count;
            for (int i = 0; i < self.forecastEntityArray.count; i++) {
                NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:@"WeatherPageView" owner:self options:nil];
                WeatherPageView *subView = [nibViews objectAtIndex:0];
                subView.forecastDataEntity = [self.forecastEntityArray objectAtIndex:i];
                [subView updateView];
                subView.frame = CGRectMake(self.view.frame.size.width * i, 0, subView.frame.size.width, subView.frame.size.height);
                [self.scrollView addSubview:subView];
            }
            
            [self.hud removeFromSuperview];
        });
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // can get location
        
    } else if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        // not
        [self setUserGPSDataDefaultWithisGPS:[NSNumber numberWithInt:0] cityName:@"" cityWoeid:@"" location:@""];
        [self getWeather];
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        // wait for choice
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didChangeAuthorizationStatus----%@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.locationManager stopUpdatingLocation];
    
    NSString *woeid = nil;
    NSDictionary* woeidResult = [YQL query:
                                 [NSString stringWithFormat: @"select * from geo.placefinder where text='%f, %f' and gflags='R'", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
    NSDictionary *gpsInfoDic = nil;
    // add
    if(woeidResult != nil
       && woeidResult[@"query"][@"results"][@"Result"][@"woeid"] != nil
       && ![woeidResult[@"query"][@"results"][@"Result"][@"woeid"] isEqualToString:@""]) {
        // get woeid
        woeid = woeidResult[@"query"][@"results"][@"Result"][@"woeid"];
        gpsInfoDic = woeidResult[@"query"][@"results"][@"Result"];
    }

    if(woeid != nil && ![woeid isEqualToString:@""]) {
        if(![woeid isEqualToString: [self getWoeidFromString: [self.woeidArray objectAtIndex:0]]]) {
            // get gps
            // store in userdefault
            // 精确到市区
            NSString *cityName = [NSString stringWithFormat:@"%@ %@", gpsInfoDic[@"line3"], gpsInfoDic[@"line2"]];
            [self setUserGPSDataDefaultWithisGPS:[NSNumber numberWithInt:1] cityName:cityName cityWoeid:woeid location:gpsInfoDic[@"name"]];

            // refresh woeid array
            NSMutableArray * temp = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@-%@", woeid, cityName], nil];
            [temp addObjectsFromArray:self.woeidArray];
            self.woeidArray = temp;
        }
    }
    
    [self getWeather];
}

- (void) setUserGPSDataDefaultWithisGPS: (NSNumber *) isgps cityName: (NSString *) name cityWoeid: (NSString *) woeid location: (NSString *) l {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* gpsDic = [[NSMutableDictionary alloc] init];
    
        
    [gpsDic setValue:isgps forKey:HAVE_GPS_DATA];
    [gpsDic setValue:woeid forKey:GPS_WOEID];
    [gpsDic setValue:l forKey:GPS_LOCATION];
    [gpsDic setValue:name forKey:GPS_CITY];
    
    [userDefault setValue:gpsDic forKey: USER_GPS_DATA];
    [userDefault synchronize];
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = self.scrollView.contentOffset.x / self.view.frame.size.width;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (IBAction) changePageEvent:(id)sender {
    NSInteger page = self.pageControl.currentPage;
    [self.scrollView setContentOffset: CGPointMake(self.view.frame.size.width * page, 0)];
}

#pragma - mark Action Event
- (IBAction) refreshWeatherButtonEvent:(id)sender {
    [self refreshWeather];
}

- (void) refreshWeather {
    // get new woeid array
    NSMutableArray *newWoeid = [[NSMutableArray alloc] init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:USER_GPS_DATA][HAVE_GPS_DATA] intValue] == 1) {
        [newWoeid addObject: [self.woeidArray objectAtIndex:0]];
    }
    [newWoeid addObjectsFromArray: [UserDefaultDataHelper getUserDefaultCityArray]];
    
    self.woeidArray = newWoeid;
    [self getWeather];
}

- (NSString *) getWoeidFromString: (NSString *) string {
    NSRange tr = [string rangeOfString:@"-"];
    return [string substringToIndex: tr.location];
}



@end
