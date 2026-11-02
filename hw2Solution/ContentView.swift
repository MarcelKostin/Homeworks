//
//  ContentView.swift
//  hw2Solution
//
//  Created by marcel on 31.10.2026.
//

import SwiftUI

import Foundation

enum TaskCategory: String {
    case work = "folder"
    case study = "lamp.desk"
    case personal = "person.fill"
    
    var color: Color {
        switch self {
        case .work:
            Color.yellow
        case .study:
            Color.green
        case .personal:
            Color.blue
        }
    }
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
    
}

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    var category: TaskCategory
}

@Observable
class TaskManager {
    fileprivate var tasks: [Task]
    init (tasks: [Task]){
        self.tasks = tasks
    }
    
    func addTask(title: String,  category: TaskCategory) -> UUID {
        let newtask = Task(title: title, category: category)
        tasks.append(newtask)
        return newtask.id
    }
    
    func removeTask(by id: UUID){
        tasks.removeAll { task in
            task.id == id
        }
    }
    
    func toggleTaskCompletion(by id: UUID){
        guard let index = tasks.firstIndex(where: { task in
            return task.id == id
        }) else { return }
        tasks[index].isCompleted.toggle()
    }
    
    func filterTasks(by category: TaskCategory) -> [Task] {
        return tasks.filter{
            element in
            !element.isCompleted && element.category == category
        }
    }
}

struct TaskRowView: View {

    var task: Task
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green : .gray)
                Text(task.title)
                task.category.image
                Spacer()
            }
            .padding(.horizontal,16)
            .padding(.vertical, 12)
        }
    }
}

struct TaskListView: View {
    @State private var manager = TaskManager(tasks: [
            Task(title: "Показать проект начальству", category: .work),
            Task(title: "Сделать домашку", category: .study),
            Task(title: "Вынести мусор", category: .personal),
            Task(title: "Подготовиться к контрольной", category: .study)
        ])
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(manager.tasks) { task in
                        TaskRowView(task: task)
                            .onTapGesture {
                                manager.toggleTaskCompletion(by: task.id)
                            }
                    }
                }
            }
            .navigationTitle("Мои Задачи")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        manager.addTask(title: "Придумать новые цели", category: [TaskCategory.work, .study, .personal].randomElement()!)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
#Preview {
    TaskListView()
}
