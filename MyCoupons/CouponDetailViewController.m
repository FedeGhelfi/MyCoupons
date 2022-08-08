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
@property (weak, nonatomic) IBOutlet UILabel *LabelDate;


@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.coupon.couponName;
    self.LabelCompanyName.text = self.coupon.companyName;
    self.LabelCode.text = self.coupon.code;
    
    [self printExpirationDate];
    [self printCode];
}


- (void)printExpirationDate {

    // se non è scaduto, formatta la data e la stampa
    if ([self.coupon isExpired] == NO){
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    
        self.LabelDate.text = [dateFormatter stringFromDate:self.coupon.expirationDate];
    }
    
    // altrimenti stampa "SCADUTO" in rosso
    else {
        self.LabelDate.textColor = [UIColor redColor];
        self.LabelDate.text = @"SCADUTO!";
    }
    
}

// stampa del formato grafico del codice
- (void)printCode {
    if ([self.coupon.codeFormat isEqualToString:@"BARCODE"]){
        CIImage *barcode= [self generateBarCode];
        
        // aggiusto la scala del barcode per evitare la sfocatura
        CGFloat scaleX = self.ImageCode.bounds.size.width / barcode.extent.size.width;
        CGFloat scaleY = self.ImageCode.bounds.size.height / barcode.extent.size.height;
        CIImage *transformedImage = [barcode imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
        
        UIImage *barcodeimage = [[UIImage alloc]initWithCIImage:transformedImage];
        self.ImageCode.image = barcodeimage;
    }
    
    else if ([self.coupon.codeFormat isEqualToString:@"QRCODE"]){
        CIImage *qrcode = [self generateQRCode];
    
        // aggiusto la scala del QR per evitare la sfocatura
        CGFloat scaleX = self.ImageCode.bounds.size.width / qrcode.extent.size.width;
        CGFloat scaleY = self.ImageCode.bounds.size.height / qrcode.extent.size.height;
        
        CIImage *transformedImage = [qrcode imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
        
         
        // converto a UIImage e la setto nella image view
        UIImage *qrcodeimage = [[UIImage alloc] initWithCIImage:transformedImage];
        
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
    // error correction rate
    [qrCodeFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
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
