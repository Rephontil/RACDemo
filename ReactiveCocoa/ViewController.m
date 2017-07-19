//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by ZhouYong on 2017/7/11.
//  Copyright © 2017年 Rephontil/Yong Zhou. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorMaker.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>
#import "SecondVC.h"

#define LOG_FUNC  NSLog(@"%s",__FUNCTION__);

@interface ViewController ()

@property (nonatomic, copy) NSString *username;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;

@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (nonatomic, strong) RACCommand *command;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self calculatorTest];
    [self calculatorFuncTest];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //next  RAC  Test all below
    //    [self rac_test01];
    //
    //    [self rac_test02];
    //
    //    [self rac_btn01];
    //
    //    [self rac_bothEvaluate01];
    //
    //    [self racSubject_test01];
    //
    //    [self rac_array];
    
    
    //    [self raccommand_test01];
    
    //    [self multicastConnection_Test01];
    
    //    [self multipleNerWork_test01];
    
//    [self textFieldTest_01];
    
//    [self concat_Test01];
    
//    [self zip_Test01];
    
//    [self merge_test01];
    
    [self combineLatest_test01];
    
    [self filter_test01];
    
    [self timer_test01];
    
    [self then_test01];
    
    
}

- (void)rac_test01{
    [RACObserve(self, self.username) subscribeNext:^(id  _Nullable x) {
        NSLog(@"test01 --- self.name = %@", x);
    }];
}

//数据筛选
- (void)rac_test02{
    [[RACObserve(self, self.username) filter:^BOOL(id  _Nullable value) {
        return [value containsString:@"1"];
    }] subscribeNext:^(id  _Nullable x) {
         NSLog(@"test02 --- self.name %@",x);
     }];
}

- (void)rac_btn01{
    
    [[self.testBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    
    self.testBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        LOG_FUNC
        return [RACSignal empty];
    }];
}
- (IBAction)both_btn01:(UIButton *)sender {
    [self racSubjectDelegate01];
}

//替换代理的方法
- (IBAction)both_btn02:(UIButton *)sender {
    SecondVC *vc = [[SecondVC alloc] init];
    
    [[vc rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"监听点击代理 --- %@ -- %@",x,[x class]);
    }];
    
    
    //替换KVO  rac_valuesForKeyPath
    UIButton *btn = (UIButton *)sender;
    [[btn rac_valuesForKeyPath:@"highlighted" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac_valuesForKeyPath %@ ---> ",x);
    }];
    
    //监听按钮事件
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"rac_signalForControlEvents ---> %@",x);
    }];
    
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)rac_bothEvaluate01{
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发射信号"];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"执行完毕销毁");
        }];
    }];
    
    [signal1 subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到数据 : %@",x);
    }];
    
}

- (void)racSubject_test01{
    //创建信号
    RACSubject *subject = [RACSubject subject];
    
    //订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到信号%@",x);
    }];
    //发送信号
    [subject sendNext:@"发送信号"];
    //先订阅信号,再发射信号.
    
    
    RACReplaySubject *replySubject = [RACReplaySubject subject];
    
    [replySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"replySubject前面 发出的信号: %@",x);
    }];
    
    [replySubject sendNext:@"--01"];
    [replySubject sendCompleted];
    [replySubject sendNext:@"--02"];
    
    [replySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"replySubject后面 发出的信号: %@",x);
    }];
    
    
}

- (void)racSubjectDelegate01{
    SecondVC *vc = [[SecondVC alloc] init];
    vc.delegateSignal = [RACSubject subject];
    [vc.delegateSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"点击了通知按钮");
    }];
    [self presentViewController:vc animated:YES completion:nil];
}


//数组和字典的遍历方法
- (void)rac_array{
    NSArray *array = @[@1,@3,@90,@87];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    NSDictionary *dic = @{@"key1":@"value1",@"key2":@"value2",@"key3":@"value3"};
    [dic.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"key = %@, value = %@",key,value);
    }];
    
    //高级用法,RAC函数式编程.  map:映射
    [[dic.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return value;
    }] array];
    
}



//RACCommand 用于处理事件的类(事件如何处理,事件如何传递包装到这个类里面,很方便地监控事件执行的全过程)
/*
 二、RACCommand使用注意:
 
 signalBlock 必须要返回一个信号，不能传 nil.
 如果不想要传递信号，直接创建空的信号 [RACSignal empty];
 RACCommand 中信号如果数据传递完，必须调用 [subscriber sendCompleted] ，这时命令才会执行完毕，否则永远处于执行中。
 RACCommand 需要被强引用，否则接收不到 RACCommand 中的信号，因此 RACCommand 中的信号是延迟发送的。
 */
