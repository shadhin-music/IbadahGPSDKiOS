//
//  UIViewController+LNPopupSupportPrivate.h
//  LNPopupController
//
//  Created by Leo Natan on 7/25/15.
//  Copyright © 2015 Leo Natan. All rights reserved.
//

#import "UIViewController+LNPopupSupport.h"

@class LNPopupController;

NS_ASSUME_NONNULL_BEGIN

void _dn_LNPopupSupportSetPopupInsetsForViewController(UIViewController* controller, BOOL layout, UIEdgeInsets popupEdgeInsets);

@interface _LNPopupBottomBarSupport : UIView @end

@interface UIViewController (LNPopupSupportPrivate)

- (nullable UIViewController*)_dn_ln_common_childViewControllerForStatusBarStyle;

@property (nonatomic, strong, readonly, getter=_dn_ln_popupController) LNPopupController* dn_ln_popupController;
- (LNPopupController*)_dn_ln_popupController_nocreate;
@property (nullable, nonatomic, assign, readwrite) UIViewController* dn_popupPresentationContainerViewController;
@property (nullable, nonatomic, strong, readonly) UIViewController* dn_popupContentViewController;

@property (nonnull, nonatomic, strong, readonly, getter=_dn_ln_bottomBarSupport) _LNPopupBottomBarSupport* dn_bottomBarSupport;
- (nullable _LNPopupBottomBarSupport *)_dn_ln_bottomBarSupport_nocreate;

- (BOOL)_isContainedInPopupController;

- (nullable UIView *)bottomDockingViewForPopup_nocreateOrDeveloper;
- (nonnull UIView *)bottomDockingViewForPopup_internalOrDeveloper;

- (CGRect)dn_defaultFrameForBottomDockingView_internal;
- (CGRect)dn_defaultFrameForBottomDockingView_internalOrDeveloper;

@end

NS_ASSUME_NONNULL_END
