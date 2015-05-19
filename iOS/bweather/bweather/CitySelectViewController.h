//
//  CitySelectViewController.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/18.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CitySelectControllerDelegete <NSObject>

-(void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation;

@end

@interface CitySelectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *citySearchBar;

@property (nonatomic, strong) NSMutableArray * ChineseCities;//存放所有未排序的城市信息
@property (nonatomic, strong) NSMutableArray *cities;//存放未处理所有城市
@property (nonatomic, strong) NSMutableArray * fixArray;//存放纯城市信息
@property (nonatomic, strong) NSMutableArray * tempArray;//中间数组
@property (nonatomic, strong) NSMutableArray * letters;//存放开头字母
@property (nonatomic, strong) NSString * loctionCity;//定位城市
@property (nonatomic, assign) BOOL isSearch;//是否是search状态

@property (nonatomic, assign) id<CitySelectControllerDelegete>delegete;

- (IBAction) goBackToSettingViewEvent:(id)sender;

@end