- (void)raccommand_test01{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"执行命令");
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //这个里面做网络请求,将请求到的数据当信号发送出去.
            [subscriber sendNext:@"将军发出了征战信号----模拟数据网络请求1"];
            [subscriber sendNext:@"将军发出了征战信号----模拟数据网络请求2"];
            
            [subscriber sendCompleted]; //需要手动调用,这时命令才执行完毕
            
            return nil;
        }];
        return signal;
        
        //必须要返回一个信号,不可以为nil.如果不想要传递信号,可以直接创建空信号.[RACSignal empty]
        
    } ];
    
    
    //强引用命令不被销毁掉.否则接受不到信号
    _command = command;
    
    //    订阅信号?
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            //            解析信号的信号
            NSLog(@"订阅到的信号是 -->:%@",x);
        }];
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"RAC高级用法: %@", x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES)
        {
            // 正在执行
            NSLog(@"正在执行");
        } else {
            // 执行完毕
            NSLog(@"执行完成");
        }
        
    }];
    
    // 5.执行命名
    [self.command execute:@1];
}


//RACMulticastConnection
- (void)multicastConnection_Test01{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"请求①");
        [subscriber sendNext:@"小火车呜呜呜..."];
        
        return nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅到信号 --> :%@",x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅到信号 --> :%@",x);
    }];
    NSLog(@"--------------------------------------");
    
    RACSignal *signal_01 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"请求②");
        
        [subscriber sendNext:@"大🚄..."];
        return nil;
    }];
    
    RACSubject *subject = [RACSubject subject];
    RACMulticastConnection *connection = [signal_01 multicast:subject];  //RACMulticastConnection创建方法1
    
    //  RACMulticastConnection *connection = [signal_01 publish];  RACMulticastConnection创建方法2
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅到信号%@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅到信号%@",x);
    }];
    
    //激活信号,连接信号
    [connection connect];
}


///////////////////////////////////////////////////////////////////////////////
/////////////
/////////////  统一处理多个网络请求,如同时进行多个网络请求，每个请求都正确返回时，再去刷新页面!
/////////////
///////////////////////////////////////////////////////////////////////////////

- (void)multipleNerWork_test01{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [self obtain:^(id returnData) {
            [subscriber sendNext:returnData];
        }];
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        for (int i = 0 ; i < 1000; i++) {
            NSLog(@"%d",i);
        }
        [subscriber sendNext:@"请求2"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(refreshTableView:data2:) withSignalsFromArray:@[signal1,signal2]];
}

//模拟多网络请求,UI REFRESH
- (void)refreshTableView:(id)data1 data2:(id)data2{
    NSLog(@"两个任务都完成了...data1: %@ ---- data2: %@",data1,data2);
}

- (void)obtain:(void(^)(id returnData))returnData{
    
    //    这里面做网络请求,把请求到的数据扔出去.☺️
    id  netData;
    NSDictionary *dic = @{
                          @"name":@"ZhouYong",
                          @"gendle":@"female", //wonderful
                          @"hobby":@"TennisRacket",
                          };
    //    male   female
    
    netData = dic;
    
    if (returnData) {
        returnData(netData);
    }
}


//////////////////////////////////////////////////////////////////
/////////////
/////////////         第二部分 RAC 高级用法来了
/////////////
//////////////////////////////////////////////////////////////////
- (void)textFieldTest_01{
    //    //方法一 使用RAC封装好的方法
    //    [_textfield.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
    //        NSLog(@"textfield输出结果： %@",x);
    //    }];
    
    
    //    //方法二 使用bind绑定方法，RAC底层就是这样实现的
    //    [[_textfield.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
    //
    //        return ^RACSignal *(id value, BOOL *stop){
    //            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
    //        };
    //
    //    }] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"方法二:%@",x);
    //    }];
    
    
//    FlatternMap 中的Block 返回信号。 Map中的block返回的是对象.开发中，如果信号发出的值 不是信号 ，映射一般使用 Map;如果信号发出的值 是信号，映射一般使用 FlatternMap。
    //映射 flattenMap
    [[_textfield.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        return [RACReturnSignal return:[NSString stringWithFormat:@"信号内容:%@",value]];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //映射 Map
    [[_textfield2.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [NSString stringWithFormat:@"%@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

//组合
- (void)concat_Test01
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"Hello"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"World"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"!"];
        [subscriber sendCompleted];
        return nil;
    }];
    
   RACSignal *signalAB = [signalA concat:signalB];
   RACSignal *signalABC = [signalAB concat:signalC];
    [signalABC subscribeNext:^(id  _Nullable x) {
        NSLog(@"ABC:%@",signalABC);
    }];


}


- (void)zip_Test01{
//    把两个信号压缩成一个信号，只有当两个信号 同时 发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"A1"];
        [subscriber sendNext:@"A2"];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"B1"];
        [subscriber sendNext:@"B2"];
        [subscriber sendNext:@"B3"];
        
        return nil;
    }];
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"C1"];
        [subscriber sendNext:@"C2"];
        [subscriber sendNext:@"C3"];
        
        return nil;
    }];
    
    RACSignal *zipSignal = [[signalA zipWith:signalB] zipWith:signalC];
    [zipSignal subscribeNext:^(id x) {
        
        RACTupleUnpack(NSString *value) = x;
        NSLog(@"%@", value);
    }];
}


