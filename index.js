import React, {PureComponent, PropTypes} from 'react';
import {requireNativeComponent, View, UIManager} from 'react-native';

class FlurryAdView extends PureComponent {
  constructor (props) {
    super(props);
    this.state = {
      adData:null
    }
    this._onFetchSuccess = this._onFetchSuccess.bind(this);
    this._onFetchError = this._onFetchError.bind(this);
    this._onReceivedClick = this._onReceivedClick.bind(this);
    this.fetched = false;
  }

  refresh = () => {
    this.fetched = false;
    this.setState({adData:null});
    UIManager.dispatchViewManagerCommand(
      ReactNative.findNodeHandle(this.flurryAdViewInstance),
      UIManager.RCTFlurryAdView.Commands.refresh,
      [],
    );
  };

  _onFetchError(event: Event) {
    if (!this.props.onFetchError) {
      return;
    }
    this.props.onFetchError();
  }

  _onFetchSuccess(event: Event) {
    this.fetched = true;
    this.setState({adData:event.nativeEvent.adData})
    if (!this.props.onFetchSuccess) {
      return;
    }
    this.props.onFetchSuccess();
  }

  _onReceivedClick(event: Event) {
    if (!this.props.onReceivedClick) {
      return;
    }
    this.props.onReceivedClick();
  }

  render () {
    const height = this.fetched ? this.props.contentStyle.height : 0;
    return(
      <RCTFlurryAdView
        {...this.props}
        style={[this.props.contentStyle,{height: height}]}
        ref={(ref)=>{this.flurryAdViewInstance = ref}}
        onFetchSuccess={this._onFetchSuccess}
        onFetchError={this._onFetchError}
        onReceivedClick={this._onReceivedClick}
      >
        {this.props.children(this.state.adData)}
      </RCTFlurryAdView>
    )
  }
}

FlurryAdView.propTypes = {
  ...View.propTypes,
  adSpaceName: PropTypes.string,
};

const RCTFlurryAdView = requireNativeComponent('RCTFlurryAdView', FlurryAdView, {
  nativeOnly: {
    onFetchSuccess: true,
    onFetchError: true,
    onReceivedClick: true

  }
});

module.exports = FlurryAdView;