//
//  EditViewController.m
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "EditViewController.h"
#import "GameViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    enemyPerson = [Person alloc];
    enemyPerson.name = _name.text;
    enemyPerson.image = _image.image;
    enemyPerson.difficulty = _difficulty.selectedSegmentIndex;
    if ([enemyPerson.name length] > 0 &&
        enemyPerson.image != nil &&
        enemyPerson.difficulty >= 0) {
        [self performSegueWithIdentifier:@"segueGameView2" sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueGameView2"]) {
        GameViewController *viewCon = segue.destinationViewController;
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
    
    self.image.image = image;
}

/* close時の動作 */
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [self dismissViewControllerAnimated:YES completion:nil];  // モーダルビューを閉じる
}

@end
