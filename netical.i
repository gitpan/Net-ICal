/* -*- Mode: C -*-*/
/*======================================================================
  FILE: ical.i

  (C) COPYRIGHT 1999 Eric Busboom
  http://www.softwarestudio.org

  The contents of this file are subject to the Mozilla Public License
  Version 1.0 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
  the License for the specific language governing rights and
  limitations under the License.

  The original author is Eric Busboom

  Contributions from:
  Graham Davison (g.m.davison@computer.org)

  ======================================================================*/  

%module Net__ICal

%{
#include "ical.h"
#include "pvl.h"
#include "icalstore.h"
#include "icalcluster.h"
#include "icalcalendar.h"

#include <sys/types.h> /* for size_t */
#include <time.h>

%}


/**********************************************************************
	ical.h
**********************************************************************/

/**********************************************************************
	icalenums.h
**********************************************************************/

typedef enum icalcomponent_kind {
    ICAL_NO_COMPONENT,
    ICAL_ANY_COMPONENT,	
    ICAL_XROOT_COMPONENT,
    ICAL_XATTACH_COMPONENT, 
    ICAL_VEVENT_COMPONENT,
    ICAL_VTODO_COMPONENT,
    ICAL_VJOURNAL_COMPONENT,
    ICAL_VCALENDAR_COMPONENT,
    ICAL_VFREEBUSY_COMPONENT,
    ICAL_VALARM_COMPONENT,
    ICAL_XAUDIOALARM_COMPONENT,  
    ICAL_XDISPLAYALARM_COMPONENT,
    ICAL_XEMAILALARM_COMPONENT,
    ICAL_XPROCEDUREALARM_COMPONENT,
    ICAL_VTIMEZONE_COMPONENT,
    ICAL_XSTANDARD_COMPONENT,
    ICAL_XDAYLIGHT_COMPONENT,
    ICAL_X_COMPONENT,
    ICAL_VSCHEDULE_COMPONENT,
    ICAL_VQUERY_COMPONENT,
    ICAL_VCAR_COMPONENT,
    ICAL_VCOMMAND_COMPONENT,
    ICAL_XLICINVALID_COMPONENT
} icalcomponent_kind;
typedef enum icalproperty_kind {
    ICAL_ANY_PROPERTY = 0, 
    ICAL_CALSCALE_PROPERTY,
    ICAL_METHOD_PROPERTY,
    ICAL_PRODID_PROPERTY,
    ICAL_VERSION_PROPERTY,
    ICAL_ATTACH_PROPERTY,
    ICAL_CATEGORIES_PROPERTY,
    ICAL_CLASS_PROPERTY,
    ICAL_COMMENT_PROPERTY,
    ICAL_DESCRIPTION_PROPERTY,
    ICAL_GEO_PROPERTY,
    ICAL_LOCATION_PROPERTY,
    ICAL_PERCENTCOMPLETE_PROPERTY,
    ICAL_PRIORITY_PROPERTY,
    ICAL_RESOURCES_PROPERTY,
    ICAL_STATUS_PROPERTY,
    ICAL_SUMMARY_PROPERTY,
    ICAL_COMPLETED_PROPERTY,
    ICAL_DTEND_PROPERTY,
    ICAL_DUE_PROPERTY,
    ICAL_DTSTART_PROPERTY,
    ICAL_DURATION_PROPERTY,
    ICAL_FREEBUSY_PROPERTY,
    ICAL_TRANSP_PROPERTY,
    ICAL_TZID_PROPERTY,
    ICAL_TZNAME_PROPERTY,
    ICAL_TZOFFSETFROM_PROPERTY,
    ICAL_TZOFFSETTO_PROPERTY,
    ICAL_TZURL_PROPERTY,
    ICAL_ATTENDEE_PROPERTY,
    ICAL_CONTACT_PROPERTY,
    ICAL_ORGANIZER_PROPERTY,
    ICAL_RECURRENCEID_PROPERTY,
    ICAL_RELATEDTO_PROPERTY,
    ICAL_URL_PROPERTY,
    ICAL_UID_PROPERTY,
    ICAL_EXDATE_PROPERTY,
    ICAL_EXRULE_PROPERTY,
    ICAL_RDATE_PROPERTY,
    ICAL_RRULE_PROPERTY,
    ICAL_ACTION_PROPERTY,
    ICAL_REPEAT_PROPERTY,
    ICAL_TRIGGER_PROPERTY,
    ICAL_CREATED_PROPERTY,
    ICAL_DTSTAMP_PROPERTY,
    ICAL_LASTMODIFIED_PROPERTY,
    ICAL_SEQUENCE_PROPERTY,
    ICAL_REQUESTSTATUS_PROPERTY,
    ICAL_X_PROPERTY,
    
    ICAL_SCOPE_PROPERTY,
    ICAL_MAXRESULTS_PROPERTY,
    ICAL_MAXRESULTSSIZE_PROPERTY,
    ICAL_QUERY_PROPERTY,
    ICAL_QUERYNAME_PROPERTY, 
    ICAL_TARGET_PROPERTY,
    
    ICAL_XLICERROR_PROPERTY,
    ICAL_XLICCLUSTERCOUNT_PROPERTY,
    ICAL_NO_PROPERTY 
} icalproperty_kind;
typedef enum icalproperty_method {
    ICAL_METHOD_PUBLISH,
    ICAL_METHOD_REQUEST,
    ICAL_METHOD_REPLY,
    ICAL_METHOD_ADD,
    ICAL_METHOD_CANCEL,
    ICAL_METHOD_REFRESH,
    ICAL_METHOD_COUNTER,
    ICAL_METHOD_DECLINECOUNTER,
    
    ICAL_METHOD_CREATE,
    ICAL_METHOD_READ,
    ICAL_METHOD_RESPONSE,
    ICAL_METHOD_MOVE,
    ICAL_METHOD_MODIFY,
    ICAL_METHOD_GENERATEUID,
    ICAL_METHOD_DELETE,
    ICAL_METHOD_NONE
} icalproperty_method ;
typedef enum icalproperty_transp {
    ICAL_TRANSP_OPAQUE,
    ICAL_TRANS_TRANSPARENT
}  icalproperty_trans;
typedef enum icalproperty_calscale {
    ICAL_CALSCALE_GREGORIAN
} icalproperty_calscale ;
typedef enum icalproperty_class {
    ICAL_CLASS_PUBLIC,
    ICAL_CLASS_PRIVATE,
    ICAL_CLASS_CONFIDENTIAL,
    ICAL_CLASS_XNAME
} icalproperty_class;
typedef enum icalproperty_status {
    ICAL_STATUS_TENTATIVE,
    ICAL_STATUS_CONFIRMED,
    ICAL_STATUS_CANCELLED, 
    ICAL_STATUS_NEEDSACTION,
    ICAL_STATUS_COMPLETED,
    ICAL_STATUS_INPROCESS,
    ICAL_STATUS_DRAFT,
    ICAL_STATUS_FINAL
}  icalproperty_status;
typedef enum icalproperty_action {
    ICAL_ACTION_AUDIO,
    ICAL_ACTION_DISPLAY,
    ICAL_ACTION_EMAIL,
    ICAL_ACTION_PROCEDURE,
    ICAL_ACTION_XNAME
} icalproperty_action;
typedef enum icalvalue_kind {
    ICAL_NO_VALUE,
    ICAL_ATTACH_VALUE, 
    ICAL_BINARY_VALUE,
    ICAL_BOOLEAN_VALUE,
    ICAL_CALADDRESS_VALUE,
    ICAL_DATE_VALUE,
    ICAL_DATETIME_VALUE,
    ICAL_DATETIMEDATE_VALUE, 
    ICAL_DATETIMEPERIOD_VALUE, 
    ICAL_DURATION_VALUE,
    ICAL_FLOAT_VALUE,
    ICAL_GEO_VALUE, 
    ICAL_INTEGER_VALUE,
    ICAL_METHOD_VALUE,
    ICAL_PERIOD_VALUE,
    ICAL_RECUR_VALUE,
    ICAL_STRING_VALUE,
    ICAL_TEXT_VALUE,
    ICAL_TIME_VALUE,
    ICAL_TRIGGER_VALUE, 
    ICAL_URI_VALUE,
    ICAL_UTCOFFSET_VALUE,
    ICAL_QUERY_VALUE,
    ICAL_XNAME_VALUE
} icalvalue_kind;
typedef enum icalparameter_kind {
    ICAL_NO_PARAMETER,
    ICAL_ANY_PARAMETER,
    ICAL_ALTREP_PARAMETER, 
    ICAL_CN_PARAMETER, 
    ICAL_CUTYPE_PARAMETER, 
    ICAL_DELEGATEDFROM_PARAMETER, 
    ICAL_DELEGATEDTO_PARAMETER, 
    ICAL_DIR_PARAMETER, 
    ICAL_ENCODING_PARAMETER, 
    ICAL_FMTTYPE_PARAMETER, 
    ICAL_FBTYPE_PARAMETER, 
    ICAL_LANGUAGE_PARAMETER, 
    ICAL_MEMBER_PARAMETER, 
    ICAL_PARTSTAT_PARAMETER, 
    ICAL_RANGE_PARAMETER, 
    ICAL_RELATED_PARAMETER, 
    ICAL_RELTYPE_PARAMETER, 
    ICAL_ROLE_PARAMETER, 
    ICAL_RSVP_PARAMETER, 
    ICAL_SENTBY_PARAMETER, 
    ICAL_TZID_PARAMETER, 
    ICAL_VALUE_PARAMETER, 
    ICAL_XLICERRORTYPE_PARAMETER, 
    ICAL_XLICCOMPARETYPE_PARAMETER, 
    ICAL_X_PARAMETER  
} icalparameter_kind;
typedef enum icalparameter_cutype {
    ICAL_CUTYPE_INDIVIDUAL, 
    ICAL_CUTYPE_GROUP, 
    ICAL_CUTYPE_RESOURCE, 
    ICAL_CUTYPE_ROOM,
    ICAL_CUTYPE_UNKNOWN,
    ICAL_CUTYPE_XNAME
} icalparameter_cutype;
typedef enum icalparameter_encoding {
    ICAL_ENCODING_8BIT, 
    ICAL_ENCODING_BASE64,
    ICAL_ENCODING_XNAME
} icalparameter_encoding;
typedef enum icalparameter_fbtype {
    ICAL_FBTYPE_FREE, 
    ICAL_FBTYPE_BUSY, 
    ICAL_FBTYPE_BUSYUNAVAILABLE, 
    ICAL_FBTYPE_BUSYTENTATIVE,
    ICAL_FBTYPE_XNAME
} icalparameter_fbtype;
typedef enum icalparameter_partstat {
    ICAL_PARTSTAT_NEEDSACTION, 
    ICAL_PARTSTAT_ACCEPTED, 
    ICAL_PARTSTAT_DECLINED, 
    ICAL_PARTSTAT_TENTATIVE, 
    ICAL_PARTSTAT_DELEGATED,
    ICAL_PARTSTAT_COMPLETED,
    ICAL_PARTSTAT_INPROCESS,
    ICAL_PARTSTAT_XNAME
} icalparameter_partstat;
typedef enum icalparameter_range {
    ICAL_RANGE_THISANDPRIOR, 
    ICAL_RANGE_THISANDFUTURE
} icalparameter_range;
typedef enum icalparameter_related {
    ICAL_RELATED_START, 
    ICAL_RELATED_END
} icalparameter_related;
typedef enum icalparameter_reltype {
    ICAL_RELTYPE_PARENT, 
    ICAL_RELTYPE_CHILD,
    ICAL_RELTYPE_SIBLING,
    ICAL_RELTYPE_XNAME
} icalparameter_reltype;
typedef enum icalparameter_role {
    ICAL_ROLE_CHAIR, 
    ICAL_ROLE_REQPARTICIPANT, 
    ICAL_ROLE_OPTPARTICIPANT, 
    ICAL_ROLE_NONPARTICIPANT,
    ICAL_ROLE_XNAME
} icalparameter_role;
typedef enum icalparameter_xlicerrortype {
    ICAL_XLICERRORTYPE_COMPONENTPARSEERROR,
    ICAL_XLICERRORTYPE_PARAMETERNAMEPARSEERROR,
    ICAL_XLICERRORTYPE_PARAMETERVALUEPARSEERROR,
    ICAL_XLICERRORTYPE_PROPERTYPARSEERROR,
    ICAL_XLICERRORTYPE_VALUEPARSEERROR,
    ICAL_XLICERRORTYPE_INVALIDITIP
} icalparameter_xlicerrortype;
typedef enum icalparameter_xliccomparetype {
    ICAL_XLICCOMPARETYPE_EQUAL=0,
    ICAL_XLICCOMPARETYPE_LESS=-1,
    ICAL_XLICCOMPARETYPE_LESSEQUAL=2,
    ICAL_XLICCOMPARETYPE_GREATER=1,
    ICAL_XLICCOMPARETYPE_GREATEREQUAL=3,
    ICAL_XLICCOMPARETYPE_NOTEQUAL=4,
    ICAL_XLICCOMPARETYPE_REGEX=5
} icalparameter_xliccomparetype;
typedef enum icalparameter_value {
    ICAL_VALUE_XNAME = ICAL_XNAME_VALUE,
    ICAL_VALUE_BINARY = ICAL_BINARY_VALUE, 
    ICAL_VALUE_BOOLEAN = ICAL_BOOLEAN_VALUE, 
    ICAL_VALUE_CALADDRESS = ICAL_CALADDRESS_VALUE, 
    ICAL_VALUE_DATE = ICAL_DATE_VALUE, 
    ICAL_VALUE_DATETIME = ICAL_DATETIME_VALUE, 
    ICAL_VALUE_DURATION = ICAL_DURATION_VALUE, 
    ICAL_VALUE_FLOAT = ICAL_FLOAT_VALUE, 
    ICAL_VALUE_INTEGER = ICAL_INTEGER_VALUE, 
    ICAL_VALUE_PERIOD = ICAL_PERIOD_VALUE, 
    ICAL_VALUE_RECUR = ICAL_RECUR_VALUE, 
    ICAL_VALUE_TEXT = ICAL_TEXT_VALUE, 
    ICAL_VALUE_TIME = ICAL_TIME_VALUE, 
    ICAL_VALUE_UTCOFFSET = ICAL_UTCOFFSET_VALUE,
    ICAL_VALUE_URI = ICAL_URI_VALUE,
    ICAL_VALUE_ERROR = ICAL_NO_VALUE
} icalparameter_value;
typedef enum icalrecurrencetype_frequency
{
    ICAL_NO_RECURRENCE,
    ICAL_SECONDLY_RECURRENCE,
    ICAL_MINUTELY_RECURRENCE,
    ICAL_HOURLY_RECURRENCE,
    ICAL_DAILY_RECURRENCE,
    ICAL_WEEKLY_RECURRENCE,
    ICAL_MONTHLY_RECURRENCE,
    ICAL_YEARLY_RECURRENCE
} icalrecurrencetype_frequency;
typedef enum icalrecurrencetype_weekday
{
    ICAL_NO_WEEKDAY,
    ICAL_SUNDAY_WEEKDAY,
    ICAL_MONDAY_WEEKDAY,
    ICAL_TUESDAY_WEEKDAY,
    ICAL_WEDNESDAY_WEEKDAY,
    ICAL_THURSDAY_WEEKDAY,
    ICAL_FRIDAY_WEEKDAY,
    ICAL_SATURDAY_WEEKDAY
} icalrecurrencetype_weekday;
enum {
    ICAL_RECURRENCE_ARRAY_MAX = 0x7f7f,
    ICAL_RECURRENCE_ARRAY_MAX_BYTE = 0x7f
};
    
