/*
This software is allowed to use under GPL or you need to obtain Commercial or Enterprise License 
 to use it in non-GPL project. Please contact sales@webix.com for details
*/
webix.i18n.pivot={apply:"Apply",bar:"Bar",cancel:"Cancel",groupBy:"Group By",chartType:"Chart type",count:"count",fields:"Fields",filters:"Filters",line:"Line",max:"max",min:"min",operationNotDefined:"Operation is not defined",layoutIncorrect:"pivotLayout should be an Array instance",pivotMessage:"Click to configure",popupHeader:"Pivot Settings",radar:"Radar",radarArea:"Area Radar",select:"select",settings:"Settings",stackedBar:"Stacked Bar",sum:"sum",text:"text",values:"Values",valuesNotDefined:"Values or Group field are not defined",windowMessage:"[move fields into required sector]"},webix.protoUI({name:"pivot-chart",defaults:{fieldMap:{},rows:[],filterLabelAlign:"right",filterWidth:300,editButtonWidth:110,filterLabelWidth:100,chartType:"bar",color:"#36abee",chart:{},singleLegendItem:1,palette:[["#e33fc7","#a244ea","#476cee","#36abee","#58dccd","#a7ee70"],["#d3ee36","#eed236","#ee9336","#ee4339","#595959","#b85981"],["#c670b8","#9984ce","#b9b9e2","#b0cdfa","#a0e4eb","#7faf1b"],["#b4d9a4","#f2f79a","#ffaa7d","#d6806f","#939393","#d9b0d1"],["#780e3b","#684da9","#242464","#205793","#5199a4","#065c27"],["#54b15a","#ecf125","#c65000","#990001","#363636","#800f3e"]]},templates:{groupNameToStr:function(t,e){return t+"_"+e},groupNameToObject:function(t){var e=t.split("_");return{name:e[0],operation:e[1]}},seriesTitle:function(t,e){var i=this.config.fieldMap[t.name]||t.name,s=webix.isArray(t.operation)?t.operation[e]:t.operation;return i+" ( "+(webix.i18n.pivot[s]||s)+")"}},templates_setter:function(t){"object"==typeof t&&webix.extend(this.templates,t)},chartMap:{bar:function(t){return{border:0,alpha:1,radius:0,color:t}},line:function(t){return{alpha:1,item:{borderColor:t,color:t},line:{color:t,width:2}}},radar:function(t){return{alpha:1,fill:!1,disableItems:!0,item:{borderColor:t,color:t},line:{color:t,width:2}}}},chartMap_setter:function(t){"object"==typeof t&&webix.extend(this.chartMap,t,!0)},$init:function(t){t.structure||(t.structure={}),webix.extend(t.structure,{groupBy:"",values:[],filters:[]}),this.$view.className+=" webix_pivot_chart",webix.extend(t,{editButtonWidth:this.defaults.editButtonWidth}),webix.extend(t,this.getUI(t)),this.$ready.push(this.render),this.data.attachEvent("onStoreUpdated",webix.bind(function(){this.$$("chart")&&this.render(this,arguments)},this))},getUI:function(t){var e={view:"toolbar",id:"toolbar",cols:[{id:"filters",hidden:!0,cols:[]},{id:"edit",view:"button",type:"iconButton",align:"right",icon:"cog",inputWidth:t.editButtonWidth,label:this.ut("settings"),click:webix.bind(this.configure,this)},{width:5}]},i={id:"bodyLayout",type:"line",margin:10,cols:[{id:"chart",view:"chart"}]};return{rows:[e,i]}},configure:function(){if(!this.pivotPopup){var t={id:"popup",view:"webix_pivot_config",operations:[],pivot:this.config.id};webix.extend(t,this.config.popup||{}),this.pivotPopup=webix.ui(t),this.pivotPopup.attachEvent("onApply",webix.bind(function(t){this.config.chartType=this.pivotPopup.$$("chartType")?this.pivotPopup.$$("chartType").getValue():"bar",this.config.chart.scale=this.pivotPopup.$$("logScale").getValue()?"logarithmic":"linear",webix.extend(this.config.structure,t,!0),this.render()},this))}var e=[];for(var i in this.operations)e.push({name:i,title:this.ut(i)});this.pivotPopup.vt=this.vt,this.pivotPopup.define("operations",e);var s=webix.html.offset(this.$$("chart").getNode());this.pivotPopup.setPosition(s.x+10,s.y+10),this.pivotPopup.define("data",this.getFields()),this.pivotPopup.wt=this.pivotPopup.show()},render:function(){var t=this.xt();t.length?(t.push({}),this.$$("filters").show(),this.$$("filters").define("cols",t),this.yt()):this.$$("filters").hide(),this.zt(),this.At(),this.Bt()},At:function(){for(var t=this.config,e=t.structure.values,i=0;i<e.length;i++)e[i].operation=e[i].operation||["sum"],webix.isArray(e[i].operation)||(e[i].operation=[e[i].operation]);var s=this.config.chartType||"bar",n=this.chartMap[s],r={type:n&&n("").type?n("").type:s,xAxis:webix.extend({template:"#id#"},t.chart.xAxis||{}),yAxis:webix.extend({},t.chart.yAxis||{})};webix.extend(r,t.chart);var a=this.Ct();r.series=a.series,r.legend=!1,(t.singleLegendItem||this.vt>1)&&(r.legend=a.legend),r.scheme={$group:this.Dt,$sort:{by:"id"}},this.$$("chart").removeAllSeries();for(var o in r)this.$$("chart").define(o,r[o])},ut:function(t){return webix.i18n.pivot[t]||t},Et:function(t){return this.config.fieldMap[t]||t},xt:function(){for(var t=this.config.structure.filters||[],e=[],i=0;i<t.length;i++){var s=t[i],n={value:s.value,label:this.Et(s.name),field:s.name,view:s.type,labelAlign:this.config.filterLabelAlign,labelWidth:this.config.filterLabelWidth,width:this.config.filterWidth};"select"==s.type&&(n.options=this.Ft(s.name)),e.push(n)}return e},Ft:function(t){var e=[{value:"",id:""}],i=this.data.pull,s={};for(var n in i){var r=i[n][t];webix.isUndefined(r)||s[r]||(e.push({value:r,id:r}),s[r]=!0)}return e.sort(function(t,e){var i=t.value,s=e.value;return s?i?(i=i.toString().toLowerCase(),s=s.toString().toLowerCase(),i>s?1:s>i?-1:0):-1:1}),e},Bt:function(){this.zt(),this.data.silent(function(){this.data.filter(webix.bind(this.Gt,this))},this),this.$$("chart").data.silent(function(){this.$$("chart").clearAll()},this),this.$$("chart").parse(this.data.getRange())},yt:function(){var t=this.$$("filters");t.reconstruct();for(var e=t.getChildViews(),i=this,s=0;s<e.length;s++){var n=e[s];"select"==n.name?n.attachEvent("onChange",function(t){i.Ht(this.config.field,t)}):webix.isUndefined(n.getValue)||n.attachEvent("onTimedKeyPress",function(){i.Ht(this.config.field,this.getValue())})}},Ht:function(t,e){for(var i=this.config.structure.filters,s=0;s<i.length;s++)if(i[s].name==t)return i[s].value=e,this.Bt(),!0;return!1},groupNameToStr:function(t){return t.name+"_"+t.operation},groupNameToObject:function(t){var e=t.split("_");return{name:e[0],operation:e[1]}},Ct:function(){var t,e,i,s,n,r={},a=[],o=this.config.structure.values;for(i={valign:"middle",align:"right",width:140,layout:"y"},webix.extend(i,this.config.chart.legend||{},!0),i.values=[],i.marker||(i.marker={}),i.marker.type="line"==this.config.chartType?"item":"s",this.series_names=[],this.vt=0,t=0;t<o.length;t++)for(webix.isArray(o[t].operation)||(o[t].operation=[o[t].operation]),webix.isArray(o[t].color)||(o[t].color=[o[t].color||this.It(this.vt)]),e=0;e<o[t].operation.length;e++){s=this.templates.groupNameToStr(o[t].name,o[t].operation[e]),this.series_names.push(s),o[t].color[e]||(o[t].color[e]=this.It(this.vt));var h=o[t].color[e],l=this.chartMap[this.config.chartType](h)||{};l.value="#"+s+"#",l.tooltip={template:webix.bind(function(t){return t[this].toFixed(3)},s)},a.push(l),n=this.templates.seriesTitle.call(this,o[t],e),i.values.push({text:n,color:h}),r[s]=[o[t].name,o[t].operation[e]],this.vt++}return this.Dt={},o.length&&(this.Dt=webix.copy({by:this.config.structure.groupBy,map:r})),{series:a,legend:i}},It:function(t){var e=this.config.palette,i=t/e[0].length;i=i>e.length?0:parseInt(i,10);var s=t%e[0].length;return e[i][s]},Jt:function(){var t,e,i,s=this.config.structure.values;for(e={valign:"middle",align:"right",width:140,layout:"y"},webix.extend(e,this.config.chart.legend||{},!0),e.values=[],e.marker||(e.marker={}),e.marker.type="line"==this.config.chartType?"item":"s",t=0;t<s.length;t++)i=this.templates.seriesTitle.call(this,s[t]),e.values.push({text:i,color:s[t].color});return e},operations:{sum:1,count:1,max:1,min:1},addGroupMethod:function(t,e){this.operations[t]=1,e&&(webix.GroupMethods[t]=e)},removeGroupMethod:function(t){delete this.operations[t]},groupMethods_setter:function(t){for(var e in t)t.hasOwnProperty(e)&&this.addGroupMethod(e,t[e])},getFields:function(){var t,e=[],i={};for(t=0;t<Math.min(this.data.count()||5);t++){var s=this.data.getItem(this.data.getIdByIndex(t));for(var n in s)i[n]||(e.push(n),i[n]=webix.uid())}var r=this.config.structure,a={fields:[],groupBy:[],values:[],filters:[]},o="object"==typeof r.groupBy?r.groupBy[0]:r.groupBy;webix.isUndefined(i[o])||(a.groupBy.push({name:o,text:this.Et(o),id:i[o]}),delete i[o]);var h={};for(t=0;t<r.values.length;t++){var o=r.values[t];if(!webix.isUndefined(i[o.name])){var l=this.Et(o.name);if(webix.isUndefined(h[o.name]))h[o.name]=a.values.length,a.values.push({name:o.name,text:l,operation:o.operation,color:o.color||[this.It(t)],id:i[o.name]});else{var c=a.values[h[o.name]];c.operation=c.operation.concat(o.operation),c.color=c.color.concat(o.color||[this.It(t)])}}}for(t=0;t<(r.filters||[]).length;t++){var o=r.filters[t];if(!webix.isUndefined(i[o.name])){var l=this.Et(o.name);a.filters.push({name:o.name,text:l,type:o.type,value:o.value,id:i[o]}),delete i[o.name]}}for(t=0;t<e.length;t++){var o=e[t];webix.isUndefined(i[o])||a.fields.push({name:o,text:this.Et(o),id:i[o]})}return a},zt:function(){for(var t=this.config.structure.filters||[],e=0;e<t.length;e++){var i=t[e],s=(i.value||"").trim();"="==s.substr(0,1)?(i.func=this.filters.equals,s=s.substr(1)):">="==s.substr(0,2)?(i.func=this.filters.more_equals,s=s.substr(2)):">"==s.substr(0,1)?(i.func=this.filters.more,s=s.substr(1)):"<="==s.substr(0,2)?(i.func=this.filters.less_equals,s=s.substr(2)):"<"==s.substr(0,1)?(i.func=this.filters.less,s=s.substr(1)):s.indexOf("...")>0?(i.func=this.filters.range,s=s.split("...")):s.indexOf("..")>0?(i.func=this.filters.range_inc,s=s.split("..")):i.func=this.filters.contains,i.fvalue=s}},Gt:function(t){for(var e=this.config.structure.filters||[],i=0;i<e.length;i++){var s=e[i];if(""!=s.fvalue){if(webix.isUndefined(t[s.name]))return!1;var n=t[s.name].toString().toLowerCase(),r=s.func.call(this.filters,s.fvalue,n);if(!r)return!1}}return!0},filters:{kt:function(t,e,i){if("object"==typeof t){for(var s=0;s<t.length;s++)if(t[s]=window.parseFloat(t[s],10),window.isNaN(t[s]))return!0}else if(t=window.parseFloat(t,10),window.isNaN(t))return!0;return window.isNaN(e)?!1:i(t,e)},contains:function(t,e){return e.indexOf(t.toString().toLowerCase())>=0},equals:function(t,e){return this.kt(t,e,function(t,e){return t==e})},more:function(t,e){return this.kt(t,e,function(t,e){return e>t})},more_equals:function(t,e){return this.kt(t,e,function(t,e){return e>=t})},less:function(t,e){return this.kt(t,e,function(t,e){return t>e})},less_equals:function(t,e){return this.kt(t,e,function(t,e){return t>=e})},range:function(t,e){return this.kt(t,e,function(t,e){return e<t[1]&&e>=t[0]})},range_inc:function(t,e){return this.kt(t,e,function(t,e){return e<=t[1]&&e>=t[0]})}},getStructure:function(){return this.config.structure},getConfigWindow:function(){return this.Us}},webix.IdSpace,webix.ui.layout,webix.DataLoader,webix.EventSystem,webix.Settings),webix.protoUI({name:"webix_pivot_config",$init:function(t){this.$view.className+=" webix_pivot_popup",webix.extend(t,this.defaults),webix.extend(t,this.Kt(t)),this.$ready.push(this.Lt)},defaults:{padding:8,height:440,width:600,head:!1,modal:!0,move:!0,chartTypeLabelWidth:80,chartTypeWidth:250,cancelButtonWidth:100,applyButtonWidth:100,fieldsColumnWidth:250},Mt:function(t){},Kt:function(t){var e=[],i=$$(t.pivot),s=i.chartMap;for(var n in s)e.push({id:n,value:i.ut(n)});return{head:{view:"toolbar",cols:[{id:"config_title",data:{value:"windowMessage"},css:"webix_pivot_transparent",borderless:!0,template:this.mt.popupHeaders},{view:"button",id:"cancel",type:"iconButton",icon:"times",label:i.ut("cancel"),width:t.cancelButtonWidth},{view:"button",id:"apply",type:"iconButton",icon:"check",css:"webix_pivot_apply",label:i.ut("apply"),width:t.applyButtonWidth}]},body:{rows:[{type:"wide",margin:5,cols:[{width:t.fieldsColumnWidth,rows:[{id:"config_title",data:{value:"fields"},template:this.mt.popupHeaders,type:"header"},{id:"fields",view:"list",scroll:!1,type:{height:35},drag:!0,template:"<span class='webix_pivot_list_marker'></span>#text#",on:{onBeforeDrop:webix.bind(this.Nt,this),onBeforeDropOut:webix.bind(this.Ot,this),onBeforeDrag:webix.bind(this.Pt,this)}}]},{view:"resizer"},{rows:[{id:"filtersHeader",data:{value:"filters"},template:this.mt.popupIconHeaders,type:"header"},{id:"filters",view:"list",scroll:!0,gravity:2,type:"PivotList",drag:!0,css:"webix_pivot_values",template:function(t){return t.type=t.type||"select","<div class='webix_pivot_link'>"+t.text+"<div class='webix_link_selection filter'>"+t.type+"</div></div> "},type:{height:35},onClick:{webix_link_selection:webix.bind(this.Qt,this)},on:{onBeforeDrag:webix.bind(this.Pt,this)}},{id:"valuesHeader",data:{value:"values"},template:this.mt.popupIconHeaders,type:"header"},{id:"values",view:"list",scroll:!0,gravity:3,drag:!0,css:"webix_pivot_values",type:{height:"auto"},template:webix.bind(this.pt,this),onClick:{webix_link_title:webix.bind(this.qt,this),webix_link_selection:webix.bind(this.qt,this),webix_color_selection:webix.bind(this.Rt,this),webix_pivot_minus:webix.bind(this.st,this)},on:{onBeforeDrop:webix.bind(this.St,this),onBeforeDropOut:webix.bind(this.Ot,this),onBeforeDrag:webix.bind(this.Pt,this)}},{id:"groupHeader",data:{value:"groupBy"},template:this.mt.popupIconHeaders,type:"header"},{id:"groupBy",view:"list",yCount:1,type:"PivotList",scroll:!1,drag:!0,type:{height:35},template:"<a class='webix_pivot_link'>#text#</a> ",on:{onBeforeDrop:webix.bind(this.Tt,this),onBeforeDrag:webix.bind(this.Pt,this)}}]}]},{borderless:!0,padding:5,type:"space",cols:[{view:"checkbox",id:"logScale",value:i.config.chart.scale&&"logarithmic"==i.config.chart.scale,label:webix.i18n.pivot.logScale,labelWidth:t.logScaleLabelWidth,width:t.logScaleLabelWidth+20},{},{view:"richselect",id:"chartType",value:i.config.chartType,label:webix.i18n.pivot.chartType,options:e,labelWidth:t.chartTypeLabelWidth,width:t.chartTypeWidth}]}]}}},mt:{popupHeaders:function(t){return webix.i18n.pivot[t.value]},popupIconHeaders:function(t){return"<span class='webix_pivot_popup_icon "+t.value+"'></span>"+webix.i18n.pivot[t.value]}},Pt:function(){webix.callEvent("onClick",[])},Nt:function(t){if(t.from==this.$$("values")){var e=t.source[0];return this.$$("values").getItem(e)&&this.$$("values").remove(e),!1}return!0},Ot:function(t){if(t.to!=t.from){var e=t.source[0];t.from==this.$$("values")&&t.to!=this.$$("fields")?(delete this.$$("values").getItem(e).operation,delete this.$$("values").getItem(e).color,this.$$("fields").getItem(e)&&this.$$("fields").remove(e)):t.from==this.$$("fields")&&t.to!=this.$$("values")&&this.$$("values").getItem(e)&&this.$$("values").remove(e)}},St:function(t){if(t.to&&t.from!=t.to){var e=t.source,i=t.from.getItem(e);if(t.from==this.$$("fields"))return t.to.getItem(e)?(this.rt({},e),this.vt++):(i=webix.copy(i),t.to.add(webix.copy(i),t.index),this.vt++),!1;this.$$("fields").getItem(e)||this.$$("fields").add(webix.copy(i)),this.Ut=!0}return!0},Tt:function(){if(this.$$("groupBy").data.order.length){var t=this.$$("groupBy").getFirstId(),e=webix.copy(this.$$("groupBy").getItem(t));this.$$("groupBy").remove(t),this.$$("fields").add(e)}return!0},Lt:function(){this.attachEvent("onItemClick",function(t){if("button"==this.$eventSource.name){var e=this.getStructure();"apply"!=this.innerId(t)||e.values.length&&e.groupBy?(this.callEvent("on"+this.innerId(t),[e]),this.hide()):webix.alert(webix.i18n.pivot.valuesNotDefined)}})},pt:function(t){t.operation=t.operation||["sum"],webix.isArray(t.operation)||(t.operation=[t.operation]);for(var e=[],i=$$(this.config.pivot),s=i.ut,n=0;n<t.operation.length;n++){t.color||(t.color=[i.It(this.vt)]),t.color[n]||t.color.push(i.It(this.vt));var r="<div class='webix_pivot_link' webix_operation='"+n+"'>";r+="<div class='webix_color_selection'><div style='background-color:"+s(t.color[n])+"'></div></div>",r+="<div class='webix_link_title'>"+t.text+"</div>",r+="<div class='webix_link_selection'>"+s(t.operation[n])+"</div>",r+="<div class='webix_pivot_minus webix_icon fa-times'></div>",r+="</div>",e.push(r)}return this.Ut&&(this.Ut=!1,this.vt++),e.join(" ")},qt:function(t,e){var i={view:"webix_pivot_popup",autofit:!0,height:150,width:150,data:this.config.operations||[]},s=webix.ui(i);s.show(t),s.attachEvent("onHide",webix.bind(function(){var i=webix.html.locate(t,"webix_operation"),n=s.getSelected();null!==n&&(this.$$("values").getItem(e).operation[i]=n.name,this.$$("values").updateItem(e)),s.close()},this))},Rt:function(t,e){var i={view:"colorboard",id:"colorboard",borderless:!0};$$(this.config.pivot).config.colorboard?webix.extend(i,$$(this.config.pivot).config.colorboard):webix.extend(i,{width:150,height:150,palette:$$(this.config.pivot).config.palette});var s=webix.ui({view:"popup",id:"colorsPopup",body:i});return s.show(t),s.getBody().attachEvent("onSelect",function(){s.hide()}),s.attachEvent("onHide",webix.bind(function(){var i=webix.html.locate(t,"webix_operation"),n=s.getBody().getValue();n&&(this.$$("values").getItem(e).color[i]=n,this.$$("values").updateItem(e)),s.close()},this)),!1},rt:function(t,e){var i=this.$$("values").getItem(e);i.operation.push("sum");var s=$$(this.config.pivot);s.config.palette,i.color.push(s.It(this.vt)),this.$$("values").updateItem(e),webix.delay(function(){for(var t=i.operation.length-1,s=this.$$("values").getItemNode(e).childNodes,n=null,r=0;r<s.length;r++)if(n=s[r],n.getAttribute){var a=n.getAttribute("webix_operation");if(!webix.isUndefined(a)&&a==t)break}null!==n&&this.qt(n,e)},this)},st:function(t,e){var i=webix.html.locate(t,"webix_operation"),s=this.$$("values").getItem(e);return s.operation.length>1?(s.operation.splice(i,1),this.$$("values").updateItem(e)):this.$$("values").remove(e),!1},Qt:function(t,e){var i=$$(this.config.pivot).ut,s={view:"webix_pivot_popup",autofit:!0,height:150,width:150,data:[{name:"select",title:i("select")},{name:"text",title:i("text")}]},n=webix.ui(s);n.show(t),n.attachEvent("onHide",webix.bind(function(){var t=n.getSelected();if(null!==t){var i=this.$$("filters").getItem(e);i.type=t.name,this.$$("filters").updateItem(e)}n.close()},this))},data_setter:function(t){this.$$("fields").clearAll(),this.$$("fields").parse(t.fields),this.$$("filters").clearAll(),this.$$("filters").parse(t.filters),this.$$("groupBy").clearAll(),this.$$("groupBy").parse(t.groupBy),this.$$("values").clearAll(),this.$$("values").parse(t.values)},getStructure:function(){var t={groupBy:"",values:[],filters:[]},e=this.$$("groupBy");e.count()&&(t.groupBy=e.getItem(e.getFirstId()).name);var i,s=this.$$("values");s.data.each(webix.bind(function(e){for(var s=0;s<e.operation.length;s++)i=webix.copy(e),webix.extend(i,{operation:e.operation[s],color:e.color[s]||$$(this.config.pivot).config.color},!0),t.values.push(i)},this));var n=this.$$("filters");return n.data.each(function(e){t.filters.push(e)}),t}},webix.ui.window,webix.IdSpace),webix.protoUI({name:"webix_pivot_popup",xg:null,$init:function(t){webix.extend(t,this.Ts(t)),this.$ready.push(this.lt)},Ts:function(t){return{body:{id:"list",view:"list",scroll:!1,borderless:!0,autoheight:!0,template:"#title#",data:t.data}}},lt:function(){this.attachEvent("onItemClick",function(t){this.xg=this.$eventSource.getItem(t),this.hide()})},getSelected:function(){return this.xg}},webix.ui.popup,webix.IdSpace);