import { NativeModules } from 'react-native';
const { RNGraphics } = NativeModules;

export default class Graphics {
  constructor(width, height) {
    // super();
    this.width = width;
    this.height = height;
    this.cmds = [];
  }

  fillText(text, styles) {
    let style = {};

    if (typeof styles == 'array') {
      styles.forEach((item) => {
        style = {
          ...style,
          ...item
        }
      });
    } else if (typeof styles == 'object') {
      style = styles;
    }

    this.cmds.push({
      'cmd': 'fillText',
      text,
      style
    })
  }

  drawImage(imageUrl, x, y, w, h) {
    this.cmds.push({
      'cmd': 'drawImage',
      imageUrl,
      x,
      y,
      w,
      h,
    })
  }

  drawBarcode(code, x, y, w, h, iconUrl, iconWidth) {
    this.cmds.push({
      'cmd': 'drawBarcode',
      code,
      x,
      y,
      w,
      h,
      iconUrl,
      iconWidth
    })
  }

  // fill() {
  //   this.cmds.push({
  //     'cmd': 'fill',
  //   })
  // }

  draw(ignoreImageDownloadError = true) {
    return new Promise((resolve, reject) => {
       RNGraphics && RNGraphics.draw(this.cmds, this.width, this.height, ignoreImageDownloadError)
       .then((result) => {
         if (result) {
           resolve(result);
         }
       })
       .catch((error) => {
         reject(error);
       });
     });
  }
}