char* icalenum_recurrence_to_string(icalrecurrencetype_frequency kind);
char* icalenum_weekday_to_string(icalrecurrencetype_weekday kind);
typedef enum icalrequeststatus {
    ICAL_UNKNOWN_STATUS,
    ICAL_2_0_SUCCESS_STATUS,
    ICAL_2_1_FALLBACK_STATUS,
    ICAL_2_2_IGPROP_STATUS,
    ICAL_2_3_IGPARAM_STATUS,
    ICAL_2_4_IGXPROP_STATUS,
    ICAL_2_5_IGXPARAM_STATUS,
    ICAL_2_6_IGCOMP_STATUS,
    ICAL_2_7_FORWARD_STATUS,
    ICAL_2_8_ONEEVENT_STATUS,
    ICAL_2_9_TRUNC_STATUS,
    ICAL_2_10_ONETODO_STATUS,
    ICAL_2_11_TRUNCRRULE_STATUS,
    ICAL_3_0_INVPROPNAME_STATUS,
    ICAL_3_1_INVPROPVAL_STATUS,
    ICAL_3_2_INVPARAM_STATUS,
    ICAL_3_3_INVPARAMVAL_STATUS,
    ICAL_3_4_INVCOMP_STATUS,
    ICAL_3_5_INVTIME_STATUS,
    ICAL_3_6_INVRULE_STATUS,
    ICAL_3_7_INVCU_STATUS,
    ICAL_3_8_NOAUTH_STATUS,
    ICAL_3_9_BADVERSION_STATUS,
    ICAL_3_10_TOOBIG_STATUS,
    ICAL_3_11_MISSREQCOMP_STATUS,
    ICAL_3_12_UNKCOMP_STATUS,
    ICAL_3_13_BADCOMP_STATUS,
    ICAL_3_14_NOCAP_STATUS,
    ICAL_4_0_BUSY_STATUS,
    ICAL_5_0_MAYBE_STATUS,
    ICAL_5_1_UNAVAIL_STATUS,
    ICAL_5_2_NOSERVICE_STATUS,
    ICAL_5_3_NOSCHED_STATUS
} icalrequeststatus;
char* icalenum_reqstat_desc(icalrequeststatus stat);
short icalenum_reqstat_major(icalrequeststatus stat);
short icalenum_reqstat_minor(icalrequeststatus stat);
icalrequeststatus icalenum_num_to_reqstat(short major, short minor);
char* icalenum_property_kind_to_string(icalproperty_kind kind);
icalproperty_kind icalenum_string_to_property_kind(char* string);
char* icalenum_value_kind_to_string(icalvalue_kind kind);
icalvalue_kind icalenum_value_kind_by_prop(icalproperty_kind kind);
char* icalenum_parameter_kind_to_string(icalparameter_kind kind);
icalparameter_kind icalenum_string_to_parameter_kind(char* string);
char* icalenum_component_kind_to_string(icalcomponent_kind kind);
icalcomponent_kind icalenum_string_to_component_kind(char* string);
icalvalue_kind icalenum_property_kind_to_value_kind(icalproperty_kind kind);
char* icalenum_method_to_string(icalproperty_method);
icalproperty_method icalenum_string_to_method(char* string);


