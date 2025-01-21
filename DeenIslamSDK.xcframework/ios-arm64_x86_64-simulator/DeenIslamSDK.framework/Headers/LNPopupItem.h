//
//  LNPopupItem.h
//  LNPopupController
//
//  Created by Leo Natan on 7/25/15.
//  Copyright © 2015 Leo Natan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An @c LNPopupItem object manages the buttons and text to be displayed in a popup bar. Each view controller in popup presentation must have an @c LNPopupItem object that contains the buttons and text it wants displayed in the popup bar.
 */
@interface LNPopupItem : NSObject

/**
 * The popup item's title.
 *
 * @note If no title or subtitle is set, the property will return its view controller's title.
 */
@property (nullable, nonatomic, copy) NSString* dn_title;

/**
 * The popup item's subtitle.
 */
@property (nullable, nonatomic, copy) NSString* dn_subtitle;

/**
 * The popup item's image.
 *
 * @note The image will only be displayed on prominent popup bars.
 */
@property (nullable, nonatomic, strong) UIImage* dn_image;

/**
 * The popup item's progress.
 *
 * The progress is represented by a floating-point value between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task. The default value is 0.0. Values less than 0.0 and greater than 1.0 are pinned to those limits.
 */
@property (nonatomic) float dn_progress;

/**
 * An array of custom bar button items to display on the left side of the popup bar.
 *
 * @note For prominent popup bars, these buttons are positioned on the right side, before items in @c rightBarButtonItems.
 */
@property(nullable, nonatomic, copy) NSArray<UIBarButtonItem*>* dn_leftBarButtonItems;

/**
 * An array of custom bar button items to display on the right side of the popup bar.
 */
@property(nullable, nonatomic, copy) NSArray<UIBarButtonItem*>* dn_rightBarButtonItems;

@end

@interface LNPopupItem (Accessibility)

/**
 * The accessibility label of the image, in a localized string.
 */
@property (nonatomic, copy, nullable) NSString* dn_accessibilityImageLabel;

/**
 * The accessibility label of the progress, in a localized string.
 */
@property (nonatomic, copy, nullable) NSString* dn_accessibilityProgressLabel;

/**
 * The accessibility value of the progress, in a localized string.
 */
@property (nonatomic, copy, nullable) NSString* dn_accessibilityProgressValue;

@end

NS_ASSUME_NONNULL_END
