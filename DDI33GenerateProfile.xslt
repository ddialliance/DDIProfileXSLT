<?xml version="1.0" encoding="UTF-8"?>
<!--

GenerateDDIProfile.xslt

Generates a basic DDI profile on the basis of a DDI instance

The approach to find the unique elements (with complete XPath) of a DDI instance
is a combination of two solutions mentioned in the XSLT FAQ at:
http://www.dpawson.co.uk/xsl/sect2/sect21.html
Chapter Sorting, Topic 13, Removing duplicates Muenchian solution
Chapter Path Trace, Topic 5, Grabbing the path to a particular node

joachim.wackerow@gesis.org

2014-04-28 changes for DDI 3.2
2010-05-19 version for DDI 3.1

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pr="ddi:ddiprofile:3_3" xmlns:r="ddi:reusable:3_3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<!-- - - - - - - - - - - -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- - - - - - - - - - - -->
	<xsl:key name="Namespace" match="*" use="namespace-uri(.)"/>
	<xsl:key name="Element" match="*" use="name(.)"/>
	<!-- - - - - - - - - - - -->
	<xsl:template match="/">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>href="DDI33Profile2html.xslt" type="text/xsl"</xsl:text>
		</xsl:processing-instruction>
		<pr:DDIProfile xsi:schemaLocation="ddi:instance:3_3 http://www.ddialliance.org/Specification/DDI-Lifecycle/3.3/XMLSchema/instance.xsd">
			<r:URN>urn:ddi:xx.agencyid:objectid:1</r:URN>
			<pr:DDIProfileName>
				<r:String>?? A name for the profile. May be expressed in multiple languages. Repeat the element to express names with different content, for example different names for different systems.</r:String>
			</pr:DDIProfileName>
			<r:Label>
				<r:Content>?? A display label for the profile. May be expressed in multiple languages. Repeat for labels with different content, for example, labels with differing length limitations.</r:Content>
			</r:Label>
			<r:Description>
				<r:Content>?? A description of the content and purpose of the profile. May be expressed in multiple languages and supports the use of structured content.</r:Content>
			</r:Description>
			<pr:ApplicationOfProfile>?? A brief description of the intended applications of the profile. Supports the use of an external controlled vocabulary.</pr:ApplicationOfProfile>
			<r:Purpose>
				<r:Content>?? Purpose describes the purpose of creating the profile such as describing the coverage of a distribution software system.</r:Content>
			</r:Purpose>
			<pr:XPathVersion>1.0</pr:XPathVersion>
			<pr:DDINamespace>3.3</pr:DDINamespace>
			<!-- list used namespaces -->
			<xsl:apply-templates select="*" mode="Namespace"/>
			<!-- list used elements -->
			<xsl:comment> Element "Used": Adjust the attributes isRequired and fixedValue (currently set to default values). Additionally, the attributes "defaultValue" and "limitMaxOccurs" are possible.</xsl:comment>
			<xsl:apply-templates select="*" mode="Path"/>
		</pr:DDIProfile>
	</xsl:template>
	<!-- - - - - - - - - - - -->
	<xsl:template match="*" mode="Namespace">
		<xsl:variable name="IdOfCurrentElement" select="generate-id(.)"/>
		<xsl:variable name="CurrentNamespace" select="namespace-uri(.)"/>
		<xsl:variable name="CurrentNamespacePrefix" select="substring-before( name(.), ':' )"/>
		<xsl:variable name="IdOfIndexedElement" select="generate-id( key( 'Namespace', $CurrentNamespace )[1] )"/>
		<xsl:if test=" $IdOfCurrentElement = $IdOfIndexedElement ">
			<pr:XMLPrefixMap>
				<pr:XMLPrefix>
					<xsl:value-of select="$CurrentNamespacePrefix"/>
				</pr:XMLPrefix>
				<pr:XMLNamespace>
					<xsl:value-of select="$CurrentNamespace"/>
				</pr:XMLNamespace>
			</pr:XMLPrefixMap>
		</xsl:if>
		<xsl:apply-templates select="*" mode="Namespace"/>
	</xsl:template>
	<!-- - - - - - - - - - - -->
	<xsl:template match="*" mode="Path">
		<xsl:variable name="IdOfCurrentElement" select="generate-id(.)"/>
		<xsl:variable name="IdOfIndexedElement" select="generate-id( key( 'Element', name(.) )[1] )"/>
		<xsl:variable name="Path">
			<xsl:for-each select="ancestor-or-self::*[ $IdOfCurrentElement = $IdOfIndexedElement ]">
				<xsl:text>/</xsl:text>
				<xsl:value-of select="name()"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test=" count( ancestor-or-self::*[ $IdOfCurrentElement = $IdOfIndexedElement ] ) > 0 ">
			<pr:Used xpath="{$Path}" fixedValue="false" isRequired="false"/>
		</xsl:if>
		<xsl:apply-templates select="*" mode="Path"/>
	</xsl:template>
	<!-- - - - - - - - - - - -->
</xsl:stylesheet>
