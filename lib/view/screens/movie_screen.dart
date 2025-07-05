import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_movie_app/controller/provider/movie_provider.dart';
import 'package:tmdb_movie_app/view/widgets/movie_card_widget.dart';
import 'package:tmdb_movie_app/view/widgets/movie_error_widget.dart';
import 'package:tmdb_movie_app/view/widgets/movie_load_more_widget.dart';
import 'package:tmdb_movie_app/view/widgets/movie_loading_widget.dart';
import 'package:tmdb_movie_app/view/widgets/no_result_widget.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchTrendingMovies();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<MovieProvider>();
      if (provider.isSearchMode) {
        provider.loadMoreSearchResults();
      } else {
        provider.fetchTrendingMovies();
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<MovieProvider>().clearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<MovieProvider>().onSearchChanged(value);
                },
              )
            : const Text(
                'Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: !_isSearching,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: _toggleSearch,
          ),
          if (!_isSearching)
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
          if (movieProvider.isCurrentlyLoading &&
              movieProvider.currentMovies.isEmpty) {
            return MovieLoadingWidget(
              message: movieProvider.isSearchMode
                  ? 'Searching movies...'
                  : 'Loading movies...',
            );
          }

          if (movieProvider.currentErrorMessage != null &&
              movieProvider.currentMovies.isEmpty) {
            return MovieErrorWidget(
              errorMessage: movieProvider.currentErrorMessage!,
              onRetry: () {
                if (movieProvider.isSearchMode &&
                    movieProvider.searchQuery.isNotEmpty) {
                  movieProvider.searchMovies(movieProvider.searchQuery,
                      isRefresh: true);
                } else {
                  movieProvider.fetchTrendingMovies(isRefresh: true);
                }
              },
            );
          }

          if (movieProvider.currentMovies.isEmpty &&
              movieProvider.isSearchMode) {
            return const NoResultsWidget();
          }

          return Column(
            children: [
              if (movieProvider.isSearchMode)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFF1A1A1A),
                  child: Text(
                    'Search results for "${movieProvider.searchQuery}"',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (movieProvider.isSearchMode &&
                        movieProvider.searchQuery.isNotEmpty) {
                      await movieProvider.searchMovies(
                          movieProvider.searchQuery,
                          isRefresh: true);
                    } else {
                      await movieProvider.fetchTrendingMovies(isRefresh: true);
                    }
                  },
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
                              if (index < movieProvider.currentMovies.length) {
                                return MovieCard(
                                    movie: movieProvider.currentMovies[index]);
                              }
                              return null;
                            },
                            childCount: movieProvider.currentMovies.length,
                          ),
                        ),
                      ),
                      if (movieProvider.isCurrentlyLoadingMore)
                        const SliverToBoxAdapter(
                          child: LoadMoreWidget(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
