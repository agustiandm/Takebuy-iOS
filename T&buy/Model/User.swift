//
//  User.swift
//  T&buy
//
//  Created by Agustian DM on 09/08/20.
//

import Foundation
import Firebase

class User {
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    var fullAddress: String?
    var onBoard: Bool
    
    //MARK: - Initializers
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        fullAddress = ""
        onBoard = false
        purchasedItemIds = []
    }
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[OBJECTID] as! String
        
        if let mail = _dictionary[EMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        if let fname = _dictionary[FIRSTNAME] {
            firstName = fname as! String
        } else {
            firstName = ""
        }
        if let lname = _dictionary[LASTNAME] {
            lastName = lname as! String
        } else {
            lastName = ""
        }
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[FULLADDRESS] {
            fullAddress = faddress as? String
        } else {
            fullAddress = ""
        }
        
        if let onB = _dictionary[ONBOARD] {
            onBoard = onB as! Bool
        } else {
            onBoard = false
        }
        
        if let purchaseIds = _dictionary[PURCHASEDITEMIDS] {
            purchasedItemIds = purchaseIds as! [String]
        } else {
            purchasedItemIds = []
        }
    }
    
    //MARK: - Return current user
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: CURRENTUSER) {
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    
    //MARK: - Login func
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
//                    print("DEBUG: Email is not verified")
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    
    //MARK: - SignUp user
    class func signupUserWith(email: String, password: String, completion: @escaping (_ error: Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            completion(error)
            
            if error == nil {
                
                //send email verification
                authDataResult!.user.sendEmailVerification { (error) in
                }
            }
        }
    }
    
    //MARK: - Resend link methods

    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print(" resend email error: ", error!.localizedDescription)
                
                completion(error)
            })
        })
    }
    
    //MARK: - Sign Out
    class func signOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: CURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
    }
}


//MARK: - Save user to firebase
func saveUserToFirestore(User: User) {
    
    FirebaseRef(.User).document(User.objectId).setData(userDictionaryFrom(user: User) as! [String : Any]) { (error) in
        
        if error != nil {
//            print("DEBUG: error saving user \(error!.localizedDescription)")
        }
    }
}

func saveUserLocally(UserDictionary: NSDictionary) {
    UserDefaults.standard.set(UserDictionary, forKey: CURRENTUSER)
    UserDefaults.standard.synchronize()
}


//MARK: - DownloadUser

func downloadUserFromFirestore(userId: String, email: String) {
    
    FirebaseRef(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else { return }
        if snapshot.exists {
//            print("DEBUG: Download current user from firestore")
            saveUserLocally(UserDictionary: snapshot.data()! as NSDictionary)
        } else {
            //there is no user, save new in firestore
            
            let user = User(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(UserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(User: user)
        }
    }
}

//MARK: - Update user

func updateCurrentUserInFirestore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    if let dictionary = UserDefaults.standard.object(forKey: CURRENTUSER) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseRef(.User).document(User.currentId()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                saveUserLocally(UserDictionary: userObject)
            }
        }
    }
}

//MARK: - Helper
func userDictionaryFrom(user: User) -> NSDictionary {
    
    return NSDictionary(objects: [user.objectId,
                                  user.email,
                                  user.firstName,
                                  user.lastName,
                                  user.fullName,
                                  user.fullAddress ?? "",
                                  user.onBoard,
                                  user.purchasedItemIds],
                        forKeys: [OBJECTID as NSCopying,
                                  EMAIL as NSCopying,
                                  FIRSTNAME as NSCopying,
                                  LASTNAME as NSCopying,
                                  FULLNAME as NSCopying,
                                  FULLADDRESS as NSCopying,
                                  ONBOARD as NSCopying,
                                  PURCHASEDITEMIDS as NSCopying])
    
}
