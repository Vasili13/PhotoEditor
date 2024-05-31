//
//  EditorViewController.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 29.05.24.
//

import UIKit

final class EditorViewController: UIViewController {
    
    //MARK: - Variables
    private var viewModel: EditorVCViewModelProtocol = EditorVCViewModel()
    
    private var originalImage: UIImage?
    
    private var initialTransform: CGAffineTransform = .identity
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .default)
        let largeImage = UIImage(systemName: "photo.badge.plus", withConfiguration: largeConfig)
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        return button
    }()
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var frameView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var filterSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Original", "Black & White"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        return control
    }()
    
    private var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()

    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBlurEffect()
    }
    
    //MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(frameView)
        frameView.addSubview(photoImageView)
        view.addSubview(addPhotoButton)
        view.addSubview(blurEffectView)
        view.addSubview(filterSegmentedControl)
        setupNavBar()
        setupImageView()
        hideUIElements()
    }
    
    private func setupNavBar() {
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(saveImage))
        navigationItem.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(cancelEditing))
        navigationItem.leftBarButtonItem = cancelButton
        addGestureToImageView()
        navigationController?.navigationBar.barTintColor = .brown
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = CustomColors.lightBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    private func addGestureToImageView() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation))
        photoImageView.addGestureRecognizer(pinchGesture)
        photoImageView.addGestureRecognizer(panGesture)
        photoImageView.addGestureRecognizer(rotationGesture)
    }
    
    private func showAlertSavedPhoto() {
        let alert = UIAlertController(title: "Успешно!",
                                      message: "Фото успешно сохранено",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", 
                                      style: .default,
                                      handler: nil))
        cancelEditing()
        present(alert, 
                animated: true,
                completion: nil)
    }
    
    private func showAlertNoPhotoSelected() {
        let alert = UIAlertController(title: "Ошибка :(",
                                      message: "Фото не выбрано",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", 
                                      style: .default,
                                      handler: nil))
        present(alert, 
                animated: true,
                completion: nil)
    }
    
    private func hideUIElements() {
        blurEffectView.isHidden = true
        frameView.isHidden = true
        photoImageView.isHidden = true
        filterSegmentedControl.isHidden = true
    }
    
    private func showUIElements() {
        blurEffectView.isHidden = false
        frameView.isHidden = false
        photoImageView.isHidden = false
        filterSegmentedControl.isHidden = false
    }
    
    private func updateBlurEffect() {
        blurEffectView.frame = view.bounds
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.frame = blurEffectView.bounds
        let maskRect = UIBezierPath(rect: blurEffectView.bounds)
        let holeRect = frameView.frame
        let holePath = UIBezierPath(rect: holeRect)
        maskRect.append(holePath)
        maskLayer.path = maskRect.cgPath
        
        blurEffectView.layer.mask = maskLayer
        blurEffectView.isUserInteractionEnabled = false
    }
    
    private func setupImageView() {
        initialTransform = photoImageView.transform
    }

    // MARK: - @objc Methods
    @objc private func cancelEditing() {
        photoImageView.image = nil
        addPhotoButton.isHidden = false
        photoImageView.transform = initialTransform
        setupImageView()
        hideUIElements()
    }
    
    @objc private func openImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view {
            view.transform = view.transform.scaledBy(x: gesture.scale, 
                                                     y: gesture.scale)
            gesture.scale = 1
        }
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: frameView)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, 
                                  y: view.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, 
                                   in: frameView)
        }
    }
    
    @objc func handleRotation(gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            //applies Black/White filter to photo
            photoImageView.image = viewModel.applyBlackAndWhiteFilter(to: originalImage)
        default:
            photoImageView.image = originalImage
        }
    }
    
    @objc private func saveImage() {
        if photoImageView.isHidden == false {
            let borderWidth: CGFloat = 2
            //save Image to galary
            let croppedImg = viewModel.createCroppedImage(from: view, frameView: frameView, borderWidth: borderWidth)
            UIImageWriteToSavedPhotosAlbum(croppedImg, nil, nil, nil)
            photoImageView.transform = initialTransform
            showAlertSavedPhoto()
            setupImageView()
        } else {
            showAlertNoPhotoSelected()
        }
    }
    
    //MARK: - Contraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        addPhotoButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        frameView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        filterSegmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(60)
        }
    }
}

//MARK: - Extension ImagePicker
extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            originalImage = selectedImage
            photoImageView.image = originalImage
        }
        addPhotoButton.isHidden = true
        showUIElements()
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        addPhotoButton.isHidden = false
        hideUIElements()
        picker.dismiss(animated: true, completion: nil)
    }
}