//合并信号,任何一个信号发送数据，都能监听到
- (void)merge_test01{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"A"];
        return nil;
    }];
    
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"B"];
        return nil;
    }];
    
    // 合并信号, 任何一个信号发送数据，都能监听到.这方法很强啊👍
    RACSignal *mergeSianl = [signalA merge:signalB];
    
    [mergeSianl subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
    
}

//数据结构与算法


//username 和 password同时有值的时候,按钮才可以点击
- (void)combineLatest_test01{
    
//    //方式1
//    [[_textfield .rac_textSignal combineLatestWith:_textfield2.rac_textSignal] subscribeNext:^(RACTwoTuple<NSString *,id> * _Nullable x) {
//        RACTupleUnpack(NSString *name, NSString *pwd) = x;
//        NSLog(@"name:%@--pwd:%@",name,pwd);
//        _testBtn.enabled = (name.length && pwd.length);
//    }];
    
    
//    //方式二
//    [[RACSignal combineLatest:@[_textfield.rac_textSignal,_textfield2.rac_textSignal] reduce:^id (NSString *name, NSString *pwd){
//        NSLog(@"%@   %@",name, pwd);
//        return @(name.length > 0   && pwd.length > 0);
//    }] subscribeNext:^(id  _Nullable x) {
//        _testBtn.enabled = [x boolValue];
//    }];
    
    //    方式三
        //如果直接使用RAC的方式会更快捷
        // 合并多个信号
        // reduce:把多个信号的值,聚合为一个值
        // reduce参数:几个信号,就几个参数,每个参数都是信号发出的值
    
        // RAC:提醒,响应式编程
        RAC(_testBtn,enabled) = [RACSignal combineLatest:@[_textfield.rac_textSignal,_textfield2.rac_textSignal] reduce:^id(NSString *account,NSString *pwd){
    
            return @(account.length > 0 && pwd.length > 0);
        }];
    
}

//过滤的高级用法
- (void)filter_test01{
    [[_textfield.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"_textfield.text: %@",x);
    }];
}

//定时器的使用
- (void)timer_test01{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"执行了block");
        [subscriber sendNext:@"hello world"];
        return nil;
    }] delay:3] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

// then:拼接 ,忽略掉上一个信号的值
// then:解决block嵌套问题
// 请求界面数据:先请求分类,在请求详情
- (void)then_test01{
    
    [[[[[self loadCategoryData] then:^RACSignal * _Nonnull{
        return [self loadDetailData];
    }] then:^RACSignal * _Nonnull{
        return [self loadDetailData];
    }] then:^RACSignal * _Nonnull{
        return [self loadCategoryData];
    }] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"订阅到信号:%@",x);
    }];
    
}
- (void)loadCategoryData:(void (^)(id returnData))success{
    if (success) {
        success(@"loadCategoryData");
    }
}
- (void)loadDetailData:(void (^)(id returnData))success{
    if (success) {
        success(@"loadDetailData");
    }
    
    
}
- (RACSignal *)loadCategoryData{
    RACReplaySubject *rSubject = [RACReplaySubject subject];
    [self loadCategoryData:^(id returnData) {
        [rSubject sendNext:returnData];
        [rSubject sendCompleted];
    }];
    return rSubject;
}
- (RACSignal *)loadDetailData{
    RACReplaySubject *rSubject = [RACReplaySubject subject];
    [self loadDetailData:^(id returnData) {
        [rSubject sendNext:returnData];
        [rSubject sendCompleted];
    }];
    return rSubject;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    int randomNum = arc4random_uniform(20);
    self.username = [NSString stringWithFormat:@"test-%d",randomNum];
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//////////////////////////////////////////////////////////////////
/////////////
/////////////          链式写法  函数式编程demo
/////////////
//////////////////////////////////////////////////////////////////

//链式写法
- (void)calculatorTest{
    CalculatorMaker *maker = [[CalculatorMaker alloc] init];
    int result = [maker makeCalculators:^(CalculatorMaker *make) {
        make.add(10).add(16).mines(5);
        
    }];
    NSLog(@"result = %d",result);
}

//函数式编程写法
- (void)calculatorFuncTest{
    
    CalculatorFunc *maker = [[CalculatorFunc alloc] init];
    BOOL result =  [[maker calculator:^int(int result) {
        result += 7;
        result += 4;
        return result;
        
    }] equal:^BOOL(int result) {
        return result == 10;
    }];
    NSLog(@"result = %d", result);
    
}


//homebrew是一个包管理工具
// npm相当于iOS开发中的cocoaPods
// npm init 创建一个环境,相当于一个.podFile文件
// npm install express  --save   表示安装一个框架,并且将这个框架的信息保存到.json文件中
// 也可以通过npm search 搜索一个框架

@end
