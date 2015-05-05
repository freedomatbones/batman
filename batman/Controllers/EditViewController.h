//
//  EditViewController.h
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface EditViewController : ViewController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate> {
    Person *enemyPerson;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficulty;

@end
