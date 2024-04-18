use Team_8;

CREATE TABLE IF NOT EXISTS TCGA_Metadata (
MID INT NOT NULL AUTO_INCREMENT,
File_ID CHAR(200) NOT NULL, 
File_Name CHAR(200),
Project_ID CHAR(10),
Case_ID	CHAR(30),
Sample_ID CHAR(30),
Sample_Type CHAR(30),
Vital_Status CHAR(10),
Submitter_ID CHAR(20),
Days_to_Death_or_Follow_Up INT,
Primary_Diagnosis CHAR(100),
Gender CHAR(10),
Vital CHAR(10),
ID INT,
PRIMARY KEY(MID, File_ID)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS TCGA_Splice(
SID INT AUTO_INCREMENT NOT NULL,
File_ID CHAR(100) NOT NULL,
Gene_ID CHAR(30),
Gene_Name CHAR(30),
Chromosome CHAR(5),
Strand ENUM('-', '+'),
Long_Exon_Start INT,
Long_Exon_End INT,
Short_Exon_Start INT,
Short_Exon_End INT,
Flanking_Exon_Start INT,
Flanking_Exon_End INT, 
Upstream_ES INT,
Upstream_EE INT, 
Downstream_ES INT,
Downstream_EE INT,
Exon_Start INT,
Exon_End INT,
1st_Exon_Start INT,
1st_Exon_End INT,
2nd_Exon_Start INT,
2nd_Exon_End INT,
Score DOUBLE,
Splicing_Event ENUM('a3ss', 'a5ss', 'afe', 'ale', 'mxe', 'ri', 'se'),
PRIMARY KEY(SID, File_ID)
)ENGINE=InnoDB;

-- updated order of the columns
CREATE TABLE IF NOT EXISTS TCGA_Splice(
SID INT AUTO_INCREMENT NOT NULL,
File_ID CHAR(100) NOT NULL,
Score DOUBLE,
Splicing_Event ENUM('a3ss', 'a5ss', 'afe', 'ale', 'mxe', 'ri', 'se'),
Gene_ID CHAR(30),
Strand ENUM('-', '+'),
Chromosome CHAR(5),
Long_Exon_Start INT,
Long_Exon_End INT,
Short_Exon_Start INT,
Short_Exon_End INT,
Flanking_Exon_Start INT,
Flanking_Exon_End INT,
Exon_Start INT,
Exon_End INT,
Upstream_ES INT,
Upstream_EE INT, 
Downstream_ES INT,
Downstream_EE INT,
1st_Exon_Start INT,
1st_Exon_End INT,
2nd_Exon_Start INT,
2nd_Exon_End INT,
Gene_Name CHAR(30),
PRIMARY KEY(SID, File_ID)
)ENGINE=InnoDB;





CREATE TABLE IF NOT EXISTS TCGA_HIT(
HID INT AUTO_INCREMENT NOT NULL,
File_ID CHAR(100) NOT NULL,
Gene_ID CHAR(50),
Gene_Name CHAR(30),
Chromosome CHAR(5),
Strand ENUM('-', '+'),
Exon_Start INT,
Exon_End INT,
Index_Score DOUBLE,
PRIMARY KEY(HID, File_ID)
)ENGINE=InnoDB;




CREATE TABLE IF NOT EXISTS TCGA_GEX(
GID INT AUTO_INCREMENT NOT NULL,
File_ID CHAR(100) NOT NULL, 
Gene_ID CHAR(50),
Gene_Name CHAR(20),
GEX_Count INT,
PRIMARY KEY(GID, File_ID)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS GTEX_MetaData(
MID INT AUTO_INCREMENT NOT NULL,
SAMPID CHAR(100) NOT NULL, 
SMTS CHAR(50),
SMTSD CHAR(50),
PRIMARY KEY(MID, SAMPID)
)ENGINE=InnoDB;




CREATE TABLE IF NOT EXISTS GTEX_Splice(
SID INT AUTO_INCREMENT NOT NULL,
File_ID CHAR(100) NOT NULL,
Gene_ID CHAR(30),
Chromosome CHAR(5),
Strand ENUM('-', '+'),
Long_Exon_Start INT,
Long_Exon_End INT,
Short_Exon_Start INT,
Short_Exon_End INT,
Flanking_Exon_Start INT,
Flanking_Exon_End INT, 
Upstream_Exon_Start INT,
Upstream_Exon_End INT, 
Downstream_Exon_Start INT,
Downstream_Exon_End INT,
Exon_Start INT,
Exon_End INT,
1st_Exon_Start INT,
1st_Exon_End INT,
2nd_Exon_Start INT,
2nd_Exon_End INT,
Splice_Score DOUBLE,
Splicing_Event ENUM('a3ss', 'a5ss', 'afe', 'ale', 'mxe', 'ri', 'se'),
PRIMARY KEY(SID, File_ID)
)ENGINE=InnoDB;



CREATE TABLE IF NOT EXISTS GTEX_HIT(
HID INT AUTO_INCREMENT NOT NULL,
File_ID CHAR(100) NOT NULL, 
Chromosome CHAR(5),
Strand ENUM('-', '+'),
POSITION CHAR(50),
HIT_Score DOUBLE,
PRIMARY KEY(HID, File_ID)
)ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS GTEX_GEX(
GID INT AUTO_INCREMENT NOT NULL,
File_ID CHAR(100) NOT NULL, 
Gene CHAR(50),
GEX_Count INT,
PRIMARY KEY(GID, File_ID)
)ENGINE=InnoDB;

LOAD DATA LOCAL INFILE '/Users/haniya/Desktop/BU/metadata_formatted.csv' 
INTO TABLE TCGA_Metadata
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(File_ID,File_Name,Project_ID,Case_ID,Sample_ID,Sample_Type,Vital_Status,Submitter_ID,
Days_to_Death_or_Follow_Up,Primary_Diagnosis,Gender,Vital,ID,Bin_ID);



Drop table TCGA_Metadata;

Drop table TCGA_Splice;


LOAD DATA LOCAL INFILE '/Users/haniya/Desktop/BU/spliceTypeSamples.csv' 
INTO TABLE TCGA_Splice
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(File_ID,Score,Splicing_Event,Gene_ID,Strand,Chromosome,Long_Exon_Start,Long_Exon_End,
Short_Exon_Start,Short_Exon_End,Flanking_Exon_Start,Flanking_Exon_End,Exon_Start,Exon_End,
Upstream_ES,Upstream_EE,Downstream_ES,Downstream_EE,1st_Exon_Start,1st_Exon_End,2nd_Exon_Start,2nd_Exon_End,Gene_Name);




 

select * from TCGA_Splice ts 
where Splicing_Event = 'a5ss';

select DISTINCT Splicing_Event from TCGA_Splice;

select * from TCGA_Splice ts 
where Splicing_Event = 'afe';

select * from TCGA_Splice ts 
where Splicing_Event = 'ri';

limit 10

#a3ss, a5ss, afe, ale, mxe, ri, se

select * from TCGA_Splice ts 
where Splicing_Event = 'se';

alter table TCGA_Splice add index gene_name_idx(Gene_Name);



alter table TCGA_Splice add index splice_type_idx(Splicing_Event);


show indexes from TCGA_Splice;

alter table TCGA_Splice add index gene_splice_idx(Gene_Name,Splicing_Event);


SELECT Primary_Diagnosis, s.Score, Strand, Chromosome, Exon_Start, Exon_End, Upstream_ES, Upstream_EE, Downstream_ES, Downstream_EE
FROM TCGA_Metadata t JOIN TCGA_Splice s using(File_ID) 
WHERE s.Gene_Name = "RMST" AND s.Splicing_Event = "a5ss" 
ORDER BY s.Score ASC;



alter table TCGA_HIT add index gene_idx(Gene_Name);

show indexes from TCGA_HIT;

alter table TCGA_GEX add index gene_idx(Gene_Name);

show indexes from TCGA_GEX;




