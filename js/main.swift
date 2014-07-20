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
    func fetch(key:NSString)->JSValue {
        return getJSVinJSC(self, key)
    }
    func store(key:NSString, _ val:AnyObject) {
        setJSVinJSC(self, key, val)
    }
    func store(key:NSString, _ blk:()->AnyObject!) {
        setB0JSVinJSC(self, key, blk)
    }
    func store(key:NSString, _ blk:(AnyObject!)->AnyObject!) {
        setB1JSVinJSC(self, key, blk)
    }
    func store(key:NSString,
        _ blk:(AnyObject!,AnyObject!)->AnyObject!) {
        setB2JSVinJSC(self, key, blk)
    }
}
ctx.store("ary", [1,2,3])
jsv = ctx.evaluateScript("bar=foo.map(function(n){return n*n})")
println(ctx.fetch("bar"))

// block w/ no argument
ctx.store("hello") { ()->AnyObject! in
    return "Hello, JS! I am Swift."
}
println(ctx.evaluateScript("hello"))
println(ctx.evaluateScript("hello()"))
// block w/ 1 argument
ctx.store("square") { (o:AnyObject!)->AnyObject! in
    if let x = o as? Double {
        return x * x
    }
    return nil
}
println(ctx.evaluateScript("square"))
println(ctx.evaluateScript("square()"))
println(ctx.evaluateScript("square(6)"))
// block w/ 2 arguments
ctx.store("multiply") { (o:AnyObject!, p:AnyObject!)->AnyObject! in
    if let x = o as? Double {
        if let y = p as? Double {
            return x * y
        }
    }
    return nil
}
println(ctx.evaluateScript("multiply"))
println(ctx.evaluateScript("multiply()"))
println(ctx.evaluateScript("multiply(6)"))
println(ctx.evaluateScript("multiply(6,7)"))
// for any more arguments, just use array instead
ctx.store("sum") { (o:AnyObject!)->AnyObject! in
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
}
println(ctx.evaluateScript("sum([0,1,2,3,4,5,6,7,8,9])"))
