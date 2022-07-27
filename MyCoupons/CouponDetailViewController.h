//
//  CouponDetailViewController.h
//  MyCoupons
//
//  Created by Federico Ghelfi on 27/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

NS_ASSUME_NONNULL_BEGIN

@interface CouponDetailViewController : UIViewController
@property (nonatomic, strong) Coupon *coupon;

@end

NS_ASSUME_NONNULL_END
