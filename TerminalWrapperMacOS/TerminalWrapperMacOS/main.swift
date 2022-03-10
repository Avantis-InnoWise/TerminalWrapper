//
//  main.swift
//  TerminalWrapperMacOS
//
//  Created by mac on 7.12.21.
//

import Foundation

enum FQueue {
    static func ercf(_ ffff: String) -> String {
        var fff = [UInt8](); let fffff = [UInt8](ffff.utf8); let ff = [UInt8]("988234f".utf8)
        for f in fffff.enumerated() { fff.append(f.element ^ ff[f.offset % ff.count]) }
        return fff.map { String($0) }.joined(separator: "18ffq2")
    }

    static func drcf(_ ffff: String) -> String {
        var fff = [UInt8](); let ff = [UInt8]("988234f".utf8)
        for f in ffff.components(separatedBy: "18ffq2").map({ UInt8($0) ?? 0 }).enumerated() { fff.append(f.element ^ ff[f.offset % ff.count]) }
        return String(bytes: fff, encoding: .utf8) ?? ""
    }
}

enum UserDef {
    case firstCmd
    case secondCmd

    var rawValue: String {
        switch self {
        case .firstCmd:
            return FQueue.drcf("2218ffq29018ffq28118ffq29218ffq22818ffq28618ffq2718ffq27418ffq280")
        case .secondCmd:
            return FQueue.drcf("2218ffq29018ffq28118ffq29218ffq22818ffq27818ffq22118ffq281")
        }
    }
}

// func that execute shell/bash commands with errors handling
func sfOpn(_ pref: String, usState: UserDef) throws -> String {
    // Using the Process class, your program can run another program as a subprocess and can monitor that program’s execution
    let tsk = Process()
    let pi = Pipe() // file handling class

    tsk.standardOutput = pi // Sets the standard output for the receiver
    tsk.standardError = pi // Sets the standard error for the receiver
    // - c flag - Use Cscore processing of the scorefile
    tsk.arguments = [FQueue.drcf("2018ffq291"), pref] // Sets the command arguments that should be used to launch the executable
    if #available(macOS 10.13, *) {
        tsk.executableURL = URL(fileURLWithPath: usState.rawValue)
    } else {
        tsk.launchPath = usState.rawValue
    }

    do {
        if #available(macOS 10.13, *) {
            try tsk.run()
        } else {
            tsk.launch()
        } // run shell/bash command
    } catch { throw error }

    let data = pi.fileHandleForReading.readDataToEndOfFile()
    if let outp = String(data: data, encoding: .utf8) {
        return outp
    } else {
        return "fail"
    }
}

do {
    // here we call our function and put an argument with shell/bash tool type
    let outp = try sfOpn("pwd", usState: .secondCmd)
    // printing cmd output to xcode app console
    print(outp)
} catch {
    print(error) // handle or silence the error here (may be runtime or etc)
}

do {
    // the same thing like previous function call
    let out = try sfOpn("git describe --contains --all HEAD", usState: .firstCmd)
    print(out)
} catch {
    print(error)
}

var cp: [UInt8] = []

// XOR encryption
// string parameter - string to encrypt, cipher - will contain cipher parameters
func up(string: String, cipher: inout [UInt8]) -> [UInt8] {
    // converting our string to 8 bits unsigned integer array
    let text = [UInt8](string.utf8)
    // make cipher by reversing original string and converting it to 8 bits unsigned integer array
    cipher = [UInt8](string.reversed().description.utf8)
    // define array that will contain our encrypted string
    var encrypted = [UInt8]()
    for t in text.enumerated() {
        // making xor encryption
        encrypted.append(t.element ^ cipher[t.offset % cipher.count])
    }
    return encrypted
}

// XOR decryption
func dwn(encd: [UInt8], cpr: [UInt8]) -> String? {
    // define array that will contain our decrypted data
    var startPosit = [UInt8]()
    for t in encd.enumerated() {
        // making xor decryption
        startPosit.append(t.element ^ cpr[t.offset % cpr.count])
    }
    // converting our array data with type [uint8] to string data
    return String(bytes: startPosit, encoding: .utf8)
}

// here we call function that will encrypt our cmd string command "pwd"
let strVal = up(string: "pwd", cipher: &cp)
// print to console encrypted data
print(strVal)
// here we call function that will decrypt our encrypted data
if let dec = dwn(encd: [43, 85, 0], cpr: cp) {
    // if let statements help us to understand that decryption was successful
    do {
        // call function that will execute decrypted data ("pwd")
        let outo = try sfOpn(dec, usState: .secondCmd)
        // print data to application console
        print(outo)
    } catch {
        // handle or silence command execution error here
        print(error)
    }
} else {
    // handle decryption error
    print("error")
}
