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
    
    // provo ad aggiungere alla lista
    [self.coupons addCoupon:[[Coupon alloc] initWithCouponName:@"Biscotti" CompanyName:@"Conad" code:@"56839G" codeFormat:@"QRCODE"]];
    [self.coupons addCoupon:[[Coupon alloc] initWithCouponName:@"Detersivi" CompanyName:@"Tigotà" code:@"FF5660" codeFormat:@"BARCODE"]];
    
    
    
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
    // Configure the cell...
    
    /*
     PROVE DI MODIFICA STRINGHE
     
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont fontWithName:@"Arial" size:16.0],
        NSForegroundColorAttributeName:[UIColor redColor]
    };
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:c.companyName attributes:attributes];
    */
    
    cell.textLabel.textColor = [UIColor purpleColor]; // testo colorato
    
    // cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18.0]; // modifico il font
    cell.textLabel.text = c.couponName;
    cell.indentationLevel = 2;

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // check sull'identifier della segue
    if([segue.identifier isEqualToString:@"SegueForDetailCoupon"]){
        
        // check sul vc di destinazione
        if([segue.destinationViewController isKindOfClass:[CouponDetailViewController class]]){
            
            CouponDetailViewController *cd = (CouponDetailViewController *)segue.destinationViewController;
            
            // index path della cella selezionata
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            
            Coupon *c = [self.coupons getCoupon:indexPath.row];
            
            cd.coupon = c;
            
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
