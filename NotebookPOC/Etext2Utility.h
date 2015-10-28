//
//  Etext2Utility.h
//  NotebookPOC
//
//  Created by Mason, Darren J on 10/21/15.
//  Copyright (c) 2015 Mason, Darren J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Etext2Utility : NSObject
/**
 *  This strips out any blank spaces and /n returns
 *
 *  @param dirtyString
 *
 *  @return
 */
+(NSString*)stripOutwhiteSpace:(NSString*)dirtyString;
/**
 *  This formates text with <b> <i> and <u> tags into formated text
 *
 *  @param htmlString
 *
 *  @return
 */
+(NSAttributedString *)formatHTMLString:(NSString*)htmlString;

/**
 *  This removes any HTML tags in an Attributted String
 *
 *  @param htmlString
 *
 *  @return     
 */
+(NSAttributedString *)stringByStrippingHTML:(NSAttributedString*)htmlString;






+(void)setUpButtonUnSelectedStyle:(UIButton*)currentButton;
+(void)setUpButtonSelectedStyle:(UIButton*)currentButton;
@end
