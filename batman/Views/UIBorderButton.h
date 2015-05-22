//
//  UIBorderButton.h
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIBorderButton : UIButton

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
