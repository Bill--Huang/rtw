

//
//  RealTimeViewController.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/15.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBlunoManager.h"
#import "MBProgressHUD.h"
#import "RealTimeDataEntity.h"

@interface RealTimeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DFBlunoDelegate,  UITabBarControllerDelegate>

@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDev;

@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSTimer *timeOutTimerForDeviceScan;

// use array, calculate average, send to server
@property (strong, nonatomic) RealTimeDataEntity *realTimeDataEntity;
@property (strong, nonatomic) NSString *temperatureData;
@property (strong, nonatomic) NSString *humidityData;
@property (strong, nonatomic) NSString *pm25Data;

// for pm25 template
@property (strong, nonatomic) IBOutlet UIView *pm25TemplateView;
@property (strong, nonatomic) IBOutlet UILabel *pm25Label;
@property (strong, nonatomic) IBOutlet UILabel *pm25ConditionLabel;
- (IBAction) closePM25TemplateViewButtonEvent:(id)sender;


- (IBAction) actionAddDeviceButton:(id)sender;

@end
