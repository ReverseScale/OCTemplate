import React, { Component } from 'react';
 import {
   AppRegistry,
   StyleSheet,
   Text,
   View,
   Image
 } from 'react-native';
 
class Main extends Component {
   render() {
     return (
       <View style={styles.container}>
         <Text style={styles.welcome}>Welcome to React Native</Text>
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