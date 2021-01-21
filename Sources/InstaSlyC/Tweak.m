#import <Orion/Orion.h>

static id observer;

__attribute__((constructor)) static void init() {
    NSBundle *bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] bundlePath], @"/Frameworks/InstagramAppCoreFramework.framework"]];
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSBundleDidLoadNotification object:bundle queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        orion_init();
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    [bundle load];
}
