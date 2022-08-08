//
//  ScanCouponViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 04/08/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "ScanCouponViewController.h"
#import "Coupon.h"


@interface ScanCouponViewController ()

@property (weak, nonatomic) IBOutlet UITextField *CouponNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *CompanyNameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ChoiceCodeFormat;
@property (weak, nonatomic) IBOutlet UIDatePicker *expirationDatePicker;

@property (weak, nonatomic) IBOutlet UILabel *LabelDisplayCode;


@property (nonatomic, strong) NSString *decodedCode; // codice decodificato
@property (nonatomic, strong) NSString *decodedCodeFormat; // formato codice decodificato


@end

@implementation ScanCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.CouponNameTextField.delegate = self;
    self.CompanyNameTextField.delegate = self;
    
    // quando verrà inserita una nuova carta verrà inviato un messaggio
    // che invocherà il metodo corretto
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDecodedCode:) name:@"SaveCode" object:nil];

}



- (void)saveDecodedCode:(NSNotification *)notification {
    
    self.decodedCode = [notification.userInfo objectForKey:@"DecodedCode"];
    self.decodedCodeFormat = [notification.userInfo objectForKey:@"FormatCode"];
    
    // tocco la UI solo dentro alla coda principale di esecuzione
    dispatch_async(dispatch_get_main_queue(), ^{
       self.LabelDisplayCode.text = self.decodedCode;
        
        if ([self.decodedCodeFormat isEqualToString:@"QRCODE"]){
            self.ChoiceCodeFormat.selectedSegmentIndex = 0;
        }
        else {
            self.ChoiceCodeFormat.selectedSegmentIndex = 1;
        }
        
    });
    
}



/* ------------------------------------- */


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
           Coupon *newCoupon = [[Coupon alloc]initWithCouponName:self.CouponNameTextField.text CompanyName:self.CompanyNameTextField.text code:self.decodedCode codeFormat:self.decodedCodeFormat expirationDate:self.expirationDatePicker.date];
           
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
