#!/usr/bin/env python3

import cgi
import cgitb
from string import Template
import pymysql

#LINK FOR WEB BROWSER:
#https://bioed.bu.edu/cgi-bin/students_24/jlha/DB_project.py


#for debugging
cgitb.enable()

# Connect to the database
connection = pymysql.connect(
	host='bioed.bu.edu',
	user='jlha',         
	password='jlha',    
	db="Team_8",
	port=4253	
)

# Create cursor object
cursor = connection.cursor()

# Create the html template
html_template = Template(
<html>
    <head>
        <title>${title}</title>
        <style>
            .tab {
                overflow: hidden;
                border: 1px solid #ccc;
                background-color: #f1f1f1;
            }
            /* Style the buttons inside the tab */
            .tab button {
                background-color: inherit;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 14px 16px;
                transition: 0.3s;
            } 
            /*Change background color of buttons on hover */
            .tab button:hover {
                background-color: #ddd;
            }
            /* Create an active tablink class */
            .tab button.active {
                background-color: #ccc;
            }
            .tabcontent {
                display: none;
                padding: 6px 12px;
                border: 1px solid #ccc;
                border-top: none;
            }
        </style>
    </head>
    <body>
        <h1>Combining TCGA and GTEX Data</h1>
        <div class="tab">
        	<button class="tablinks active" onclick="openTab(event, 'About')">About</button>
            <button class="tablinks" onclick="openTab(event, 'Search')">Search</button>
            <button class="tablinks" onclick="openTab(event, 'Response')">Response</button>
        </div>
        
        <!-- Tab content -->
        <div id="About" class="tabcontent">
            <p>This project aims to create a user interface that allows users to search different types of alternative splicing and view their relationships between phenotypes and genes. Data is derived from The Cancer Atlas Program (TCGA) which represents tissue data from 33 different cancer types. </p>
            <p>Alternative splicing is defined as a molecular process that alters pre-mRNAs prior to translation during which a single gene can produce multiple different mRNA transcripts by including/excluding different exons. This process allows for the generation of multiple protein isoforms from a single gene. This process increases the diversity of proteins that can be produced by the genome.</p>
			<img src="splicing_complexity.png" alt="from powerpoint" width="800" height="400">
			<p>Replicate multivariate analysis of transcript splicing (rMATS) quantifies alternative splicing events. Relative quantification in the form of a Percent Spliced-in Score (Ψ): Ψ∈ [0, 1]. The hybrid-internal-terminal (HIT) Index quantifies and classifies exons.</p>
			<img src="splicing_overview.png" alt="Fiszbein, Science Advances. (2022)." width="800" height="400">
			<p>In the context of disease, particularly cancer, alternative splicing plays a crucial role in tumorigenesis and cancer progression. Aberrant splicing patterns can lead to the production of cancer-specific isoforms that contribute to tumor development, metastasis, and drug resistance. Additionally, alternative splicing can impact the function of key regulatory proteins involved in cell cycle control, apoptosis, and signaling pathways, influencing the malignant phenotype of cancer cells.</p>
			
        </div>
        
        <div id="Search" class="tabcontent">
            ${form_html}
        </div>

        
        <div id="Response" class="tabcontent">
            <div id="response_gene_error">${response_gene_error}</div>
            <div id="responses">${responses}</div>
        </div>

        <script>
    // Function to switch between tabs
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tabcontent");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tablinks");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }

    // Get the element with id "About" and show it by default
    document.getElementById("About").style.display = "block";
    document.getElementsByClassName("tablinks")[1].classList.add("active");
</script>
    </body>
</html>
)


# Define the tab title
title="Alternative Splicing Database"

# Initialize empty responses
responses = ""
response_gene_error = ""

# Define the form
form_html="""
<form name="myForm" action="https://bioed.bu.edu/cgi-bin/students_24/jlha/DB_project.py" method="get"> 
    			<p>Input gene for example: INTS11</p>
                Gene name: 
    				<input type="text" name="gene_name">
                    
                    <br>
    			<p>Input splice mechanism, for example: a5ss </p>
				Mechanism: 
					<select name="mechanism">
						<option selected value="a3ss">a3ss</option>
						<option value="a5ss">a5ss</option>
						<option value="afe">afe</option>
                        <option value="ale">ale</option>
                        <option value="mxe">mxe</option>
                        <option value="ri">ri</option>
                        <option value="se">se</option>
					</select><br><br>
			
				<input type="submit" value="Submit">
</form>
"""

# Retrieve form data from the web server
form = cgi.FieldStorage()

# Test to see if there was any query string
if (form):

    # Get individual values from the form data
    # Use getvalue when there is only one instance of the key in the query string
    gene_name = form.getvalue("gene_name")       
    mechanism = form.getvalue("mechanism")

    try:
        # Query the database - find if the gene exists
        query_1 = """
                SELECT s.Gene_Name
                FROM TCGA_Splice s
                WHERE s.Gene_Name = %s;
                """

        cursor.execute(query_1, (gene_name))
        gene_results = cursor.fetchall()

        if not gene_results:
            response_gene_error = Template(
            """
            <p style='color: red;'>
            Error: Gene ${gene_name} not found in the splicing database.
            </p>
            """
            )
            response_gene_error = response_gene_error.safe_substitute(gene_name=gene_name)

        else:
            # Query the database - What does the alternative splicing look like for a particular phenotype
            query_2 = """
                    SELECT primary_diagnosis
                    FROM META JOIN TCGA_Splice using (File_ID) 
                    WHERE s.Gene_Name = %s AND s.Splicing_Event = %s 
                    ORDER BY t.score ASC;
                    """

            cursor.execute(query_2, (gene_name, mechanism))
            gene_splice_results = cursor.fetchall()

            if gene_splice_results:
                # Create HTML table for results
                table_html = "<table border='1'><tr><th>mid</th><th>miRNA name</th><th>targeting score</th></tr>"
                for result in mirna_results:
                    table_html += f"<tr><td>{result[0]}</td><td>{result[1]}</td><td>{result[2]}</td></tr>"
                table_html += "</table>"

                # Create summary statement
                #count = len(mirna_results)
                #summary = f"Gene {gene_name} is targeted by {count} miRNAs with scores ≤ {maximum}."            
            else:
                table_html = ""  # Empty table if no results
                summary = f"No miRNAs found for gene {gene_name} with scores ≤ {maximum}."

            # Create a returning template for the html
            responses = Template(
            """           
            <p>
            ${summary} <br><br>
            ${table_html} <br>
            </p>
            """
            )  
            # Get complete response
            responses = responses.safe_substitute(summary=summary, table_html=table_html)

    except pymysql.Error as e:
        # Handle database query errors
        responses = f"<p>Error: {e}</p>"

print("Content-type: text/html\n")
print(html_template.safe_substitute(title=title, responses=responses, form_html=form_html, response_gene_error= response_gene_error))