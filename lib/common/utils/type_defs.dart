import 'package:fpdart/fpdart.dart';
import 'package:freedom_chat/models/error_model.dart';

typedef FutureEither<T> = Future<Either<ErrorModel, T>>;
typedef FutureVoid = FutureEither<void>;
