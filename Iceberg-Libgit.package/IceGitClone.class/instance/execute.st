actions
execute

	| repo cloneOptions |
	location exists
		ifTrue: [ IceCloneLocationAlreadyExists signalFor: location ].
	
	[location ensureCreateDirectory.
	
	repo := LGitRepository on: location.
	cloneOptions := LGitCloneOptions withCredentialsProvider: (IceCredentialsProvider defaultForRemoteUrl: url).
	cloneOptions checkoutOptions checkoutStrategy: LGitCheckoutStrategyEnum git_checkout_force.

	repo clone: url options: cloneOptions.

	(LGitRemote of: repo named: 'origin')
		lookup;
		setUrl: url.
		
	] on: LGitCallReturnHandler , IceWrongUrl do: [ :error |
		location exists ifTrue: [ location ensureDeleteAll ].
		error acceptError: (IceLibgitErrorVisitor onContext: self) ].