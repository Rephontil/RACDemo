//
//  SecondVC.m
//  ReactiveCocoa
//
//  Created by ZhouYong on 2017/7/11.
//  Copyright © 2017年 Rephontil/Yong Zhou. All rights reserved.
//

#import "SecondVC.h"

@interface SecondVC ()

@property (nonatomic, strong) UIButton *button;


@end

@implementation SecondVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(100, 100, 100, 50);
    [self.button setTitle:@"Button" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    [self.button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)btnClick:(UIButton *)button{
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