/**********************************************************************
	icalcomponent.h
**********************************************************************/

typedef void icalcomponent;
icalcomponent* icalcomponent_new(icalcomponent_kind kind);
icalcomponent* icalcomponent_new_clone(icalcomponent* component);
icalcomponent* icalcomponent_new_from_string(char* str);
void icalcomponent_free(icalcomponent* component);
char* icalcomponent_as_ical_string(icalcomponent* component);
int icalcomponent_is_valid(icalcomponent* component);
icalcomponent_kind icalcomponent_isa(icalcomponent* component);
int icalcomponent_isa_component (void* component);
void icalcomponent_add_property(icalcomponent* component,
				icalproperty* property);
void icalcomponent_remove_property(icalcomponent* component,
				   icalproperty* property);
int icalcomponent_count_properties(icalcomponent* component,
				   icalproperty_kind kind);
icalproperty* icalcomponent_get_current_property(icalcomponent* component);
icalproperty* icalcomponent_get_first_property(icalcomponent* component,
					      icalproperty_kind kind);
icalproperty* icalcomponent_get_next_property(icalcomponent* component,
					      icalproperty_kind kind);
icalproperty** icalcomponent_get_properties(icalcomponent* component,
					      icalproperty_kind kind);
void icalcomponent_add_component(icalcomponent* parent,
				icalcomponent* child);
