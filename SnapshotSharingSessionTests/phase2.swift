//
//  phase2.swift
//  SnapshotSharingSessionTests
//
//  Created by Ambar Septian on 19/02/20.
//  Copyright © 2020 Ambar Septian. All rights reserved.
//

import XCTest
@testable import SnapshotSharingSession

class CustomTableViewControllerTests2: XCTest {
    func testCustomTableViewControllerView() {
//        let viewController = CustomTableViewController()
//        assertSnapshot(matching: viewController.view)
    }
    
//    func assertSnapshot(
//      matching value: Snapshottable,
//      file: StaticString = #file,
//      function: String = #function,
//      line: UInt = #line) {
//
//      // Change to `Snapshottable`
//        let snapshot = value.snapshot
//      
//      let referenceUrl = snapshotUrl(file: file, function: function)
//        .appendingPathExtension("png")
//
//      if !record, let referenceData = try? Data(contentsOf: referenceUrl) {
//        let reference = UIImage(data: referenceData, scale: UIScreen.main.scale)!
//        guard let difference = Diff.images(reference, snapshot) else { return }
//        XCTFail("Format didn't match reference", file: file, line: line)
//        XCTContext.runActivity(named: "Attached failure diff") { activity in
//          [reference, snapshot, difference]
//            .forEach { image in activity.add(XCTAttachment(image: image)) }
//        }
//      } else {
//        try! snapshot.pngData()!.write(to: referenceUrl)
//        XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
//      }
//    }
}


//protocol Snapshottable {
//    var snapshot: UIImage { get }
//}
//
//extension UIImage: Snapshottable {
//    var snapshot: UIImage {
//        return self
//    }
//}
//
//
//extension UIView: Snapshottable {
//    var snapshot: UIImage {
//        return UIGraphicsImageRenderer(size: self.bounds.size).image { ctx in layer.render(in: ctx.cgContext) }
//    }
//}



//extension CALayer: Snapshottable {
//    var snapshot: UIImage {
//        return UIGraphicsImageRenderer(size: bounds.size)
//            .image { ctx in render(in: ctx.cgContext) }
//    }
//}
//
//
//extension UIView: Snapshottable {
//    var snapshot: UIImage {
//        return layer.snapshot
//    }
//}
//
//extension UIViewController: Snapshottable {
//    var snapshot: UIImage {
//        return view.snapshot
//    }
//}

