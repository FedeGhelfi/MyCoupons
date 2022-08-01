//
//  ChoiceViewController.m
//  MyCoupons
//
//  Created by Federico Ghelfi on 01/08/2022.
//  Copyright © 2022 Federico Ghelfi. All rights reserved.
//

#import "ChoiceViewController.h"

@interface ChoiceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *GeneraButton;
@property (weak, nonatomic) IBOutlet UIButton *ScansionaButton;

@end

@implementation ChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scegli la modalità";
    
    // configuro il bottone "GENERA"
    self.GeneraButton.layer.borderWidth = 1;
    self.GeneraButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.GeneraButton.layer.cornerRadius = 3;
    
    // configuro il bottone "SCANSIONA"
    self.ScansionaButton.layer.borderWidth = 1;
    self.ScansionaButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.ScansionaButton.layer.cornerRadius = 3;
}

@end
