# Daraz-Style Product Listing App

A Flutter e-commerce application built with clean architecture principles, mimicking Daraz's product listing UI with proper scroll handling, tab navigation, and user authentication.

## Architecture Overview

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Framework & utilities
│   ├── constants/          # API endpoints
│   ├── theme/              # Theme configuration
│   └── utils/              # Utility functions
├── data/                    # Data layer (external)
│   ├── datasources/        # Remote/local data sources
│   ├── models/             # Data models (JSON serializable)
│   └── repositories/       # Repository implementations
├── domain/                  # Business logic layer (pure)
│   ├── entities/           # Pure Dart entities
│   ├── repositories/       # Abstract repository interfaces
│   └── usecases/           # Use case implementations
└── presentation/            # UI layer (widgets, pages)
    ├── pages/              # Screen pages
    ├── providers/          # Riverpod state management
    └── widgets/            # Reusable UI components
```

## Key Features

### 1. **Single Vertical Scroll Ownership** ✓
- **Custom ScrollView** manages the entire vertical scroll hierarchy
- No nested scrollables to prevent jitter or scroll conflicts
- Scroll position persists when switching tabs

### 2. **Horizontal Swipe Navigation**
- **PageView** handles horizontal swiping between categories
- Isolated gesture handling that doesn't interfere with vertical scrolling
- Physics: `PageScrollPhysics()` ensures smooth, predictable swipes
- Tab position synchronized with PageView page index

### 3. **Sticky Tab Bar**
- Uses `SliverPersistentHeader` with `pinned: true`
- Remains visible when header collapses
- Automatically scrolls with collapsible header
- Supports both tap and swipe navigation

### 4. **Pull-to-Refresh**
- Works from any tab position
- Uses `RefreshIndicator` at the product list level
- Triggers API refresh without scroll position reset

## Architecture Decisions Explained

### Why Single CustomScrollView?

```dart
CustomScrollView(
  controller: _scrollController,
  slivers: [
    SliverAppBar(),           // Collapsible header
    SliverPersistentHeader(), // Sticky tab bar
    SliverFillRemaining(      // PageView for horizontal nav
      child: PageView(...)
    ),
  ],
)
```

**Benefits:**
- One scroll controller = one source of truth
- No nested scrollables = no conflicts
- Scroll position preserved across tab changes
- Tab bar sticks at exact pinned position

### Horizontal Swipe Implementation

The `PageView` is placed inside `SliverFillRemaining` which:
1. **Fills remaining space** after header/tab bar
2. **Respects vertical scroll** - doesn't create new scroll context
3. **Handles horizontal gestures independently** - uses `PageScrollPhysics()`

**Key physics settings:**
```dart
PageView(
  physics: const PageScrollPhysics(), // Page snapping + velocity
  scrollBehavior: ScrollConfiguration.of(context)
      .copyWith(scrollbars: false),
)
```

This ensures:
- Horizontal swipes don't trigger vertical scroll
- Momentum scrolling ends on page boundary
- No gesture conflicts

### Tab Position Management

```dart
void _onPageChanged(int page) {
  setState(() => _selectedCategoryIndex = page);
  _tabController.animateTo(page); // Sync TabBar
}

// Tap handling
onTap: (index) {
  setState(() => _selectedCategoryIndex = index);
  _pageController.animateToPage(index); // Sync PageView
}
```

**Why this matters:**
- TabBar and PageView are separate controllers
- Manual index synchronization prevents conflicts
- Both controllers animate to same position simultaneously

## State Management (Riverpod)

### Service Layer (`service_provider.dart`)
Provides dependency injection:
```dart
final httpClientProvider = Provider((ref) => http.Client());
final productRepositoryProvider = Provider<ProductRepository>(...);
final getProductsUseCaseProvider = Provider(...);
```

### App State (`app_state_provider.dart`)
Manages business state:
```dart
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final productsByCategoryProvider = FutureProvider.family(...);
```

**Family vs regular provider:**
- `FutureProvider.family` creates separate cache per category
- Prevents unnecessary API calls when switching tabs
- Maintains loading state per category

## Authentication Flow

1. **Login Page** displays all available users from FakeStore API
2. User selects an account → stored in `selectedUserIdProvider`
3. User profile displayed in collapsible header
4. Logout button navigates back to login

## API Integration

Uses **FakeStore API** (`https://fakestoreapi.com`):

### Endpoints Used
- `GET /products` - All products
- `GET /products/categories` - Category list
- `GET /products/category/{name}` - Products by category
- `GET /users` - All users
- `GET /users/{id}` - User details

### Error Handling
- Try-catch blocks in repositories
- Loading states in UI
- Error widgets with retry buttons
- Timeout: 10 seconds per request
