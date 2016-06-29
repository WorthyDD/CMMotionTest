//
//  ViewController.m
//  AccelerateTest
//
//  Created by 武淅 段 on 16/6/29.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>


//static const NSTimeInterval deviceMinMotion = 0.01;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerX;

@property (nonatomic) CMMotionManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _manager = [[CMMotionManager alloc]init];
    
    [self startDetectMotion];
}


- (void) startDetectMotion
{
    NSTimeInterval delta = 0.1;
    float width = _image.image.size.width;
    float height = _image.image.size.height;
    NSLog(@"image [%f,%f]",width,height);
    float acHeight = [UIScreen mainScreen].bounds.size.height;
    float acWidth = width*acHeight/height;
    NSLog(@"actual [%f,%f]",acWidth,acHeight);
    
    
    __weak typeof(self) WeakSelf = self;
    if([_manager isDeviceMotionAvailable]){
        [_manager setGyroUpdateInterval:delta];
        [_manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            [WeakSelf.xLabel setText:[NSString stringWithFormat:@"x : %f", motion.attitude.roll]];
            [WeakSelf.yLabel setText:[NSString stringWithFormat:@"y : %f", motion.attitude.pitch]];
            [WeakSelf.zLabel setText:[NSString stringWithFormat:@"z : %f", motion.attitude.yaw]];
            
            
            //x -3.14  -  3.14    image
            double n = acWidth/(2*M_PI);
            double x = motion.attitude.roll*n;
//            WeakSelf.image.center = CGPointMake(x, WeakSelf.image.center.y);
            if(x <= -acWidth/2){
                x = - acWidth/2;
            }
            else if(x >= acWidth/2){
                x = acWidth/2;
            }
            WeakSelf.centerX.constant = x;

        }];
    }
}


@end
