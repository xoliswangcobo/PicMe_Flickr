//
//  BaseViewController.m
//  BaseComponents
//
//  Created by Xoliswa Ngcobo on 2016/10/11.
//
//

#import "BaseViewController.h"

@interface BaseViewController ()
    @property (strong, nonatomic) UIScrollView * contentScrollView;
    @property (strong, nonatomic) UITapGestureRecognizer * endEditingTapGestureRecognizer;
@end

static UIView * loadingIndicatorView;

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.endEditingTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingOnView)];
    
    for (UIView * subView in [self.view subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            self.contentScrollView = (UIScrollView*) subView;
            break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.contentScrollView) {
        [self registerForKeyboardNotifications];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    [self endEditingOnView];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    if (self.contentScrollView) {
        NSDictionary* info = [notification userInfo];
        CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        [self.contentScrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)];
    }
    
    [self.view addGestureRecognizer:self.endEditingTapGestureRecognizer];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    if (self.contentScrollView) {
        [self.contentScrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [self.contentScrollView setContentOffset:CGPointZero animated:YES];
    }
    
    [self.view removeGestureRecognizer:self.endEditingTapGestureRecognizer];
}

- (void) endEditingOnView {
    [self.view.window endEditing:YES];
}


#pragma mark - ProgressIndicator

- (void) showLoadingProgressIndicatorWithMessage:(NSString *)loadingMessage {
    self.view.userInteractionEnabled = NO;
    self.view.alpha = 0.8f;
    
    UIActivityIndicatorView * progressIndicator;
    UILabel * loadingIndicatorViewMessage;
    
    if (loadingIndicatorView != nil) {
        [loadingIndicatorView removeFromSuperview];
        loadingIndicatorView = nil;
    }
    
    loadingIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.6, self.view.frame.size.height*0.2)];
    loadingIndicatorView.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:159.0/255.0 blue:237.0/255 alpha:1.0];
    loadingIndicatorView.layer.cornerRadius = 5.0f;
    loadingIndicatorView.center = CGPointMake(self.view.center.x, self.view.center.y - self.navigationController.navigationBar.frame.size.height);
    
    progressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    progressIndicator.center = CGPointMake(loadingIndicatorView.frame.size.width / 2, loadingIndicatorView.frame.size.height / 2);
    progressIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [progressIndicator setColor:[UIColor whiteColor]];
    [progressIndicator startAnimating];
    
    loadingIndicatorViewMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingIndicatorView.frame.size.width, loadingIndicatorView.frame.size.height*0.3)];
    [loadingIndicatorViewMessage setText:loadingMessage];
    [loadingIndicatorViewMessage setTextColor:[UIColor whiteColor]];
    [loadingIndicatorViewMessage setTextAlignment:NSTextAlignmentCenter];
    loadingIndicatorViewMessage.center = CGPointMake(progressIndicator.center.x, progressIndicator.center.y+20+progressIndicator.frame.size.height/2);
    
    [loadingIndicatorView addSubview:loadingIndicatorViewMessage];
    [loadingIndicatorView addSubview:progressIndicator];
    [self.view addSubview:loadingIndicatorView];
}

- (void) dismissLoadingProgressIndicator {
    [self enabledUserInteraction];
    self.view.alpha = 1.0f;
    
    if (loadingIndicatorView != nil) {
        [loadingIndicatorView removeFromSuperview];
        loadingIndicatorView = nil;
        
        [self performSelector:@selector(enabledUserInteraction) withObject:nil afterDelay:0.5];
    }
}

- (void) enabledUserInteraction {
    self.view.userInteractionEnabled = YES;
}


#pragma mark - Alert Controller (Messages)

- (void) presentModalMessageWithTitle:(NSString*)title message:(NSString*)message buttonTitles:(NSArray*)buttonTitles buttonActions:(NSArray*)buttonActions {
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (int buttonIndex = 0; buttonIndex < buttonTitles.count; buttonIndex++) {
        void (^buttonActionBlock) () = buttonActions[buttonIndex];
        UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:buttonTitles[buttonIndex] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            buttonActionBlock();
        }];
        
        [alertView addAction:buttonAction];
    }
    
    [self presentViewController:alertView animated:YES completion:nil];
}

@end
