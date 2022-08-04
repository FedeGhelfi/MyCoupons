//
//  Coupon.h
//  MyCoupons
//
//  Created by Federico Ghelfi on 25/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Coupon : NSObject

-(instancetype) initWithCouponName:(NSString *)couponName
                CompanyName:(NSString *)companyName
                code:(NSString *)code
                codeFormat:(NSString *)codeFormat
                expirationDate:(NSDate *)expirationDate;

-(NSString *) displayCoupon;
-(BOOL)isExpired;

@property(nonatomic, strong) NSString *couponName; // identificativo del coupon
@property(nonatomic, strong) NSString *companyName;
@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSString *codeFormat;
@property(nonatomic, strong) NSDate *expirationDate;

@end

NS_ASSUME_NONNULL_END
