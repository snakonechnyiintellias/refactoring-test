import UIKit

let booksNotificationCenter = NotificationCenter.default
let bookNotificationName = Notification.Name("com.user.books")

struct Book: Codable {
    let name: String
    let description: String
    let genre: String
    let pageNumber: Int
    let rating: Float
}

class BookListViewController: UITableViewController {
    var books: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        BookLoader.fetchBooks()

        booksNotificationCenter.addObserver(
            self,
            selector: #selector(updateBooks(_:)),
            name: bookNotificationName,
            object: nil
        )
    }

    @objc func updateBooks(_ notification: Notification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let books = dict["books"] as? [Book] {
                self.books = books
                tableView.reloadData()
            }
        }
    }

    func createDescription(for book: Book) -> String {
        "Description: \(book.description), Genre: \(book.genre), Rating: \(book.rating)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let book = books[indexPath.row]
        cell.textLabel?.text = book.name
        cell.detailTextLabel?.text = createDescription(for: book)
        return cell
    }
}

class BookLoader {
    static let booksURLString = "books.test.com"

    static func fetchBooks() {
        let request = URLRequest(url: URL(string: booksURLString)!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let books = try? JSONDecoder().decode([Book].self, from: data) else {
                return
            }
            booksNotificationCenter.post(name: bookNotificationName, object: nil, userInfo: ["books": books])
        }
    }
}
