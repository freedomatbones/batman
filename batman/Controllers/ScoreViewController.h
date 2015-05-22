//
//  ScoreViewController.h
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "ViewController.h"
#import "Enum.h"

@interface ScoreViewController : ViewController<UITableViewDelegate, UITableViewDataSource, UITabBarDelegate> {
    NSMutableArray *_normalAllScore;
    NSMutableArray *_hardAllScore;
    Difficulty _tableType;
    CGPoint _offsetNormal;
    CGPoint _offsetHard;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UITabBarItem *normalTabItem;

@end
