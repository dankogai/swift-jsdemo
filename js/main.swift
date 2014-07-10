//
//  main.swift
//  js
//
//  Created by Dan Kogai on 6/16/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

import JavaScriptCore
let ctx = JSContext()
let ary = [0, 1, 2, 3]
var jsv = ctx.evaluateScript(
    "\(ary).map(function(n){return n*n})"
)
println(jsv)
var a = jsv.toArray()
println(a)
jsv = ctx.evaluateScript("nonsense * nonsense")
println(jsv)
jsv = ctx.evaluateScript("this")
println(jsv)

extension JSContext {
    func get(key:NSString) -> JSValue {
        return getJSVinJSC(self, key)
    }
    func set(key:NSString, _ val:AnyObject) {
        setJSVinJSC(self, key, val)
    }
    func set(key:NSString, _ blk:(()->AnyObject!)?) {
        setB0JSVinJSC(self, key, blk)
    }
    func set(key:NSString, _ blk:((AnyObject!)->AnyObject!)?) {
        setB1JSVinJSC(self, key, blk)
    }
    func set(key:NSString, _ blk:((AnyObject!,AnyObject!)->AnyObject!)?) {
        setB2JSVinJSC(self, key, blk)
    }
}
ctx.set("ary", [1,2,3])
jsv = ctx.evaluateScript("bar = foo.map(function(n){return n*n})")
println(ctx.get("bar"))

ctx.set("square", { (o:AnyObject!)->AnyObject! in
    if let x = o as? Double {
        return x * x
    }
    return nil
})
println(ctx.evaluateScript("square"))
println(ctx.evaluateScript("square()"))
println(ctx.evaluateScript("square(6)"))
ctx.set("multiply", { (o:AnyObject!, p:AnyObject!)->AnyObject! in
    if let x = o as? Double {
        if let y = p as? Double {
            return x * y
        }
    }
    return nil
})
println(ctx.evaluateScript("multiply"))
println(ctx.evaluateScript("multiply()"))
println(ctx.evaluateScript("multiply(6)"))
println(ctx.evaluateScript("multiply(6,7)"))
ctx.set("sum", { (o:AnyObject!)->AnyObject! in
    if let a = o as? NSArray {
        var result = 0.0
        for v in a {
            if let n = v as? Double {
                result += n
            } else {
                return nil
            }
        }
        return result
    }
    return nil
})
println(ctx.evaluateScript("sum([0,1,2,3,4,5,6,7,8,9])"))
