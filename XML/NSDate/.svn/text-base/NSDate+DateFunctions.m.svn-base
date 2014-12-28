//
//  NSDate+DateFunctions.m
//  JhonSell
//
//  Created by Mario Montoya on 22/01/09.
//  Copyright 2009 El malabarista. All rights reserved.
//

#import "NSDate+DateFunctions.h"

@implementation NSDate (DateFunctions)

+ (NSDate *)dateFromISOString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

    NSDate *date = [dateFormatter dateFromString:dateStr];
    [locale release], locale = nil;
    [dateFormatter release], dateFormatter = nil;
    return date;
}

- (NSString *)formatAsISODate {
    NSDateComponents *dateComp;
    NSCalendar *cal = [NSCalendar currentCalendar];

    dateComp = [cal
            components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                    | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
              fromDate:self];

    return [NSString stringWithFormat:@"%02zd-%02zd-%02zdT%02zd:%02zd:%02zd", dateComp.year,
                                      dateComp.month, dateComp.day, dateComp.hour, dateComp.minute, dateComp.second];
}

- (NSString *)formatAsString {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)addDays:(NSInteger)numDays {
    NSDate *now = self;

    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:numDays];

    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDate *newDate2 = [gregorian dateByAddingComponents:components toDate:now options:0];
    [components release], components = nil;
    [gregorian release], gregorian = nil;

    return newDate2;
}

+ (NSInteger)daysBetweenDates:(NSDate *)fromDate ToDate:(NSDate *)toDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger days = 0;

    NSDateComponents *components = [gregorian components:NSDayCalendarUnit
                                                fromDate:fromDate
                                                  toDate:toDate options:0];

    days = [components day];

    [gregorian release], gregorian = nil;

    return days;
}

+ (NSDate *)addMonths:(NSDate *)toDate Months:(NSInteger)months {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = months;
    NSDate *nextMonth = [gregorian dateByAddingComponents:components toDate:toDate options:0];
    [components release];
    [gregorian release], gregorian = nil;
    return nextMonth;
}

+ (NSDate *)dateFromString:(NSString *)strDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    [dateFormatter release], dateFormatter = nil;
    return date;
}

+ (NSDate *)dateWithString:(NSString *)strDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    [dateFormatter release];
    return date;
}

- (NSDate *)addMonths:(NSInteger)months {
    return [NSDate addMonths:self Months:months];
}
@end
