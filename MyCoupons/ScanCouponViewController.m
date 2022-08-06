//
//  ScanCouponViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 04/08/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "ScanCouponViewController.h"
#import "Coupon.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanCouponViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *CouponNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *CompanyNameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ChoiceCodeFormat;
@property (weak, nonatomic) IBOutlet UIDatePicker *expirationDatePicker;
@property (nonatomic, strong) NSString *decodedQR;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CALayer *targetLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) NSMutableArray *codeObjects; // per memorizzare i metatadataObject


@property(nonatomic) BOOL isReading;

@end

@implementation ScanCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.CouponNameTextField.delegate = self;
    self.CompanyNameTextField.delegate = self;
    
    self.isReading = NO;
    
    self.captureSession = nil;

}

/* ------------------------------------ */
// PARTE DI SCANSIONE


- (BOOL)startReading {
    
    NSLog(@"Sono in start reading");
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if(!deviceInput) {
        NSLog(@"Error %@", error.localizedDescription);
        return NO;
    }
    
    self.captureSession = [[AVCaptureSession alloc]init];
    [self.captureSession addInput:deviceInput];
    
    NSLog(@"Ho aggiunto dev input a capture session");
    
    AVCaptureMetadataOutput *capturedMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:capturedMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [capturedMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [capturedMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code]];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //[self.previewLayer setFrame:self._viewPreview.layer.bounds];
    
   // [self.viewPreview.layer addSublayer:self.pre];
    
    [self.captureSession startRunning];
    
    
    return YES;
}




// metodo che viene invocato ogni volta che viene localizzato un oggetto di tipo specificato
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
   
    //self.codeObjects = nil;
    
    for (AVMetadataObject *metadataObject in metadataObjects) {
        
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode] || [metadataObject.type isEqualToString:AVMetadataObjectTypeEAN13Code]){
                
            AVMetadataMachineReadableCodeObject *readableCodeobject = (AVMetadataMachineReadableCodeObject *)metadataObject; // cast
            NSLog(@"Sono arrivato nel for, la string value vale: %@",readableCodeobject.stringValue);
            self.decodedQR = readableCodeobject.stringValue;
            [self stopReading];
        }
        
    }
   // [self clearTargetLayer];
   // [self showDetectedObjects];
}

- (void)stopReading {
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

- (IBAction)startScanning:(id)sender {
    NSLog(@"Button start pressed");
    [self startReading];
}



/* ------------------------------------- */

- (NSString *)whichCodeFormat:(UISegmentedControl *)sc {
    NSString *string = [[NSString alloc] init];
    switch(sc.selectedSegmentIndex) {
        case 0:
            string = @"QRCODE";
            break;
        case 1:
            string = @"BARCODE";
            break;
        default:
            string = @"";
            break;
    }
    return string;
}

// controllo sugli input
- (BOOL)controlTextField:(NSString *)string{
    if (string.length > 0)
        return YES;
    else
        return NO;
}

// Configurazione dell'alert standard
- (UIAlertController *)alertSet{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attenzione" message:@"prova" preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ho capito" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:defaultAction];
    return alert;
}




- (IBAction)addCoupon:(id)sender {
    
    UIAlertController *alert = [self alertSet];
    
       // controllo gli input
       if ([self controlTextField:self.CouponNameTextField.text] == NO){
           alert.message = @"Inserisci il nome del coupon";
           [self presentViewController:alert animated:YES completion:nil];
       }
       else if ([self controlTextField:self.CompanyNameTextField.text] == NO){
           alert.message = @"Inserisci il nome dell'azienda";
           [self presentViewController:alert animated:YES completion:nil];
       }
        // AGGIUNGERE CONTROLLO SU SCANSIONE ?
       else {
           Coupon *newCoupon = [[Coupon alloc]initWithCouponName:self.CouponNameTextField.text CompanyName:self.CompanyNameTextField.text code:self.decodedQR codeFormat:[self whichCodeFormat:self.ChoiceCodeFormat] expirationDate:self.expirationDatePicker.date];
           
           // dictionary che contiene dati coupon aggiunto
           NSDictionary *info = @{@"AddedCoupon":newCoupon};
       
           // notifica di aggiunta coupon
           [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewCoupon" object:self userInfo:info];
       
           // prendo tutto lo stack dei viewController
           NSArray *viewcontrollers = [self.navigationController viewControllers];
       
           // Ritorno alla lista dei coupon
           [self.navigationController popToViewController:[viewcontrollers objectAtIndex:0] animated:YES];
       }
    
}



// chiamato appena prima che che il text field diventi attivo
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    // cambio colore ai textfield
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:0.3f];
    return YES;
}
  
// chiamato quando diventa attivo il textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

// Metodo che fa sparire la tastiera
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"TextFieldShouldReturn");
    
    [textField resignFirstResponder];
    return YES;
}



@end
