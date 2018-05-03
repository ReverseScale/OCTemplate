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
         <Text style={styles.welcome}>Welcome to React Native</Text>

         <TouchableOpacity style={{height:30}}
                            onPress={()=>{
                RNCalliOSAction.calliOSActionWithOneParams('hello');
            }}>
              <Text>点击调用iOS原生方法,RN向iOS传递一个参数</Text>
          </TouchableOpacity>

       </View>
     );
   }
 }
 
 const styles = StyleSheet.create({
   container: {
     flex: 1,
     justifyContent: 'center',
     alignItems: 'center',
     backgroundColor: '#87e6e3',
   },
   welcome: {
     fontSize: 20,
     color: "#FFFFFF",
   },
 });
 
 AppRegistry.registerComponent('OCTemplate', () => Main);