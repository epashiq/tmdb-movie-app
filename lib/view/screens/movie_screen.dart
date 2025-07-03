import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_movie_app/controller/provider/movie_provider.dart';
import 'package:tmdb_movie_app/view/widgets/movie_card_widget.dart';
import 'package:tmdb_movie_app/view/widgets/movie_error_widget.dart';
import 'package:tmdb_movie_app/view/widgets/movie_load_more_widget.dart';
import 'package:tmdb_movie_app/view/widgets/movie_loading_widget.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchTrendingMovies();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MovieProvider>().fetchTrendingMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Trending Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context
                  .read<MovieProvider>()
                  .fetchTrendingMovies(isRefresh: true);
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading && movieProvider.movies.isEmpty) {
            return const MovieLoadingWidget();
          }

          if (movieProvider.errorMessage != null &&
              movieProvider.movies.isEmpty) {
            return MovieErrorWidget(
              errorMessage: movieProvider.errorMessage!,
              onRetry: () => movieProvider.fetchTrendingMovies(isRefresh: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => movieProvider.fetchTrendingMovies(isRefresh: true),
            backgroundColor: const Color(0xFF1A1A1A),
            color: Colors.orange,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < movieProvider.movies.length) {
                          return MovieCard(movie: movieProvider.movies[index]);
                        }
                        return null;
                      },
                      childCount: movieProvider.movies.length,
                    ),
                  ),
                ),
                if (movieProvider.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: LoadMoreWidget(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
