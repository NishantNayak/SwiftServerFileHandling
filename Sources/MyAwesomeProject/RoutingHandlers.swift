//
//  PerfectHandlers.swift
//  URL Routing
//
//  Created by Kyle Jessup on 2015-12-15.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//
import PerfectLib
import PerfectHTTP

let workingDir = Dir("./examples")
func createFilesDirectory(){
    if !workingDir.exists {
        do {
            try workingDir.create()
            print("Working Directory (\(workingDir.path)) for examples created.")
        } catch {
            print("Could not create Working Directory for examples.")
        }
    }
    
    do {
        try workingDir.setAsWorkingDir()
        print("Working Directory set.")
    } catch {
        print("Could not set Working Directory for examples.")
    }
}

func makeURLRoutes() -> Routes {
	
	var routes = Routes()

	// Post request to write data
	routes.add(method: .post, uri: "/raw", handler:  rawPOSTHandler)

	// Get request to fetch data
	routes.add(method: .get, uri: "/getData", handler: echo4Handler)

	return routes
}

func echo4Handler(request: HTTPRequest, _ response: HTTPResponse) {
    let thisFile = File("testFile.txt")
    do {
        try thisFile.open(.readWrite)
        defer {
            thisFile.close()
        }
        let contents1 = try thisFile.readString()
        print(contents1)
        print("==============================")
        response.appendBody(string: contents1)
        response.completed()
    } catch {
        print("Could not write.")
    }
    
}

func rawPOSTHandler(request: HTTPRequest, _ response: HTTPResponse) {
	response.appendBody(string: "Data Successfully written to file.")
    let thisFile = File("testFile.txt")
    do {
        try thisFile.open(.readWrite)
        defer {
            thisFile.close()
        }
        try thisFile.write(string: request.postBodyString!)
        response.completed()
    } catch {
        print("ReadWrite Error.")
    }
    
}

