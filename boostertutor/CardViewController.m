//
//  CardViewController.m
//  Booster Tutor
//
//  Created by Al Gilardi on 12/15/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import "CardViewController.h"

@interface CardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *cardImage;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardID = (int)[self.cardNumber integerValue];
    NSString *url = [NSString stringWithFormat:
                     @"http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=%i&type=card", self.cardID];
    [self.cardImage setImage:[UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:url]]]];
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
