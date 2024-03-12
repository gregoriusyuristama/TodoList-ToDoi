// StreamBuilder<QuerySnapshot>(
//                     stream: DBServices.db.snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return EmptyTodo(
//                           availableHeight: constraints.maxHeight * 0.7,
//                           availableWidth: constraints.maxWidth,
//                         );
//                       } else {
//                         final data = snapshot.data!.docs;
//                         return ListView.builder(
//                           itemBuilder: (context, index) {
//                             ToDo todoItem = ToDo(
//                                 id: data[index]['to_do_id'],
//                                 todoName: data[index]['to_do_text'],
//                                 priority: data[index]['to_do_prio'],
//                                 todoDone: data[index]['to_do_done']);
//                             return TodoCard(
//                               constraints.maxWidth,
//                               constraints.maxHeight,
//                               todoItem,
//                               () {
//                                 todoItem.toggleDone();
//                                 FirebaseFirestore.instance
//                                     .collection('user')
//                                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                                     .collection('to_dos')
//                                     .doc(todoItem.id)
//                                     .update(
//                                   {
//                                     'to_do_done': todoItem.todoDone,
//                                   },
//                                 );
//                                 ;
//                               },
//                             );
//                           },
//                           itemCount: snapshot.data?.size,
//                         );
//                       }
//                     },
//                   )