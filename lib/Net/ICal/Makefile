DESIGNDATA = ../../../../libical/design-data
ICALSCRIPTS =../../../../libical/scripts

all: property parameter value component

property:
	$(ICALSCRIPTS)/mkderivedproperties.pl -i Property.pm -p $(DESIGNDATA)/prop-to-value.txt ${DESIGNDATA}/value-c-types.txt > Property.newpm
	mv Property.newpm Property.pm


parameter: 
	$(ICALSCRIPTS)/mkderivedparameters.pl -i Parameter.pm -p $(DESIGNDATA)/param-c-types.txt > Parameter.newpm
	mv Parameter.newpm Parameter.pm


value: 
	$(ICALSCRIPTS)/mkderivedvalues.pl -i Value.pm -p $(DESIGNDATA)/value-c-types.txt > Value.newpm
	mv Value.newpm Value.pm


component: 
	$(ICALSCRIPTS)/mkderivedcomponents.pl -i Component.pm -p $(DESIGNDATA)/components.txt > Component.newpm
	mv Component.newpm Component.pm



