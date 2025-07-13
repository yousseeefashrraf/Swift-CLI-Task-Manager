# ✅ Swift CLI Task Manager

A lightweight console-based task management app built using **Swift**. It allows users to create, view, update, and delete tasks using terminal input, while persisting data via a local text file.

---

## 📌 Features

- 📋 **Add, remove, and complete tasks** from the terminal
- 🧠 **Stateful task manager** using dictionaries
- 🗃️ **Persistence** via a local `.txt` file
- 🕓 **Due date validation** and user input parsing
- 🔁 **Continuous loop UI** with smart user prompts
- 📅 **Date formatting & calendar support**
- ✅ **Status updates** with `TaskStatus` enum (`pending`, `completed`, `unknown`)
- 💥 **Error handling** using Swift enums & `throw`

---

## ⚙️ Technologies

- **Language**: Swift
- **Style**: Console I/O (`readLine`, `print`)
- **File I/O**: POSIX functions (`open`, `read`, `write`, `ftruncate`)
- **Persistence**: Text-based task serialization/deserialization
- **Architecture**: Custom classes + enums (`Task`, `TaskManager`, `TaskStatus`)

---

## 🧠 What I Learned
- Working with low-level file operations (open, read, write)

- Building interactive terminal applications in Swift

- Designing with structs, enums, and basic custom error handling

- Managing app state via dictionaries and clean separation of logic

## 📈 Future Improvements
 - JSON or Codable-based persistence

 - Sort by due date or completion status

 - Better file path handling (cross-platform)

 - Input sanitization for edge cases

 - CLI arguments or menu shortcuts

## 📸 Images 

  <img width="699" alt="Screenshot 2025-02-15 at 6 00 41 PM" src="https://github.com/user-attachments/assets/ba3a7a8e-ea73-45c1-9c6f-0eec63c0d66a" />



## 👨‍💻 Author

**Youssef Ashraf**  
iOS Developer | Computer Science Student  
[GitHub](https://github.com/yousseeefashrraf) · [YouTube](https://youtube.com/@YooussefAshraf)

