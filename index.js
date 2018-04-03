import React, {PureComponent} from 'react';
import {requireNativeComponent, View, UIManager} from 'react-native';
import RCTFlurryAdView from './flurryAdView';

export default class FlurryAdView extends PureComponent {
  constructor (props) {
    super(props);
    this.state = {
      adData:null
    }
    props.ref(this);
  }

  refresh = () => {
    this._root.refresh();
  };

  _assignRoot = (component) => {
    this._root = component;
  };

  render () {
    return(
      <RCTFlurryAdView
        adSpaceName={this.props.adSpaceName}
        ref={this._assignRoot}
        onFetchSuccess={(event)=>{
          this.setState({adData:event.data})
        }}
      >
        {this.props.children(this.state.adData)}
      </RCTFlurryAdView>
    )
  }
}