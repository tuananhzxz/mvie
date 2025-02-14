import Foundation

class TranslationService {
    static let shared = TranslationService()
    private let apiKey = "AIzaSyAakbYgtrts5KERIFrct94Ihe-fnruYT64"
    
    private init() {}
    
    func translate(_ text: String, completion: @escaping (String?) -> Void) {
        // Kiểm tra text rỗng
        guard !text.isEmpty else {
            completion(nil)
            return
        }
        
        // Tạo URL request
        let baseURL = "https://translation.googleapis.com/language/translate/v2"
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "target", value: "vi"),
            URLQueryItem(name: "source", value: "en"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components.url else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        // Thực hiện request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  error == nil,
                  let response = try? JSONDecoder().decode(TranslationResponse.self, from: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let translatedText = response.data.translations.first?.translatedText
            
            DispatchQueue.main.async {
                completion(translatedText)
            }
        }.resume()
    }
}

// MARK: - Response Models
struct TranslationResponse: Codable {
    let data: TranslationData
}

struct TranslationData: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}
