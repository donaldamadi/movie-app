import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env_config.dart';
import 'movie.dart';
export 'movie.dart';

final dioProvider = Provider((ref) {
  return Dio(BaseOptions(
    baseUrl: EnvironmentConfig.BASE_URL,
  ));
});

final movieTypeProvider = StateProvider((ref) => MovieType.popular);

final moviesProvider = FutureProvider<List<Movie>>((ref) async {
  final movieType = ref.watch(movieTypeProvider.state).state;
  final dio = ref.watch(dioProvider);
  final response = await dio.get('movie/${movieType.value}', queryParameters: {'api_key': EnvironmentConfig.API_KEY});
  return MovieResponse.fromJson(response.data).results;
});

// final similarMovieProvider = FutureProvider<List<Movie>>((ref) async {
//   final movie = ref.watch(movieProvider).state.first;
//   final dio = ref.watch(dioProvider);
//   final response = await dio.get('movie/${movie.id}/similar', queryParameters: {'api_key': EnvironmentConfig.API_KEY});
//   return MovieResponse.fromJson(response.data).results;
// });

final movieProvider = Provider(
  (ref) => Movie(
    title: 'Math',
    releaseDate: '58943456',
    voteAverage: 4.5,
    id: 1,
    overview: 'blwkefnlfenff',
  ),
);

final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter(ref);
});

class Counter extends StateNotifier<int> {
  Counter(this.ref) : super(0);

  final Ref ref;

  int increment() {
    // Counter can use the "ref" to read other providers
    // final repository = ref.read();
    // repository.post('...');
    state++;
    state++;
    return state;
  }
}

abstract class PageState {}

class PageLoading extends PageState {}

class PageLoadingStopped extends PageState {}

class PageError extends PageState {}

class PageRating extends PageState {}

class PageLoaded extends PageState {
  final dynamic mood;

  PageLoaded(this.mood);
}

class PageNotifier extends StateNotifier<PageState> {
  PageNotifier(this.ref) : super(PageLoading());

  Ref ref;

 Future rateMovie({@required double rating, @required String id}) async {
    try {
      Map<String, dynamic> _payload = {
        'value': rating.toString(),
      };
      state = PageLoading();
      final dio = ref.watch(dioProvider);

      final response = await dio.post('/movie/$id/rating', data: _payload, queryParameters: {'api_key': EnvironmentConfig.API_KEY});

      debugPrint(response.statusCode.toString());
      fetchSimilarMovies(
        id: id,
      );
    } catch (e) {
      debugPrint('There is an error ${e.response.data['status_message']}');
      state = PageError();
    }
  }

  Future<void> fetchSimilarMovies({String id = ''}) async {
    try {
      state = PageLoading();

      final dio = ref.watch(dioProvider);
      debugPrint('id: $id');
      final response = await dio.get('movie/$id/similar', queryParameters: {'api_key': EnvironmentConfig.API_KEY});

      debugPrint(response.statusCode.toString());

      state = PageLoaded(MovieResponse.fromJson(response.data).results);
    } catch (error) {
      debugPrint('There is an error ${error.response.statusCode}');
      state = PageError();
    }
  }
}

final pageProvider = StateNotifierProvider<PageNotifier, PageState>((ref) => PageNotifier(ref));
