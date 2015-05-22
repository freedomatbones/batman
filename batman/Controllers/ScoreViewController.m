//
//  ScoreViewController.m
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "ScoreViewController.h"
#import "SoundPlayer.h"
#import "Score.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabbar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    _normalAllScore = [Score findNormalAll];
    _hardAllScore = [Score findHardAll];
    _offsetNormal = CGPointMake(0, 0);
    _offsetHard = CGPointMake(0, 0);
    _tableType = NORMAL;
    [self.tabbar setSelectedItem:_normalTabItem];
}

// 全体が表示されたタイミング
- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewWillAppear:(BOOL)animated {
    [SoundPlayer playMusic:MAIN_BGM];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
}

- (IBAction)pushButtonTop:(id)sender {
    [SoundPlayer playSE:CANCEL_SE];
    [self performSegueWithIdentifier:@"segueTop" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

// タブ切り替え NORMAL = 0 HARD = 1
- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item {
    [SoundPlayer playSE:TAB_SE];
    if (item.tag == 0) {
        if (_tableType == HARD) {
            _tableType = NORMAL;
            _offsetHard = [self.tableView contentOffset];
            [self.tableView reloadData];
            [self.tableView setContentOffset:_offsetNormal];
        }
        
    }
    else if (item.tag == 1) {
        if (_tableType == NORMAL) {
            _tableType = HARD;
            _offsetNormal = [self.tableView contentOffset];
            [self.tableView reloadData];
            [self.tableView setContentOffset:_offsetHard];
        }
    }
}

#pragma mark - UITableView DataSource

/**
 テーブルに表示するデータ件数を返します。（必須）
 
 @return NSInteger : データ件数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount;
    
    // テーブルに表示するデータ件数を返す section == 0前提ね
    switch (_tableType) {
        case NORMAL:
            dataCount = [_normalAllScore count];
            break;
        case HARD:
            dataCount = [_hardAllScore count];
            break;
        default:
            break;
    }
    return dataCount;
}

/**
 テーブルに表示するセクション（区切り）の件数を返します。（オプション）
 
 @return NSInteger : セクションの数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 テーブルに表示するセルを返します。（必須）
 
 @return UITableViewCell : テーブルセル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // 再利用できるセルがあれば再利用する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }
    //  indexPath.section == 0前提ね
    Score *score;
    switch (_tableType) {
        case NORMAL:
            score = (Score *)[_normalAllScore objectAtIndex:indexPath.row];
            cell.textLabel.text = score.name;
            cell.detailTextLabel.text = score.timeToString;
            break;
        case HARD:
            score = (Score *)[_hardAllScore objectAtIndex:indexPath.row];
            cell.textLabel.text = score.name;
            cell.detailTextLabel.text = score.timeToString;
            break;
        default:
            break;
    }
    cell.clipsToBounds = YES;//frameサイズ外を描画しない
    
    return cell;
}

// ボタンがタップされた際に呼び出されるメソッド
-(void)tapButton:(id)sender {
    NSLog(@"Execute Button tapped.");
}

/*
// スワイプ
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
 */

//UITableViewDelegateに追加されたメソッド
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"削除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [SoundPlayer playSE:DELETE_SE];
        long section = indexPath.section;
        long row = indexPath.row;
        NSLog(@"Delete========================:%ld %ld", section, row);
        Score *delScore;
        switch (_tableType) {
            case NORMAL:
                delScore = (Score *)[_normalAllScore objectAtIndex:indexPath.row];
                [self destroy:delScore];
                [_normalAllScore removeObjectAtIndex:indexPath.row];
                break;
            case HARD:
                delScore = (Score *)[_hardAllScore objectAtIndex:indexPath.row];
                [self destroy:delScore];
                [_hardAllScore removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    /*
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"Edit:%@", indexPath);
    }];
    */
    
    return @[deleteAction];
}

// 編集モードを呼び出すために記述
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete:＝＝＝＝＝＝＝＝＝＝");
//        [_rows removeObjectAtIndex:indexPath.row];
//        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
}
 */

// 削除
- (void)destroy:(Score*)delScore {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:delScore];
    [realm commitWriteTransaction];
}

@end
