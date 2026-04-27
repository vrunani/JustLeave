import javax.xml.transform.TransformerFactory;

import org.jcp.xml.dsig.internal.dom.DOMBase64Transform;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

@webServlet("/addStudentServelet")
public class addStudentServelet extends HttpServlet{
    protected void dopost(HttpServletRequest request,HttpServletResponse response)throws servletException ,IOException{
        String roll=req.getPrarameter("roll");
        String name=req.getPrarameter("name");
        String email=req.getPrarameter("email");
        String course=req.getPrarameter("course");
        String path=getServletContext().getRealPath("");
        try{
            documnentBuilderFactory dbf=DocumentBuilderFactory.newInstance();
            DocumentBuilder db=dbf.newDocumentBuilder();
            Document doc=db.parse(new file(path));
            Element student=doc.createElement("student");
            Element r=doc.createElement("roll");
            r.setTextContent(roll);
            student.appendChild(r);
            Element n=doc.createElement("name");
            n.setTextContent(name);
            student.appendChild(n);
            Element e=doc.createElement("email");
            e.setTextContent(email);
            student.appendChild(e);
            Element c=doc.createElement("course");
            c.setTextContent(course);
            student.appendChild(c);
            doc.getDocumentElement().appendChild(student);
            TransformerFactory tf=transformerFactory.newInstance();
            transformer t=tf.newTransformer();
            t.setOutputProperty(OutputKeys.INDENT,"yes");
            DomSource src =new DomSource(doc);
            StreamResult result=new StreamResult(new file(path)
            );
            t.tranform(src,result);
            res.getWriter().println("Student added successfully");


        }catch(Exception e){
            e.printStackTrace();
            res.getWriter().println("Error adding student");
        }
    }
}
