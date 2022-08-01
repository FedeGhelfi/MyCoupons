//
//  AddCouponViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 26/07/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "AddCouponViewController.h"
#import "Coupon.h"

@interface AddCouponViewController ()

@property (weak, nonatomic) IBOutlet UITextField *CouponNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *CompanyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *CodeTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ChoiceCodeFormat;

@end

@implementation AddCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // il view controller diventa il delegate dei text field
    self.CouponNameTextField.delegate = self;
    self.CompanyNameTextField.delegate = self;
    self.CodeTextField.delegate = self;

}

// chiamato appena prima che che il text field diventi attivo
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:0.3f];
    return YES;
}
 
// chiamato quando diventa attivo il textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}

// Metodo che fa sparire la tastiera
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"TextFieldShouldReturn");
    
    [textField resignFirstResponder];
    return YES;
}

// Dopo aver cliccato "Save"
- (IBAction)addCoupon:(id)sender {
    
    UIAlertController *alert = [self AlertSet];
 
    // controllo gli input
    if ([self ControlTextField:self.CouponNameTextField.text] == NO){
        alert.message = @"Inserisci il nome del coupon";
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([self ControlTextField:self.CompanyNameTextField.text] == NO){
        alert.message = @"Inserisci il nome dell'azienda";
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([self ControlTextField:self.CodeTextField.text] == NO){
        alert.message = @"Inserisci il codice";
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
    
        Coupon *newCoupon = [[Coupon alloc]initWithCouponName:self.CouponNameTextField.text CompanyName:self.CompanyNameTextField.text code:self.CodeTextField.text codeFormat:[self whichCodeFormat:self.ChoiceCodeFormat]];
    
        // dictionary che contiene dati coupon aggiunto
        NSDictionary *info = @{@"AddedCoupon":newCoupon};
    
        // notifica di aggiunta coupon
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewCoupon" object:self userInfo:info];
    
        NSLog(@"Pressed Save");
    
        // prendo tutto lo stack dei viewController
        NSArray *viewcontrollers = [self.navigationController viewControllers];
    
        // Ritorno alla lista dei coupon
        [self.navigationController popToViewController:[viewcontrollers objectAtIndex:0] animated:YES];
    }
}

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
    
    NSLog(@"Scelta: %@", string);
    return string;
}

// controllo sugli input
- (BOOL) ControlTextField:(NSString *)string{
    if (string.length > 0)
        return YES;
    else
        return NO;
}


// Configurazione dell'alert
- (UIAlertController *)AlertSet{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attenzione" message:@"prova" preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ho capito" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:defaultAction];
    return alert;
}

@end
