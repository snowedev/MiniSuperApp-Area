import ModernRIBs

protocol TransportHomeDependency: Dependency {
	var cardOnFileRepository: CardOnFileRepository { get }
	var superPayRepository: SuperPayRespository { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency, TopupDependency {
	var topupBaseViewController: ViewControllable
	var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
	var superPayRepository: SuperPayRespository { dependency.superPayRepository }
	var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
	
	init (
		dependency: TransportHomeDependency,
		topupBaseViewController: ViewControllable
	) {
		self.topupBaseViewController = topupBaseViewController
		super.init(dependency: dependency)
	}
}

// MARK: - Builder

protocol TransportHomeBuildable: Buildable {
  func build(withListener listener: TransportHomeListener) -> TransportHomeRouting
}

final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
  
  override init(dependency: TransportHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TransportHomeListener) -> TransportHomeRouting {
    let viewController = TransportHomeViewController()
	let component = TransportHomeComponent(dependency: dependency, topupBaseViewController: viewController)
    
    let interactor = TransportHomeInteractor(presenter: viewController, dependency: component)
    interactor.listener = listener
    
	let topupBuiler = TopupBuilder(dependency: component)
	  
    return TransportHomeRouter(
      interactor: interactor,
      viewController: viewController,
	  topupBuildable: topupBuiler
    )
  }
}