void icalcomponent_remove_component(icalcomponent* parent,
				icalcomponent* child);
int icalcomponent_count_components(icalcomponent* component,
				   icalcomponent_kind kind);
icalcomponent* icalcomponent_get_current_component (icalcomponent* component);
icalcomponent* icalcomponent_get_first_component(icalcomponent* component,
					      icalcomponent_kind kind);
icalcomponent* icalcomponent_get_next_component(icalcomponent* component,
					      icalcomponent_kind kind);
icalproperty** icalcomponent_get_component(icalcomponent* component,
					      icalproperty_kind kind);
int icalcomponent_count_errors(icalcomponent* component);
void icalcomponent_convert_errors(icalcomponent* component);
void icalcomponent_strip_errors(icalcomponent* component);
icalcomponent* icalcomponent_get_parent(icalcomponent* component);
void icalcomponent_set_parent(icalcomponent* component, 
			      icalcomponent* parent);


/**********************************************************************
	icalerror.h
**********************************************************************/

void icalerror_crash_here(void);

void icalerror_stop_here(void);
typedef enum icalerrorenum {
    
    ICAL_BADARG_ERROR,
    ICAL_NEWFAILED_ERROR,
    ICAL_MALFORMEDDATA_ERROR,
    ICAL_PARSE_ERROR,
    ICAL_INTERNAL_ERROR, 
    ICAL_FILE_ERROR,
    ICAL_ALLOCATION_ERROR,
    ICAL_USAGE_ERROR,
    ICAL_NO_ERROR,
    ICAL_MULTIPLEINCLUSION_ERROR,
    ICAL_UNKNOWN_ERROR 
} icalerrorenum;
void icalerror_clear_errno();
void icalerror_set_errno(icalerrorenum);
char* icalerror_strerror(icalerrorenum e);

/**********************************************************************
	icalmemory.h
**********************************************************************/

void* icalmemory_tmp_buffer(size_t size);
char* icalmemory_tmp_copy(char* str);
void  icalmemory_add_tmp_buffer(void*);
void icalmemory_free_ring();
void* icalmemory_new_buffer(size_t size);
void* icalmemory_resize_buffer(void* buf, size_t size);
void icalmemory_free_buffer(void* buf);
void icalmemory_append_string(char** buf, char** pos, size_t* buf_size, 
			      char* string);
void icalmemory_append_char(char** buf, char** pos, size_t* buf_size, 
			      char ch);

/**********************************************************************
	icalparameter.h
**********************************************************************/

