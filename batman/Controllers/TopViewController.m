//
//  TopViewController.m
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "TopViewController.h"
#import "GameViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushButtonNormal:(id)sender {
    enemyPerson = [Person alloc];
    enemyPerson.name = @"Joker";
    enemyPerson.image = [UIImage imageNamed:@"img_joker.jpg"];
    enemyPerson.difficulty = NORMAL;
    [self performSegueWithIdentifier:@"segueGameView" sender:self];
}

- (IBAction)pushButtonHard:(id)sender {
    enemyPerson = [Person alloc];
    enemyPerson.name = @"a-watanabe";
    enemyPerson.image = [UIImage imageNamed:@"a-watanabe.jpg"];
    enemyPerson.difficulty = HARD;
    [self performSegueWithIdentifier:@"segueGameView" sender:self];
}

- (IBAction)pushButtonEdit:(id)sender {
    [self performSegueWithIdentifier:@"segueEditView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueGameView"]) {
        GameViewController *viewCon = segue.destinationViewController;
        viewCon.enemyPerson = enemyPerson;
    }
}

@end
