//IOS 10
@interface NCNotificationDateLabel
@property (assign,nonatomic) NSString *text;
-(void)sizeToFit;
@end
//IOS 10
@interface NCLookHeaderContentView
-(void)_updateDateLabelFontForShortLook;
@end
//IOS 11
@interface BSUIRelativeDateLabel
@property (assign,nonatomic) NSString *text;
-(void)sizeToFit;
@end
//IOS 11
@interface MTPlatterHeaderContentView
-(void)_updateTextAttributesForDateLabel;
@end


static bool is24h;
static NSString *settingsPath = @"/var/mobile/Library/Preferences/com.gilshahar7.exacttimeprefs.plist";

%group iOS10
    %hook NCLookHeaderContentView
    -(void)_updateDateLabelFontForShortLook{
        %orig;
        NSDate *date = MSHookIvar<NSDate *>(self, "_date");
        NSInteger format = MSHookIvar<NSInteger >(self, "_dateFormatStyle");
        NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
        CGFloat affectTime = [[prefs objectForKey:@"affectTime"] floatValue];
        if((date != nil) && (format == 1)){
            NCNotificationDateLabel *dateLabel = MSHookIvar<NCNotificationDateLabel *>(self, "_dateLabel");
            int timeSinceNow = (int)[date timeIntervalSinceNow];
            timeSinceNow = timeSinceNow*-1;
            bool addMinutes =  [[prefs objectForKey:@"addMinutes"] boolValue];
            bool addToCurrent =  [[prefs objectForKey:@"addToCurrent"] boolValue];
            int hours = timeSinceNow / 3600;
            int minutes = (timeSinceNow % 3600) / 60;
            if(addMinutes){
                if(hours == 0){
                    if(minutes == 0){
                    }else{
                        dateLabel.text = [NSString stringWithFormat:@"%im ago", minutes];
                    }
                }else{
                    if(minutes == 0){
                        dateLabel.text = [NSString stringWithFormat:@"%ih ago", hours];
                    } else{
                        dateLabel.text = [NSString stringWithFormat:@"%ih %im ago", hours, minutes];
                    }
                }
            }else if(addToCurrent){
                if(hours == 0){
                    if(minutes == 0){
                    }else{
                        dateLabel.text = [NSString stringWithFormat:@"%im ago", minutes];
                    }
                }else{
                    dateLabel.text = [NSString stringWithFormat:@"%ih ago", hours];
                }
            }
            if((timeSinceNow/60) >= affectTime){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                if(is24h){
                    [dateFormatter setDateFormat:@"HH:mm"];
                }else{
                    [dateFormatter setDateFormat:@"h:mm a"];
                }
                if(addToCurrent && !([dateLabel.text isEqualToString:[dateFormatter stringFromDate:date]])){
                    dateLabel.text = [[dateLabel.text stringByAppendingString:@" • "] stringByAppendingString:[dateFormatter stringFromDate:date]];
                }else{
                    dateLabel.text =[dateFormatter stringFromDate:date];
                }
                [dateLabel sizeToFit];
                [dateFormatter release];
            }
        }
    }
    -(void)dateLabelDidChange:(id)arg1{
        %orig(arg1);
        [self _updateDateLabelFontForShortLook];
    }
    %end
%end

%group iOS11
    %hook MTPlatterHeaderContentView
    -(void)_updateTextAttributesForDateLabel{
        %orig;
        NSDate *date = MSHookIvar<NSDate *>(self, "_date");
        NSInteger format = MSHookIvar<NSInteger >(self, "_dateFormatStyle");
        NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
        CGFloat affectTime = [[prefs objectForKey:@"affectTime"] floatValue];
        if((date != nil) && (format == 1)){
            BSUIRelativeDateLabel *dateLabel = MSHookIvar<BSUIRelativeDateLabel *>(self, "_dateLabel");
            int timeSinceNow = (int)[date timeIntervalSinceNow];
            timeSinceNow = timeSinceNow*-1;
            bool addMinutes =  [[prefs objectForKey:@"addMinutes"] boolValue];
            bool addToCurrent =  [[prefs objectForKey:@"addToCurrent"] boolValue];
            int hours = timeSinceNow / 3600;
            int minutes = (timeSinceNow % 3600) / 60;
            if(addMinutes){
                if(hours == 0){
                    if(minutes == 0){
                    }else{
                        dateLabel.text = [NSString stringWithFormat:@"%im ago", minutes];
                    }
                }else{
                    if(minutes == 0){
                        dateLabel.text = [NSString stringWithFormat:@"%ih ago", hours];
                    } else{
                        dateLabel.text = [NSString stringWithFormat:@"%ih %im ago", hours, minutes];
                    }
                }
            }else if(addToCurrent){
                if(hours == 0){
                    if(minutes == 0){
                    }else{
                        dateLabel.text = [NSString stringWithFormat:@"%im ago", minutes];
                    }
                }else{
                    dateLabel.text = [NSString stringWithFormat:@"%ih ago", hours];
                }
            }
            if((timeSinceNow/60) >= affectTime){
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                if(is24h){
                    [dateFormatter setDateFormat:@"HH:mm"];
                }else{
                    [dateFormatter setDateFormat:@"h:mm a"];
                }
                if(addToCurrent && !([dateLabel.text isEqualToString:[dateFormatter stringFromDate:date]])){
                    dateLabel.text = [[dateLabel.text stringByAppendingString:@" • "] stringByAppendingString:[dateFormatter stringFromDate:date]];
                }else{
                    dateLabel.text =[dateFormatter stringFromDate:date];
                }
                [dateLabel sizeToFit];
                [dateFormatter release];
            }
        }
    }
    -(void)dateLabelDidChange:(id)arg1{
        %orig(arg1);
        [self _updateTextAttributesForDateLabel];
    }
    %end
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0) {
        %init(iOS10);
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 12.0) {
        %init(iOS11);
    }
}
