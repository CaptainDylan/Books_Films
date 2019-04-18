1. DESCRIPTION 
---------------

The instructions below will help you get the 'Read It or Watch It?' Qlik Sense Dashboard up and running on your local machine. The Qlik Sense file in the CODE folder is self-contained as it connects directly to our storage database and contains code within it, but we have also provided a folder with all the code used to compile our dataset in the CODE folder. There's a separate overview file there describing those code files. 

2. INSTALLATION
---------------

1. 	Create a Qlik Sense Account and Download Qlik Sense

	You will need to first create an account with Qlik to download Qlik Sense Desktop.

	a.	If you are a professor or a student, take advantage of the Academic Program by applying here:
		https://www.qlik.com/us/company/academic-program

	b. 	If you are not a student or just don't want to obtain a student account, just register and download here:
		https://www.qlik.com/us/try-or-buy/download-qlik-sense
		

2.	Install Qlik Sense Desktop
	
	Important Note: While installing, be sure to include the Dashboard Bundle and the Visualization Bundle. 
	There should be 2 checkboxes under "Supported extension bundles". Please check both.

	Please note Qlik Sense Desktop requires a Windows OS. You can use a virtual machine if your native OS is not Windows.
					
3.	Download and Install Additional Extensions

	We made use of 2 additional free extensions to enhance our visualizations: 
		
	a. 	Mekaarogram
		A Qlik Sense extension used to display hierarchical structures from multiple dimensions.
		For more information, go to: https://github.com/miralemd/mekaarogram
	
	b.	Climber Cards
		A Qlik Sense Table extension with cards as cells, developed for showcasing items with images.
		For more information, go to: https://github.com/ClimberAB/ClimberCards
		
	Installation guide:
	
	We have downloaded the 2 extensions to make it easier for you. We zipped them together in the Extensions.zip file in this package.
	
	Unzip the Extensions.zip file and copy the 2 folders (cl-cards-v1.5.0 and mekaarogram-v0.8.1) to the following folder:
	"C:\Users[%Username%]\Documents\Qlik\Sense\Extensions"
		
	Once copied, you should have 2 new folders under the Extensions folder:
		- C:\Users[%Username%]\Documents\Qlik\Sense\Extensions\cl-cards-v1.5.0
		- C:\Users[%Username%]\Documents\Qlik\Sense\Extensions\mekaarogram-v0.8.1

4.	To install our file, all you will need to do is copy the "Read It or Watch It.qvf" file provided 	 in the CODE folder to the following path:
	"C:\Users[%Username%]\Documents\Qlik\Sense\Apps\"
		
3. EXECUTION 
---------------------

1.	Open Qlik Sense Desktop and login to your account
2.	On the Qlik Sense Hub, find the application called "Read It or Watch It" (it contains an image 		of a book with a clapper between the pages)
3.	Click on that Image to open up the Dashboard

Navigating the Dashboard:

The Dashboard starts by showing you all sheets (pages) available for you to explore.
We recommend that you start at the Home page: To Read or watch?
All you have to do is click on the image that says "Start Here" (with an arrow pointing to the sheet title: To Read or watch?)
You should now see the Home Page which lists the Top Books and Movies, an interactive scatterplot, a bar chart with book/movie rating as well as navigation buttons at the top.

Enjoy exploring more about your favorite movies and books!
