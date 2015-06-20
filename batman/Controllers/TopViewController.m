//
//  TopViewController.m
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "TopViewController.h"
#import "GameViewController.h"
#import "SoundPlayer.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [SoundPlayer playMusic:MAIN_BGM];
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//戻る用のメソッド実装
- (IBAction)prevView:(UIStoryboardSegue *)segue {
    [SoundPlayer playSE:CANCEL_SE];
}

- (IBAction)pushButtonNormal:(id)sender {
    [SoundPlayer playSE:SELECT_SE];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ゲームを開始します" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // addActionした順に左から右にボタンが配置されます
    [alertController addAction:[UIAlertAction actionWithTitle:@"開始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SoundPlayer playSE:SELECT_SE];
        gameConfig = [GameConfig alloc];
        gameConfig.difficulty = NORMAL;
        gameConfig.sound = NORMAL_BGM;
        
        myPerson = [Person alloc];
        myPerson.name = @"BADMAN";
        myPerson.image = [UIImage imageNamed:@"batpod_kai.png"];
        myPerson.weaponImgA = [UIImage imageNamed:@"img_new_batman_logo.png"];
        myPerson.weaponImgB = [UIImage imageNamed:@"rpg7.png"];
        
        enemyPerson = [Person alloc];
        enemyPerson.name = @"Joker";
        enemyPerson.image = [UIImage imageNamed:@"img_joker.jpg"];
        enemyPerson.weaponImgA = [UIImage imageNamed:@"bullet.png"];
        [self performSegueWithIdentifier:@"segueGame" sender:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SoundPlayer playSE:CANCEL_SE];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pushButtonHard:(id)sender {
    [SoundPlayer playSE:SELECT_SE];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ゲームを開始します" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    // addActionした順に左から右にボタンが配置されます
    [alertController addAction:[UIAlertAction actionWithTitle:@"開始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SoundPlayer playSE:SELECT_SE];
        gameConfig = [GameConfig alloc];
        gameConfig.difficulty = HARD;
        gameConfig.sound = HARD_BGM;
        
        myPerson = [Person alloc];
        myPerson.name = @"BADMAN";
        myPerson.image = [UIImage imageNamed:@"batpod_kai.png"];
        myPerson.weaponImgA = [UIImage imageNamed:@"candy.png"];
        myPerson.weaponImgB = [UIImage imageNamed:@"hana.png"];
        
        enemyPerson = [Person alloc];
        enemyPerson.name = @"a-watanabe";
        enemyPerson.image = [UIImage imageNamed:@"a-watanabe.jpg"];
        enemyPerson.weaponImgA = [UIImage imageNamed:@"knife.png"];
        [self performSegueWithIdentifier:@"segueGame" sender:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SoundPlayer playSE:CANCEL_SE];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pushButtonEdit:(id)sender {
    [SoundPlayer playSE:SELECT_SE];
    [self performSegueWithIdentifier:@"segueEdit" sender:self];
}

- (IBAction)pushButtonScore:(id)sender {
    [SoundPlayer playSE:SELECT_SE];
    [self performSegueWithIdentifier:@"segueScore" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueGame"]) {
        GameViewController *viewCon = segue.destinationViewController;
        viewCon.gameConfig = gameConfig;
        viewCon.myPerson = myPerson;
        viewCon.enemyPerson = enemyPerson;
    }
}

@end
