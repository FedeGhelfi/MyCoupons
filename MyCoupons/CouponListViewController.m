//
//  CouponListViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 25/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "CouponListViewController.h"

@interface CouponListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (nonatomic, strong) Coupon *c;    //prova 

@end

@implementation CouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // prova di creazione coupon
    self.c = [[Coupon alloc] initWithCompanyName:@"Conad" code:@"1234FD" codeFormat:@"QR"];
    self.TitleLabel.text = self.c.displayCoupon;
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
