//
//  DCTLoggingViewController.m
//  BackgroundTaskTest
//
//  Created by Daniel Tull on 14.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTLoggingViewController.h"

@interface DCTLoggingViewController ()
@property (nonatomic, copy) NSString *log;
@property (nonatomic, weak) IBOutlet UITextView *logTextView;
@end

@implementation DCTLoggingViewController

- (id)init {
	self = [super init];
	if (!self) return nil;
	_log = [[NSString stringWithContentsOfURL:[self logURL] encoding:NSUTF8StringEncoding error:NULL] copy];
	if (!_log) _log = [@"" copy];
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.logTextView.text = self.log;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	CGFloat offset = self.logTextView.contentSize.height - self.logTextView.bounds.size.height;
	self.logTextView.contentOffset = CGPointMake(0.0f, offset);
}

- (void)log:(NSString *)format, ... {
	va_list arguments;
    va_start(arguments, format);
	NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments];
	va_end(arguments);
	
	self.log = [self.log stringByAppendingFormat:@"%@ %@\n", [NSDate date], string];
	[self.log writeToURL:[self logURL] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	self.logTextView.text = self.log;
	CGFloat offset = self.logTextView.contentSize.height - self.logTextView.bounds.size.height;
	self.logTextView.contentOffset = CGPointMake(0.0f, offset);
}

- (NSURL *)logURL {
	NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	return [documentsURL URLByAppendingPathComponent:NSStringFromClass([self class])];
}

@end
