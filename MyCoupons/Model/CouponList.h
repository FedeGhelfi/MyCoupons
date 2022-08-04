//
//  CouponList.h
//  MyCoupons
//
//  Created by Federico Ghelfi on 26/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coupon.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponList : NSObject

- (long)size; // dimensione collezione
- (void)addCoupon:(Coupon *)c;
- (void)removeCoupon:(Coupon *)c;
- (Coupon *)getCoupon:(NSInteger)index;
- (NSArray *)getAll;

@end

NS_ASSUME_NONNULL_END
