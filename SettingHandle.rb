# encoding: UTF-8


class SettingHandle
  #環境基本資料
  DBTYPE="DB2"  #MSSQL or DB2 or ORA
  DBHOST="emrdb"
  DBID="eecuser"
  DBPW="eecpwd"
  DBSID=""
  
  
  #ruby程式所在的資料匣
  APPPATH="C:\\Sameway\\DicomCQuery_Batch\\"
  APPNAME="movescu.exe"
  
  #採用模式
  MODE="-d -v"
  
  #CQuery時採用的已方AETitle
  AETITLE="--aetitle minipacstest"
  
  #CQuery時採用的對方AETitle、IP、Port
  CALL="--call TCGHWFM01"
  IP="10.10.5.2"
  PORT="104"
  
  #採用的QueryLevel
  QUERYLEVEL="--study"
  QUERYRESULTLEVEL="-k 0008,0052=STUDY"
end