//
//  ViewController.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/2.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 
#import "WeatherPageView.h"
#import "WeatherHelper.h"
#import "ForecastDataEntity.h"
#import "YForecastDataEntity.h"
#import "MBProgressHUD.h"


@interface WeatherViewController : UIViewController<CLLocationManagerDelegate, UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>

@property (strong, nonatomic) WeatherHelper *weatherHelper;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray *forecastEntityArray;
@property (strong, nonatomic) NSMutableArray *woeidArray;
@property (retain, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction) refreshWeatherButtonEvent:(id)sender;
- (IBAction) changePageEvent:(id)sender;

@end

