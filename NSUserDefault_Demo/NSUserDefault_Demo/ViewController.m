//
//  ViewController.m
//  NSUserDefault_Demo
//
//  Created by Eli on 2018/12/6.
//  Copyright © 2018年 Eli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//
//    NSString *libPath = [paths objectAtIndex:0];
//
//    NSString *prePath = [libPath stringByAppendingPathComponent:@"Preferences"];
//
//    NSLog(@"Preferences路径:%@",prePath);
    
    NSLog(@"输出结果:%@",[defaults objectForKey:@"key"]);
    
}


- (IBAction)btn1Click:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1234" forKey:@"key"];
    //[defaults synchronize];
    
    NSLog(@"存入内容:%@",[defaults objectForKey:@"key"]);
    
}


- (IBAction)btn2Click:(id)sender
{
    
    
    
    NSString *key = [@"key" stringByAppendingFormat:@"%d", [self getRandomNumber:0 to:100]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:key forKey:key];
    
    //[defaults synchronize];
    
    NSLog(@"存入内容:%@",[defaults objectForKey:key]);
    
}


- (IBAction)btn3Click:(id)sender {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dictionary = [defaults dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        
        [defaults removeObjectForKey:key];
//        [defaults synchronize];
        
        
    }
    
    NSLog(@"清空后内容:%@",[defaults objectForKey:@"key"]);
    
}

- (IBAction)btn4Click:(id)sender {
    
    NSString *extension = @"plist";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *libPath = [paths objectAtIndex:0];
    
    NSString *prePath = [libPath stringByAppendingPathComponent:@"Preferences"];
    
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:prePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[prePath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //    [defaults setObject:@"keys" forKey:@"keys"];
    //
    //    [defaults synchronize];
    
    
    NSLog(@"清空后内容:%@",[defaults objectForKey:@"key"]);
    
}


-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}


@end
