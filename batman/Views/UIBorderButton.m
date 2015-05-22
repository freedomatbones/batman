//
//  UIBorderButton.m
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "UIBorderButton.h"

@implementation UIBorderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    _borderColor = [UIColor blackColor];
    _borderWidth = 0;
    _cornerRadius = 0;
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

@end
