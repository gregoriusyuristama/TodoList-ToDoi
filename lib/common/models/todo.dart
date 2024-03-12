class ToDo {
  String id;
  String todoName;
  int priority;
  bool todoDone;
  String dueDate;

  ToDo({
    required this.id,
    required this.todoName,
    required this.priority,
    this.todoDone = false,
    this.dueDate = 'no',
  });

  bool hasDueDate() {
    if (dueDate == 'no') {
      return false;
    }
    return true;
  }

  void setDueDate(String setDate) {
    dueDate = setDate;
  }

  String getDueDate() {
    return dueDate;
  }

  void toggleDone() {
    todoDone = !todoDone;
  }
}
