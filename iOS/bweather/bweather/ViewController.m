//
//  ViewController.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/2.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.weatherHelper = [[WeatherHelper alloc] init];
    [self.weatherHelper getForecastWeatherEntityWithAPIType: Yahoo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
