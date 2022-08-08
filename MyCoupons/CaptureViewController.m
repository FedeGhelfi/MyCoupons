//
//  CaptureViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 06/08/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "CaptureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CaptureViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) NSString *decodedCode;
@property (nonatomic, strong) NSString *decodedCodeFormat;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CALayer *targetLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVMetadataObject *obj;

@property (weak, nonatomic) IBOutlet UILabel *LabelCode;
@property (weak, nonatomic) IBOutlet UIButton *ButtonOK;


@property(nonatomic) BOOL isReading;


@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isReading = NO;
    
    self.captureSession = nil;
    
    [self startReading];
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
    
    /* NON ANDREBBE FATTO SULLA MAIN QUEUE, ma sarebbe molto lento */
    
   // dispatch_queue_t dispatchQueue;
   // dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [capturedMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [capturedMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code]];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:self.viewPreview.layer.bounds];
    
    [self.viewPreview.layer addSublayer:self.previewLayer];
    
    // detection object
    self.targetLayer = [CALayer layer];
    self.targetLayer.frame = self.viewPreview.layer.bounds;
    [self.viewPreview.layer addSublayer:self.targetLayer];
    
    
    
    [self.captureSession startRunning];
    
    
    return YES;
}

- (void)clearTargetLayer {
  NSArray *sublayers = [[self.targetLayer sublayers] copy];
  for (CALayer *sublayer in sublayers) {
    [sublayer removeFromSuperlayer];
  }
}


// metodo che viene invocato ogni volta che viene localizzato un oggetto di tipo specificato
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
   
    for (AVMetadataObject *metadataObject in metadataObjects) {
        
        if ([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode]){  // è un QR
                
            AVMetadataMachineReadableCodeObject *readableCodeobject = (AVMetadataMachineReadableCodeObject *)metadataObject; // cast
            self.obj = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            
            /*
             Una volta localizzato: riempio label con codice e attivo un button che salva e fa pop view controller.
             */
            
            NSLog(@"Sto leggendo un qrcode, la string value vale: %@",readableCodeobject.stringValue);
            self.decodedCode = readableCodeobject.stringValue;
            self.decodedCodeFormat = @"QRCODE";
            
            self.LabelCode.text = self.decodedCode;
            // [self stopReading];
        }
        else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
            
            AVMetadataMachineReadableCodeObject *readableCodeobject = (AVMetadataMachineReadableCodeObject *)metadataObject; // cast
            self.obj = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            NSLog(@"Sto leggendo un barcode, la string value vale: %@",readableCodeobject.stringValue);
            self.decodedCode = readableCodeobject.stringValue;
            self.decodedCodeFormat = @"BARCODE";
            
            self.LabelCode.text = self.decodedCode;
            
            // [self stopReading
        }
        
        
        [self showButtonAndCode];
        
    }
    
    [self clearTargetLayer];
    [self showDetectedObjects];
    self.obj = nil; // pulisco
}

- (void)showButtonAndCode{
    self.LabelCode.text = self.decodedCode;
    self.ButtonOK.enabled = YES;

}

- (IBAction)popViewController:(id)sender {
    [self stopReading];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)showDetectedObjects {
    if (!self.obj){
        return;
    }
      CAShapeLayer *shapeLayer = [CAShapeLayer layer];
      shapeLayer.strokeColor = [UIColor redColor].CGColor;
      shapeLayer.fillColor = [UIColor clearColor].CGColor;
      shapeLayer.lineWidth = 2.0;
      shapeLayer.lineJoin = kCALineJoinRound;
      CGPathRef path = createPathForPoints([(AVMetadataMachineReadableCodeObject *)self.obj corners]);
      shapeLayer.path = path;
      CFRelease(path);
      [self.targetLayer addSublayer:shapeLayer];
  }

CGMutablePathRef createPathForPoints(NSArray* points) {
  CGMutablePathRef path = CGPathCreateMutable();
  CGPoint point;
  if ([points count] > 0) {
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[points objectAtIndex:0], &point);
    CGPathMoveToPoint(path, nil, point.x, point.y);
    int i = 1;
    while (i < [points count]) {
      CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[points objectAtIndex:i], &point);
      CGPathAddLineToPoint(path, nil, point.x, point.y);
      i++;
    }
    CGPathCloseSubpath(path);
  }
  return path;
}

- (void)stopReading {
    
    // dictionary che contiene dati coupon aggiunto
    NSDictionary *code = @{@"DecodedCode":self.decodedCode, @"FormatCode":self.decodedCodeFormat};
    
    // notifica per comunicare codice decodificato e relativo formato
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveCode" object:self userInfo:code];
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.previewLayer removeFromSuperlayer];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
