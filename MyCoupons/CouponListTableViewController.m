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
    
    // provo ad aggiungere alla lista: FUNZIONA
    /*
    [self.coupons addCoupon:[[Coupon alloc] initWithCouponName:@"Biscotti" CompanyName:@"Conad" code:@"56839G" codeFormat:@"QRCODE"]];
    [self.coupons addCoupon:[[Coupon alloc] initWithCouponName:@"Detersivi" CompanyName:@"Tigotà" code:@"FF5660" codeFormat:@"BARCODE"]];
    */
    
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
    
    // rimuovi coupon notificato dalla lista
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
