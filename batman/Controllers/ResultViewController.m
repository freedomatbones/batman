//
//  ResultViewController.m
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "ResultViewController.h"
#import "ScoreViewController.h"
#import "Enum.h"
#import "SoundPlayer.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ResultViewController:viewDidLoad");
    
    switch (self.score.difficulty) {
        case NORMAL:
            self.difficultyLabel.text = @"NORMAL";
            break;
        case HARD:
            self.difficultyLabel.text = @"HARD";
            break;
        default:
            break;
    }
    
    // int hour   = self.score.time / (60 * 60);
    int minute = fmod((self.score.time / 60) ,60);
    int second = fmod(self.score.time ,60);
    int miliSec = (self.score.time - floor(self.score.time)) * 1000;
    NSString *format = self.timeLabel.text;
    self.timeLabel.text = [NSString stringWithFormat:format, minute, second, miliSec];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"ResultViewController:viewDidLoad");
    [SoundPlayer playMusic:RESULT_BGM];
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushButtonTop:(id)sender {
//    [SoundPlayer playSE:SELECT_SE];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"保存しなくてよろしいですか?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    // addActionした順に左から右にボタンが配置されます
    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"はい"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    [SoundPlayer playSE:SELECT_SE];
                                    [self performSegueWithIdentifier:@"segueTop" sender:self];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [SoundPlayer playSE:CANCEL_SE];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pushButtonRegister:(id)sender {
//    [SoundPlayer playSE:SELECT_SE];
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"スコア登録"
                                          message:@"登録名を入力してください。"
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    //入力欄（UITextField）付きを設定
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"必須";
        textField.secureTextEntry = NO; //マスク（*表示）
    }];
    
    //キャンセルボタンと処理
    UIAlertAction *actionCancel =
    [UIAlertAction actionWithTitle:@"キャンセル"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action) {
//                               [SoundPlayer playSE:CANCEL_SE];
                           }];
    [alert addAction:actionCancel];
    
    //OKボタンと処理
    UIAlertAction *actionOK =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               [SoundPlayer playSE:SELECT_SE];
                               UITextField *textField = alert.textFields.firstObject;
                               [self execRegister:textField.text];
                           }];
    [alert addAction:actionOK];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueScore"]) {
    }
}

- (void) execRegister:(NSString*) str{
    self.score.name = str;
    self.score.key  = [self.score nextPrimaryKey];
    
    // デフォルトのRealmを取得
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // トランザクションを開始し書き込む
    [realm beginWriteTransaction];
    [realm addObject:self.score];
    [realm commitWriteTransaction];
//    NSLog(@"text editing finished %@:%ld:%f", self.score.name, self.score.difficulty, self.score.time);
    [self performSegueWithIdentifier:@"segueScore" sender:self];
}

@end
