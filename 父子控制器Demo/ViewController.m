//
//  ViewController.m
//  父子控制器Demo
//
//  Created by monster on 16/5/12.
//  Copyright © 2016年 Monster. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)buttonClick:(UIButton *)sender {
    //获取button的index值,按照添加的顺序获取
    NSInteger index = [sender.superview.subviews indexOfObject:sender];
    NSLog(@"%ld",(long)index);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
