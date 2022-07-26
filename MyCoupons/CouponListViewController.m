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
@property (nonatomic, strong) CouponList *list;

@end

@implementation CouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Classe coupon testata.");
    NSLog(@"Classe cuponList testata.");
    
    self.list = [[CouponList alloc] init];
    
    // prova di creazione coupon
    self.c = [[Coupon alloc] initWithCompanyName:@"Conad" code:@"1234FD" codeFormat:@"QR"];
    self.TitleLabel.text = self.c.displayCoupon;
    
    Coupon *c2 = [[Coupon alloc] initWithCompanyName:@"tigotà" code:@"448FF6" codeFormat:@"barcode"];
    
    Coupon *c3 = [[Coupon alloc] initWithCompanyName:@"eurospin" code:@"000000" codeFormat:@"barcode"];
    
    [self.list addCoupon:c2];
    [self.list addCoupon:c3];
    NSLog(@"Size: %ld", self.list.size);
    
    // debug per creazione collezione
    for (int i = 0; i < [self.list size]; i++){
        NSLog(@"Sono nel for");
        Coupon* object = [self.list getCoupon:i];
        NSLog(@"Coupon %d: %@", i, object.displayCoupon);
    }
    
    [self.list removeCoupon:c3];
    for (int i = 0; i < [self.list size]; i++){
        Coupon* object = [self.list getCoupon:i];
        NSLog(@"Coupon %d: %@", i, object.displayCoupon);
    }
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
