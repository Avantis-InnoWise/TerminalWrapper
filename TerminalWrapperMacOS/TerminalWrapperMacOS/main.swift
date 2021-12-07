//
//  main.swift
//  TerminalWrapperMacOS
//
//  Created by mac on 7.12.21.
//

import Foundation

enum CommandType {
    case bash
    case shell

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
    let output = String(data: data, encoding: .utf8)!

    return output
}

do {
    // here we call our function and put an argument
    let output = try safeWrapper("pwd", commandType: .shell)
    print(output)
} catch {
    print(error) // handle or silence the error here (may be runtime or etc)
}

do {
    let output = try safeWrapper("git describe --contains --all HEAD", commandType: .bash)
    print(output)
} catch {
    print(error)
}
