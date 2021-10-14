/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {
  StyleSheet,
  View,
  Image,
  Dimensions
} from 'react-native';
import Graphics from './src/react-native-graphics'

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      path: null
    }
  }
  componentDidMount() {
    let graphics = new Graphics(750, 950);

    graphics.drawImage('https://img0.fengqucdn.com/sf/skuInfos/1038522/022bac97865e90f40d49b42a0062bb60.jpg',
      0, 0, 750, 750);

    graphics.fillText('【滋润补水 润泽美肌】韩国Sulwhasoo雪花秀 雨润面膜 120ml', styles.title);

    graphics.drawBarcode('https://m.fengqu.com', 750 - 20 - 160, 760, 160, 160, 'https://img0.fengqucdn.com/cmsres/20161201/dcde7592-0a3f-475e-9f78-669f41982243.png', 50);

    graphics.fillText('¥1000', styles.price);
    graphics.fillText('¥2000', styles.orginPrice);

    graphics.draw()
      .then((path) => {

        this.setState({
          path
          })
        })
      .catch((error) => {
        console.log(error);
        })
  }

  render() {
    return (
      <View>
      {
        this.state.path &&
          <Image source={ {uri:this.state.path} } style={styles.image}/>
      }


      </View>
      );
  }
}
var windowSize =  Dimensions.get('window');
const styles = StyleSheet.create({
  title: {
    // 坐标相对图片，非屏幕
    top: 760,
    left: 20,
    width: 720 - 40 - 160 - 15,
    height: 200,
    fontSize: 26,
    fontWeight: 'bold',
    color: '#333333',
    // backgroundColor: '#ffffff',
    lineHeight: 10,
    // textAlign: 'center',
    // textDecorationLine:'underline',
    // textDecorationStyle:'solid',
    // textDecorationLine:'line-through'
    // textDecorationStyle:'double'
    // textDecorationStyle:'dotted'
    // textDecorationStyle:'dashed'
   // textDecorationColor :'#000000',
  },
  price: {
    // 坐标相对图片，非屏幕
    top: 880,
    left: 20,
    // 没有width和height，根据字计算
    // width: 720 - 40 - 160 - 15,
    // height: 200,
    fontSize: 32,
    fontWeight: 'bold',
    color: '#e62117',
    // backgroundColor: '#ffffff',
    lineHeight: 10,
    // textAlign: 'center',
    // textDecorationLine:'underline',
    // textDecorationStyle:'solid',
    // textDecorationLine:'line-through'
    // textDecorationStyle:'double'
    // textDecorationStyle:'dotted'
    // textDecorationStyle:'dashed'
   // textDecorationColor :'#000000',
  },
  orginPrice: {
    top: 886,
    // left: 20, // 不写left 拿上个组件的最右侧
    fontSize: 24,
    fontWeight: 'bold',
    color: '#999999',
    lineHeight: 10,
    textDecorationLine:'line-through',
    marginLeft: 5,
  },
  image: {
    width: windowSize.width,
    height: 900 / (750 / windowSize.width)
  }
});

export default App;
