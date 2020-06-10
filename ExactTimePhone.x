@interface UIDateLabel : UILabel
@property (nonatomic, strong) NSDate *date;
@end

@interface MPRecentsTableViewCell
@property (nonatomic, strong) UIDateLabel *callerDateLabel;
@end

static bool is24h;
static NSString *settingsPath = @"/var/mobile/Library/Preferences/com.gilshahar7.exacttimeprefs.plist";
static bool enabled;

%hook MPRecentsTableViewCell
-(void)layoutSubviews{
	%orig;
	if(enabled){
		if(![self.callerDateLabel.text containsString:@":"]){
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		if(is24h){
			[dateFormatter setDateFormat:@"\nHH:mm"];
		}else{
			[dateFormatter setDateFormat:@"\nh:mm a"];
		}

		self.callerDateLabel.textAlignment = 2;
		self.callerDateLabel.numberOfLines = 2;
		self.callerDateLabel.text = [self.callerDateLabel.text stringByAppendingString:[dateFormatter stringFromDate:self.callerDateLabel.date]];
		}
	}
}
%end

%ctor{

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
	enabled =  [[prefs objectForKey:@"phone"] boolValue];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [formatter stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
	is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
}
