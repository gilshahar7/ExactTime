@interface NCNotificationDateLabel
@property (assign,nonatomic) NSString *text;
-(void)sizeToFit;
@end

@interface NCLookHeaderContentView
-(void)_updateDateLabelFontForShortLook;
@end

static bool is24h;

%hook NCLookHeaderContentView
-(void)_updateDateLabelFontForShortLook{
	%orig;
	NSDate *date = MSHookIvar<NSDate *>(self, "_date");
	NSInteger format = MSHookIvar<NSInteger >(self, "_dateFormatStyle");
	if((date != nil) && (format == 1)){
		NCNotificationDateLabel *dateLabel = MSHookIvar<NCNotificationDateLabel *>(self, "_dateLabel");
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		if(is24h)
		{
			[dateFormatter setDateFormat:@"HH:mm"];
		}else{
			[dateFormatter setDateFormat:@"hh:mm a"];
		}
		dateLabel.text = [dateFormatter stringFromDate:date];
		[dateLabel sizeToFit];		
		[dateFormatter release];
	}
}
-(void)dateLabelDidChange:(id)arg1{
	%orig(arg1);
	[self _updateDateLabelFontForShortLook];
}
%end

%ctor{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [formatter stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
	is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
	[formatter release];
}