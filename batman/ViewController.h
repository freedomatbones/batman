//
//  ViewController.h
//  batman
//
//  Created by 山口 大輔 on 2015/03/07.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPView.h"
#import "UAProgressView.h"

@interface ViewController : UIViewController<UINavigationControllerDelegate,
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
    CGPoint moveDistanceBegan;
    CGPoint moveDistance;
    NSTimer *moveTimer;
    
    // controller
    UIView *controller;
    UIView *stick;
}

@end

