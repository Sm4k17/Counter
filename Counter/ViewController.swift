//
//  ViewController.swift
//  Counter
//
//  Created by Рустам Ханахмедов on 30.03.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private var counterValue: Int = 0 {
        didSet {
            updateCounterLabel()
            updateButtonsState()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var historyTextView: UITextView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var plusButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        configureView()
        configureHistoryTextView()
        configureCounterLabel()
        configureButtons()
        updateClearButtonState()
    }
    
    private func configureView() {
        view.backgroundColor = .systemTeal
        historyTextView.backgroundColor = .systemTeal
    }
    
    
    private func configureHistoryTextView() {
        historyTextView.textColor = .white
        historyTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        historyTextView.text = "История изменений:"
        historyTextView.isEditable = false
        historyTextView.isSelectable = true
        historyTextView.isScrollEnabled = true
        historyTextView.showsVerticalScrollIndicator = true
        historyTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    private func configureCounterLabel() {
        counterLabel.text = "Значение счётчика: 0"
        counterLabel.textColor = .white
    }
    
    private func configureButtons() {
        plusButton.tintColor = .systemRed
        minusButton.tintColor = .systemBlue
        resetButton.tintColor = .systemOrange
        clearButton.tintColor = .systemGray
        
        updateButtonsState()
    }
    
    private func updateButtonsState() {
        minusButton.isEnabled = counterValue > 0
        resetButton.isEnabled = counterValue != 0
        plusButton.isEnabled = counterValue < Int.max
    }
    
    // MARK: - Counter Logic
    private func updateCounterLabel() {
        counterLabel.text = "Значение счётчика: \(counterValue)"
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private func addHistoryEntry(_ message: String) {
        let newEntry = "\n[\(ViewController.dateFormatter.string(from: Date()))] \(message)"
        let attributedNewEntry = NSMutableAttributedString(string: newEntry)
        historyTextView.textStorage.append(attributedNewEntry)
        
        historyTextView.textColor = .white
        historyTextView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        historyTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        updateClearButtonState()
        
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        let range = NSRange(location: historyTextView.text.count - 1, length: 1)
        historyTextView.scrollRangeToVisible(range)
    }
    
    private func updateClearButtonState() {
        let isHistoryEmpty = historyTextView.text == "История изменений:" || historyTextView.text.isEmpty
        clearButton.isEnabled = !isHistoryEmpty
    }
    // MARK: - Actions
    @IBAction private func minusButtonTapped(_ sender: UIButton) {
        guard counterValue > 0 else {
            addHistoryEntry("Попытка уменьшить значение ниже 0")
            return }
        counterValue -= 1
        addHistoryEntry("Значение уменьшено на 1")
    }
    
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        if counterValue < Int.max {
            counterValue += 1
            addHistoryEntry("Значение увеличено на 1")
        } else {
            addHistoryEntry("Достигнуто максимальное значение")
        }
        
    }
    
    @IBAction private func resetButtonTapped(_ sender: UIButton) {
        counterValue = 0
        addHistoryEntry("Счётчик сброшен")
    }
    
    @IBAction private func clearButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Очистить историю",
            message: "Вы уверены, что хотите очистить историю изменений?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Очистить", style: .destructive) { _ in
            self.historyTextView.text = "История изменений:"
            self.counterValue = 0
            self.updateClearButtonState()
        })
        
        present(alert, animated: true)
    }
}
