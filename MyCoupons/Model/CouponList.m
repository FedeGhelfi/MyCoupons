//
//  CouponList.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 26/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "CouponList.h"

@interface CouponList()

@property (nonatomic,strong) NSMutableArray *list;

@end

@implementation CouponList

- (instancetype) init{
    if (self = [super init]){
        _list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (long) size{
    return self.list.count;
}

- (void) addCoupon:(Coupon *)c{
    [self.list addObject:c];
    NSLog(@"AddCoupon...");
}

- (void) removeCoupon:(Coupon *)c{
    [self.list removeObject:c];
}

- (NSArray *) getAll{
    return self.list;
}

-(Coupon *) getCoupon:(NSInteger)index{
    NSLog(@"getCoupon...");
    return [self.list objectAtIndex:index];
    
}


@end
