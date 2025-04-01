//
//  ViewController.swift
//  Counter
//
//  Created by Рустам Ханахмедов on 30.03.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    private var countNumber: Int = .zero {
        didSet {
            updateCounterLabel()
        }
    }
    
    @IBOutlet weak private var changesHistory: UITextView!
    @IBOutlet weak private var counter: UILabel!
    @IBOutlet weak private var minusButton: UIButton!
    
    @IBOutlet weak private var resetButton: UIButton!
    
    @IBOutlet weak private var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemYellow
        changesHistory.backgroundColor = .systemYellow
        counter.text = "0"
        plusButton.tintColor = .red
        minusButton.tintColor = .blue
        
        configureTextView()
    }
    
    private func configureTextView() {
        changesHistory.text = "История изменений:"
        changesHistory.isEditable = false // Запрет редактирования
        changesHistory.isSelectable = true // Разрешение выделения текста
        changesHistory.isScrollEnabled = true // Включение прокрутки
        changesHistory.showsVerticalScrollIndicator = true // Показ скролл-бара
        changesHistory.font = UIFont.systemFont(ofSize: 14) // Шрифт
        changesHistory.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) // Отступы
    }
    
    private func updateCounterLabel() {
        counter.text = "Значение счётчика: \(countNumber)"
    }
    
    private func dateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    private func addHistoryEntry(_ message: String) {
        let newEntry = "\n\(dateFormat()) \(message)"
        changesHistory.text += newEntry
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        guard !changesHistory.text.isEmpty else { return }
        
        let location = changesHistory.text.count - 1
        let range = NSRange(location: location, length: 1)
        changesHistory.scrollRangeToVisible(range)
    }
    
    @IBAction private func minusCount(_ sender: Any) {
        if countNumber > 0 {
            countNumber -= 1
            addHistoryEntry("Значение изменено на -1")
        } else {
            addHistoryEntry("Попытка уменьшить значение счётчика ниже 0")
        }
    }
    
    @IBAction private func plusCount(_ sender: Any) {
        countNumber += 1
        addHistoryEntry("Значение изменено на +1")
    }
    
    @IBAction private func resetCount(_ sender: Any) {
        countNumber = 0
        addHistoryEntry("Значение сброшено")
    }
    
}

