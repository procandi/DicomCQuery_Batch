# encoding: UTF-8


require "date"
require "logger"


class UserHandle
  #last sql command information 
  attr_accessor:chartno
  attr_accessor:chartname
  attr_accessor:citizenid
  attr_accessor:birthday
  attr_accessor:sex
  attr_accessor:address
  attr_accessor:phone
  
  attr_accessor:accessionno
  attr_accessor:age
  attr_accessor:orderdate
  attr_accessor:ordertime
  attr_accessor:examtype
  attr_accessor:examdate
  attr_accessor:status
  attr_accessor:drorderidname
  attr_accessor:dronidname
  attr_accessor:drreportidname
  attr_accessor:examdetail
  
  attr_accessor:userid
  attr_accessor:username
  
  attr_accessor:itemcode
  attr_accessor:divisionon
  
  attr_accessor:examtime
  attr_accessor:sfp
  attr_accessor:sfn
  

  def initialize(db)
    @db=db
    @logger=Logger.new("log.txt","daily")
  end
  
  #get user name
  def GetUserName(userid)
    @userid=userid
    
    sql="select "
    sql+="name "
    sql+="from "
    sql+="cris_user "
    sql+="where "
    sql+="userid='#{@userid}' "
    @logger.info(sql)
    
    flag=false
    @db.dbh.select_all(sql){|rec|
      flag=true
      return rec[0]
    }  
         
    if !flag
      return ""
    end
  end
  
  #get item name
  def GetItemName(itemcode)
    @itemcode=itemcode
    
    sql="select "
    sql+="type "
    sql+="from "
    sql+="cris_reference "
    sql+="where "
    sql+="code='#{@itemcode}' "
    @logger.info(sql)
    
    flag=false
    @db.dbh.select_all(sql){|rec|
      flag=true
      return rec[0]
    }
    
    if !flag
      return ""
    end
  end
  
  #get exam key number
  def GetUniKey(chartno,examtype,examdate)
    @chartno=chartno
    @examtype=examtype
    @examdate=examdate
    
    sql="select "
    sql+="uni_key "
    sql+="from "
    sql+="cris_exam_online "
    sql+="where "
    sql+="chartno='#{@chartno}' and "
    sql+="examdate='#{@examdate}' and "
    sql+="type='#{@examtype}' "
    @logger.info(sql)
    
    flag=false
    @db.dbh.select_all(sql){|rec|
      flag=true
      return rec[0]
    }    
    
    if !flag
      return @chartno+"_"+@examdate.delete("/")
    end
  end
  
  #get exam item code
  def GetExamItemCode(accessionno)
    @accessionno=accessionno
    sql="select "
    sql+="examdetail "
    sql+="from "
    sql+="cris_exam_online "
    sql+="where "
    sql+="uni_key='#{@accessionno}' "
    @logger.info(sql)
    
    flag=false
    @db.dbh.select_all(sql){|rec|
      flag=true
      return rec[0]
    }
    
    if !flag
      return ""
    end
  end
  
  #get exam item name
  def GetExamItemName(accessionno)
    @accessionno=accessionno
    sql="select "
    sql+="type "
    sql+="from "
    sql+="cris_exam_online "
    sql+="where "
    sql+="uni_key='#{@accessionno}' "
    @logger.info(sql)
    
    flag=false
    @db.dbh.select_all(sql){|rec|
      flag=true
      return rec[0]
    }
    
    if !flag
      return ""
    end
  end
  
  #get database has this exam or not
  def GetExam(accessionno,condition)
    @accessionno=accessionno
    sql="select "
    sql+="* "
    sql+="from "
    sql+="cris_exam_online "
    sql+="where "
    if condition!=nil && condition!=""
      sql+="#{condition} and "
    end
    sql+="uni_key='#{@accessionno}' "
    @logger.info(sql)
    
    flag=false
    @db.dbh.select_all(sql){|rec|
      flag=true
      break
    }    
    
    return flag
  end
  
  #insert one exam data to database
  def InsertExam(chartno,accessionno,age,orderdate,ordertime,examtype,examdate,examtime,status,drorderidname,dronidname,drreportidname,examdetail,drfrom,chargeby,modality,divisionon,zone,isdanger)
    @chartno=chartno
    @accessionno=accessionno
    @age=age
    @orderdate=orderdate
    @ordertime=ordertime
    @examtype=examtype
    @examdate=examdate
    @examtime=examtime
    @status=status
    @drfrom=drfrom
    @drorderidname=drorderidname
    @dronidname=dronidname
    @drreportidname=drreportidname
    @examdetail=examdetail
    @chargeby=chargeby
    @modality=modality
    @divisionon=divisionon
    @zone=zone
    @isdanger=isdanger
    
    sql="insert into "
    sql+="cris_exam_online( "
    sql+="system,chartno,uni_key,age,orderdate,ordertime,type,examdate,examtime,status,accessionnumber,dr_from,dr_order,dr_on,dr_report,uploadcode,examdetail,his_reqno,chargeby,modality,division_on,zone,isdanger "
    sql+=") values( "
    sql+="'HIS_IN', "
    sql+="'#{@chartno}', "
    sql+="'#{@accessionno}', "
    sql+="'#{@age}', "
    sql+="'#{@orderdate}', "
    sql+="'#{@ordertime}', "
    sql+="'#{@examtype}', "
    sql+="'#{@examdate}', "
    sql+="'#{@examtime}', "
    sql+="'#{@status}', "
    sql+="'#{@accessionno}', "
    sql+="'#{@drfrom}', "
    sql+="'#{@drorderidname}', "
    sql+="'#{@dronidname}', "
    sql+="'#{@drreportidname}', "
    sql+="'10', "    
    sql+="'#{@examdetail}', "
    sql+="'#{@accessionno}', "
    sql+="'#{@chargeby}', "
    sql+="'#{@modality}', "
    sql+="'#{@divisionon}', "
    sql+="'#{@zone}', "
    sql+="'#{@isdanger}' "
    sql+=") "
    @logger.info(sql)
    
    @db.dbh.do(sql)
    if @db::dbtype=="ORA"
      @db.dbh.commit()
    end
  end
  
  #update one exam data to database
  def UpdateExam(chartno,accessionno,age,orderdate,ordertime,examtype,examdate,examtime,status,drorderidname,dronidname,drreportidname,examdetail,drfrom,chargeby,modality,divisionon,zone,isdanger)
    @chartno=chartno
    @accessionno=accessionno
    @age=age
    @orderdate=orderdate
    @ordertime=ordertime
    @examtype=examtype
    @examdate=examdate
    @examtime=examtime
    @status=status
    @drfrom=drfrom
    @drorderidname=drorderidname
    @dronidname=dronidname
    @drreportidname=drreportidname
    @examdetail=examdetail
    @chargeby=chargeby
    @modality=modality
    @divisionon=divisionon
    @zone=zone
    @isdanger=isdanger
    
    sql="update "
    sql+="cris_exam_online "
    sql+="set "
    sql+="system='HIS_IN', "
    sql+="chartno='#{@chartno}', "
    sql+="age='#{@age}', "
    sql+="orderdate='#{@orderdate}', " 
    sql+="ordertime='#{@ordertime}', "
    sql+="type='#{@examtype}', "
    sql+="examdate='#{@examdate}', "
    sql+="examtime='#{@examtime}', "
    sql+="status='#{@status}', "
    sql+="accessionnumber='#{@accessionno}', "
    sql+="dr_from='#{@drfrom}', "
    sql+="dr_order='#{@drorderidname}', "
    sql+="dr_on='#{@dronidname}', "
    sql+="dr_report='#{@drreportidname}', "
    sql+="uploadcode='10', "
    sql+="examdetail='#{@examdetail}', "
    sql+="his_reqno='#{@accessionno}', "
    sql+="chargeby='#{@chargeby}', "
    sql+="division_on='#{@divisionon}', "
    sql+="modality='#{@modality}', "
    sql+="zone='#{@zone}', "
    sql+="isdanger='#{@isdanger}' "
    sql+="where "
    sql+="uni_key='#{@accessionno}' "
    @logger.info(sql)
    
    @db.dbh.do(sql)
    if @db::dbtype=="ORA"
      @db.dbh.commit()
    end
  end
  
  
  #get database has this patient or not
  def GetPatient(chartno)
    @chartno=chartno
    sql="select "
    sql+="* "
    sql+="from "
    sql+="cris_patient_info "
    sql+="where "
    sql+="chartno='#{@chartno}' "
    @logger.info(sql)
    
    flag=false
    @db.dbh.select_all(sql){|rec|
      flag=true
      break
    }    
    
    return flag
  end
  
  #insert one patient data to database
  def InsertPatient(chartno,chartname,citizenid,birthday,sex,address,phone)
    @chartno=chartno
    @chartname=chartname
    @citizenid=citizenid
    @birthday=birthday
    @sex=sex
    @address=address
    @phone=phone
       
    sql="insert into "
    sql+="cris_patient_info( "
    sql+="chartno,name,citizenid,birthday,sex,address,phone "
    sql+=") values( "
    sql+="'#{@chartno}', "
    if @db::dbtype=="MSSQL"
      sql+="N'#{@chartname}', "
    else
      sql+="'#{@chartname}', "
    end
    sql+="'#{@citizenid}', "
    sql+="'#{@birthday}', "
    sql+="'#{@sex}', "
    sql+="'#{@address}', "
    sql+="'#{@phone}' "
    sql+=") "
    @logger.info(sql)
    
    @db.dbh.do(sql)
    if @db::dbtype=="ORA"
      @db.dbh.commit()
    end
  end
  
  #update one patient data to database
  def UpdatePatient(chartno,chartname,citizenid,birthday,sex,address,phone)
    @chartno=chartno
    @chartname=chartname
    @citizenid=citizenid
    @birthday=birthday
    @sex=sex
    @address=address
    @phone=phone
    
    sql="update "
    sql+="cris_patient_info "
    sql+="set "
    if @db::dbtype=="MSSQL"
      sql+="name=N'#{@chartname}', "
    else
      sql+="name='#{@chartname}', "
    end
    sql+="citizenid='#{@citizenid}', "
    sql+="birthday='#{@birthday}', "
    sql+="sex='#{@sex}', "
    sql+="address='#{@address}', "
    sql+="phone='#{@phone}' "
    sql+="where "
    sql+="chartno='#{@chartno}' "
    @logger.info(sql)
    
    @db.dbh.do(sql)
    if @db::dbtype=="ORA"
      @db.dbh.commit()
    end
  end
   
    
  #insert one image link to database
  def InsertImage(chartno,examtype,examdate,examtime,sfp,sfn,accessionno)
    @chartno=chartno
    @examtype=examtype
    @examdate=examdate
    @examtime=examtime
    @sfp=sfp
    @sfn=sfn
    @accessionno=accessionno
    
    sql="insert into "
    sql+="cris_images_reference( "
    sql+="system,imgowner,class,type,createdate,createtime,filepath,filename,[backup],uni_key "
    sql+=") values( "
    sql+="'HIS_IN', "
    sql+="'#{@chartno}', "
    sql+="'OCR', "
    sql+="'#{@examtype}', "
    sql+="'#{@examdate}', "
    sql+="'#{@examtime}', "
    sql+="'#{@sfp}', "
    sql+="'#{@sfn}.jpg', "
    sql+="'0', "
    sql+="'#{@accessionno}' "
    sql+=") "
    @logger.info(sql)
    
    @db.dbh.do(sql)
    if @db::dbtype=="ORA"
      @db.dbh.commit()
    end
  end
end