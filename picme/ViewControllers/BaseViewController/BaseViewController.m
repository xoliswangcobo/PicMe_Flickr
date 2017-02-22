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
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingOnView)]];
    
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

- (void) setupNavigationBarTitleViewWithImage:(NSString*) imageName {
    // The image will be centered perfectly.
    // It will takeup 50% of the navigation bar width
    // It will takeup 100% of the navigation bar height
    // It will also replace the titleView
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width*0.5;
    CGFloat height = self.navigationController.navigationBar.frame.size.height*0.9;
    
    // This get the perfect center position on the x-axis
    CGFloat xPosition = ([[UIScreen mainScreen] bounds].size.width - width)/2.0;
    CGFloat yPosition = self.navigationController.navigationBar.frame.origin.y;
    
    UIImageView * newTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, width, height)];
    [newTitleView setContentMode:UIViewContentModeScaleAspectFit];
    [newTitleView setImage:[UIImage imageNamed:imageName]];
    
    [self.navigationItem setTitleView:newTitleView];
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
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    if (self.contentScrollView) {
        [self.contentScrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [self.contentScrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (void) endEditingOnView {
    [self.view.window endEditing:YES];
}

@end
