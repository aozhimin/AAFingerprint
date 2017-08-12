//
//  ViewController.m
//  AAFingerprintDemo
//
//  Created by dev-aozhimin on 2017/8/5.
//  Copyright © 2017年 aozhimin. All rights reserved.
//

#import "ViewController.h"
#import <AAFingerprint/AAFingerprint.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fingerprintLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.fingerprintLabel.text = [NSString stringWithFormat:@"Device Fingerprint: %@", [AAFDevice deviceFingerPrint]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
