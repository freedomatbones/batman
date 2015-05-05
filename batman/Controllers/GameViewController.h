//
//  GameViewController.h
//  batman
//
//  Created by 山口 大輔 on 2015/03/07.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPView.h"
#import "BackgroundView.h"
#import "UAProgressView.h"
#import "Person.h"

@interface GameViewController : UIViewController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>{
    
    HPView *hp;
    
    UIImageView *myIV;
    UIImageView *enemyIV;
    
    NSMutableArray *myShots;
    NSMutableArray *enemyShots;
    
    CAEmitterLayer *myEmitterLayer;
    CAEmitterLayer *enemyEmitterLayer;
    
    ///////////////////////////////////////////////////
    
    // Batman
    NSTimer *moveTimer;
    
    double moveX;
    double moveY;
}

@property (nonatomic) Person* myPerson;
@property (nonatomic) Person* enemyPerson;

@end

