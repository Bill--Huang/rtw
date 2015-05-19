//
//  RealTimeViewController.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/15.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "RealTimeViewController.h"
#import "RTTableViewCell.h"
#import "UserDefaultDataHelper.h"
#import "MBProgressHUD.h"

#define START_SEND_DATA @"1"
#define STOP_SEND_DATA_DISCONNECT @"2"

@implementation RealTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.delegate = self;
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.aryDevices = [[NSMutableArray alloc] init];
    
    [self resetData];
}

- (void) resetData {
    self.temperatureData = nil;
    self.humidityData = nil;
    self.pm25Data = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"RTTableViewCell";
    RTTableViewCell *cell = (RTTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[RTTableViewCell alloc] init];
    }
    cell.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    
    if(indexPath.row == 0) {
        cell.titleLabel.text = @"温度";
        cell.dataLabel.text = self.temperatureData == nil ? @" - " : self.temperatureData;
        cell.unitLabel.text = @"C";
        cell.superUnitLabel.text = @"";
        
        self.temperatureData = nil;
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"湿度";
        cell.dataLabel.text = self.humidityData == nil ? @" - " : self.humidityData;
        cell.unitLabel.text = @"%";
        cell.superUnitLabel.text = @"";
        
        self.humidityData = nil;
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = @"PM 2.5";
        cell.dataLabel.text = self.pm25Data == nil ? @" - " : self.pm25Data;
        cell.unitLabel.text = @"ug/m";
        cell.superUnitLabel.text = @"3";
        
        self.pm25Data = nil;
    }
    [self setLastCellSeperatorToLeft: cell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; （这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (void) setLastCellSeperatorToLeft: (UITableViewCell*) cell {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

#pragma mark - BLE Actions
- (IBAction)actionAddDeviceButton:(id)sender {
    //    [self.aryDevices removeAllObjects];
    //[self.tbDevices reloadData];
    //[self.SearchIndicator startAnimating];
    //self.viewDevices.hidden = NO;
    
    // 长时间没搜索到设备，自动停止
    self.timeOutTimerForDeviceScan = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFinished:) userInfo:nil repeats:NO];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.tabBarController.view animated:YES];
    self.hud.labelText = @"搜索多云设备中";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.blunoManager scan];
    });
    
    
}

- (void) timerFinished: (NSTimer *)timer {
    // can not find blue device in 5s
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
    });
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @" 周围无多云设备  ";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [hud removeFromSuperview];
    });
    
    
    [self.blunoManager stop];
}

- (void) sendSignalToDevice:(NSString *) signal {
    if (self.blunoDev.bReadyToWrite) {
        NSString* strTemp = signal;
        // NSData* data = [strTemp dataUsingEncoding: NSUTF8StringEncoding];
        NSData* data = [strTemp dataUsingEncoding: NSASCIIStringEncoding];
        [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
    } else {
        NSLog(@"Device is not ready, can not send signal");
    }
}


#pragma mark - DFBlunoDelegate
-(void)bleDidUpdateState:(BOOL)bleSupported {
    //    if(bleSupported)
    //    {
    //        [self.blunoManager scan];
    //    }
}

-(void)didDiscoverDevice:(DFBlunoDevice*)dev
{
    if(self.blunoDev != nil) {
        [self.blunoManager stop];
    } else {
        self.blunoDev = dev;
        [self.blunoManager connectToDevice:self.blunoDev];
    }
}

-(void)readyToCommunicate:(DFBlunoDevice*)dev {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
    });
    
    // get blue device in 5s, so stop timeout timer
    [self.timeOutTimerForDeviceScan invalidate];
    self.timeOutTimerForDeviceScan = nil;
    
    self.blunoDev = dev;
    self.addButton.hidden = YES;
    self.tableView.hidden = NO;
    self.cityLabel.hidden = NO;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:USER_GPS_DATA][HAVE_GPS_DATA] intValue] == 1) {
        // have gps
        self.cityLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_GPS_DATA][GPS_CITY];
    } else {
        // not gps show alert view
        self.cityLabel.text = @"多云";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"多云" message:@"多云无法访问您的位置 \n 请前往设置, 开启定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    // send connect signal to device and ready for receive data
    [self sendSignalToDevice: START_SEND_DATA];
    
    // set notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)didDisconnectDevice:(DFBlunoDevice*)dev {
    //self.lbReady.text = @"Not Ready!";
    self.blunoDev = nil;
    
    self.addButton.hidden = NO;
    self.tableView.hidden = YES;
    self.cityLabel.hidden = YES;
    [self resetData];
    [self.tableView reloadData];
}

-(void)didWriteData:(DFBlunoDevice*)dev {
    
}

-(void)didReceiveData:(NSData*)data Device:(DFBlunoDevice*)dev {
    // 1 -> temperature 2 -> humidity 3 -> pm2.5
    
    NSString *temp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRange range = [temp rangeOfString:@":"];
    NSString *prefix = [temp substringToIndex: range.location];
    NSString *dataS = [temp substringFromIndex: range.location + 1];
    
    if([prefix isEqualToString:@"1"] && self.temperatureData == nil) {
        self.temperatureData = [NSString stringWithFormat:@"%li", (long)[dataS integerValue]];
    }
    
    if([prefix isEqualToString:@"2"] && self.humidityData == nil) {
        self.humidityData = [NSString stringWithFormat:@"%li", (long)[dataS integerValue]];
    }
    
    if([prefix isEqualToString:@"3"] && self.pm25Data == nil) {
        self.pm25Data = dataS;
    }
    
    
    if(self.pm25Data != nil && self.temperatureData != nil && self.humidityData != nil) {
        [self.tableView reloadData];
    }
}

#pragma - mark TabBarController Delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if(![self isEqual:viewController]) {
        // reset this viewController
        [self inactiveRealTimePage];
    }
}

#pragma - mark UIApplicationNotification

- (void) applicationWillResignActive: (UIApplication *)application {
    [self inactiveRealTimePage];
}

- (void) applicationDidEnterBackground: (UIApplication *)application {
    [self inactiveRealTimePage];
}

- (void) inactiveRealTimePage {
    
    if( self.blunoDev != nil) {
        // delete notification
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self sendSignalToDevice: STOP_SEND_DATA_DISCONNECT];
        [self.blunoManager disconnectToDevice: self.blunoDev];
    }
}

@end