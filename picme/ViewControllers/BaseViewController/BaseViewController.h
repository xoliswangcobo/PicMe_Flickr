//
//  BaseViewController.h
//  BaseComponents
//
//  Created by Xoliswa Ngcobo on 2016/10/11.
//
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void) setupNavigationBarTitleViewWithImage:(NSString*) imageName;
- (void) showLoadingProgressIndicatorWithMessage:(NSString*) loadingMessage;
- (void) dismissLoadingProgressIndicator;

@end
