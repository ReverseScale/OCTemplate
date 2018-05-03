import React, { Component } from 'react';
 import {
   AppRegistry,
   StyleSheet,
   TouchableOpacity,
   NativeModules,
   Text,
   View,
   Image
 } from 'react-native';

var RNCalliOSAction = NativeModules.RNCalliOSAction;
 
class Main extends Component {
   render() {
     return (
       <View style={styles.container}>
         <Text style={styles.welcome}>React 和 Native 通信</Text>
         <TouchableOpacity style={styles.calltonative}
                            onPress={()=>{
                RNCalliOSAction.calliOSActionWithOneParams('hello');
            }}>
              <Text>点击调用 Native 方法, 并传递一个参数</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.calltonative}
                            onPress={()=>{
                RNCalliOSAction.calliOSActionWithSecondParams('hello','iOS');
            }}>
              <Text>点击调用 Native 方法, 并传递两个参数</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.calltonative}
                            onPress={()=>{
                RNCalliOSAction.calliOSActionWithDictionParams({
                    params1:'RN',
                    params2:'call',
                    params3:'iOS'
                });
            }}>
              <Text>点击调用 Native 方法, 并传递一个 json 数据</Text>
          </TouchableOpacity>

          <TouchableOpacity style={{height:30}}
                            onPress={()=>{
                RNCalliOSAction.calliOSActionWithArrayParams([
                    'RN',
                    'call',
                    'iOS'
                ]);
            }}>
              <Text>点击调用 Native 方法, 并传递一个数组</Text>
          </TouchableOpacity>

          <TouchableOpacity style={{height:30}}
                            onPress={()=>{
                RNCalliOSAction.calliOSActionWithActionSheet();
            }}>
              <Text>点击调用 Native 方法, 弹出 ActionSheet</Text>
          </TouchableOpacity>

       </View>
     );
   }
 }
 
 const styles = StyleSheet.create({
   container: {
     flex: 1,
     justifyContent: 'center',
     top: -50,
     alignItems: 'center',
     backgroundColor: '#87e6e3',
   },
   welcome: {
     fontSize: 20,
     color: "#FFFFFF",
     height:45,
   },
   calltonative: {
     height:30,
   },
 });
 
 AppRegistry.registerComponent('OCTemplate', () => Main);