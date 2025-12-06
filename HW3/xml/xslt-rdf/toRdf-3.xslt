<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ex="http://example.org/vocabulary/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:schema="https://schema.org/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    exclude-result-prefixes="xsl">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/ShopperHierarchy">
	  <xsl:value-of select="concat('@prefix ex: &lt;', 'http://example.org/vocabulary/', '&gt; .&#10;')" disable-output-escaping="yes"/>
	  <xsl:value-of select="concat('@prefix rdfs: &lt;', 'http://www.w3.org/2000/01/rdf-schema#', '&gt; .&#10;')" disable-output-escaping="yes"/>
	  <xsl:value-of select="concat('@prefix foaf: &lt;', 'http://xmlns.com/foaf/0.1/', '&gt; .&#10;')" disable-output-escaping="yes"/>
	  <xsl:value-of select="concat('@prefix schema: &lt;', 'https://schema.org/', '&gt; .&#10;')" disable-output-escaping="yes"/>
	  <xsl:value-of select="concat('@prefix owl: &lt;', 'http://www.w3.org/2002/07/owl#', '&gt; .&#10;')" disable-output-escaping="yes"/>
	  <xsl:value-of select="concat('@prefix xsd: &lt;', 'http://www.w3.org/2001/XMLSchema#', '&gt; .&#10;')" disable-output-escaping="yes"/>
	  <xsl:value-of select="concat('@prefix dcterms: &lt;', 'http://purl.org/dc/terms/', '&gt; .&#10;&#10;')" disable-output-escaping="yes"/>

	  <xsl:for-each select="Shopper">
		  <xsl:variable name="ID" select="position()"/>
		  
		  <xsl:value-of select="concat('ex:', 'Shopper', $ID)"/>
		  <xsl:text> a ex:Shopper ;&#10;</xsl:text>
		  <xsl:text>  foaf:givenName "</xsl:text>
		  <xsl:value-of select="FirstName"/>
		  <xsl:text>"</xsl:text>
		  <xsl:if test="FirstName/@xml:lang">
			  <xsl:text>@</xsl:text>
			  <xsl:value-of select="FirstName/@xml:lang"/>
		  </xsl:if>
		  <xsl:text> ;&#10;</xsl:text>
		  <xsl:text>  foaf:familyName "</xsl:text>
		  <xsl:value-of select="LastName"/>
		  <xsl:text>"</xsl:text>
		  <xsl:if test="LastName/@xml:lang">
			  <xsl:text>@</xsl:text>
			  <xsl:value-of select="LastName/@xml:lang"/>
		  </xsl:if>
		  <xsl:text> .&#10;&#10;</xsl:text>
		  
		  <xsl:for-each select="Account">
			  <xsl:value-of select="concat('ex:', 'Account', $ID)"/>
			  <xsl:text> a ex:Account ;&#10;</xsl:text>
			  <xsl:text>  foaf:accountName "</xsl:text>
			  <xsl:value-of select="Login"/>
			  <xsl:text>"</xsl:text>
			  <xsl:if test="Login/@xml:lang">
				  <xsl:text>@</xsl:text>
				  <xsl:value-of select="Login/@xml:lang"/>
			  </xsl:if>
			  <xsl:text>;&#10;</xsl:text>
			  <xsl:text>  ex:password "</xsl:text>
			  <xsl:value-of select="Password"/>
			  <xsl:text>" .&#10;&#10;</xsl:text>
		  </xsl:for-each>
	  </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
