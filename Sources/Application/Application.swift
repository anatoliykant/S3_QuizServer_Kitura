import Dispatch
import Foundation
import Kitura
import Configuration
import CloudEnvironment
import Health
import KituraOpenAPI
import KituraCORS
import LoggerAPI

public class App {
	
	// MARK: - Dependencies
	
	let router = Router()
	let cloudEnv = CloudEnv()
	
	// MARK: - Private properties
	
	private var nextId = 0
	
	// MARK: - Initialization
	
	public init() throws {
		
		// Run the metrics initializer
		
		initializeMetrics(router: router)
	}
	
	// MARK: - Public methods
	
	// MARK: Running
	
	public func run() throws {
		try postInit()
		Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
		Kitura.run()
	}
	
	// MARK: - Private methods
	
	func postInit() throws {
		
		// Database setup
		
		Persistence.setUp()
		
		do {
			try Answer.createTableSync()
		} catch let error {
			Log.warning("⚠️ WARNING: Table Answers already exists: \(error.localizedDescription)")
		}
		
		do {
			try Question.createTableSync()
		} catch let error {
			Log.warning("⚠️ WARNING: Table Questions already exists: \(error.localizedDescription)")
		}
		
		// Find maximum id and assign it to nextID
		
		Question.findAll { [weak self] (questions, error) in
			guard let self = self else { return }
			let maxQuestionId = questions?.compactMap { $0.id }.max() ?? -1
			
			Answer.findAll { (answers, error) in
				let maxAnswerId = answers?.compactMap{ $0.id }.max() ?? -1
				self.nextId = max(maxQuestionId, maxAnswerId) + 1
				Log.info("Next identifier: \(self.nextId)")
			}
		}
		
		// Endpoints
		
		initializeHealthRoutes(app: self)
		KituraOpenAPI.addEndpoints(to: router)
		
		// KituraCORS
		
		let options = Options(allowedOrigin: .all)
		let cors = CORS(options: options)
		
		// Setup Routes
		
		router.all("/*", middleware: cors)
		
		// MARK: Answers requests
		
		router.get("/answers", handler: getAllAnswersHandler)
		router.get("/answers", handler: getOneAnswerHandler)
		router.post("/answers", handler: storeAnswerHandler)
		router.delete("/answers", handler: deleteOneAnswerHandler)
		router.patch("/answers", handler: updateAnswerHandler)
		
		// MARK: Questions requests
		
		router.get("/questions", handler: getAllQuestionsHandler)
		router.get("/questions", handler: getOneQuestionHandler)
		router.delete("/questions", handler: deleteOneQuestionHandler)
		router.patch("/questions", handler: updateQuestionHandler)
		router.post("/questions", handler: storeQuestionHandler)
	}
	
	// MARK: - Answer Handlers
	
	// MARK: GET handlers
	
	private func getAllAnswersHandler(completion: @escaping ([Answer]?, RequestError?) -> Void) {
		Answer.findAll(completion)
	}
	
	private func getOneAnswerHandler(id: Int, completion: @escaping (Answer?, RequestError?) -> Void) {
		Answer.find(id: id, completion)
	}
	
	// MARK: DELETE handler
	
	private func deleteOneAnswerHandler(id: Int, completion: @escaping (RequestError?) -> Void) {
		Answer.delete(id: id, completion)
	}
	
	// MARK: PATCH handler
	
	private func updateAnswerHandler(id: Int, new: Answer, completion: @escaping (Answer?, RequestError?) -> Void) {
		
		Answer.find(id: id) { current, error in
			guard error == nil else {
				return completion(nil, error)
			}
			
			guard var current = current else {
				return completion(nil, .notFound)
			}
			
			guard id == current.id else {
				return completion(nil, .internalServerError)
			}
			
			current.text = new.text ?? current.text
			current.type = new.type ?? current.type
			current.questionId = new.questionId ?? current.questionId
			
			current.update(id: id, completion)
		}
	}
	
	// MARK: POST handler
	
	private func storeAnswerHandler(answer: Answer, completion: @escaping (Answer?, RequestError?) -> Void) {
		
		let answerId = nextId
		
		// check that text and type are not empty
		
		guard
			let text = answer.text,
			!text.isEmpty,
			answer.type != nil
			else {
				return completion(nil, .badRequest)
		}
		
		// store answer
		
		var answer = answer
		answer.id = answerId
		nextId += 1
		return answer.save(completion)
	}
	
	// MARK: - Question Handlers
	
	// MARK: GET handlers
	
	private func getAllQuestionsHandler(completion: @escaping ([Question]?, RequestError?) -> Void) {
		Question.findAll(completion)
	}
	
	private func getOneQuestionHandler(id: Int, completion: @escaping (Question?, RequestError?) -> Void) {
		Question.find(id: id, completion)
	}
	
	// MARK: DELETE handler
	
	private func deleteOneQuestionHandler(id: Int, completion: @escaping (RequestError?) -> Void) {
		Question.delete(id: id, completion)
	}
	
	// MARK: PATCH handler
	
	private func updateQuestionHandler(id: Int, new: Question, completion: @escaping (Question?, RequestError?) -> Void) {
		
		Question.find(id: id) { current, error in
			guard error == nil else {
				return completion(nil, error)
			}
			
			guard var current = current else {
				return completion(nil, .notFound)
			}
			
			guard id == current.id else {
				return completion(nil, .internalServerError)
			}
			
			current.text = new.text ?? current.text
			current.type = new.type ?? current.type
			
			current.update(id: id, completion)
		}
	}
	
	// MARK: POST handler
	
	private func storeQuestionHandler(question: Question, completion: @escaping (Question?, RequestError?) -> Void) {
		
		let questionId = nextId
		
		// check that text and type are not empty
		
		guard
			let text = question.text,
			!text.isEmpty,
			question.type != nil
			else {
				return completion(nil, .badRequest)
		}
		
		// store question
		
		var question = question
		question.id = questionId
		nextId += 1
		return question.save(completion)
	}
}
