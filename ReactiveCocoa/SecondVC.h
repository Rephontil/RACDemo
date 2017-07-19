//
//  SecondVC.h
//  ReactiveCocoa
//
//  Created by ZhouYong on 2017/7/11.
//  Copyright © 2017年 Rephontil/Yong Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>


@interface SecondVC : UIViewController
@property (nonatomic, strong) RACSubject *delegateSignal;

@end
