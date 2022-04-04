//
//  Networking.swift
//  TechTetva-19
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Alamofire

struct CollegesResponse:Decodable {
    let success: Bool
    let data: [College]?
}
struct College:Decodable, Encodable {
    let name:String
    let state:String?
}

struct UserKeys{
    static let sharedInstance = UserKeys()
    let mobile = "mobile"
    let firstName = "firstName"
    let lastName = "lastName"
    let userID = "userID"
    let email = "email"
    let loggedIn = "isLoggedIn"
    let active = "active"
}
let testURL = "https://revels22-api.herokuapp.com"
let baseURL = "https://revelsmit.in"

let apiKey = "o92PqCYAstWGq1Mx0kou"
let resultsURL = "https://api.mitrevels.in/results" //"https://api.techtatva.in/results"
let eventsURL = "\(baseURL)/api/user/event/getallevents"
let scheduleURL = "https://techtatvadata.herokuapp.com/schedule"
let collegesURL = "\(baseURL)/api/colleges"
//let categoriesURL = "https://api.mitrevels.in/categories"
let categoriesURL = "\(baseURL)/api/category/getall"
//let delegateCardsURL = "https://api.mitrevels.in/delegate_cards"
let boughtDelegateCardsURL = "https://register.mitrevels.in/boughtCards" 
//let paymentsURL = "https://register.mitrevels.in/buy?card="
//let mapsDataURL = "https://appdev.mitrevels.in/maps"
//let collegeDataURL = "http://api.mitrevels.in/colleges"
let defaults = UserDefaults.standard
let emailCached = defaults.object(forKey: "Email") as? String ?? ""
let passwordCached = defaults.object(forKey: "Password") as? String ?? ""
let userIDCached = defaults.object(forKey: "userID") as! Int
let token = defaults.object(forKey: "token") as! String

struct NetworkResponse <T: Decodable>: Decodable{
    let success: Bool
    let data: [T]?
}

let newsLetterURL = "https://app.themitpost.com/newsletter"
    //"http://newsletter-revels.herokuapp.com/pdf"

struct NewsLetterApiRespone: Decodable{
    let data: String?
}
struct Networking {
    
    let userSignUpURL = "\(testURL)/api/user/register"
    let userPasswordForgotURL = "\(testURL)/api/user/forgetpass"
    let userPasswordResetURL = "https://register.mitrevels.in/setPassword/"
    let userLoginURL = "\(testURL)/api/user/login"
    let userDetailsURL = "https://register.mitrevels.in/userProfile"
    let registerEventURL = "\(testURL)/api/user/event/register"
    let getRegisteredEventsURL = "\(testURL)/api/user/event/getevents"
    let leaveTeamURL = "https://techtatva.in/app/leaveteam"
    let joinTeamURL = "https://techtatva.in/app/jointeam"
    let removeTeammateURL = "https://techtatva.in/app/removeuser"
    let updateDriveLinkURL = "https://techtatva.in/app/updatedrive"
    
    let teamDetailsURL = "https://techtatva.in/app/teamDetails"

    
    let liveBlogURL = "https://app.themitpost.com/liveblog"
    
    static let sharedInstance = Networking()
    
    func getResults(dataCompletion: @escaping (_ Data: [Result]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(resultsURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(ResultsResponse.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Results Response Failed")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    func getData<T: Decodable>(url: String, decode: T, dataCompletion: @escaping (_ Data: [T]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){

        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(NetworkResponse<T>.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Response Failed in \(url)")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error in getData(Networking)")
                }
            }
        }
    }
    
    func getEvents(dataCompletion: @escaping (_ Data: [Event]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(eventsURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                    print("Data: \(resultsResponse.data![0].name)")
                    if !resultsResponse.success{
                        if let data = resultsResponse.data{
                            print("before datacompletion")
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Events Response Failed(Networking)")
                    }
                }catch let error{ 
                    print(error)
                    errorCompletion("Decoding Error in getting Events(Networking)")
                }
            }
        }
    }
    
    
    func getScheduleData(dataCompletion: @escaping (_ Data: [ScheduleDays]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(scheduleURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(ScheduleResponse.self, from: data)
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    else{
                        errorCompletion("Schedule Response Failed(Networking)")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error in getting Schedule(Networking)")
                }
            }
        }
    }
    
    

