# XSLT (1.0) Stylesheets for DDI Profiles

DDI31GenerateProfile.xslt and DDI32GenerateProfile.xslt create a DDI Profile
template on the basis of an existing DDI instance.

DDI31Profile2html.xslt and DDI32Profile2html.xslt render a DDI Profile in HTML.

# Usage

## Generate DDI XML Profile 

    xsltproc -o outputfile.xml DDI3xGenerateProfile.xslt input.xml

The outputfile.xml (The DDI Profile) contains the following fields which can be edited to annotate the Profile for a user. 
- ProfileName
- Label
- Description
- Purpose

In addition, the Profile can be refined by amending the attributes to indicate whether the element is mandatory or not
- fixedValue
- isRequired

## Generate DDI HTML Profile from DDI XML Profile

    xsltproc -o outputfile.html DDI3xProfile2HTML outputfile.xml

# Provenance

This repository was cloned from [https://bitbucket.org/wackerow/ddiprofilexslt/src/master/] 
