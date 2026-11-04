#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <substrate.h>

// ฮุค AVPlayer เร่งความเร็ววิดีโอ 20 เท่า
%hook AVPlayer

- (void)setRate:(float)rate {
    if (rate > 0.0f) {
        %orig(20.0f);
    } else {
        %orig(rate);
    }
}

- (void)play {
    %orig;
    [self setRate:20.0f];
}

%end

// ฮุค WKWebView เร่งความเร็วโฆษณา HTML5
%hook WKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    if (configuration) {
        WKUserContentController *ucc = configuration.userContentController;
        if (!ucc) {
            ucc = [[WKUserContentController alloc] init];
            configuration.userContentController = ucc;
        }
        
        NSString *speedHackJS = @"setInterval(function(){ "
                                 "  var vids = document.querySelectorAll('video'); "
                                 "  vids.forEach(function(v) { "
                                 "    if (v.playbackRate !== 20.0) { v.playbackRate = 20.0; } "
                                 "  }); "
                                 "}, 500);";
                                 
        WKUserScript *script = [[WKUserScript alloc] initWithSource:speedHackJS 
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentEnd 
                                                   forMainFrameOnly:NO];
        [ucc addUserScript:script];
    }
    return %orig(frame, configuration);
}

%end
