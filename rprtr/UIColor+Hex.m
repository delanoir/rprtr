//
//  UIColor+Hex.m
//  PENTA
//
//  Created by Karolis Stasaitis on 11/22/13.
//  Copyright (c) 2013 penta. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (id)colorWithHex:(unsigned int)hex{
	return [UIColor colorWithHex:hex alpha:1];
}

+ (id)colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha{
	
	return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
	
}

@end
