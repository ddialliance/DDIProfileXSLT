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

2010-05-19

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pr="ddi:ddiprofile:3_1" xmlns:r="ddi:reusable:3_1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<!-- - - - - - - - - - - -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- - - - - - - - - - - -->
	<xsl:key name="Namespace" match="*" use="namespace-uri(.)"/>
	<xsl:key name="Element" match="*" use="name(.)"/>
	<!-- - - - - - - - - - - -->
	<xsl:template match="/">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>href="DDI31Profile2html.xslt" type="text/xsl"</xsl:text>
		</xsl:processing-instruction>
		<pr:DDIProfile id="p1" xsi:schemaLocation="ddi:instance:3_1 http://www.ddialliance.org/schema/ddi3.1/instance.xsd">
			<r:Label>DDI Profile for ??</r:Label>
			<r:Description>This is a DDI Profile for ??. It can be used for interoperability purposes. ??</r:Description>
			<pr:XPathVersion>1.0</pr:XPathVersion>
			<pr:DDINamespace>3.1</pr:DDINamespace>
			<!-- list used namespaces -->
			<xsl:apply-templates select="*" mode="Namespace"/>
			<!-- list used elements -->
			<xsl:comment> Element "Used": Adjust the attributes with default values. Additionally, the attribute "defaultValue" is possible </xsl:comment>
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
			<pr:Used path="{$Path}" fixedValue="false" required="false"/>
		</xsl:if>
		<xsl:apply-templates select="*" mode="Path"/>
	</xsl:template>
	<!-- - - - - - - - - - - -->
</xsl:stylesheet>
