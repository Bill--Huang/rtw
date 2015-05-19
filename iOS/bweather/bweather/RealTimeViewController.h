

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

@interface RealTimeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DFBlunoDelegate,  UITabBarControllerDelegate>

@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDev;
@property(strong, nonatomic) NSMutableArray* aryDevices;

@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSTimer *timeOutTimerForDeviceScan;

// use array, calculate average
@property (strong, nonatomic) NSString *temperatureData;
@property (strong, nonatomic) NSString *humidityData;
@property (strong, nonatomic) NSString *pm25Data;

- (IBAction) actionAddDeviceButton:(id)sender;

@end
