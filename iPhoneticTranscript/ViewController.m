//
//  ViewController.m
//  iPhoneticTranscript
//
//  Created by Rajesh on 1/5/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef enum {
    kShowResult,
    kStartNew,
    kBookmark,
    kSpeak,
    kDictionary
}ButtonType;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *prononciationLabel;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helpMeLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoeResultTopConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_textField becomeFirstResponder];
    [_textField setInputAccessoryView:_accessoryView];
    [_resultView setAlpha:0.f];
    [_helpMeLabelTopConstraint setConstant:self.view.bounds.size.height*.4 - 100];
    [_shoeResultTopConstraint setConstant:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)textFieldTextChanged:(UITextField *)sender {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return _resultView.alpha == 0.f;
}

- (IBAction)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
        case kShowResult :
            if (_textField.text.length) {
                [self showResult:YES];
                [_prononciationLabel setText:_textField.text];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Type something to let me analyze!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            break;
        case kStartNew :
            [self showResult:NO];
            break;
        case kBookmark : {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Coming soon!" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case kSpeak : {
            AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:_textField.text];
            [synthesizer speakUtterance:utterance];
        }
            break;
        case kDictionary : {
            if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:_textField.text]) {
                UIReferenceLibraryViewController *referenceLibraryViewController = [[UIReferenceLibraryViewController alloc] initWithTerm:_textField.text];
                [self presentViewController:referenceLibraryViewController animated:YES completion:nil];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Term not available" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

- (void)showResult:(BOOL)shouldShow {
    if (shouldShow) {
        [_helpMeLabelTopConstraint setConstant:40];
        [_shoeResultTopConstraint setConstant:-44];
        [_textField setFont:[UIFont boldSystemFontOfSize:15.f]];
    } else {
        [_helpMeLabelTopConstraint setConstant:self.view.bounds.size.height*.4 - 100];
        [_shoeResultTopConstraint setConstant:0];
        [_textField setFont:[UIFont boldSystemFontOfSize:30.f]];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        if (shouldShow) {
            [_resultView setAlpha:1.f];
        } else {
            [_resultView setAlpha:0.f];
        }
        [self.view layoutIfNeeded];
        [self.accessoryView layoutIfNeeded];
    }];
}

@end
