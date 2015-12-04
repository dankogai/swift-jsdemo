//
//  main.swift
//  js
//
//  Created by Dan Kogai on 6/16/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//
//  Swift 1.2 or better required

import JavaScriptCore

let ctx = JSContext()
let ary = [0, 1, 2, 3]
var jsv = ctx.evaluateScript(
    "\(ary).map(function(n){return n*n})"
)

print(jsv)
var a = jsv.toArray()
print(a)
jsv = ctx.evaluateScript("nonsense * nonsense")
print(jsv)
jsv = ctx.evaluateScript("this")
print(jsv)

typealias ID = AnyObject!

extension JSContext {
    func fetch(key:String)->JSValue {
        return getJSVinJSC(self, key)
    }
    func store(key:String, _ val:ID) {
        setJSVinJSC(self, key, val)
    }
    // Yikes.  Swift 1.2 and its JavaScriptCore no longer allows method overloding by type
    func setb0(key:String, _ blk:()->ID) {
        setB0JSVinJSC(self, key, blk)
    }
    func setb1(key:String, _ blk:(ID)->ID) {
        setB1JSVinJSC(self, key, blk)
    }
    func setb2(key:String, _ blk:(ID,ID)->ID) {
        setB2JSVinJSC(self, key, blk)
    }
}

ctx.store("ary", [0,1,2,3])
print(ctx.fetch("ary"))
jsv = ctx.evaluateScript("ary2=ary.map(function(n){return n*n})")
print(ctx.fetch("ary2"))

// block w/ no argument
ctx.setb0("hello") { ()->ID in
    return "Hello, JS! I am Swift."
}
print(ctx.evaluateScript("hello"))
print(ctx.evaluateScript("hello()"))

// block w/ 1 argument
ctx.setb1("square") { (o:ID)->ID in
    if let x = o as? Double {
        return x * x
    }
    return nil
}
print(ctx.evaluateScript("square"))
print(ctx.evaluateScript("square()"))
print(ctx.evaluateScript("square(6)"))
// block w/ 2 arguments
ctx.setb2("multiply") { (o:ID, p:ID)->ID in
    if let x = o as? Double {
        if let y = p as? Double {
            return x * y
        }
    }
    return nil
}
print(ctx.evaluateScript("multiply"))
print(ctx.evaluateScript("multiply()"))
print(ctx.evaluateScript("multiply(6)"))
print(ctx.evaluateScript("multiply(6,7)"))
// for any more arguments, just use array instead
ctx.setb1("sum") { (o:ID)->ID in
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
print(ctx.evaluateScript("sum([0,1,2,3,4,5,6,7,8,9,10])"))
