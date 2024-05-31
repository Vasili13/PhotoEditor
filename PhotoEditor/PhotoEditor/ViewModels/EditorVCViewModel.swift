//
//  EditorVCViewModel.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 31.05.24.
//

import UIKit

protocol EditorVCViewModelProtocol {
    func createCroppedImage(from view: UIView, frameView: UIView, borderWidth: CGFloat) -> UIImage
    func applyBlackAndWhiteFilter(to image: UIImage?) -> UIImage?
}

final class EditorVCViewModel: EditorVCViewModelProtocol {
    func createCroppedImage(from view: UIView, frameView: UIView, borderWidth: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: borderWidth + 2,
                                                              y: borderWidth + 2,
                                                              width: frameView.bounds.width - 2 * borderWidth,
                                                              height: frameView.bounds.height - 2 * borderWidth))
        let croppedImg = renderer.image { _ in
            view.drawHierarchy(in: CGRect(x: -frameView.frame.origin.x + borderWidth,
                                          y: -frameView.frame.origin.y + borderWidth,
                                          width: view.bounds.width,
                                          height: view.bounds.height), afterScreenUpdates: true)
        }
        return croppedImg
    }

    func applyBlackAndWhiteFilter(to image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }

        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectMono") else { return image }
        let beginImage = CIImage(image: image)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        guard let output = currentFilter.outputImage, let cgimg = context.createCGImage(output, from: output.extent) else {
            return image
        }

        return UIImage(cgImage: cgimg)
    }
}
