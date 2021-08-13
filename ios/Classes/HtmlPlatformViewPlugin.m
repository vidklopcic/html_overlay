#import "HtmlPlatformViewPlugin.h"
#if __has_include(<html_overlay/html_overlay-Swift.h>)
#import <html_overlay/html_overlay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "html_overlay-Swift.h"
#endif

@implementation HtmlPlatformViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHtmlPlatformViewPlugin registerWithRegistrar:registrar];
}
@end
