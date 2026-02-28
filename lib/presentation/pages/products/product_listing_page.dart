import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../widgets/collapsible_header.dart';
import '../../widgets/product_card.dart';


class ProductListingPage extends ConsumerStatefulWidget {
  const ProductListingPage({super.key});

  @override
  ConsumerState<ProductListingPage> createState() =>
      _ProductListingPageState();
}

class _ProductListingPageState extends ConsumerState<ProductListingPage>
    with TickerProviderStateMixin {

  final PageController _pageController = PageController(initialPage: 0);
  final ScrollController _scrollController = ScrollController();


  TabController? _tabController;

  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _selectedCategoryIndex = page;
    });
    _tabController?.animateTo(page);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final currentUser = ref.watch(currentUserProvider);

    return categoriesAsync.when(
      data: (categories) {

        if (_tabController?.length != categories.length) {
          _tabController?.dispose();
          _tabController = TabController(
            length: categories.length,
            vsync: this,
            initialIndex: _selectedCategoryIndex,
          );
        }

        if (_pageController.hasClients &&
            _pageController.page?.toInt() != _selectedCategoryIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients) {
              _pageController.jumpToPage(_selectedCategoryIndex);
            }
          });
        }

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [

                  SliverAppBar(
                    expandedHeight: 150,
                    floating: false,
                    pinned: false,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CollapsibleHeader(
                        currentUser: currentUser,
                      ),
                    ),
                  ),
                  // Sticky tab bar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyTabBarDelegate(
                      tabBar: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorColor: Colors.blue,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        tabs: categories
                            .map((category) => Tab(
                          text: category.isNotEmpty
                              ? '${category[0].toUpperCase()}${category.substring(1).toLowerCase()}'
                              : category,
                        )).toList(),
                        onTap: (index) {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  // Product list with PageView for horizontal swipe
                  SliverFillRemaining(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const PageScrollPhysics(),
                      onPageChanged: _onPageChanged,
                      scrollBehavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return _ProductListView(
                          category: categories[index],
                          scrollController: _scrollController,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text('Error loading categories: $error',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(categoriesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductListView extends ConsumerWidget {
  final String category;
  final ScrollController scrollController;

  const _ProductListView({
    required this.category,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsByCategoryProvider(category));
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    return productsAsync.when(
      data: (products) {
        // Apply simple client-side search filtering
        final filtered = searchQuery.isEmpty
            ? products
            : products.where((p) {
          final title = p.title.toLowerCase();
          final desc = p.description.toLowerCase();
          return title.contains(searchQuery) || desc.contains(searchQuery);
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined,
                    size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No products in $category',
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Invalidate the provider for this category so new data is fetched
            ref.invalidate(productsByCategoryProvider(category));
            // Give a small delay to let UI show the indicator
            await Future.delayed(const Duration(milliseconds: 200));
          },
          child: ListView.builder(
            // Crucial: DO NOT use a new scroll controller here.
            // The scroll position is managed by CustomScrollView above.
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return ProductCard(product: filtered[index]);
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text('Error loading products: $error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}


class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _StickyTabBarDelegate({
    required this.tabBar,
    required this.backgroundColor,
  });

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}