//
//  SettingViewController.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/17.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "SettingViewController.h"
#import "UserDefaultDataHelper.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityArray = [UserDefaultDataHelper getUserDefaultCityArray];
    
    // set for table view
    if(44 * self.cityArray.count <= 300) {
        self.cityTableView.frame  = CGRectMake(0, self.cityTableView.frame.origin.y, self.cityTableView.frame.size.width, 44 * self.cityArray.count);
    }
    
    self.addCityButton.frame =  CGRectMake(0, self.cityTableView.frame.origin.y + self.cityTableView.frame.size.height + 16, self.addCityButton.frame.size.width, self.addCityButton.frame.size.height);
    
    [self.view addSubview: [self createLineForTableView: self.staticCellImageView.frame.origin.y]];
    [self.view addSubview: [self createLineForTableView: self.staticCellImageView.frame.origin.y + self.staticCellImageView.frame.size.height]];
    
    [self.view addSubview: [self createLineForTableView: self.cityTableView.frame.origin.y]];
    self.tableBottomLine = [self createLineForTableView: self.cityTableView.frame.origin.y + self.cityTableView.frame.size.height];
    [self.view addSubview: self.tableBottomLine ];
    
    self.cityTableView.tableFooterView = [[UIView alloc] init];
    self.cityTableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.cityTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // set for switch button
    BOOL isUseC = [[UserDefaultDataHelper getUserDefaultUnit] integerValue] == 1;
    [self.unitSwitchButton setOn: isUseC];
    self.unitLabel.text = isUseC ? @"使用温度单位 C" : @"使用温度单位 F";
    
    [self.unitSwitchButton addTarget:self action:@selector(switchActionEvent:) forControlEvents:UIControlEventValueChanged];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        //cell = [[DayForecastCell alloc] init];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    if(indexPath.row != 0) {
        [self.cityTableView addSubview:[self createLineForTableView: 44 * indexPath.row]];
    }
    
    cell.textLabel.text = [self getCityNameFromString: [self.cityArray objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = indexPath.row;
        [UserDefaultDataHelper deleteUserDefaultCityArrayAtIndex:index];
        self.cityArray = [UserDefaultDataHelper getUserDefaultCityArray];
        [self resetCityTableView];
    }
}

- (UIView *) createLineForTableView: (CGFloat) height {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height, self.cityTableView.frame.size.width, 1 / UIScreen.mainScreen.scale)];
    line.backgroundColor = self.cityTableView.separatorColor;
    return line;
}

//delete useless lines
-(void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    //[view release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void) resetCityTableView {
    if(44 * self.cityArray.count <= 300) {
        self.cityTableView.frame  = CGRectMake(0, self.cityTableView.frame.origin.y, self.cityTableView.frame.size.width, 44 * self.cityArray.count);
        
        self.addCityButton.frame =  CGRectMake(0, self.cityTableView.frame.origin.y + self.cityTableView.frame.size.height + 16, self.addCityButton.frame.size.width, self.addCityButton.frame.size.height);
    }
    
    [self.tableBottomLine removeFromSuperview];
    self.tableBottomLine = [self createLineForTableView: self.cityTableView.frame.origin.y + self.cityTableView.frame.size.height];
    [self.view addSubview: self.tableBottomLine ];
    
    [self.cityTableView reloadData];
}

#pragma mark - switch button event
-(void)switchActionEvent:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSNumber *isUseC = [NSNumber numberWithInt:1];
    if (!isButtonOn) {
        isUseC = [NSNumber numberWithInt:0];
    }
    [UserDefaultDataHelper updateUserDefaultUnit: isUseC];
    self.unitLabel.text = isButtonOn ? @"使用温度单位 C" : @"使用温度单位 F";
}

#pragma mark - Action Event
- (IBAction) goBackToWeatherPageView: (id)sender {
    [self dismissViewControllerAnimated: YES completion:nil];
}

#pragma mark - city view control delegate
-(void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    // reload table data
    self.cityArray = [UserDefaultDataHelper getUserDefaultCityArray];
    [self resetCityTableView];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CitySelectViewController *controller = (CitySelectViewController*)[segue destinationViewController];
    controller.delegete = self;
}

- (NSString *) getCityNameFromString: (NSString *) string {
    NSRange tr = [string rangeOfString:@"-"];
    return [string substringFromIndex: (tr.location + 1)];
}


@end
