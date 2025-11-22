<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes"/>

	<xsl:template match="/EshopHierarchy">
		<html>
			<head>
				<title>E-Shop Overview</title>
				<style>
					body { font-family: Arial, sans-serif; }
					.eshop { margin-bottom: 20px; }
					.account { margin-left: 20px; }
					.cart { margin-left: 40px; }
				</style>
			</head>
			<body>
				<h1>E-Shop Hierarchy</h1>
				<xsl:apply-templates select="Owner"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="Owner">
		<div class="owner">
			<h2>Owner: <xsl:value-of select="Name"/></h2>
			<p>Company ID: <xsl:value-of select="CompanyID"/></p>
			<xsl:apply-templates select="EShop"/>
		</div>
	</xsl:template>

	<xsl:template match="EShop">
		<div class="eshop">
			<h3>Shop: <xsl:value-of select="Name"/></h3>
			<p>URL: <a href="{URL}"> <xsl:value-of select="URL"/></a></p>
			<p>Icon: <img src="{Icon}" alt="{Name}" width="50"/></p>
			<xsl:apply-templates select="Account"/>
		</div>
	</xsl:template>

	<xsl:template match="Account">
		<div class="account">
			<p>Login: <xsl:value-of select="Login"/></p>
			<p>Password: <xsl:value-of select="Password"/></p>
			<xsl:apply-templates select="Cart"/>
		</div>
	</xsl:template>

	<xsl:template match="Cart">
		<div class="cart">
			<p>Items: <xsl:value-of select="ItemCount"/></p>
			<p>Total Price: <xsl:value-of select="TotalPrice"/></p>
			<ul>
				<xsl:for-each select="Item">
					<li>
						<xsl:value-of select="Name"/> — $<xsl:value-of select="Price"/>
						<p>Description: <xsl:value-of select="Description"/></p>
						<p>Availability: <xsl:value-of select="Available"/></p>
						<xsl:for-each select="PromoImages">
							<li><a href="{.}"> <xsl:value-of select="."/></a></li>
						</xsl:for-each>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>

</xsl:stylesheet>
