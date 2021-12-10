//
//  main.swift
//  TerminalWrapperMacOS
//
//  Created by mac on 7.12.21.
//

import Foundation

<<<<<<< HEAD
print("Hello, World!!")
=======
enum CommandType {
    case bash
    case shell
>>>>>>> feature/dr/wrappers

    var rawValue: String {
        switch self {
        case .bash:
            return "/bin/bash"
        case .shell:
            return "/bin/zsh"
        }
    }
}

// func that execute shell/bash commands with errors handling
func safeWrapper(_ command: String, commandType: CommandType) throws -> String {
    // Using the Process class, your program can run another program as a subprocess and can monitor that program’s execution
    let task = Process()
    let pipe = Pipe() // file handling class

    task.standardOutput = pipe // Sets the standard output for the receiver
    task.standardError = pipe // Sets the standard error for the receiver
    // - c flag - Use Cscore processing of the scorefile
    task.arguments = ["-c", command] // Sets the command arguments that should be used to launch the executable
    task.executableURL = URL(fileURLWithPath: commandType.rawValue)

    do {
        try task.run() // run shell/bash command
    } catch { throw error }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: .utf8) {
        return output
    } else {
        return "command execution failed"
    }
}

do {
    // here we call our function and put an argument with shell/bash tool type
    let output = try safeWrapper("pwd", commandType: .shell)
    // printing cmd output to xcode app console
    print(output)
} catch {
    print(error) // handle or silence the error here (may be runtime or etc)
}

do {
    // the same thing like previous function call
    let output = try safeWrapper("git describe --contains --all HEAD", commandType: .bash)
    print(output)
} catch {
    print(error)
}

var cipher: [UInt8] = []

// XOR encryption
// string parameter - string to encrypt, cipher - will contain cipher parameters
func encrypt(string: String, cipher: inout [UInt8]) -> [UInt8] {
    // converting our string to 8 bits unsigned integer array
    let text = [UInt8](string.utf8)
    // make cipher by reversing original string and converting it to 8 bits unsigned integer array
    cipher = [UInt8](string.reversed().description.utf8)
    // define array that will contain our encrypted string
    var encrypted = [UInt8]()
    for t in text.enumerated() {
        // making xor encryption
        encrypted.append(t.element ^ cipher[t.offset])
    }
    return encrypted
}

// XOR decryption
func decrypt(encrypted: [UInt8], cipher: [UInt8]) -> String? {
    // define array that will contain our decrypted data
    var decrypted = [UInt8]()
    for t in encrypted.enumerated() {
        // making xor decryption
        decrypted.append(t.element ^ cipher[t.offset])
    }
    // converting our array data with type [uint8] to string data
    return String(bytes: decrypted, encoding: .utf8)
}

// here we call function that will encrypt our cmd string command "pwd"
let encrypted = encrypt(string: "pwd", cipher: &cipher)
// print to console encrypted data
print(encrypted)
// here we call function that will decrypt our encrypted data
if let decrypted = decrypt(encrypted: encrypted, cipher: cipher) {
    // if let statements help us to understand that decryption was successful
    do {
        // call function that will execute decrypted data ("pwd")
        let output = try safeWrapper(decrypted, commandType: .shell)
        // print data to application console
        print(output)
    } catch {
        // handle or silence command execution error here
        print(error)
    }
} else {
    // handle decryption error
    print("decryption error")
}
