require 'rdf'
require 'rdf/turtle'
require 'rdf/tabular'
require 'csv'
require 'uri'

# --- Load CSVW metadata ---
metadata_file = File.expand_path("../HW4/csv/data.csv-metadata.json", __dir__)
metadata = RDF::Tabular::Metadata.open(metadata_file)

graph = RDF::Graph.new

# --- Define prefixes ---
prefixes = {
  ex: RDF::URI("http://example.org/vocabulary/"),
  foaf: RDF::URI("http://xmlns.com/foaf/0.1/"),
  schema: RDF::URI("https://schema.org/"),
  dcterms: RDF::URI("http://purl.org/dc/terms/"),
  xsd: RDF::URI("http://www.w3.org/2001/XMLSchema#")
}

def shorten_uri(uri_str, prefixes)
  prefixes.each do |prefix, base_uri|
    if uri_str.start_with?(base_uri.to_s)
      return prefix + uri_str.sub(base_uri.to_s, "")
    end
  end
  uri_str  # fallback: return original if no match
end

# --- Process each table ---
metadata.tables.each do |table|
  schema = table.tableSchema

  # Resolve CSV file path
  csv_path = if table.url.to_s.start_with?("file:")
               URI(table.url.to_s).path.sub(%r{^/([A-Za-z]:/)}, '\1')
             else
               File.expand_path(table.url.to_s, File.dirname(metadata_file))
             end

  CSV.foreach(csv_path, headers: true) do |row|
    row = row.to_h

    id = row.values.first
    subject_uri = RDF::URI(schema.aboutUrl.to_s.gsub(/\{.+?\}/, id))

    # --- Type triple ---
    if schema.class
      class_uri = RDF::URI(schema.propertyUrl.to_s)
      graph << [subject_uri, RDF.type, class_uri]
    end

    # --- Add column triples ---
    schema.columns.each do |col|
      value = row[col.name]

      predicate = RDF::URI(col.propertyUrl)

      object =
        if col.datatype
          case col.datatype.to_s.downcase
          when /integer/
            RDF::Literal.new(value.to_i, datatype: RDF::XSD.integer)
          when /decimal/
            RDF::Literal.new(value.to_f, datatype: RDF::XSD.decimal)
          when /double/
            RDF::Literal.new(value.to_f, datatype: RDF::XSD.double)
          when /boolean/
            RDF::Literal.new(value == "true", datatype: RDF::XSD.boolean)
          when /string/
            col.lang ? RDF::Literal.new(value, language: col.lang.to_sym) : RDF::Literal.new(value, datatype: RDF::XSD.string)
          else
            RDF::Literal.new(value)
          end
        else
          RDF::Literal.new(value)
        end
      
      unless col.name.end_with?("Key")
        graph << [subject_uri, predicate, object]
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
