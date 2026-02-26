# Daraz Clone - Flutter E-Commerce App

A production-ready Flutter application demonstrating Daraz-style product listing with proper scroll management, tab navigation, and user authentication.

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Features

 **User Authentication** - Select from FakeStore API users
 **Category Browsing** - Dynamic category tabs with swipe navigation
 **Smart Scrolling** - Single scroll hierarchy, no jitter
 **Pull-to-Refresh** - Refresh products from any position
 **Sticky Tab Bar** - Remains visible when header collapses
 **Product Details** - View full product info in bottom sheet
 **Clean Architecture** - Separation of UI, business logic, and data layers

## Architecture

- **Presentation**: Flutter UI with Riverpod state management
- **Domain**: Business logic and use cases
- **Data**: API client and data models
- **Core**: Constants, utilities, and theme

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed explanation of:
1. How horizontal swipe works without interfering with vertical scroll
2. Who owns the vertical scroll and why (CustomScrollView)
3. How tab position is preserved across swipes
4. Trade-offs and limitations

## Key Technical Decisions

| Decision | Why |
|----------|-----|
| **CustomScrollView** | Single scroll owner prevents conflicts and jitter |
| **PageView inside SliverFillRemaining** | Handles horizontal swipes independently |
| **Manual controller sync** | TabController and PageController stay in sync |
| **Riverpod FutureProvider.family** | Separate cache per category, no redundant API calls |
| **RemoteDataSource pattern** | Clean separation between API and domain layers |

## Stack

- **Framework**: Flutter 3.9.2
- **State Management**: Riverpod 2.4.0
- **HTTP**: http 1.1.0
- **Image Caching**: cached_network_image 3.3.1
- **API**: FakeStore API (https://fakestoreapi.com)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/                     # Constants, theme, utilities
├── data/                     # API client, models, repositories
├── domain/                   # Entities, interfaces, use cases
└── presentation/             # Pages, widgets, providers
    ├── pages/
    │   ├── auth/             # Login page
    │   └── products/         # Product listing page
    ├── widgets/              # Reusable components
    └── providers/            # Riverpod providers
```

## Usage

1. **Start**: Run the app - shows login page
2. **Select User**: Tap any user to proceed
3. **Browse**: Swipe between categories or tap tab bar
4. **Refresh**: Pull down to refresh products
5. **Details**: Tap a product card to see full info
6. **Logout**: Tap logout button in header to return to login

## Common Issues

| Issue | Solution |
|-------|----------|
| Scroll jumps between tabs | Scroll state is preserved by CustomScrollView |
| Tab bar not visible | It's pinned via SliverPersistentHeader |
| Swipe doesn't work | Ensure horizontal gesture is inside PageView |

## Next Steps

- [ ] Add pagination for large product lists
- [ ] Implement product search
- [ ] Add local caching (offline support)
- [ ] Create wishlist/cart features
- [ ] Add checkout flow

See [ARCHITECTURE.md](ARCHITECTURE.md) for full technical documentation.

---

**Questions?** Check ARCHITECTURE.md for detailed implementation explanations.

