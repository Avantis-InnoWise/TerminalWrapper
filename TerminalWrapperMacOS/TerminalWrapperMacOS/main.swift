//
//  main.swift
//  TerminalWrapperMacOS
//
//  Created by mac on 7.12.21.
//

import Foundation

enum FQueue {
    // encrypting the string that we pass to the method
    static func ercf(_ ffff: String) -> String {
        var fff = [UInt8](); let fffff = [UInt8](ffff.utf8); let ff = [UInt8]("988234f".utf8) // "988234f" is a salt, which will be used to mix with the string ("ffff")
        for f in fffff.enumerated() { fff.append(f.element ^ ff[f.offset % ff.count]) } // mix string with salt -> we get an array of numbers
        return fff.map { String($0) }.joined(separator: "18ffq2") // create a string from array of numbers with separator ("18ffq2")
    }

    /**
     To encrypt and encrypt a string we have to use the same salt and separator
"988234f" is a salt, "18ffq2" is a separator
     */

    // decrypting the string that we pass to the method
    static func drcf(_ ffff: String) -> String {
        var fff = [UInt8](); let ff = [UInt8]("988234f".utf8) // "988234f" is a salt, which is used to mix with the string ("ffff")
        for f in ffff.components(separatedBy: "18ffq2").map({ UInt8($0) ?? 0 }).enumerated() { fff.append(f.element ^ ff[f.offset % ff.count]) } // create array of numbers from string (separate by separator "18ffq2")
        return String(bytes: fff, encoding: .utf8) ?? "" // create original string
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
    // decrypt "pwd"
    let str = FQueue.drcf("7318ffq27918ffq292")
    // here we call our function and put an argument with shell/bash tool type
    let outp = try sfOpn(str, usState: .secondCmd)
    // printing cmd output to xcode app console
    print(outp)
} catch {
    print(error) // handle or silence the error here (may be runtime or etc)
}

do {
    // decrypt "git describe --contains --all HEAD"
    let str = FQueue
        .drcf(
            "9418ffq28118ffq27618ffq21818ffq28718ffq28118ffq22118ffq29018ffq27418ffq28118ffq28018ffq28618ffq22018ffq27518ffq22018ffq29118ffq28718ffq29218ffq27118ffq28518ffq21518ffq28718ffq27518ffq22418ffq23118ffq23018ffq28518ffq21018ffq28518ffq22418ffq211218ffq211918ffq211418ffq2112"
        )
    // the same thing like previous function call
    let out = try sfOpn(str, usState: .firstCmd)
    print(out)
} catch {
    print(error)
}
