# Access Point map database support tools 

The tools should work with CSV files in many languages.

Main target readers are those who use Japanese.

## Functions
`apmap-eduroamJP.pl` is an assistant tool that reads
Access Point management sheet in Cityroam format
and produces AP map data for the eduroam JP mapping system.

`apmap-kml.pl` is an assistant tool that reads
Access Point management sheet in Cityroam format
and produces KML data for Google maps (Placemark sections only).

## About the Cityroam-standard spreadsheet
This is Cityroam-standard spreadsheet for Access Point management,
developed at the Cityroam Federation.
The sheet is designed to makee it easier to exchange the map data
across different organizations.

When used within an organization, you may define columns at the right
for local use.
You may add new labels in the line begining with "visibility" 
as long as the labels do not conflict with an existing one.

## Notes
- **No Pull Requests.**  
We don't accept immediate PRs.
Please open Issue first when you have a fix or feature request.
- Security isn't considered so well for the input data.
Special caution is needed when used in a system such as web service.