typedef void icalparameter;
icalparameter* icalparameter_new(icalparameter_kind kind);
icalparameter* icalparameter_new_clone(icalparameter* p);
icalparameter* icalparameter_new_from_string(icalparameter_kind kind, char* value);
void icalparameter_free(icalparameter* parameter);
char* icalparameter_as_ical_string(icalparameter* parameter);
int icalparameter_is_valid(icalparameter* parameter);
icalparameter_kind icalparameter_isa(icalparameter* parameter);
int icalparameter_isa_parameter(void* param);
void icalparameter_set_xname (icalparameter* param, char* v);
char* icalparameter_get_xname(icalparameter* param);
void icalparameter_set_xvalue (icalparameter* param, char* v);
char* icalparameter_get_xvalue(icalparameter* param);
icalparameter* icalparameter_new_altrep(char* v);
char* icalparameter_get_altrep(icalparameter* value);
void icalparameter_set_altrep(icalparameter* value, char* v);
icalparameter* icalparameter_new_cn(char* v);
char* icalparameter_get_cn(icalparameter* value);
void icalparameter_set_cn(icalparameter* value, char* v);
icalparameter* icalparameter_new_cutype(icalparameter_cutype v);
icalparameter_cutype icalparameter_get_cutype(icalparameter* value);
void icalparameter_set_cutype(icalparameter* value, icalparameter_cutype v);
icalparameter* icalparameter_new_delegatedfrom(char* v);
char* icalparameter_get_delegatedfrom(icalparameter* value);
void icalparameter_set_delegatedfrom(icalparameter* value, char* v);
icalparameter* icalparameter_new_delegatedto(char* v);
char* icalparameter_get_delegatedto(icalparameter* value);
void icalparameter_set_delegatedto(icalparameter* value, char* v);
icalparameter* icalparameter_new_dir(char* v);
char* icalparameter_get_dir(icalparameter* value);
void icalparameter_set_dir(icalparameter* value, char* v);
icalparameter* icalparameter_new_encoding(icalparameter_encoding v);
icalparameter_encoding icalparameter_get_encoding(icalparameter* value);
void icalparameter_set_encoding(icalparameter* value, icalparameter_encoding v);
icalparameter* icalparameter_new_fbtype(icalparameter_fbtype v);
icalparameter_fbtype icalparameter_get_fbtype(icalparameter* value);
void icalparameter_set_fbtype(icalparameter* value, icalparameter_fbtype v);
icalparameter* icalparameter_new_fmttype(char* v);
char* icalparameter_get_fmttype(icalparameter* value);
void icalparameter_set_fmttype(icalparameter* value, char* v);
icalparameter* icalparameter_new_language(char* v);
char* icalparameter_get_language(icalparameter* value);
void icalparameter_set_language(icalparameter* value, char* v);
icalparameter* icalparameter_new_member(char* v);
char* icalparameter_get_member(icalparameter* value);
void icalparameter_set_member(icalparameter* value, char* v);
icalparameter* icalparameter_new_partstat(icalparameter_partstat v);
icalparameter_partstat icalparameter_get_partstat(icalparameter* value);
void icalparameter_set_partstat(icalparameter* value, icalparameter_partstat v);
icalparameter* icalparameter_new_range(icalparameter_range v);
icalparameter_range icalparameter_get_range(icalparameter* value);
void icalparameter_set_range(icalparameter* value, icalparameter_range v);
icalparameter* icalparameter_new_related(icalparameter_related v);
icalparameter_related icalparameter_get_related(icalparameter* value);
void icalparameter_set_related(icalparameter* value, icalparameter_related v);
icalparameter* icalparameter_new_reltype(icalparameter_reltype v);
icalparameter_reltype icalparameter_get_reltype(icalparameter* value);
void icalparameter_set_reltype(icalparameter* value, icalparameter_reltype v);
icalparameter* icalparameter_new_role(icalparameter_role v);
icalparameter_role icalparameter_get_role(icalparameter* value);
void icalparameter_set_role(icalparameter* value, icalparameter_role v);
icalparameter* icalparameter_new_rsvp(int v);
int icalparameter_get_rsvp(icalparameter* value);
void icalparameter_set_rsvp(icalparameter* value, int v);
icalparameter* icalparameter_new_sentby(char* v);
char* icalparameter_get_sentby(icalparameter* value);
void icalparameter_set_sentby(icalparameter* value, char* v);
icalparameter* icalparameter_new_tzid(char* v);
char* icalparameter_get_tzid(icalparameter* value);
void icalparameter_set_tzid(icalparameter* value, char* v);
icalparameter* icalparameter_new_value(icalparameter_value v);
icalparameter_value icalparameter_get_value(icalparameter* value);
void icalparameter_set_value(icalparameter* value, icalparameter_value v);
icalparameter* icalparameter_new_x(char* v);
char* icalparameter_get_x(icalparameter* value);
void icalparameter_set_x(icalparameter* value, char* v);
icalparameter* icalparameter_new_xlicerrortype(icalparameter_xlicerrortype v);
icalparameter_xlicerrortype icalparameter_get_xlicerrortype(icalparameter* value);
void icalparameter_set_xlicerrortype(icalparameter* value, icalparameter_xlicerrortype v);
icalparameter* icalparameter_new_xliccomparetype(icalparameter_xliccomparetype v);
icalparameter_xliccomparetype icalparameter_get_xliccomparetype(icalparameter* value);
void icalparameter_set_xliccomparetype(icalparameter* value, icalparameter_xliccomparetype v);

/**********************************************************************
	icalparser.h
**********************************************************************/

typedef void* icalparser;
typedef enum icalparser_state {
    ICALPARSER_ERROR,
    ICALPARSER_SUCCESS,
    ICALPARSER_BEGIN_COMP,
    ICALPARSER_END_COMP,
    ICALPARSER_IN_PROGRESS
} icalparser_state;
icalcomponent* icalparser_parse_string(char* str);
icalparser* icalparser_new();
void icalparser_set_gen_data(icalparser* parser, void* data);
icalcomponent* icalparser_add_line(icalparser* parser, char* str );
icalcomponent* icalparser_claim(icalparser* parser);
icalcomponent* icalparser_clean(icalparser* parser);
icalparser_state icalparser_get_state(icalparser* parser);
void icalparser_free(icalparser* parser);
icalvalue*  icalparser_parse_value(icalvalue_kind kind, char* str, icalcomponent** errors);
char* string_line_generator(char *out, size_t buf_size, void *d);

/**********************************************************************
	icalproperty.h
**********************************************************************/

typedef void icalproperty;
icalproperty* icalproperty_new(icalproperty_kind kind);
icalproperty* icalproperty_new_clone(icalproperty * prop);
icalproperty* icalproperty_new_from_string(char* str);
char* icalproperty_as_ical_string(icalproperty* prop);
void  icalproperty_free(icalproperty* prop);
icalproperty_kind icalproperty_isa(icalproperty* property);
int icalproperty_isa_property(void* property);
void icalproperty_add_parameter(icalproperty* prop,icalparameter* parameter);
void icalproperty_remove_parameter(icalproperty* prop,
				   icalparameter_kind kind);
int icalproperty_count_parameters(icalproperty* prop);
icalparameter* icalproperty_get_first_parameter(icalproperty* prop,
						icalparameter_kind kind);
icalparameter* icalproperty_get_next_parameter(icalproperty* prop,
						icalparameter_kind kind);
