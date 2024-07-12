import SwiftUI
import UIKit
import CocoaLumberjackSwift
import FileCachePackage

class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    private enum Constants {
        static let sizeOfCalendarCell: CGFloat = 70
    }
    var tableView: UITableView!
    var scrollView: UIScrollView!
    var isTableViewScrolling = false

    var items: [TodoItem] = []
    var groupedItems: [String: [TodoItem]] = [:]
    var sortedSections: [String] = []

    init(tasks: [TodoItem]) {
        super.init(nibName: nil, bundle: nil)
        self.items = tasks
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        groupDataByDeadline()
        setupScrollView()
        setupTableView()
        setupAddButton()
    }
    func getTasksFromDict() -> [TodoItem] {
        var array: [TodoItem] = []
        for (_, value) in self.groupedItems {
            array += value
        }
        return array.sorted { $0.id < $1.id }
    }

    override func viewDidAppear(_ animated: Bool) {
        DDLogDebug("UIKitCalendar screen opened")
    }

    func groupDataByDeadline() {
        for item in items {
            var dateString: String
            if let deadline = item.deadline {
                let df = DateFormatter()
                df.dateFormat = "dd MMMM"
                dateString = df.string(from: deadline)
            } else {
                dateString = "Другое"
            }

            if groupedItems[dateString] == nil {
                groupedItems[dateString] = []
            }
            groupedItems[dateString]?.append(item)
        }
        sortedSections = groupedItems.keys.sorted()

        // "Другое" всегда будет в конце
        if let index = sortedSections.firstIndex(of: "Другое") {
            sortedSections.append(sortedSections.remove(at: index))
        }
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: Constants.sizeOfCalendarCell)
        ])

        var xOffset: CGFloat = 0
        for date in sortedSections {
            let dateView = UIView(frame: CGRect(x: xOffset, y: 0, width: Constants.sizeOfCalendarCell, height: Constants.sizeOfCalendarCell))
            dateView.backgroundColor = UIColor._background
            let inset: CGFloat = 7
            let labelX = inset
            let labelY = inset
            let labelW = dateView.bounds.width - inset
            let labelH = dateView.bounds.height - 2 * inset
            let label = UILabel(frame: CGRect(x: labelX, y: labelY, width: labelW, height: labelH))
            label.layer.cornerRadius = 10
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.borderWidth = 2
            label.layer.masksToBounds = true
            label.backgroundColor = UIColor._scrollSelection
            label.text = date
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.4
            label.textAlignment = .center
            label.numberOfLines = 2
            dateView.addSubview(label)
            scrollView.addSubview(dateView)
            xOffset += Constants.sizeOfCalendarCell
        }

        scrollView.contentSize = CGSize(width: xOffset, height: 70)
    }

    func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor._background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedSections.count
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let date = sortedSections[indexPath.section]
        guard groupedItems[date]?[indexPath.row] != nil else { return nil }

        let activateAction = UIContextualAction(style: .normal, title: "In progress") { _, _, completionHandler in
            self.setDone(false, at: indexPath)
            completionHandler(true)
        }
        activateAction.backgroundColor = .yellow
        return UISwipeActionsConfiguration(actions: [activateAction])

    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let date = sortedSections[indexPath.section]
        guard groupedItems[date]?[indexPath.row] != nil else { return nil }

        let activateAction = UIContextualAction(style: .normal, title: "Done") { _, _, completionHandler in
            self.setDone(true, at: indexPath)
            completionHandler(true)
        }
        activateAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [activateAction])
    }

    private func toggleComplete(at indexPath: IndexPath) {
        let date = sortedSections[indexPath.section]
        // TODO: ??
        let task = groupedItems[date]?[indexPath.row].withToggledIsDone()
        groupedItems[date]?[indexPath.row] = task  ?? TodoItem(text: "")
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    private func setDone(_ isDone: Bool, at indexPath: IndexPath) {
        let date = sortedSections[indexPath.section]
        // TODO: ??
        let task = groupedItems[date]?[indexPath.row].withIsDone(isDone)
        groupedItems[date]?[indexPath.row] = task  ?? TodoItem(text: "")
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = sortedSections[section]
        return groupedItems[date]?.count ?? 0
    }
    func setupAddButton() {
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.contentHorizontalAlignment = .fill
        addButton.contentVerticalAlignment = .fill
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func addButtonTapped() {
        self.navigationController?.popViewController(animated: true)

    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let date = sortedSections[indexPath.section]
        if let item = groupedItems[date]?[indexPath.row] {
            if item.isDone {
                cell.textLabel?.textColor = .gray
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: item.text)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                cell.textLabel?.attributedText = attributeString
            } else {
                cell.textLabel?.textColor = .black
                cell.textLabel?.attributedText = nil
                cell.textLabel?.text = item.text
            }
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView  &&  isTableViewScrolling {
            syncScrollWhenTableScrolled()
        } else if scrollView == self.scrollView && !isTableViewScrolling {
            syncScrollWhenHorizontalScrolled()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            isTableViewScrolling = true
        } else {
            isTableViewScrolling = false
        }
    }

    private func syncScrollWhenHorizontalScrolled() {
        let numberOfSections = tableView.numberOfSections
        var array = [CGFloat]()
        var sum: CGFloat = 0
        for _ in 0..<numberOfSections {
            let sectionWidth = Constants.sizeOfCalendarCell
            sum += sectionWidth
            array.append(sum)
        }

        let yOffset = scrollView.contentOffset.x
        var scrollWindowSize: CGFloat = Constants.sizeOfCalendarCell
        var minWindow: CGFloat = 0
        var sectionNUMBER = 0
        for i in 1..<array.count - 1 {
            if yOffset > array[i - 1] && yOffset < array[i] {
                scrollWindowSize = array[i] - array[i-1]
                minWindow = array[i - 1]
                sectionNUMBER = i
                break
            }
        }
        let scrollViewOffset = (0..<sectionNUMBER).map({tableView.rect(forSection: $0).height}).reduce(0, +) + tableView.rect(forSection: sectionNUMBER).height * (yOffset - minWindow) / scrollWindowSize
        tableView.setContentOffset(CGPoint(x: 0, y: scrollViewOffset), animated: false)
    }
    private func syncScrollWhenTableScrolled() {
        // скорость скрола на разных промежутках разная
        // надо уметь знать в какой мы секции

        let numberOfSections = tableView.numberOfSections
        var array = [CGFloat]()
        var sum: CGFloat = 0
        for i in 0..<numberOfSections {
            let sectionWidth = tableView.rect(forSection: i).height
            sum += sectionWidth
            array.append(sum)
        }

        let yOffset = tableView.contentOffset.y
        var scrollWindowSize: CGFloat = tableView.rect(forSection: 0).height
        var minWindow: CGFloat = 0
        var sectionNUMBER = 0
        for i in 1..<array.count - 1 {
            if yOffset > array[i - 1] && yOffset < array[i] { // [138.0, 232.0, 326.0, 420.0, 514.0, 608.
                // запомнить и выйти
                scrollWindowSize = array[i] - array[i-1]
                // maxWindow = array[i]
                minWindow = array[i - 1]
                sectionNUMBER = i
                break
            }
        }
        let scrollViewOffset = Constants.sizeOfCalendarCell * (CGFloat(sectionNUMBER) + (yOffset - minWindow) / scrollWindowSize)
        scrollView.setContentOffset(CGPoint(x: scrollViewOffset, y: 0), animated: false)
    }
}

//
// #Preview {
//    ContentView()
// }
//

struct PortableView: UIViewControllerRepresentable {
    @Binding var tasks: [TodoItem]
    func makeUIViewController(context: Context) -> MyViewController {
        MyViewController(tasks: tasks)
    }

    func updateUIViewController(_ uiViewController: MyViewController, context: Context) {
        self.tasks = uiViewController.getTasksFromDict()
    }
    
    typealias UIViewControllerType = MyViewController
}
