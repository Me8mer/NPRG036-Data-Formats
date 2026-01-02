require 'rdf'
require 'rdf/tabular'
require 'rdf/turtle'
require 'csv'
require 'uri'

# Load CSVW metadata
metadata_file = File.expand_path("../HW4/csv/data.csv-metadata.json", __dir__)
metadata = RDF::Tabular::Metadata.open(metadata_file)

graph = RDF::Graph.new

# --- Define prefixes ---
prefixes = {
  ex: RDF::URI("http://example.org/vocabulary/"),
  foaf: RDF::URI("http://xmlns.com/foaf/0.1/"),
  schema: RDF::URI("https://schema.org/"),
  xsd: RDF::URI("http://www.w3.org/2001/XMLSchema#"),
  rdfs: RDF::URI("http://www.w3.org/2000/01/rdf-schema#"),
  owl: RDF::URI("http://www.w3.org/2002/07/owl#"),
  dcterms: RDF::URI("http://purl.org/dc/terms/")
}

# --- Define ontology classes ---
classes = {
  "Owner" => { label: "Owner", subclass_of: prefixes[:foaf] + "Agent", comment: "An entity with the ownership over another entity" },
  "EShop" => { label: "E-Shop", subclass_of: prefixes[:schema] + "WebSite", comment: "A website operating as an online shop" },
  "Item" => { label: "Item", subclass_of: prefixes[:schema] + "Product", comment: "A single item for sale in an online shop" },
  "Cart" => { label: "Cart", subclass_of: prefixes[:schema] + "ItemList", comment: "A collection of items chosen for purchase" },
  "Account" => { label: "Account", subclass_of: prefixes[:foaf] + "OnlineAccount", comment: "An account in an online shop" },
  "Shopper" => { label: "Shopper", subclass_of: prefixes[:foaf] + "Person", comment: "A person with an account in an online shop" }
}

classes.each do |name, info|
  uri = prefixes[:ex] + name
  graph << [uri, RDF.type, RDF::RDFS.Class]
  graph << [uri, RDF::RDFS.label, RDF::Literal.new(info[:label], language: :en)]
  graph << [uri, RDF::RDFS.subClassOf, info[:subclass_of]]
  graph << [uri, RDF::RDFS.comment, RDF::Literal.new(info[:comment], language: :en)]
end

# --- Define properties ---
properties = {
  "password" => { type: RDF::OWL.DatatypeProperty, domain: prefixes[:ex] + "Account", range: prefixes[:xsd] + "string", label: "password", comment: "A password for an account in an online shop" },
  "owns" => { type: RDF::OWL.ObjectProperty, domain: prefixes[:foaf] + "Agent", range: RDF::OWL.Thing, label: "owns", comment: "An Agent owns a Thing" },
  "provides" => { type: RDF::OWL.ObjectProperty, domain: RDF::OWL.Thing, range: RDF::OWL.Thing, label: "provides", comment: "A Thing provides access to another Thing" },
  "contains" => { type: RDF::OWL.ObjectProperty, domain: RDF::OWL.Thing, range: RDF::OWL.Thing, label: "contains", comment: "A Thing contains another Thing" }
}

properties.each do |name, info|
  uri = prefixes[:ex] + name
  graph << [uri, RDF.type, info[:type]]
  graph << [uri, RDF::RDFS.label, RDF::Literal.new(info[:label], language: :en)]
  graph << [uri, RDF::RDFS.domain, info[:domain]]
  graph << [uri, RDF::RDFS.range, info[:range]]
  graph << [uri, RDF::RDFS.comment, RDF::Literal.new(info[:comment], language: :en)]
end

# --- Process CSV tables ---
metadata.tables.each do |table|
  table_schema = table.tableSchema
  primary_key = table_schema.primaryKey

  csv_path = table.url.to_s

  # If it's a file: URI, strip prefix
  if csv_path.start_with?("file:")
    csv_path = URI(csv_path).path
    csv_path = csv_path.sub(%r{^/([A-Za-z]:/)}, '\1') # Windows fix
  else
    csv_path = File.expand_path(csv_path, File.dirname(metadata_file))
  end

  CSV.foreach(csv_path, headers: true) do |row|
    table_schema.columns.each do |col|
      value = row[col.name]
      next if value.nil? || value.strip.empty?

      # Subject URI
      subject_uri = if col.aboutUrl
                      RDF::URI.new(col.aboutUrl.gsub("{#{col.name}}", value))
                    elsif primary_key && row[primary_key]
                      RDF::URI.new("http://example.org/#{File.basename(csv_path)}/#{row[primary_key]}")
                    else
                      RDF::URI.new("http://example.org/#{File.basename(csv_path)}/row/#{row.to_h.hash}")
                    end

      # Predicate URI
      predicate_uri = col.propertyUrl ? RDF::URI.new(col.propertyUrl) : prefixes[:ex] + col.name

      # Object literal
      # Object literal
	datatype = col.datatype ? col.datatype.to_s : nil
	object = case datatype
         when /integer$/i
           RDF::Literal.new(value.to_i, datatype: RDF::XSD.integer)
         when /decimal$/i, /double$/i
           RDF::Literal.new(value.to_f, datatype: RDF::XSD.double)
         when /boolean$/i
           RDF::Literal.new(value == "true", datatype: RDF::XSD.boolean)
         else
           # Force plain literal (no language)
           RDF::Literal.new(value.to_s)
         end

      graph << [subject_uri, predicate_uri, object]
    end
  end
end

# --- Write Turtle file ---
File.open("data.ttl", "w") do |f|
  RDF::Turtle::Writer.new(f, prefixes: prefixes) do |writer|
    graph.each_statement { |stmt| writer << stmt }
  end
end

puts "RDF Turtle file written to data.ttl"
