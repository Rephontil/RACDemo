//
//  CalculatorMaker.h
//  ReactiveCocoa
//
//  Created by ZhouYong on 2017/7/11.
//  Copyright © 2017年 Rephontil/Yong Zhou. All rights reserved.
//  简单的链式编程与函数式编程demo

#import <Foundation/Foundation.h>

@interface CalculatorMaker : NSObject

@property (nonatomic, assign) int result;

- (int)makeCalculators:(void(^)(CalculatorMaker *make))make;

//参数是int类型
- (CalculatorMaker *(^)(int))add;

- (CalculatorMaker *(^)(int))mines;

@end




//函数式编程(下文)
@interface CalculatorFunc : NSObject

@property (nonatomic, assign) int result;
@property (nonatomic, assign) BOOL isEqual;

- (CalculatorFunc *)calculator:(int (^)(int result))make;
- (CalculatorFunc *)equal:(BOOL (^)(int result))compareNum;


@end