void icalproperty_set_value(icalproperty* prop, icalvalue* value);
icalvalue* icalproperty_get_value(icalproperty* prop);
void icalproperty_set_x_name(icalproperty* prop, char* name);
char* icalproperty_get_x_name(icalproperty* prop);
icalproperty* icalproperty_new_method(icalproperty_method v);
void icalproperty_set_method(icalproperty* prop, icalproperty_method v);
icalproperty_method icalproperty_get_method(icalproperty* prop);
icalproperty* icalproperty_new_lastmodified(struct icaltimetype v);
void icalproperty_set_lastmodified(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_lastmodified(icalproperty* prop);
icalproperty* icalproperty_new_uid(char* v);
void icalproperty_set_uid(icalproperty* prop, char* v);
char* icalproperty_get_uid(icalproperty* prop);
icalproperty* icalproperty_new_prodid(char* v);
void icalproperty_set_prodid(icalproperty* prop, char* v);
char* icalproperty_get_prodid(icalproperty* prop);
icalproperty* icalproperty_new_status(char* v);
void icalproperty_set_status(icalproperty* prop, char* v);
char* icalproperty_get_status(icalproperty* prop);
icalproperty* icalproperty_new_description(char* v);
void icalproperty_set_description(icalproperty* prop, char* v);
char* icalproperty_get_description(icalproperty* prop);
icalproperty* icalproperty_new_duration(struct icaldurationtype v);
void icalproperty_set_duration(icalproperty* prop, struct icaldurationtype v);
struct icaldurationtype icalproperty_get_duration(icalproperty* prop);
icalproperty* icalproperty_new_categories(char* v);
void icalproperty_set_categories(icalproperty* prop, char* v);
char* icalproperty_get_categories(icalproperty* prop);
icalproperty* icalproperty_new_version(char* v);
void icalproperty_set_version(icalproperty* prop, char* v);
char* icalproperty_get_version(icalproperty* prop);
icalproperty* icalproperty_new_tzoffsetfrom(int v);
void icalproperty_set_tzoffsetfrom(icalproperty* prop, int v);
int icalproperty_get_tzoffsetfrom(icalproperty* prop);
icalproperty* icalproperty_new_rrule(struct icalrecurrencetype v);
void icalproperty_set_rrule(icalproperty* prop, struct icalrecurrencetype v);
struct icalrecurrencetype icalproperty_get_rrule(icalproperty* prop);
icalproperty* icalproperty_new_attendee(char* v);
void icalproperty_set_attendee(icalproperty* prop, char* v);
char* icalproperty_get_attendee(icalproperty* prop);
icalproperty* icalproperty_new_contact(char* v);
void icalproperty_set_contact(icalproperty* prop, char* v);
char* icalproperty_get_contact(icalproperty* prop);
icalproperty* icalproperty_new_relatedto(char* v);
void icalproperty_set_relatedto(icalproperty* prop, char* v);
char* icalproperty_get_relatedto(icalproperty* prop);
icalproperty* icalproperty_new_organizer(char* v);
void icalproperty_set_organizer(icalproperty* prop, char* v);
char* icalproperty_get_organizer(icalproperty* prop);
icalproperty* icalproperty_new_comment(char* v);
void icalproperty_set_comment(icalproperty* prop, char* v);
char* icalproperty_get_comment(icalproperty* prop);
icalproperty* icalproperty_new_trigger(union icaltriggertype v);
void icalproperty_set_trigger(icalproperty* prop, union icaltriggertype v);
union icaltriggertype icalproperty_get_trigger(icalproperty* prop);
icalproperty* icalproperty_new_xlicerror(char* v);
void icalproperty_set_xlicerror(icalproperty* prop, char* v);
char* icalproperty_get_xlicerror(icalproperty* prop);
icalproperty* icalproperty_new_class(char* v);
void icalproperty_set_class(icalproperty* prop, char* v);
char* icalproperty_get_class(icalproperty* prop);
icalproperty* icalproperty_new_tzoffsetto(int v);
void icalproperty_set_tzoffsetto(icalproperty* prop, int v);
int icalproperty_get_tzoffsetto(icalproperty* prop);
icalproperty* icalproperty_new_transp(char* v);
void icalproperty_set_transp(icalproperty* prop, char* v);
char* icalproperty_get_transp(icalproperty* prop);
icalproperty* icalproperty_new_sequence(int v);
void icalproperty_set_sequence(icalproperty* prop, int v);
int icalproperty_get_sequence(icalproperty* prop);
icalproperty* icalproperty_new_location(char* v);
void icalproperty_set_location(icalproperty* prop, char* v);
char* icalproperty_get_location(icalproperty* prop);
icalproperty* icalproperty_new_requeststatus(char* v);
void icalproperty_set_requeststatus(icalproperty* prop, char* v);
char* icalproperty_get_requeststatus(icalproperty* prop);
icalproperty* icalproperty_new_exdate(struct icaltimetype v);
void icalproperty_set_exdate(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_exdate(icalproperty* prop);
icalproperty* icalproperty_new_tzid(char* v);
void icalproperty_set_tzid(icalproperty* prop, char* v);
char* icalproperty_get_tzid(icalproperty* prop);
icalproperty* icalproperty_new_resources(char* v);
void icalproperty_set_resources(icalproperty* prop, char* v);
char* icalproperty_get_resources(icalproperty* prop);
icalproperty* icalproperty_new_tzurl(char* v);
void icalproperty_set_tzurl(icalproperty* prop, char* v);
char* icalproperty_get_tzurl(icalproperty* prop);
icalproperty* icalproperty_new_repeat(int v);
void icalproperty_set_repeat(icalproperty* prop, int v);
int icalproperty_get_repeat(icalproperty* prop);
icalproperty* icalproperty_new_priority(int v);
void icalproperty_set_priority(icalproperty* prop, int v);
int icalproperty_get_priority(icalproperty* prop);
icalproperty* icalproperty_new_freebusy(struct icalperiodtype v);
void icalproperty_set_freebusy(icalproperty* prop, struct icalperiodtype v);
struct icalperiodtype icalproperty_get_freebusy(icalproperty* prop);
icalproperty* icalproperty_new_dtstart(struct icaltimetype v);
void icalproperty_set_dtstart(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_dtstart(icalproperty* prop);
icalproperty* icalproperty_new_recurrenceid(struct icaltimetype v);
void icalproperty_set_recurrenceid(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_recurrenceid(icalproperty* prop);
icalproperty* icalproperty_new_summary(char* v);
void icalproperty_set_summary(icalproperty* prop, char* v);
char* icalproperty_get_summary(icalproperty* prop);
icalproperty* icalproperty_new_dtend(struct icaltimetype v);
void icalproperty_set_dtend(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_dtend(icalproperty* prop);
icalproperty* icalproperty_new_tzname(char* v);
void icalproperty_set_tzname(icalproperty* prop, char* v);
char* icalproperty_get_tzname(icalproperty* prop);
icalproperty* icalproperty_new_rdate(struct icalperiodtype v);
void icalproperty_set_rdate(icalproperty* prop, struct icalperiodtype v);
struct icalperiodtype icalproperty_get_rdate(icalproperty* prop);
icalproperty* icalproperty_new_url(char* v);
void icalproperty_set_url(icalproperty* prop, char* v);
char* icalproperty_get_url(icalproperty* prop);
icalproperty* icalproperty_new_attach(struct icalattachtype v);
void icalproperty_set_attach(icalproperty* prop, struct icalattachtype v);
struct icalattachtype icalproperty_get_attach(icalproperty* prop);
icalproperty* icalproperty_new_xlicclustercount(int v);
void icalproperty_set_xlicclustercount(icalproperty* prop, int v);
int icalproperty_get_xlicclustercount(icalproperty* prop);
icalproperty* icalproperty_new_exrule(struct icalrecurrencetype v);
void icalproperty_set_exrule(icalproperty* prop, struct icalrecurrencetype v);
struct icalrecurrencetype icalproperty_get_exrule(icalproperty* prop);
icalproperty* icalproperty_new_query(char* v);
void icalproperty_set_query(icalproperty* prop, char* v);
char* icalproperty_get_query(icalproperty* prop);
icalproperty* icalproperty_new_percentcomplete(int v);
void icalproperty_set_percentcomplete(icalproperty* prop, int v);
int icalproperty_get_percentcomplete(icalproperty* prop);
icalproperty* icalproperty_new_calscale(char* v);
void icalproperty_set_calscale(icalproperty* prop, char* v);
char* icalproperty_get_calscale(icalproperty* prop);
icalproperty* icalproperty_new_created(struct icaltimetype v);
void icalproperty_set_created(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_created(icalproperty* prop);
icalproperty* icalproperty_new_geo(struct icalgeotype v);
void icalproperty_set_geo(icalproperty* prop, struct icalgeotype v);
struct icalgeotype icalproperty_get_geo(icalproperty* prop);
icalproperty* icalproperty_new_completed(struct icaltimetype v);
void icalproperty_set_completed(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_completed(icalproperty* prop);
icalproperty* icalproperty_new_dtstamp(struct icaltimetype v);
void icalproperty_set_dtstamp(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_dtstamp(icalproperty* prop);
icalproperty* icalproperty_new_due(struct icaltimetype v);
void icalproperty_set_due(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_due(icalproperty* prop);
icalproperty* icalproperty_new_action(char* v);
void icalproperty_set_action(icalproperty* prop, char* v);
char* icalproperty_get_action(icalproperty* prop);

/**********************************************************************
	icalrestriction.h
**********************************************************************/

typedef enum icalrestriction_kind {
    ICAL_RESTRICTION_NONE=0,		
    ICAL_RESTRICTION_ZERO,		
    ICAL_RESTRICTION_ONE,		
    ICAL_RESTRICTION_ZEROPLUS,		
    ICAL_RESTRICTION_ONEPLUS,		
    ICAL_RESTRICTION_ZEROORONE,		
    ICAL_RESTRICTION_ONEEXCLUSIVE,	
    ICAL_RESTRICTION_ONEMUTUAL,		
    ICAL_RESTRICTION_UNKNOWN		
} icalrestriction_kind;
int 
icalrestriction_compare(icalrestriction_kind restr, int count);
icalrestriction_kind
icalrestriction_get_property_restriction(icalproperty_method method,
					 icalcomponent_kind component,
					 icalproperty_kind property);
icalrestriction_kind
icalrestriction_get_component_restriction(icalproperty_method method,
					 icalcomponent_kind component,
					  icalcomponent_kind subcomponent);
int
icalrestriction_is_parameter_allowed(icalproperty_kind property,
                                       icalparameter_kind parameter);
int icalrestriction_check(icalcomponent* comp);

/**********************************************************************
	icaltypes.h
**********************************************************************/

struct icalattachtype
{
	void* binary;
	int owns_binary; 
	char* base64;
	int owns_base64;
	char* url;
	int refcount; 
};
struct icalattachtype* icalattachtype_new();
void  icalattachtype_add_reference(struct icalattachtype* v);
void icalattachtype_free(struct icalattachtype* v);
void icalattachtype_set_url(struct icalattachtype* v, char* url);
char* icalattachtype_get_url(struct icalattachtype* v);
void icalattachtype_set_base64(struct icalattachtype* v, char* base64,
				int owns);
char* icalattachtype_get_base64(struct icalattachtype* v);
void icalattachtype_set_binary(struct icalattachtype* v, char* binary,
				int owns);
void* icalattachtype_get_binary(struct icalattachtype* v);
struct icalgeotype 
{
	float lat;
	float lon;
};
struct icaltimetype
{
	int year;
	int month;
	int day;
	int hour;
	int minute;
	int second;
	int is_utc; 
	int is_date; 
};	
struct icaltimetype icaltimetype_from_timet(time_t v, int is_date);
					   
struct icalrecurrencetype 
{
	icalrecurrencetype_frequency freq;
	
       	struct icaltimetype until;
	int count;
	short interval;
	
	icalrecurrencetype_weekday week_start;
	
	short by_second[61];
	short by_minute[61];
	short by_hour[25];
	short by_day[8];
	short by_month_day[32];
	short by_year_day[367];
	short by_week_no[54];
	short by_month[13];
	short by_set_pos[367];
};
void icalrecurrencetype_clear(struct icalrecurrencetype *r);
struct icaldurationtype
{
	unsigned int days;
	unsigned int weeks;
	unsigned int hours;
	unsigned int minutes;
	unsigned int seconds;
};
struct icaldurationtype icaldurationtype_from_timet(time_t t);
time_t icaldurationtype_as_timet(struct icaldurationtype duration);
struct icaltimetype icalrecurrencetype_next_occurance(
    struct icalrecurrencetype *r,
    struct icaltimetype *after);
struct icalperiodtype 
{
	struct icaltimetype start; 	
	struct icaltimetype end; 
	struct icaldurationtype duration;
};
time_t icalperiodtype_duration(struct icalperiodtype period);
time_t icalperiodtype_end(struct icalperiodtype period);
union icaltriggertype 
{
	struct icaltimetype time; 
	struct icaldurationtype duration;
};
struct icalreqstattype {
  icalrequeststatus code;
  char* desc;
  char* debug;
};
struct icalreqstattype icalreqstattype_from_string(char* str);
char* icalreqstattype_as_string(struct icalreqstattype);

/**********************************************************************
	icalvalue.h
**********************************************************************/

typedef void icalvalue;
icalvalue* icalvalue_new(icalvalue_kind kind);
icalvalue* icalvalue_new_clone(icalvalue* value);
icalvalue* icalvalue_new_from_string(icalvalue_kind kind, char* str);
void icalvalue_free(icalvalue* value);
int icalvalue_is_valid(icalvalue* value);
char* icalvalue_as_ical_string(icalvalue* value);
icalvalue_kind icalvalue_isa(icalvalue* value);
int icalvalue_isa_value(void*);
icalparameter_xliccomparetype
icalvalue_compare(icalvalue* a, icalvalue *b);
icalvalue* icalvalue_new_attach(struct icalattachtype v);
struct icalattachtype icalvalue_get_attach(icalvalue* value);
void icalvalue_set_attach(icalvalue* value, struct icalattachtype v);
icalvalue* icalvalue_new_binary(char* v);
char* icalvalue_get_binary(icalvalue* value);
void icalvalue_set_binary(icalvalue* value, char* v);
icalvalue* icalvalue_new_boolean(int v);
int icalvalue_get_boolean(icalvalue* value);
void icalvalue_set_boolean(icalvalue* value, int v);
icalvalue* icalvalue_new_caladdress(char* v);
char* icalvalue_get_caladdress(icalvalue* value);
void icalvalue_set_caladdress(icalvalue* value, char* v);
icalvalue* icalvalue_new_date(struct icaltimetype v);
struct icaltimetype icalvalue_get_date(icalvalue* value);
void icalvalue_set_date(icalvalue* value, struct icaltimetype v);
icalvalue* icalvalue_new_datetime(struct icaltimetype v);
struct icaltimetype icalvalue_get_datetime(icalvalue* value);
void icalvalue_set_datetime(icalvalue* value, struct icaltimetype v);
icalvalue* icalvalue_new_datetimedate(struct icaltimetype v);
struct icaltimetype icalvalue_get_datetimedate(icalvalue* value);
void icalvalue_set_datetimedate(icalvalue* value, struct icaltimetype v);
icalvalue* icalvalue_new_datetimeperiod(struct icalperiodtype v);
struct icalperiodtype icalvalue_get_datetimeperiod(icalvalue* value);
void icalvalue_set_datetimeperiod(icalvalue* value, struct icalperiodtype v);
icalvalue* icalvalue_new_duration(struct icaldurationtype v);
struct icaldurationtype icalvalue_get_duration(icalvalue* value);
void icalvalue_set_duration(icalvalue* value, struct icaldurationtype v);
icalvalue* icalvalue_new_float(float v);
float icalvalue_get_float(icalvalue* value);
void icalvalue_set_float(icalvalue* value, float v);
icalvalue* icalvalue_new_geo(struct icalgeotype v);
struct icalgeotype icalvalue_get_geo(icalvalue* value);
void icalvalue_set_geo(icalvalue* value, struct icalgeotype v);
icalvalue* icalvalue_new_integer(int v);
int icalvalue_get_integer(icalvalue* value);
void icalvalue_set_integer(icalvalue* value, int v);
icalvalue* icalvalue_new_method(icalproperty_method v);
icalproperty_method icalvalue_get_method(icalvalue* value);
void icalvalue_set_method(icalvalue* value, icalproperty_method v);
icalvalue* icalvalue_new_period(struct icalperiodtype v);
struct icalperiodtype icalvalue_get_period(icalvalue* value);
void icalvalue_set_period(icalvalue* value, struct icalperiodtype v);
icalvalue* icalvalue_new_recur(struct icalrecurrencetype v);
struct icalrecurrencetype icalvalue_get_recur(icalvalue* value);
void icalvalue_set_recur(icalvalue* value, struct icalrecurrencetype v);
icalvalue* icalvalue_new_text(char* v);
char* icalvalue_get_text(icalvalue* value);
void icalvalue_set_text(icalvalue* value, char* v);
icalvalue* icalvalue_new_time(struct icaltimetype v);
struct icaltimetype icalvalue_get_time(icalvalue* value);
void icalvalue_set_time(icalvalue* value, struct icaltimetype v);
icalvalue* icalvalue_new_trigger(union icaltriggertype v);
union icaltriggertype icalvalue_get_trigger(icalvalue* value);
void icalvalue_set_trigger(icalvalue* value, union icaltriggertype v);
icalvalue* icalvalue_new_uri(char* v);
char* icalvalue_get_uri(icalvalue* value);
void icalvalue_set_uri(icalvalue* value, char* v);
icalvalue* icalvalue_new_utcoffset(int v);
int icalvalue_get_utcoffset(icalvalue* value);
void icalvalue_set_utcoffset(icalvalue* value, int v);
icalvalue* icalvalue_new_query(char* v);
char* icalvalue_get_query(icalvalue* value);
void icalvalue_set_query(icalvalue* value, char* v);

/**********************************************************************
	icalcalendar.h
**********************************************************************/

typedef  void icalcalendar;
icalcalendar* icalcalendar_new(char* dir);
void icalcalendar_free(icalcalendar* calendar);
int icalcalendar_lock(icalcalendar* calendar);
int icalcalendar_unlock(icalcalendar* calendar);
int icalcalendar_islocked(icalcalendar* calendar);
int icalcalendar_ownlock(icalcalendar* calendar);
icalstore* icalcalendar_get_booked(icalcalendar* calendar);
icalcluster* icalcalendar_get_incoming(icalcalendar* calendar);
icalcluster* icalcalendar_get_properties(icalcalendar* calendar);
icalcluster* icalcalendar_get_freebusy(icalcalendar* calendar);

/**********************************************************************
	icalcluster.h
**********************************************************************/

typedef void icalcluster;
icalcluster* icalcluster_new(char* path);
void icalcluster_free(icalcluster* cluster);
char* icalcluster_path(icalcluster* cluster);
icalcomponent* icalcluster_get_component(icalcluster* cluster);
void icalcluster_mark(icalcluster* cluster);
icalerrorenum icalcluster_commit(icalcluster* cluster); 
icalerrorenum icalcluster_add_component(icalcomponent* parent,
			       icalcomponent* child);
icalerrorenum icalcluster_remove_component(icalcomponent* parent,
				  icalcomponent* child);
int icalcluster_count_components(icalcomponent* component,
				 icalcomponent_kind kind);
icalcomponent* icalcluster_get_current_component (icalcomponent* component);
icalcomponent* icalcluster_get_first_component(icalcomponent* component,
					       icalcomponent_kind kind);
icalcomponent* icalcluster_get_next_component(icalcomponent* component,
					      icalcomponent_kind kind);


/**********************************************************************
	icalstore.h
**********************************************************************/

typedef void icalstore;
icalstore* icalstore_new(char* dir);
void icalstore_free(icalstore* store);
icalerrorenum icalstore_add_component(icalstore* store, icalstore* comp);
icalerrorenum icalstore_remove_component(icalstore* store, icalstore* comp);
icalerrorenum icalstore_select(icalstore* store, icalcomponent* gauge);
int icalstore_test(icalcomponent* comp, icalcomponent* gauge);
void icalstore_clear(icalstore* store);
icalcomponent* icalstore_fetch(icalstore* store, char* uid);
int icalstore_has_uid(icalstore* store, char* uid);
icalcomponent* icalstore_get_first_component(icalstore* store);
icalcomponent* icalstore_get_next_component(icalstore* store);
	
int icalstore_next_uid_number(icalstore* store);
