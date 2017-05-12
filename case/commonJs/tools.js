function $(id) {
    var element = document.getElementById(id);
    console.print("$:"+id+" "+element);
    return element;
}

/**
 *  可以获取当前页面指定元素的值。
 *
 *  @param id 页面元素ID
 *
 *  @return
 */
function getValue(id) {
    var element = document.getElementById(id);
    var value = element.attributeForName('value');
    return value.toString();
}
function log(msg){
    console.print(msg);
}
/**
 *  设置当前页面指定元素的值
 *
 *  @param id    要设置的元素的id值。
 *  @param value 要设置的元素值。
 *
 *  @return
 */
function setValue(id, value) {
    var element = document.getElementById(id);
    element.setAttribute("value", value);
}


function getAttibute(id, attributeName) {
    var element = document.getElementById(id);
    var value = element.attributeForName(attributeName);
    log(value);
    return value;
}

/**
 *  设置当前页面指定元素的指定属性值
 *
 *  @param id             要设置的元素的id值。
 *  @param attributeName  要设置的属性名
 *  @param attributeValue 要设置的属性值。
 *
 *  @return
 */
function setAttribute(id, attributeName, attributeValue) {
    var element = document.getElementById(id);
    element.setAttribute(attributeName, attributeValue);
}


/**
 *  设置当前页面指定元素的样式。
 *
 *  @param id         要设置的元素的id值。
 *  @param styleName  要设置的样式名。
 *  @param styleValue 要设置的样式值。
 *
 *  @return
 */
function setStyle(id, styleName, styleValue) {
    var element = document.getElementById(id);
    element.setStyle(styleName, styleValue);
}



/**
 *  可以删除当前页面的指定元素。
 *
 *  @param pid 要删除的元素的父级的id值。
 *  @param id  要删除的元素id值。
 *
 *  @return
 */
function removeChild(pid, id) {
    var element = document.getElementById(pid);
    element.removeChild(id);
}


/**
 *  可以清空当前页面的指定元素的子节点
 *
 *  @return 
 */
function removeChildren(id) {
    var element = document.getElementById(id);
    element.removeChild(id);
}

/**
 *  可以向当前页面的指定元素插入子节点。
 *
 *  @param id        要插入的元素id值。
 *  @param direction 要插入HSML的方向，向下增长或者向上增长，up：向上增长，其他参数都向下增长
 *  @param TMLString 要插入的TML字符串。
 *
 *  @return
 */
function insertInnerTML(id, direction, TMLString) {
    var element = document.getElementById(id);
    element.insertInnerTML(direction,TMLString);
}

/**
 *  可以页面跳转到指定的url。
 *
 *  @param url 要跳转的url
 *
 *  @return
 */
function goto(url) {
    var page = new Page();
    page.url = url;
    page.hidesStatusBar=false;

    
     var opts = {"page":page ,"animate":"slideFromRight"};
    
    page.hidesTabBar = true;
    window.page.navigator.push(opts);
}

/**
 *  页面返回
 *
 *  @return
 */
function back() {
    window.back();
}

/**
 *  打开一个子窗口并跳转到指定url
 *
 *  @param url    url
 *  @param width  窗体宽度
 *  @param height 窗体高度
 *
 *  @return 
 */
function open(url, width, height,animationType) {
    window.open(url, width, height,animationType);
}


/**
 *  函数可以提交指定表单。
 *
 *  @param formid form表单ID
 *
 *  @return
 */
function submit(formid) {
    var element = document.getElementById(formid);
    element.submit();
}

/**
 *  发送网络请求
 *
 *  @param url url地址
 *
 *  @return
 */
function sendRequest(url) {
    var request = new Request();
    request.url = url;
    request.method = "get";
    request.postFilds = "";
    window.lock();
    request.success = function (data) {
        var json = jsonParser(data)
        setValue('id', json.name);
        
    }
    request.error = function (error) {
        window.unlock();

    }
    request.send();
}

function setFocus(id) {
    var element = document.getElementById(id);
    element.focus();
}

function closeKeyBoard() {
    window.closeKeyBoard();
}

/**
 *  保存数据到客户端的内存中/本地
 *
 *  @param key 要保存的key值
 *  @param value 要保存的value值。
 *  @param bFlag true为保存到本地，false为保存到内存中。
 *
 *  @return
 */
function saveValue(key, value, bFlag){
    console.print("saveValue:"+key+" "+value+" "+bFlag);
    window.saveValue(key, value, bFlag);
}

/**
 *  保存数据到客户端的内存中/本地
 *  @param key 要保存的key值
 *  @param value 要保存的value值。
 *  @param bFlag true为保存到本地，false为保存到内存中。
 *
 *  @return
 */
function loadValue(key, bFlag){
    console.print("loadValue:"+key+" "+window.loadValue(key, bFlag)+" "+bFlag);
    return window.loadValue(key, bFlag);
}


function mapNavigation(latitude, longitude, name){
    return window.mapNavigation(latitude, longitude, name);

}

function tel(phone){
    return window.tel(phone)
}

function alert(msg){
    return window.info(msg)
}