    // MARK: - Events
    
    func getCategories(dataCompletion: @escaping (_ Data: [Category]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(categoriesURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                            debugPrint("Category DATA: \(resultsResponse)")
                        }
                    }else{
                        errorCompletion("Category Response Failed(Networking)")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error in getting Categories(Networking)")
                }
            }
        }
    }
    
    
    // MARK: - Users
    
    func registerUserWithDetails(name: String, email: String, mobile: String,password:String, collname: String, course:String,regno:Int64,branch:String, dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "name": name,
            "email": email,
            "mobileNumber": mobile,
            "registrationNumber":regno,
            "password":password,
            "branch":branch,
            "college": collname,
            "course": course
            ] as [String : Any]
        print(parameters)
        
        Alamofire.request(userSignUpURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
//                        defaults.set(data[0].userID, forKey: "userId")
                        dataCompletion(response.msg ?? "Successful")
                    }else{
                        print(response)
                        errorCompletion(response.msg ?? "Someting went wrong")
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func forgotPasswordFor(Email email: String, dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "email": email
            ] as [String : String]
        
        Alamofire.request(userPasswordForgotURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        dataCompletion(response.msg ?? "Successful")
                    }else{
                        print(response)
                        errorCompletion(response.msg ?? "Something went wrong")
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print("idhar haga?")
                    print(error)
                }
            }
        }
    }
    
    func resetPassword(Token: String, Password: String, dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "token": Token,
            "password": Password,
            "password2": Password,
            ] as [String : Any]
        
        Alamofire.request(userPasswordResetURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        dataCompletion(response.msg ?? "Success")
                    }else{
                        print(response)
                        errorCompletion(response.msg ?? "Something went wrong")
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func loginUser(Email: String, Password: String, dataCompletion: @escaping (_ Data: User) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "email": Email,
            "password": Password
            ] as [String : Any]

        Alamofire.request(userLoginURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response1 = try JSONDecoder().decode(UserResponse.self, from: data)
                    if response1.success{
                        print(data)
                        let defaults = UserDefaults.standard
                        defaults.set(response1.data?.token, forKey: "token")
                        defaults.set(response1.data?.userID, forKey: "userID")
                        defaults.set(response1.data?.name, forKey: "name")
                        defaults.synchronize()
                        dataCompletion(response1.data!)
                    }else{
                        print("FFFFFF")
                        errorCompletion(response1.msg ?? "")
                    }
                }catch let error{
                    print("LMAOO")
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
//    func toUpdateDriveLink(drivelink: String ,successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
//            let parameters = [
//                "userID": userIDCached,
//                "driveLink": drivelink,
//                "email": emailCached,
//                "password": passwordCached,
//                "key": apiKey
//                ] as [String : Any]
//
//            Alamofire.request(updateDriveLinkURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
//                if let data = response.data{
//                    do{
//                        let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
//                        if response.success{
//                            successCompletion(response.msg)
//                            }
//                        else{
//                            print(response)
//                            errorCompletion(response.msg)
//                        }
//                    }catch let error{
//                        print("Error in getting status update after registering" ,error)
//                    }
//                }
//            }
//        }
    
    func getStatusUpdate(dataCompletion: @escaping (_ Data: User) -> ()){
        let parameters = [
            "email": emailCached,
            "password": passwordCached,
            "key": apiKey
            ] as [String : Any]

        Alamofire.request(userLoginURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
                    if response.success{
                        if let data = response.data{
                            dataCompletion(data)
                        }
                    }else{
                        print(response)
                    }
                }catch let error{
                    print("Error in getting status update after registering" ,error)
                }
            }
        }
    }
    
    func getNewsLetterUrl(dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(newsLetterURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(NewsLetterApiRespone.self, from: data)
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }else{
                            errorCompletion("Unable to get Newletter URL")
                        }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    
    
    //MARK: - EVENTS
    
    
    func registerEventWith(eventID: Int, userid:Int, category:String, successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        let parameters = [
            "eventID":eventID,
            ] as [String : Any]
        debugPrint("yeh hai eventy id",eventID)
        debugPrint("lell",token)
        let tok = UserDefaults.standard.object(forKey: "token") as! String
        let headers: HTTPHeaders = [
            "authorization": tok
        ]
        Alamofire.request(registerEventURL, method: .post, parameters: parameters, encoding: URLEncoding(), headers: headers).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(CreateTeamResponse.self, from: data)
                    if response.success{
                        successCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func getRegisteredEvents(dataCompletion: @escaping (_ Data: [RegEvents]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let tok = UserDefaults.standard.object(forKey: "token") as! String

        let headers: HTTPHeaders = [
            "authorization": tok
        ]
        
        Alamofire.request(getRegisteredEventsURL, method: .get, parameters: nil, encoding: URLEncoding(),headers: headers).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(RegisteredEventsResponse.self, from: data)
                    print("ye hai registered events ka data", resultsResponse)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Coudn't Fetch Registered Events")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    func leaveTeamForEventWith(userID: Int, teamID:String, eventID:Int, successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "teamID":teamID
            ] as [String : Any]
        let tok = UserDefaults.standard.object(forKey: "token") as! String

        let headers: HTTPHeaders = [
            "authorization": tok
        ]
        
        Alamofire.request(leaveTeamURL, method: .post, parameters: parameters, encoding: URLEncoding(),headers: headers).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        print(response.msg)
                        successCompletion(response.msg ?? "Successful")
                    }else{
                        print(response)
                        errorCompletion(response.msg ?? "Something went wrong")
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func removeTeammate(userID: Int, teamID:String, eventID:Int,removeID: Int, successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "userID":userID,
            "teamID":teamID,
            "eventID": eventID,
            "removeID": removeID,
            "email":emailCached,
            "password":passwordCached,
            "key":apiKey
            ] as [String : Any]
        
        Alamofire.request(removeTeammateURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        successCompletion(response.msg ?? "Successful")
                    }else{
                        print(response)
                        errorCompletion(response.msg ?? "Something went wrong")
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func joinTeam( eventId: String,userID:Int,category :String,partyCode:String, successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "userID":userID,
            "eventID": eventId,
            "category":category,
            "partyCode": partyCode,
            "email":emailCached,
            "password":passwordCached,
            "key":apiKey
            ] as [String : Any]
        
        Alamofire.request(joinTeamURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(JoinTeamResponse.self, from: data)
                    if response.success{
                        successCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    
    func getTeamDetails(teamID:String, dataCompletion: @escaping (_ Data: TeamMemberDetails) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "teamID": teamID,
            "email": emailCached,
            "userID": userIDCached,
            "password": passwordCached,
            "key": apiKey
            ] as [String : Any]

        Alamofire.request(teamDetailsURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(TeamDetailsResponse.self, from: data)
                    if response.success{
                        if let data = response.data{
                            print(data)
                            dataCompletion(data)
                        }
                    }else{
                        print(response)
                        errorCompletion(response.msg ?? "")
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    
    // live blog url
    
    func getLiveBlogData(dataCompletion: @escaping (_ Data: [Blog]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(liveBlogURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(BlogData.self, from: data)
                    if resultsResponse.success ?? false{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Coudn't Fetch Registered Events")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    // MARK: - Colleges
    func getColleges(dataCompletion: @escaping (_ Data:[College]) -> (), errorCompletion: @escaping(_ ErrorMessage: String) -> ()){
        Alamofire.request(collegesURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let collegeResponse = try JSONDecoder().decode(CollegesResponse.self, from: data)
                    if collegeResponse.success{
                        if let dat = collegeResponse.data{
                            dataCompletion(dat)
                        }else{
                            errorCompletion("Couldnt fetch colleges")
                        }
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Error fetching colleges")
                
            }
        }
    }
        
    }
    
}
