import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/app/router/app_routes.dart';
import 'package:{{project_name.snakeCase()}}/features/home/presentation/pages/home_page.dart';
// [feature-imports] - `mason make feature` inserts imports above this line.

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (_, _) => const HomePage(),
    ),
    // [feature-routes] - `mason make feature` inserts routes above this line.
  ],
);
