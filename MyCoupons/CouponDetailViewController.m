//
//  CouponDetailViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 27/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "CouponDetailViewController.h"

@interface CouponDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *LabelCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *LabelCode;
@property (weak, nonatomic) IBOutlet UILabel *LabelCodeFormat;


@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.coupon.couponName;
    self.LabelCompanyName.text = self.coupon.companyName;
    self.LabelCode.text = self.coupon.code;
    self.LabelCodeFormat.text = self.coupon.codeFormat;
}

- (IBAction)removeCoupon:(id)sender {
    
    NSDictionary *info = @{@"RemoveCoupon":self.coupon};
    
    // invio notifica
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveCoupon" object:self userInfo:info];
    
    [self.navigationController popViewControllerAnimated:YES];
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
