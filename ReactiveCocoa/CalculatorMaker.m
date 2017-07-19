//
//  CalculatorMaker.m
//  ReactiveCocoa
//
//  Created by ZhouYong on 2017/7/11.
//  Copyright © 2017年 Rephontil/Yong Zhou. All rights reserved.
//

#import "CalculatorMaker.h"

@interface CalculatorMaker ()


@end

@implementation CalculatorMaker

//需求:一个方法,返回int型结果,方法的参数是一个block,block的参数是一个类对象

- (int)makeCalculators:(void(^)(CalculatorMaker *make))make
{
    CalculatorMaker *maker = [[CalculatorMaker alloc] init];
    make(maker);
    
    return maker.result;
}

- (CalculatorMaker *(^)(int num))add{
    CalculatorMaker *(^block)(int) = ^(int num){
        _result += num;
        return self;
    };
    
    return block;
}

- (CalculatorMaker *(^)(int num))mines{
    CalculatorMaker *(^block)(int) = ^(int num){
        _result -= num;
        return self;
    };
    return block;
}



@end



//函数式编程(下文)
@implementation CalculatorFunc

//需求:一个方法,返回值是当前的类对象,返回值仍旧可以调用其他的实例方法,每一个方法在其clock回调内部做任务
- (CalculatorFunc *)calculator:(int (^)(int result))make
{
    return self;
}

- (CalculatorFunc *)equal:(BOOL (^)(int result))compareNum
{
    return self;
}

@end

