//
//  ScoreTableViewCell.m
//  batman
//
//  Created by 山口大輔 on 2015/05/12.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //メインテキスト
        self.titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, 240, 40)];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 2;
        
        //ドキュメントによると、self.contentViewに追加するのが正しいとコメントいただきました。
        [self.contentView addSubview:self.titleLabel];
        
        //...以下パーツを色々生成・追加
    }
    
    //レイアウトをアップデート
    [self updateLayout];
    
    return self;
}

@end
