<?xml version="1.0" encoding="UTF-8"?>
<!--

DDI31Profile2html.xslt

Generates HTML page based on a DDI profile.
Current limitations: ignores element NotUsed

joachim.wackerow@gesis.org

2014-05-17 integration of mapping of namespaces to filenames
2013-11 changes for links to documentation
2010-05-19

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pr="ddi:ddiprofile:3_1" xmlns:r="ddi:reusable:3_1" xmlns="http://www.w3.org/1999/xhtml" xmlns:my="my:namespace-file-mapping" exclude-result-prefixes="my pr r">
	<!-- - - - - - - - - - - -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:param name="sort" select=" 'y' "/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:variable name="URLPrefix" select=" 'http://www.ddialliance.org/Specification/DDI-Lifecycle/3.1/XMLSchema/FieldLevelDocumentation/' "/>
	<xsl:variable name="URLIntermediatePiece" select=" '/elements/' "/>
	<xsl:variable name="URLPostfix" select=" '.html' "/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<my:NamespaceFileMapping>
		<my:Map key="ddi:archive:3_1" value="archive_xsd"/>
		<my:Map key="ddi:comparative:3_1" value="comparative_xsd"/>
		<my:Map key="ddi:conceptualcomponent:3_1" value="conceptualcomponent_xsd"/>
		<my:Map key="ddi:datacollection:3_1" value="datacollection_xsd"/>
		<my:Map key="ddi:dataset:3_1" value="dataset_xsd"/>
		<my:Map key="ddi:dcelements:3_1" value="dcelements_xsd"/>
		<my:Map key="ddi:ddiprofile:3_1" value="ddiprofile_xsd"/>
		<my:Map key="ddi:group:3_1" value="group_xsd"/>
		<my:Map key="ddi:instance:3_1" value="instance_xsd"/>
		<my:Map key="ddi:logicalproduct:3_1" value="logicalproduct_xsd"/>
		<my:Map key="ddi:physicaldataproduct:3_1" value="physicaldataproduct_xsd"/>
		<my:Map key="ddi:physicaldataproduct_ncube_inline:3_1" value="physicaldataproduct_ncube_inline_xsd"/>
		<my:Map key="ddi:physicaldataproduct_ncube_normal:3_1" value="physicaldataproduct_ncube_normal_xsd"/>
		<my:Map key="ddi:physicaldataproduct_ncube_tabular:3_1" value="physicaldataproduct_ncube_tabular_xsd"/>
		<my:Map key="ddi:physicaldataproduct_proprietary:3_1" value="physicaldataproduct_proprietary_xsd"/>
		<my:Map key="ddi:physicalinstance:3_1" value="physicalinstance_xsd"/>
		<my:Map key="ddi:reusable:3_1" value="reusable_xsd"/>
		<my:Map key="ddi:studyunit:3_1" value="studyunit_xsd"/>
	</my:NamespaceFileMapping>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:key name="NamespaceFileMapping" match="/xsl:stylesheet/my:NamespaceFileMapping/my:Map" use="@key"/>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="/">
		<xsl:apply-templates select="//pr:DDIProfile"/>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="pr:DDIProfile">
		<html>
			<head>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<title>
					<xsl:call-template name="Title"/>
				</title>
				<xsl:call-template name="Style"/>
			</head>
			<body>
				<xsl:call-template name="PageHeader"/>
				<hr/>
				<xsl:call-template name="Namespace"/>
				<hr/>
				<xsl:call-template name="Path"/>
			</body>
		</html>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template name="Title">
		<xsl:value-of select="r:Label"/>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template name="Style">
		<style type="text/css"><![CDATA[
body {
  margin: 2em;
  font-size: 80%;
}
h2 {
  font-size: 130%;
}
hr {
  clear: left;
  color: #D3D3D3; /*lightgrey */
  margin-top: 2em;
  margin-bottom: 2em;
  margin-left: 10%;
  margin-right: 10%;
}
table, th, td {
  border-style: solid;
  border-color: #D3D3D3; /*lightgrey */
  border-collapse: collapse;
}
caption {
  font-size: 130%;
  font-weight: bold;
  margin-bottom: 1em;
  text-align: left;
}
thead {
  font-size: 120%;
}
th, td {
  padding: 0.5em;
  vertical-align: top;
}
td.center {
  text-align: center;
}
tr.Path>td, td.Path {
  border-top-width: 10px;
}
td.Path {
  font-weight: bold;
}
]]></style>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template name="PageHeader">
		<h1>
			<xsl:call-template name="Title"/>
		</h1>
		<hr/>
		<h2>Description</h2>
		<p>
			<xsl:value-of select="r:Description"/>
		</p>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template name="Namespace">
		<table>
			<caption>XML Namespaces</caption>
			<thead>
				<tr>
					<th>Used Namespace Prefix</th>
					<th>Namespace</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="pr:XMLPrefixMap">
					<xsl:sort select="pr:XMLNamespace"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template name="Path">
		<table border="1">
			<caption>Used Elements</caption>
			<thead>
				<tr>
					<th>XPath</th>
					<th>Required</th>
					<th>Fixed Value</th>
					<th>Default Value</th>
					<th>Doc.</th>
				</tr>
			</thead>
			<tbody>
				<xsl:choose>
					<xsl:when test=" $sort = 'y' ">
						<xsl:apply-templates select="pr:Used">
							<xsl:sort select="@path"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="pr:Used"/>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="pr:XMLPrefixMap">
		<tr>
			<td>
				<xsl:value-of select="pr:XMLPrefix"/>
			</td>
			<td>
				<xsl:value-of select="pr:XMLNamespace"/>
			</td>
		</tr>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="pr:Used">
		<tr>
			<td class="Path">
				<xsl:value-of select="@path"/>
			</td>
			<td class="center">
				<xsl:choose>
					<xsl:when test="normalize-space( @required ) != '' ">
						<xsl:value-of select="@required"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>false</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="center">
				<xsl:choose>
					<xsl:when test="normalize-space( @fixedValue ) != '' ">
						<xsl:value-of select="@fixedValue"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>false</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="center">
				<xsl:choose>
					<xsl:when test="normalize-space( @defaultValue ) != '' ">
						<xsl:value-of select="@defaultValue"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td align="center">
				<xsl:variable name="DocURL">
					<xsl:call-template name="DocURL"/>
				</xsl:variable>
				<a href="{$DocURL}" target="_blank">⇗</a>
			</td>
		</tr>
		<xsl:if test="normalize-space( pr:Description ) != '' ">
			<tr>
				<td colspan="5">
					<span style="font-style:italic">
						<xsl:text>Description: </xsl:text>
					</span>
					<xsl:apply-templates select="pr:Instructions"/>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="normalize-space( pr:Instructions ) != '' ">
			<tr>
				<td colspan="5">
					<span style="font-style:italic">
						<xsl:text>Instructions: </xsl:text>
					</span>
					<xsl:apply-templates select="pr:Instructions"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="r:Content">
		<div>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template name="DocURL">
		<!-- is it an attribute? -->
		<xsl:variable name="InputString">
			<xsl:choose>
				<xsl:when test="contains( @path, '@' )">
					<xsl:value-of select="substring-before( @path, '/@' )"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@path"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="FullElementName">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="input" select="$InputString"/>
				<xsl:with-param name="marker" select=" '/' "/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="NamespacePrefix" select="substring-before($FullElementName, ':' )"/>
		<xsl:variable name="Namespace" select="../pr:XMLPrefixMap[pr:XMLPrefix = $NamespacePrefix ]/pr:XMLNamespace"/>
		<!-- based on XSLT FAQ, Keys -->
		<!-- see: http://www.dpawson.co.uk/xsl/sect2/N4852.html#d6183e1398 -->
		<xsl:variable name="ModuleFilename">
			<xsl:for-each select="document( '' )">
				<xsl:value-of select="key( 'NamespaceFileMapping', $Namespace )/@value"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="ElementName">
			<xsl:choose>
				<xsl:when test="contains( $FullElementName, ':' )">
					<xsl:value-of select="substring-after( $FullElementName, ':' )"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$FullElementName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$URLPrefix"/>
		<xsl:value-of select="$ModuleFilename"/>
		<xsl:value-of select="$URLIntermediatePiece"/>
		<xsl:value-of select="$ElementName"/>
		<xsl:value-of select="$URLPostfix"/>
	</xsl:template>
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<!-- based on XSLT FAQ, Substring-after, last occurrence -->
	<!-- see: http://www.dpawson.co.uk/xsl/sect2/N7240.html#d10127e532 -->
	<xsl:template name="substring-after-last">
		<xsl:param name="input"/>
		<xsl:param name="marker"/>
		<xsl:choose>
			<xsl:when test="contains($input,$marker)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="substring-after($input,$marker)"/>
					<xsl:with-param name="marker" select="$marker"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$input"/>
			</xsl:otherwise>
		</xsl:choose>
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	</xsl:template>
</xsl:stylesheet>
