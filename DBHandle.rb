# encoding: UTF-8


#Extra:
#如果使用的是MSSQL的話，rec裡要填的欄位名稱需等同於下的sql command，如果sql command用的是*搜尋，則等同資料表內的設定
#反之使用的是DB2或ORACLE的話，rec裡要填的欄位名稱只能是大寫字母
#


require "dbi"
require "odbc_utf8"
begin
  require "oci8"
rescue LoadError
  p 'oci8 is not exist.'
end


class DBHandle
  #db connect information
  attr_accessor:dbtype
  attr_accessor:dbhost
  attr_accessor:dbid
  attr_accessor:dbpw
  attr_accessor:dbsid
  attr_accessor:dbh
  

  def initialize(type,host="",id="",pw="",sid="")
    @dbtype = type
    @dbhost = host
    @dbid = id
    @dbpw = pw
    @dbsid = sid
    
    if type=="MSSQL"
      @dbh=DBI.connect("DBI:ODBC:DRIVER={SQL Server};SERVER=#{@dbhost};UID=#{@dbid};PWD=#{@dbpw};DATABASE=#{@dbsid};")
    elsif type=="DB2"
      @dbh=DBI.connect("DBI:ODBC:DSN=#{@dbhost};uid=#{@dbid};pwd=#{@dbpw};")
    elsif type=="ORA"
      @dbh=DBI.connect("DBI:OCI8:(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=#{@dbhost})(PORT=1521))(CONNECT_DATA=(SID=#{@dbsid})))","#{@dbid}","#{@dbpw}")
    end
  end
  
  def finalize(object_id)
    @dbh.disconnect()
  end
end