//
//  CouponListTableViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 26/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "CouponListTableViewController.h"
#import "CouponDetailViewController.h"

@interface CouponListTableViewController ()

@property (nonatomic, strong) CouponList *coupons;

@end

@implementation CouponListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Coupons";
    
    // alloco la lista di coupon
    self.coupons = [[CouponList alloc] init];
    
    
    // quando verrà inserita una nuova carta verrà inviato un messaggio
    // che invocherà il metodo corretto
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCoupon:) name:@"AddNewCoupon" object:nil];
    
    // comportamento speculare con la rimozione
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoupon:) name:@"RemoveCoupon" object:nil];
}

- (void)addNewCoupon:(NSNotification *)notification {
    
    [self.coupons addCoupon:[notification.userInfo objectForKey:@"AddedCoupon"]];
    NSLog(@"Size: %ld",self.coupons.size);
    
    [self.tableView reloadData];
    
}


- (void)removeCoupon:(NSNotification *)notification {
    
    [self.coupons removeCoupon:[notification.userInfo objectForKey:@"RemoveCoupon"]];
    NSLog(@"Size: %ld", self.coupons.size);
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.coupons.size;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell" forIndexPath:indexPath];
    
    Coupon *c = [self.coupons getCoupon:indexPath.row];
    
   // cell.textLabel.textColor = [UIColor purpleColor]; // testo colorato
    
    // cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18.0]; // modifico il font
    cell.textLabel.text = c.couponName;
    cell.indentationLevel = 2;

    return cell;
}

#pragma mark - Navigation

// segue verso il view controller di dettaglio
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // check sull'identifier della segue
    if([segue.identifier isEqualToString:@"SegueForDetailCoupon"]){
        
        // check sul vc di destinazione
        if([segue.destinationViewController isKindOfClass:[CouponDetailViewController class]]){
            
            CouponDetailViewController *cd = (CouponDetailViewController *)segue.destinationViewController;
            
            // index path della cella selezionata
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            
            // ottengo il coupon corrispondente alla cella premuta per passarlo al prossimo vc
            Coupon *c = [self.coupons getCoupon:indexPath.row];
        
            cd.coupon = c;
        }
    }
}


@end
