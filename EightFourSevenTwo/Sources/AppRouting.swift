enum AppRouting {}

extension AppRouting {
    static func rootView() -> MainView {
        let viewModel = MainViewModel()
        let view = MainView(viewModel: viewModel)
        return view
    }
}

