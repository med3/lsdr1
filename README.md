
Team members : Kien Bui, Kodjo Mawuélom EDAH, Mohammed Taha EL AHMAR, Monssef EL FAGHLOUMI
Roboconf DSL README 
We use Eclipse MARS for DSL Developper ( version 3.1 )


Steps to follow in order to test the project .

0- Start Eclipse, import the project as an Existing Eclipse Project

1- Run Rdsl.xtext file ( lsdr/org.rdsl/src/org/Rdsl.xtext ) as "Generate Xtext Artifacts"

2- Run the project and choose " Eclipse Runtime Application "

3- In the editor opened by eclipse :
	3-1 : Create Java Project
	
	3-2 : Create two files with extension .graph and .instance in the src/ directory 
	
	3-3 : Copy and paste the content of proposed Test files ( the files are the directory lsdr/TestFile)
	
	3-4 : Copy and paste the jit library on the src-gen directory (copy just the lib directory : lsdr/Jit/lib )
	
        3-5 : Open the generated file xxxx_graph.html in a browser. If the graph is empty, just modify and save again xxxx.graph file (The generation happens when saving the graph file)
        
