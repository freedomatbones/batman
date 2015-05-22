//
//  EditViewController.m
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "EditViewController.h"
#import "GameViewController.h"
#import "SoundPlayer.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"EditViewController:viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    [SoundPlayer playMusic:EDIT_BGM];
    NSLog(@"EditViewController:viewWillAppear");
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)onSingleTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)pushButtonSelectImage:(id)sender {
    [self uiImagePickerController];
}

- (IBAction)pushButtonGameStart:(id)sender {
    gameConfig = [GameConfig alloc];
    gameConfig.difficulty = _difficulty.selectedSegmentIndex;
    Sound sound = -1;
    switch (gameConfig.difficulty) {
        case NORMAL:
            sound = NORMAL_BGM;
            break;
        case HARD:
            sound = HARD_BGM;
            break;
        default:
            break;
    }
    gameConfig.sound = sound;
    
    enemyPerson = [Person alloc];
    enemyPerson.name = _name.text;
    enemyPerson.image = _image.image;
    if ([enemyPerson.name length] > 0 &&
        enemyPerson.image != nil &&
        gameConfig.difficulty >= 0) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ゲームを開始します" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        // addActionした順に左から右にボタンが配置されます
        [alertController addAction:[UIAlertAction actionWithTitle:@"開始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [SoundPlayer playSE:SELECT_SE];
            [self performSegueWithIdentifier:@"segueGame" sender:self];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self alert:@"必須項目を入力してください"];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueGame"]) {
        [SoundPlayer stopMusic];
        GameViewController *viewCon = segue.destinationViewController;
        viewCon.gameConfig = gameConfig;
        viewCon.enemyPerson = enemyPerson;
    }
}

/* UIImagePickerController *////////////////////////////////////////////////////
/* 画像選択画面を呼び出す */
- (void) uiImagePickerController {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init]; // 生成
    ipc.delegate = self; // デリゲートを自分自身に設定
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;  // 画像の取得先をアルバムに設定
    ipc.allowsEditing = YES;  // 画像取得後編集する
    [self presentViewController:ipc animated:YES completion:nil];
}

/* 選択後に呼び出される */
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self.image setContentMode:UIViewContentModeScaleToFill];
    self.image.alpha = 1.0;
    [self.image setImage:image];
}

/* close時の動作 */
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [self dismissViewControllerAnimated:YES completion:nil];  // モーダルビューを閉じる
}

// お手軽アラート
// 警告を表示します。OKボタンタップで閉じます。
- (void)alert:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    // 親ビューコンをなんとか検索
    UIViewController *baseView = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (baseView.presentedViewController != nil && !baseView.presentedViewController.isBeingDismissed) {
        baseView = baseView.presentedViewController;
    }
    [baseView presentViewController:alert animated:YES completion:nil];
}

@end
