//
//  ResultViewController.h
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "ViewController.h"
#import "Score.h"

@interface ResultViewController : ViewController<UITextFieldDelegate>

@property (nonatomic) Score* score;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
