//
//  CitySelectViewController.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/18.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "CitySelectViewController.h"
#import "HandleCityData.h"
#import "City.h"
#import "YQL.h"
#import "UserDefaultDataHelper.h"

@interface CitySelectViewController ()

@end

@implementation CitySelectViewController {
    BOOL isSearching;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSearch = NO;
    [self initDataArray];
    [self initSearchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goBackToSettingViewEvent:(id)sender {
    [self dismissViewControllerAnimated: YES completion:nil];
}
-(void)initDataArray {
    self.letters = [[NSMutableArray alloc] init];
    self.fixArray = [[NSMutableArray alloc] init];
    self.tempArray = [[NSMutableArray alloc] init];//search出来的数据存放
    self.ChineseCities = [[NSMutableArray alloc] init];
    HandleCityData * handle = [[HandleCityData alloc] init];
    NSArray * cityInforArray = [handle cityDataDidHandled];
    [self.letters addObjectsFromArray:[cityInforArray objectAtIndex:0]];//存放所有section字母
    [self.fixArray addObjectsFromArray:[cityInforArray objectAtIndex:1]];//存放所有城市信息数组嵌入数组和字母匹配
    [self.ChineseCities addObjectsFromArray:[cityInforArray objectAtIndex:2]];
}

#pragma mark - Initialization

- (void)initSearchBar {
    self.citySearchBar.translucent  = YES;
    self.citySearchBar.delegate     = self;
    self.citySearchBar.placeholder  = @"名称";
}

#pragma mark tableViewDelegete
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.letters.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        return self.tempArray.count;
    }
    NSArray * letterArray = [self.fixArray objectAtIndex:section];//对应字母所含城市数组
    return letterArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isSearch) {
        return nil;
    }
    return [self.letters objectAtIndex:section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.letters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.isSearch) {
        return 1;
    }
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    City * city;
    if (self.isSearch) {
        city = [self.tempArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
    }else{
        NSArray * letterArray = [self.fixArray objectAtIndex:indexPath.section];//对应字母所含城市数组
        city = [letterArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.cityNAme;
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // get city name
    // get woeid from yahoo
    // store in userdefault
    // update ui
    if(![cell.textLabel.text isEqualToString: @"北京"] && ![cell.textLabel.text isEqualToString: @"上海"]) {
        NSDictionary* woeidResult = [YQL query:
                                     [NSString stringWithFormat: @"select * from geo.placefinder(1) where text='%@'", cell.textLabel.text]];
        NSString *woeid = woeidResult[@"query"][@"results"][@"Result"][@"woeid"];
        NSString *cityAndWoeid = [NSString stringWithFormat:@"%@-%@", woeid, cell.textLabel.text];
        [UserDefaultDataHelper addUserDefaultCityArray:cityAndWoeid];
    }
    
    [_delegete cityViewdidSelectCity:cell.textLabel.text anamation:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark searchBarDelegete
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.tempArray removeAllObjects];
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (City * city in self.ChineseCities) {
            NSRange chinese = [city.cityNAme rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.letter rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (chinese.location != NSNotFound) {
                [self.tempArray addObject:city];
            }else if (letters.location != NSNotFound){
                [self.tempArray addObject:city];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.isSearch = NO;
}

@end
