//
//  Coupon.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 25/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

// costruttore coupon
- (instancetype)initWithCouponName:(NSString *)couponName
                       CompanyName:(NSString *)companyName
                              code:(NSString *)code
                        codeFormat:(NSString *)codeFormat
                        expirationDate:(NSDate *)expirationDate {
    if (self = [super init]){
        _couponName = [couponName copy];
        _companyName = [companyName copy];
        _code = [code copy];
        _codeFormat = [codeFormat copy];
        _expirationDate = [expirationDate copy];
    }
    
    return self;
}

// debug
- (NSString *)displayCoupon{
    NSLog(@"Called displayCoupon function");
    return [NSString stringWithFormat:@"%@ %@ %@", self.companyName, self.code, self.codeFormat];
}

@end
