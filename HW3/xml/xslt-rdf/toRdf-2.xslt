<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ex="http://example.org/vocabulary/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:schema="https://schema.org/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    exclude-result-prefixes="xsl">

	<xsl:output method="text" encoding="UTF-8"/>

	<xsl:template match="/ItemsHierarchy">
		<xsl:value-of select="concat('@prefix ex: &lt;', 'http://example.org/vocabulary/', '&gt; .&#10;')" disable-output-escaping="yes"/>
		<xsl:value-of select="concat('@prefix rdfs: &lt;', 'http://www.w3.org/2000/01/rdf-schema#', '&gt; .&#10;')" disable-output-escaping="yes"/>
		<xsl:value-of select="concat('@prefix foaf: &lt;', 'http://xmlns.com/foaf/0.1/', '&gt; .&#10;')" disable-output-escaping="yes"/>
		<xsl:value-of select="concat('@prefix schema: &lt;', 'https://schema.org/', '&gt; .&#10;')" disable-output-escaping="yes"/>
		<xsl:value-of select="concat('@prefix owl: &lt;', 'http://www.w3.org/2002/07/owl#', '&gt; .&#10;')" disable-output-escaping="yes"/>
		<xsl:value-of select="concat('@prefix xsd: &lt;', 'http://www.w3.org/2001/XMLSchema#', '&gt; .&#10;')" disable-output-escaping="yes"/>
		<xsl:value-of select="concat('@prefix dcterms: &lt;', 'http://purl.org/dc/terms/', '&gt; .&#10;&#10;')" disable-output-escaping="yes"/>

		<xsl:for-each select="EShop">
			<xsl:variable name="ID" select="position()"/>

			<xsl:value-of select="concat('ex:EShop', $ID)"/>
			<xsl:text> a ex:EShop ;&#10;</xsl:text>
			<xsl:text>  foaf:name "</xsl:text>
			<xsl:value-of select="Name"/>
			<xsl:text>"</xsl:text>
			<xsl:if test="Name/@xml:lang">
				<xsl:text>@</xsl:text>
				<xsl:value-of select="Name/@xml:lang"/>
			</xsl:if>
			<xsl:text> ;&#10;</xsl:text>

			<xsl:text>  schema:url </xsl:text>
			<xsl:value-of select="concat('&lt;', URL, '&gt;')" disable-output-escaping="yes"/>
			<xsl:text> ;&#10;</xsl:text>

			<xsl:text>  schema:image </xsl:text>
			<xsl:value-of select="concat('&lt;', Icon, '&gt;')" disable-output-escaping="yes"/>
			<xsl:text> .&#10;&#10;</xsl:text>

			<xsl:for-each select="Item">
				<xsl:value-of select="concat('ex:Item', $ID)"/>
				<xsl:text> a ex:Item ;&#10;</xsl:text>
				<xsl:text>  foaf:name "</xsl:text>
				<xsl:value-of select="Name"/>
				<xsl:text>"</xsl:text>
				<xsl:if test="Name/@xml:lang">
					<xsl:text>@</xsl:text>
					<xsl:value-of select="Name/@xml:lang"/>
				</xsl:if>
				<xsl:text> ;&#10;</xsl:text>

				<xsl:text>  schema:price "</xsl:text>
				<xsl:value-of select="Price"/>
				<xsl:text>"^^xsd:decimal ;&#10;</xsl:text>

				<xsl:text>  dcterms:description "</xsl:text>
				<xsl:value-of select="Description"/>
				<xsl:text>"</xsl:text>
				<xsl:if test="Description/@xml:lang">
					<xsl:text>@</xsl:text>
					<xsl:value-of select="Description/@xml:lang"/>
				</xsl:if>
				<xsl:text> ;&#10;</xsl:text>

				<xsl:text>  schema:availability </xsl:text>
				<xsl:value-of select="concat('&lt;', Available, '&gt;')" disable-output-escaping="yes"/>
				<xsl:text> ;&#10;</xsl:text>

				<xsl:for-each select="PromoImages">
					<xsl:if test="position() != 1">
						<xsl:text> ;&#10;</xsl:text>
					</xsl:if>
					<xsl:text>  schema:image </xsl:text>
					<xsl:value-of select="concat('&lt;', ., '&gt;')" disable-output-escaping="yes"/>
				</xsl:for-each>
				<xsl:text> .&#10;&#10;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
