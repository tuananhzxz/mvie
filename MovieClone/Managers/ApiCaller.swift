//
//  ApiCaller.swift
//  MovieClone
//
//  Created by tuananhdo on 5/1/25.
//

import Foundation


struct Constants {
    static let API_KEY = "cef0bd5a521d4f4d30bd67baff1ef8ef"
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let YOUTUBE_KEY = "AIzaSyDb3coaafHkBEV5DOLeSKG9QjJezlmkSUc"
    static let YOUTUBE_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError : Error {
    case faildToGetData
}

class ApiCaller {
    static let shared = ApiCaller()
    
    func getTrendMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/trending/movie/day?api_key=\(Constants.API_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        
        task.resume()
    }
    
    func getTrendingTv(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/trending/tv/day?api_key=\(Constants.API_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
//                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/movie/upcoming?api_key=\(Constants.API_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/movie/popular?api_key=\(Constants.API_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/movie/top_rated?api_key=\(Constants.API_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(completion : @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        
        task.resume()
    }
    
    func search(with query : String, completion : @escaping (Result<[Movie], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let url = URL(string: "\(Constants.BASE_URL)/search/movie?api_key=\(Constants.API_KEY)&query=\(query)")!
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                    completion(.success(result.results))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        
        task.resume()
    }
    
    func getMovie(with query : String, completion : @escaping (Result<YoutubeVideo, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.YOUTUBE_BASE_URL)q=\(query)&key=\(Constants.YOUTUBE_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if error != nil {
                completion(.failure(APIError.faildToGetData))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(YoutubeSearchResultResponse.self, from: data)
                    completion(.success(result.items[0]))
                } catch {
                    completion(.failure(APIError.faildToGetData))
                }
            }
        }
        
        task.resume()
    }
}
