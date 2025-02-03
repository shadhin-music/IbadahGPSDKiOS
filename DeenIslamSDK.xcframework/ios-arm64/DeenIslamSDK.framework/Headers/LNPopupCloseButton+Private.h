//
//  LNPopupCloseButton+Private.h
//  LNPopupController
//
//  Created by Léo Natan on 2016-12-02.
//  Copyright © 2015-2024 Léo Natan. All rights reserved.
//

#import "LNPopupCloseButton.h"
#import "LNPopupContentView.h"

@interface LNPopupCloseButton ()

- (instancetype)initWithContainingContentView:(LNPopupContentView*)contentView;

@property (nonatomic, weak) LNPopupContentView* popupContentView;

- (void)_setStyle:(LNPopupCloseButtonStyle)style;
- (void)_setButtonContainerStationary;
- (void)_setButtonContainerTransitioning;

@end
