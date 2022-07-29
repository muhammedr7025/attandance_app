import 'package:attandance_app/core/resources/pref_resources.dart';
import 'package:attandance_app/model/attandance_model.dart';
import 'package:attandance_app/model/class_attandance_model.dart';
import 'package:attandance_app/model/classroom.dart';
import 'package:attandance_app/model/course.dart';
import 'package:attandance_app/model/course_attandance.dart';
import 'package:attandance_app/model/student.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'attandance_event.dart';
part 'attandance_state.dart';

class AttandanceBloc extends Bloc<AttandanceEvent, AttandanceState> {
  final _firebaseFirestore = FirebaseFirestore.instance;
  AttandanceBloc() : super(AttandanceInitial()) {
    on<MarkAttandanceEvent>(_markAttandance);
    on<GetIndividualCourseAttandanceEvent>(_getIndividualCourseAttandance);
  }

  _markAttandance(
      MarkAttandanceEvent event, Emitter<AttandanceState> emit) async {
    emit(AttandanceInitial());
    emit(AttandanceLoading());
    try {
      for (var i = 0; i < event.presentStudentsList.length; i++) {
        await _firebaseFirestore
            .collection(PrefResources.STUDENT)
            .doc(event.presentStudentsList[i].name)
            .collection('attandance')
            .doc(DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now()))
            .set(event.attandance.toMap());

        // await _firebaseFirestore
        //     .collection('course')
        //     .doc(event.course.name)
        //     .collection(event.classroom.name)
        //     .doc()
        //     .set({
        //   'totalHoursTaken':
        //       (int.parse(event.course.totalHoursTaken) + 1).toString(),
        // });
        await _firebaseFirestore
            .collection('course')
            .doc(event.course.name)
            .update({
          'totalHoursTaken':
              (int.parse(event.course.totalHoursTaken) + 1).toString(),
        });
        for (var i = 0; i < event.studentsList.length; i++) {
          await _firebaseFirestore
              .collection('Attandance')
              .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()))
              .set(
                event.classAttandanceModel.toMap(),
              );
        }
        await _firebaseFirestore
            .collection('course')
            .doc(event.course.name)
            .collection('courseTakenDates')
            .add(CourseAttandance(dateTime: DateTime.now().toString()).toMap());
        emit(MarkAttandanceLoaded());
      }
    } on FirebaseException catch (e) {
      emit(AttandanceError(error: e.message!));
    }
  }

  _getIndividualCourseAttandance(GetIndividualCourseAttandanceEvent event,
      Emitter<AttandanceState> emit) async {
    emit(AttandanceInitial());
    emit(AttandanceLoading());
    ClassAttandanceModel attandace;
    try {
      final response = await _firebaseFirestore
          .collection('attandance')
          .doc(event.date)
          .get();
      // final res = response.docs
      //     .map((docSnap) => Attandance.fromMap(docSnap.data()))
      //     .toList();
      final res = ClassAttandanceModel.fromMap(response.data()!);
      attandace = res;
      emit(IndividualCourseAttandanceLoaded(classAttandance: attandace));
    } on FirebaseException catch (e) {
      emit(AttandanceError(error: e.message!));
    }
  }
}
