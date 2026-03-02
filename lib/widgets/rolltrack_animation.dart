import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RolltrackAnimation extends StatefulWidget {
	const RolltrackAnimation({super.key, this.height = 180});
	final double height;

	@override
	State<RolltrackAnimation> createState() => _RolltrackAnimationState();
}

class _RolltrackAnimationState extends State<RolltrackAnimation> {
	late final FileLoader _fileLoader = FileLoader.fromAsset(
		'lib/animation_assets/rolltrack.riv',
		riveFactory: Factory.rive,
	);

	@override
	void dispose() {
		_fileLoader.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			height: widget.height,
			child: RiveWidgetBuilder(
				fileLoader: _fileLoader,
				builder: (context, state) {
					if (state is RiveLoading) {
						return const Center(child: CircularProgressIndicator());
					} else if (state is RiveFailed) {
						return Center(
							child: Text(
								'Failed to load animation: ${state.error}',
								style: const TextStyle(color: Colors.red),
							),
						);
					} else if (state is RiveLoaded) {
						return RiveWidget(
							controller: state.controller,
							fit: Fit.contain,
						);
					}
					return const SizedBox();
				},
			),
		);
	}
}
