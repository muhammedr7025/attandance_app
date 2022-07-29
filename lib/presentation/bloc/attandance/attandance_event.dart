part of 'attandance_bloc.dart';

abstract class AttandanceEvent extends Equatable {
  const AttandanceEvent();

  @override
  List<Object> get props => [];
}

class MarkAttandanceEvent extends AttandanceEvent {
  final List<Student> presentStudentsList;
  final Attandance attandance;
  final Course course;
  final ClassRoom classroom;
  final List<Students> studentsList;
  final ClassAttandanceModel classAttandanceModel;
  const MarkAttandanceEvent({
    required this.presentStudentsList,
    required this.attandance,
    required this.classroom,
    required this.course,
    required this.studentsList,
    required this.classAttandanceModel,
  });
  @override
  List<Object> get props => [presentStudentsList];
}

class GetIndividualCourseAttandanceEvent extends AttandanceEvent {
  final String courseName;
  final String date;
  const GetIndividualCourseAttandanceEvent({
    required this.courseName,
    required this.date,
  });
  @override
  List<Object> get props => [
        courseName,
        date,
      ];
}
