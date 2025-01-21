//
//  _LNPopupBarSupportObject.h
//  LNPopupController
//
//  Created by Leo Natan on 7/24/15.
//  Copyright © 2015 Leo Natan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNPopupBar+Private.h"
#import "UIViewController+LNPopupSupportPrivate.h"
#import "LNPopupCloseButton.h"
#import "LNPopupContentView.h"

@interface LNPopupContentView ()

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong, readwrite) UIPanGestureRecognizer* dn_popupInteractionGestureRecognizer;
@property (nonatomic, strong, readwrite) LNPopupCloseButton* dn_popupCloseButton;
@property (nonatomic, strong) UIVisualEffectView* dn_effectView;

@property (nonatomic, weak) UIViewController* dn_currentPopupContentViewController;

@end

@interface LNPopupController : NSObject

- (instancetype)initDnWithContainerViewController:(__kindof UIViewController*)containerController;

@property (nonatomic, weak) UIView* dn_bottomBar;

@property (nonatomic, strong) LNPopupBar* dn_popupBar;
@property (nonatomic, strong, readonly) LNPopupBar* dn_popupBarStorage;
@property (nonatomic, strong) LNPopupContentView* dn_popupContentView;
@property (nonatomic, strong) UIScrollView* dn_popupContentContainerView;

@property (nonatomic) LNPopupPresentationState dn_popupControllerState;
@property (nonatomic) LNPopupPresentationState dn_popupControllerTargetState;

@property (nonatomic, weak) __kindof UIViewController* dn_containerController;

@property (nonatomic) CGPoint dn_lastPopupBarLocation;
@property (nonatomic) CFTimeInterval dn_lastSeenMovement;

@property (nonatomic, weak) UIViewController* dn_effectiveStatusBarUpdateController;

- (CGFloat)dn__percentFromPopupBar;

- (void)_dn_setContentToState:(LNPopupPresentationState)state;

- (void)_dn_movePopupBarAndContentToBottomBarSuperview;

- (void)_dn_repositionPopupCloseButton;

- (void)dn_presentPopupBarAnimated:(BOOL)animated openPopup:(BOOL)open completion:(void(^)(void))completionBlock;
- (void)dn_openPopupAnimated:(BOOL)animated completion:(void(^)(void))completionBlock;
- (void)dn_closePopupAnimated:(BOOL)animated completion:(void(^)(void))completionBlock;
- (void)dn_dismissPopupBarAnimated:(BOOL)animated completion:(void(^)(void))completionBlock;

- (void)_dn_configurePopupBarFromBottomBar;

+ (CGFloat)_dn_statusBarHeightForView:(UIView*)view;

@end
