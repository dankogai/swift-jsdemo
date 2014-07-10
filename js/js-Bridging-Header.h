//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
#import <JavaScriptCore/JavaScriptCore.h>
JSValue *getJSVinJSC(JSContext *ctx, NSString *key);
void setJSVinJSC(JSContext *ctx, NSString *key, id val);
void setB0JSVinJSC(JSContext *ctx, NSString *key,id(^block)());
void setB1JSVinJSC(JSContext *ctx, NSString *key,id(^block)(id));
void setB2JSVinJSC(JSContext *ctx, NSString *key,id(^block)(id,id));
