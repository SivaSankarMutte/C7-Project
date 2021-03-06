

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author SIVASANKAR
 */
package QuestionsPackage;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class goToPrevQuestion extends HttpServlet{
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        HttpSession session=request.getSession();
        ArrayList<Questions> questionsRecords = (ArrayList<Questions>)session.getAttribute("questionsRecords");
        
        try
        {
            String rno=session.getAttribute("regdNo").toString();
            String eid=session.getAttribute("examId").toString();
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/demo2?useSSL=false&allowPublicKeyRetrieval=true","siva","0000");
            Questions qobj=(Questions)session.getAttribute("qobj");
            int qid=(int)qobj.getQuestionId();
            
            if(qobj.getHaveMultipleAns()==0)
            {
                if(request.getParameter("radioName")!=null)
                {
                    String submittedAns=request.getParameter("radioName");
                    float marksObtained;
                    qobj.setProvidedAns(submittedAns);
    //                qobj.providedAns=submittedAns;
                    String realAns=qobj.getRealAns();

                    float qmarks=(float)qobj.getQuestionMarks();

                    if(realAns.equals(submittedAns))
                    {
                        marksObtained=qmarks;
                    }
                    else
                    {
                        marksObtained=-(qobj.getNegativeMarks());
                    }


                    String sqlUpdate="Update examSpecialTable"+eid+ " set marksObtained=?,selectedOptions=? where qid=? and regdNo=?";
                    PreparedStatement ps = con.prepareStatement(sqlUpdate);
                    ps.setFloat(1,marksObtained);
                    ps.setString(2, submittedAns);
                    ps.setInt(3,qid);
                    ps.setString(4, rno);
                    int status=ps.executeUpdate();

                    if(status==0)
                    {
                        Statement st=con.createStatement();
                        st.executeUpdate("insert into examSpecialTable"+eid+" (qid,regdNo,marksObtained,selectedOptions)values('"+qid+"','"+rno+"','"+marksObtained+"','"+submittedAns+"')");                
                    }
                }
                else
                {
                    String sqlUpdate="Update examSpecialTable"+eid+ " set marksObtained=null,selectedOptions=null where qid=? and regdNo=?";
                    PreparedStatement ps = con.prepareStatement(sqlUpdate);
                    ps.setInt(1,qid);
                    ps.setString(2, rno);
                    int status=ps.executeUpdate();

                    if(status==0)
                    {
                        Statement st=con.createStatement();
                        st.executeUpdate("insert into examSpecialTable"+eid+" (qid,regdNo)values('"+qid+"','"+rno+"')");   
                    }

                }
            }
            else
            {
                if(request.getParameterValues("checkboxname")!=null)
                {
                    String submittedAns[]=request.getParameterValues("checkboxname");
                    String realAns[]=qobj.getRealAns().split("&");
                    Arrays.sort(submittedAns);
                    Arrays.sort(realAns);
             
                    String ans="";
                    for(int j = 0; j < submittedAns.length; j++) {
                        ans=ans+submittedAns[j]+"&";
                    }
                    float marksObtained=-(qobj.getNegativeMarks());
                    qobj.setCheckboxOptionsGiven(submittedAns);
                    
                    if(Arrays.equals(realAns, submittedAns))
                    {
                        marksObtained=(float)qobj.getQuestionMarks();
                        String sqlUpdate="Update examSpecialTable"+eid+ " set marksObtained=?,selectedOptions=? where qid=? and regdNo=?";
                        PreparedStatement ps = con.prepareStatement(sqlUpdate);
                        ps.setFloat(1,marksObtained);
                        ps.setString(2, qobj.getRealAns());
                        ps.setInt(3,qid);
                        ps.setString(4, rno);
                        int status=ps.executeUpdate();

                        if(status==0)
                        {
                            Statement st=con.createStatement();
                            st.executeUpdate("insert into examSpecialTable"+eid+" (qid,regdNo,marksObtained,selectedOptions)values('"+qid+"','"+rno+"','"+marksObtained+"','"+qobj.getRealAns()+"')");                
                        }
                    }
                    else
                    {
                        String sqlUpdate="Update examSpecialTable"+eid+ " set marksObtained=?,selectedOptions=? where qid=? and regdNo=?";
                        PreparedStatement ps = con.prepareStatement(sqlUpdate);
                        ps.setFloat(1,marksObtained);
                        ps.setString(2, ans.substring(0,ans.length()-1));
                        ps.setInt(3,qid);
                        ps.setString(4, rno);
                        int status=ps.executeUpdate();

                        if(status==0)
                        {
                            Statement st=con.createStatement();
                            st.executeUpdate("insert into examSpecialTable"+eid+" (qid,regdNo,marksObtained,selectedOptions)values('"+qid+"','"+rno+"','"+marksObtained+"','"+ans.substring(0,ans.length()-1)+"')");                
                        }
                    }
                   

                    
                }
                else
                {
                    String sqlUpdate="Update examSpecialTable"+eid+ " set marksObtained=null,selectedOptions=null where qid=? and regdNo=?";
                    PreparedStatement ps = con.prepareStatement(sqlUpdate);
                    ps.setInt(1,qid);
                    ps.setString(2, rno);
                    int status=ps.executeUpdate();

                    if(status==0)
                    {
                        Statement st=con.createStatement();
                        st.executeUpdate("insert into examSpecialTable"+eid+" (qid,regdNo) values('"+qid+"','"+rno+"')");   
                    }

                }
            }
            
            int num=(int) session.getAttribute("n");
            num-=1;
            session.setAttribute("n", num);   
            RequestDispatcher rd=request.getRequestDispatcher("accessTestNavigationBetweenQuestions.jsp");
            rd.forward(request,response);    
        }
        catch(IOException | ClassNotFoundException | NumberFormatException | SQLException | ServletException e)
        {
            pw.print(e);
        }
    }
}

