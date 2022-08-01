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
@property (weak, nonatomic) IBOutlet UIImageView *ImageCode;


@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.coupon.couponName;
    self.LabelCompanyName.text = self.coupon.companyName;
    self.LabelCode.text = self.coupon.code;
    
    [self printCode];
}

- (void)printCode {
    if ([self.coupon.codeFormat isEqualToString:@"BARCODE"]){
        CIImage *barcode= [self generateBarCode];
        UIImage *barcodeimage = [[UIImage alloc]initWithCIImage:barcode];
        self.ImageCode.image = barcodeimage;
    }
    else if ([self.coupon.codeFormat isEqualToString:@"QRCODE"]){
        CIImage *qrcode = [self generateQRCode];
        UIImage *qrcodeimage = [[UIImage alloc] initWithCIImage:qrcode];
        self.ImageCode.image = qrcodeimage;
    }
}

- (IBAction)removeCoupon:(id)sender {
    
    // alert per chiedere conferma di eliminazione
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attenzione" message:@"Sei sicuro di voler eliminare il coupon?" preferredStyle:UIAlertControllerStyleAlert];
    
    // Si: proseguo con eliminazione
    UIAlertAction *Si = [UIAlertAction actionWithTitle:@"Si" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
        NSDictionary *info = @{@"RemoveCoupon":self.coupon};
    
        // invio notifica di rimozione
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveCoupon" object:self userInfo:info];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *No = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
        
    [alert addAction:Si];
    [alert addAction:No];
    [self presentViewController:alert animated:YES completion:nil];
}

// genera QR CODE
- (CIImage *)generateQRCode{
    NSData *data = [self.coupon.code dataUsingEncoding:NSISOLatin1StringEncoding];
    
    CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrCodeFilter setValue:data forKey:@"inputMessage"];
    [qrCodeFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    return qrCodeFilter.outputImage;
}


-(CIImage *)generateBarCode{
    
    NSData *data = [self.coupon.code dataUsingEncoding:NSASCIIStringEncoding];
    CIFilter *barCodeFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [barCodeFilter setValue:data forKey:@"inputMessage"];
      [barCodeFilter setValue:[NSNumber numberWithFloat:7.0] forKey:@"inputQuietSpace"];
    
    return barCodeFilter.outputImage;

}

@end
