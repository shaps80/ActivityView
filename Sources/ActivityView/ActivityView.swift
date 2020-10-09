import SwiftUI
import LinkPresentation
import CoreServices

extension View {

    public func activity(isPresented: Binding<Bool>, items: [Any], activities: [UIActivity]? = nil, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) -> some View {
        background(ActivityView(isPresented: isPresented, items: items, activities: activities, onComplete: onComplete))
    }

}

private struct ActivityView: UIViewControllerRepresentable {

    private let activityItems: [Any]
    private let applicationActivities: [UIActivity]?
    private let completion: UIActivityViewController.CompletionWithItemsHandler?

    @Binding var isPresented: Bool

    public init(isPresented: Binding<Bool>, items: [Any], activities: [UIActivity]? = nil, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        _isPresented = isPresented
        activityItems = items
        applicationActivities = activities
        completion = onComplete
    }

    func makeUIViewController(context: Context) -> _ActivityWrapper {
        _ActivityWrapper(isPresented: $isPresented, activityItems: activityItems, applicationActivities: applicationActivities, onComplete: completion)
    }

    func updateUIViewController(_ uiViewController: _ActivityWrapper, context: Context) {
        uiViewController.isPresented = $isPresented
        uiViewController.completion = completion
        uiViewController.updateState()
    }

}

private final class _ActivityWrapper: UIViewController {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    var isPresented: Binding<Bool>
    var completion: UIActivityViewController.CompletionWithItemsHandler?

    init(isPresented: Binding<Bool>, activityItems: [Any], applicationActivities: [UIActivity]? = nil, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateState()
    }

    fileprivate func updateState() {
        let isActivityPresented = presentedViewController != nil

        if isActivityPresented != isPresented.wrappedValue {
            if !isActivityPresented {
                let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
                controller.popoverPresentationController?.sourceView = view
                controller.completionWithItemsHandler = { [weak self] (activityType, success, items, error) in
                    self?.isPresented.wrappedValue = false
                    self?.completion?(activityType, success, items, error)
                }
                present(controller, animated: true, completion: nil)
            }
        }
    }

}

private struct ShareView: View {
    @State private var isPresented = false

    var body: some View {
        return Button("Share") { isPresented = true }
            .activity(
                isPresented: $isPresented,
                items: ["text"]
            )
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView()
    }
}
