//
//  UIColor+Hex.h
//  PENTA
//
//  Created by Karolis Stasaitis on 11/22/13.
//  Copyright (c) 2013 penta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (id)colorWithHex:(unsigned int)hex;
+ (id)colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

@end
