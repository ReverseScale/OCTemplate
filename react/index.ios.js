import React, { Component } from 'react';
 import {
   Text,
   View,
   Image,
   AppRegistry,
   StyleSheet,
   TouchableOpacity,
   NativeAppEventEmitter, 
   NativeModules,
   NativeEventEmitter,
 } from 'react-native';

var RNCalliOSAction = NativeModules.RNCalliOSAction;
var NativeModule = new NativeEventEmitter(RNCalliOSAction)
class Main extends Component {

  constructor(props){
    super(props);

    this.state={
        callBackData:'',
        PromisesData:'',
        selectDate:'',
    }
  }
  
  componentDidMount (){
    this.listener = NativeAppEventEmitter.addListener('getSelectDate',(data)=>{
        this.setState({
            selectDate:data.SelectDate,
        })
    })
    // NativeModule.addListener("sendName",(body) => this._getNotice(body))
    this.listener = NativeAppEventEmitter.addListener("sendName",(body) => this._getNotice(body))
  }

  _getNotice (body) {
    this.setState({
        notice:body.name+','+body.age
    })
  } 

  componentWillUnmount(){
    this.listener && this.listener.remove();
    this.listener = null;
}

  //Promises 回调  异步执行方法
  async PromisesCallBack(){
    console.log('PromisesCallBack');
    //try catch确保程序正确执行
    try {
        console.log('RNCalliOSAction'+RNCalliOSAction);
        //await  是等待获取回调值以后在进行下一步的操作
        var events=await RNCalliOSAction.calliOSActionWithResolve();
        this.setState({
            PromisesData: events,
        });
        console.log('Promises回调：'+events);
    } catch (error) {
        console.log('Promises回调error：'+error);
    }
}

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
                  params1:'React',
                  params2:'call',
                  params3:'iOS'
              });
          }}>
            <Text>点击调用 Native 方法, 并传递一个 json 数据</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.calltonative}
                          onPress={()=>{
              RNCalliOSAction.calliOSActionWithArrayParams([
                  'React',
                  'call',
                  'iOS'
              ]);
          }}>
            <Text>点击调用 Native 方法, 并传递一个数组</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.calltonative}
                          onPress={()=>{
              RNCalliOSAction.calliOSActionWithActionSheet();
          }}>
            <Text>点击调用 Native 方法, 弹出 ActionSheet</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.calltonativecallback}
                          onPress={()=>{
                              //此处的(string,array)参数列表要和回调时传的参数列表要一致。位置一样才可以获取正确的数据
              RNCalliOSAction.calliOSActionWithCallBack((string,array,end)=>{
                  console.log(string);
                  console.log(array);
                  console.log(end);
                  let data=string+'  '+array[0]+'  '+array[1]+'  '+array[2]+'  '+end;

                  this.setState({
                      callBackData:data,
                  })

              });
          }}>
            <Text>点击调用 Native 方法, 并回调</Text>
            <Text>回调结果 callBack：{this.state.callBackData}</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.calltonativecallback}
                            onPress={()=>{
                                this.PromisesCallBack();
          }}>
          <Text>点击调用 Native 方法, Promises 回调</Text>
          <Text>回调结果 Promises：{this.state.PromisesData}</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.calltonativecallback}
                            onPress={()=>{
                                RNCalliOSAction.RNCalliOSToShowDatePicker();
            }}>
              <Text>点击调用 Native 方法, 弹出时间选取器</Text>
              <Text>选取的时间：{this.state.selectDate}</Text>
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
     fontSize: 22,
     color: "#FFFFFF",
     height:50,
   },
   calltonative: {
     height:30,
   },
   calltonativecallback: {
    height:60,
  },
 });
 
 AppRegistry.registerComponent('OCTemplate', () => Main);