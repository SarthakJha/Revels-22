
//  SignUpViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit


struct RegisterResponse: Decodable{
    let success: Bool
    let msg: String
}
struct LeaveResponse: Decodable{
    let succes: Bool
    let msg: String
}


class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    var loginViewController: LoginViewController?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Revels-Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var phoneField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var collegeField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var driveField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var stateField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var registerButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Register", for: UIControl.State())
        button.backgroundColor = UIColor(red: 183.0/255.0, green: 130.0/255.0, blue: 239.0/255.0, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var guestButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Continue as Guest", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.CustomColors.Purple.logoLightPink, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var driveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Note: Enter publicly shareable google drive link with college ID uploaded for verification"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
    
   
    var collegeSearchearchController = collegeSearchTableViewController()
    var searchController = UISearchController()
    var stateSearchController = StateTableViewController()
//    let navController = UINavigationController(rootViewController: stateSearchController)
    
    var colleges = [String]()
    var maheColleges = [String]()
    var filteredColleges = [String]()

    // MARK: - Table view data source
    func setupColleges(){
//        let apiStruct = ApiStruct(url: collegeDataURL, method: .get, body: nil)
//        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (map: collegeDataResponse) in
//            if map.success{
//                for i in map.data{
//                    self.colleges.append(i.name)
//                    if(i.MAHE == 1)
//                    {
//                        self.maheColleges.append(i.name)
//                    }
//                }
//                self.colleges.sort()
//                self.maheColleges.sort()
//                self.filteredColleges = self.colleges
//            }
//        }) { (error) in
//            print(error)
//        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == collegeField {
//            hideKeyboard()
//            collegeSearchearchController.collegeDelegate = self
//            collegeSearchearchController.colleges = self.colleges
//            collegeSearchearchController.maheColleges = self.maheColleges
//            collegeSearchearchController.filteredColleges = self.filteredColleges
//            searchController = UISearchController(searchResultsController: collegeSearchearchController)
//            searchController.searchResultsUpdater = collegeSearchearchController
//            searchController.searchBar.barStyle = .blackTranslucent
//            searchController.searchBar.backgroundImage = UIImage.init(color: .clear)
//            searchController.searchBar.barTintColor = .black
//            searchController.dimsBackgroundDuringPresentation = false
//            searchController.hidesNavigationBarDuringPresentation = false
//
//            present(searchController, animated: true, completion: nil)
//            searchController.searchResultsController?.view.isHidden = false
//            return false
//        }
        
        if textField == stateField{
            hideKeyboard()
            stateSearchController.stateDelegate = self
            present(stateSearchController, animated: true, completion: nil)
//            searchController.searchResultsController?.view.isHidden = false
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.CustomColors.Black.background
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        observeKeyboardNotifications()
        setupViews()
//        setupColleges()
    }
    
    func setupViews(){
        //Make the bordercolor changes here for the registration page
        //The logo looks blurry , get a high quality image to replace it
        nameField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Purple.logoLightPink,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        nameField.keyboardType = .default
        nameField.autocorrectionType = .no
        nameField.clipsToBounds = true
        nameField.delegate = self
        nameField.tag = 0
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        emailField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Purple.logoLightPink,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        emailField.keyboardType = .emailAddress
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.clipsToBounds = true
        emailField.delegate = self
        emailField.tag = 1
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        passwordField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Purple.logoLightPink,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        passwordField.keyboardType = .emailAddress
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.clipsToBounds = true
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        passwordField.tag = 2
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        phoneField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Purple.logoLightPink,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        phoneField.keyboardType = .phonePad
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.clipsToBounds = true
        phoneField.delegate = self
        phoneField.tag = 3
        phoneField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        collegeField.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Purple.logoLightPink,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        collegeField.keyboardType = .default
        collegeField.autocorrectionType = .no
        collegeField.clipsToBounds = true
        collegeField.delegate = self
        collegeField.tag = 4
        collegeField.attributedPlaceholder = NSAttributedString(string: "College Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        stateField.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Purple.logoLightPink,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        stateField.keyboardType = .default
        stateField.autocorrectionType = .no
        stateField.clipsToBounds = true
        stateField.delegate = self
        stateField.tag = 5
        stateField.attributedPlaceholder = NSAttributedString(string: "Enter your home state", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        driveField.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Purple.logoLightPink,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        driveField.keyboardType = .default
        driveField.autocorrectionType = .no
        driveField.clipsToBounds = true
        driveField.delegate = self
        driveField.tag = 6
        driveField.attributedPlaceholder = NSAttributedString(string: "Enter drive link for ID", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        
        
        if isSmalliPhone(){
//            view.addSubview(logoImageView)
//            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 70, heightConstant: 70)
            driveLabel.font = UIFont.systemFont(ofSize: 13)
            view.addSubview(nameField)
            _ = nameField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 70, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            view.addSubview(emailField)
            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(passwordField)
            _ = passwordField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
//
            view.addSubview(phoneField)
            _ = phoneField.anchor(top: passwordField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(collegeField)
            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(stateField)
            _ = stateField.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(driveField)
            _ = driveField.anchor(top: stateField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(driveLabel)
            _ = driveLabel.anchor(top: driveField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
            
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
            
            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 8, rightConstant: 32, widthConstant: 0, heightConstant: 40)
            
        }else{
            view.addSubview(logoImageView)
            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 100, heightConstant: 100)
            view.addSubview(nameField)
            _ = nameField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 48, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(emailField)
            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(passwordField)
            _ = passwordField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)

            
            view.addSubview(phoneField)
            _ = phoneField.anchor(top: passwordField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(collegeField)
            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(stateField)
            _ = stateField.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(driveField)
            _ = driveField.anchor(top: stateField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(driveLabel)
            _ = driveLabel.anchor(top: driveField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 0, rightConstant: 16,heightConstant: 0)
            
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
            
            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 50)
            
        }
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.logoImageView.alpha = 1
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            var y: CGFloat = -90
            if self.isSmalliPhone(){
                y = -50
            }
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            self.logoImageView.alpha = 0
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        switch textField.tag {
        case 0:
            emailField.becomeFirstResponder()
            break
        case 1:
            passwordField.becomeFirstResponder()
            break
        case 2:
            phoneField.becomeFirstResponder()
            
            break
        case 3:
            collegeField.becomeFirstResponder()
            break
        case 4:
            //Made changes here
            stateField.becomeFirstResponder()
            break
        case 5:
            driveField.becomeFirstResponder()
            break
        case 6:
        hideKeyboard()
        default: break
        }
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true)
    }
    
    @objc func handleRegister(){
        guard let name = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else {return}
        guard let phone = phoneField.text else { return }
        guard let college = collegeField.text else { return }
        guard let state = stateField.text else {return}
        guard let dlink = driveField.text else { return }
        
        
        if name == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your Details", Color: .red, onPresentation: {
                self.nameField.becomeFirstResponder()
            }) {}
            return
        }
        
        if email == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Email Address", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        if validateEmail(enteredEmail: email) == false{
            FloatingMessage().floatingMessage(Message: "Invalid Email Address", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        if password == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Password", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        if validatePassword(enteredPassword: password) == false{
            FloatingMessage().floatingMessage(Message: "Password is too short", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        
        
        if phone == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Phone Number", Color: .red, onPresentation: {
                self.phoneField.becomeFirstResponder()
            }) {}
            return
        }
        
        if validatePhoneNumber(enteredNumber: phone) == false {
            FloatingMessage().floatingMessage(Message: "Invalid Phone Number", Color: .red, onPresentation: {
                self.phoneField.becomeFirstResponder()
            }) {}
            return
        }
        
        if college == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your College Name", Color: .red, onPresentation: {
                self.collegeField.becomeFirstResponder()
            }) {}
            return
        }
        
        if dlink == ""{
            FloatingMessage().floatingMessage(Message: "Please enter the drive link", Color: .red, onPresentation: {
                self.driveField.becomeFirstResponder()
            }) {}
            return
        }
        
        if state == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your State", Color: .red, onPresentation: {
                self.stateField.becomeFirstResponder()
            }) {}
            return
        }
        
        registerButton.showLoading()
        registerButton.activityIndicator.color = .white
        
        Networking.sharedInstance.registerUserWithDetails(name: name, email: email,mobile: phone, password:password, collname: college, sname: state, dlink: dlink, dataCompletion: { (successString) in
            print(successString)
            FloatingMessage().longFloatingMessage(Message: "Successfully Registered", Color: UIColor.CustomColors.Purple.register, onPresentation: {
                self.hideKeyboard()
            }) {
                self.loginViewController?.emailField.text = email
                self.loginViewController?.passwordField.text = password
                self.navigationController?.popViewController(animated: true)
            }
            self.registerButton.hideLoading()
        }) { (errorString) in
            FloatingMessage().floatingMessage(Message: errorString, Color: .red, onPresentation: {
            }) {}
            print(errorString)
            self.registerButton.hideLoading()
            return
        }
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validatePhoneNumber(enteredNumber: String) -> Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex)
        return phonePredicate.evaluate(with: enteredNumber)
    }
    
    func validatePassword(enteredPassword: String) -> Bool {
        if(enteredPassword.count<8){
            return false
        }
        return true
    }
    
}


protocol collegeSelected
{
    func collegeTapped(name:String)
}

extension SignUpViewController: collegeSelected
{
    func collegeTapped(name: String) {
        
        searchController.dismiss(animated: true) {
            self.collegeField.text = name
            self.stateField.becomeFirstResponder()
        }
        
        searchController.dismiss(animated: false, completion: nil)
    }
}

extension SignUpViewController: StateSelected{
    
    func stateSelected(state: String) {
        stateSearchController.dismiss(animated: true) {
            self.stateField.text = state
            self.driveField.becomeFirstResponder()
        }
        stateSearchController.dismiss(animated: false, completion: nil)
        
    }
    
    
    
    
}

