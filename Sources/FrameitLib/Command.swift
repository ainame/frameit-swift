import ArgumentParser
import Foundation
import enum SwiftUI.LayoutDirection

public struct Command<HeroView: AppScreenshotView,
                      View: AppScreenshotView,
                      LayoutOption: LayoutConfigurationProviderOption>: ParsableCommand {

    public static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "frameit")
    }

    @Option(name: .shortAndLong,
            help: "\(LayoutOption.allCases.map({ "\"\($0.rawValue)\"" }).joined(separator: ", "))",
            completion: .list(LayoutOption.allCases.map(\.rawValue)))
    var layout: LayoutOption

    @Option(name: .shortAndLong, help: "A string to be shown with bold font")
    var keyword: String

    @Option(name: .shortAndLong, help: "A string to be shown with regular font")
    var title: String

    @Option(name: .shortAndLong,
            help: "An absolute or relative path to the image to be shown as background",
            completion: .file())
    var backgroundImage: String?


    @Option(name: .shortAndLong,
            help: """
An absolute or relative path to the image to be shown as the device frame. Download them by 'fastlane frameit download_frames')
""",
            completion: .file())
    var deviceFrame: String

    @Option(name: .shortAndLong, help: "An absolute or relative path to output", completion: .file())
    var output: String

    @Flag(name: .long,
          help: "To choose hero screenshot view pass this flag.")
    var isHero: Bool = false

    @Flag(name: .long, help: "If tehe target is RLT language, then add this")
    var isRTL: Bool = false

    @Option(name: .shortAndLong,
            help: "An absolute or relative path to the image to be shown as the embeded screenshot within a device frame",
            completion: .file())
    var screenshots: [String] = []

    public init() {}

    public mutating func run() throws {
        let configuraion = Configuration(
            outputPath: output,
            keyword: keyword,
            title: title,
            backgroundImage: backgroundImage,
            screenshots: screenshots,
            deviceFrame: deviceFrame,
            layoutDirection: isRTL ? .rightToLeft : .leftToRight
        )

        Frameit.run(
            viewType: isHero ? HeroView.self as! View.Type : View.self,
            layout: layout.value,
            with: configuraion
        )
    }
}
