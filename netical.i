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

#include <sys/types.h> /* for size_t */
#include <time.h>

%}


/**********************************************************************
	ical.h
**********************************************************************/

struct icaltime_span {
	time_t start; 
	time_t end; 
	int is_busy; 
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
struct icaltimetype icaltime_null_time(void);
int icaltime_is_null_time(struct icaltimetype t);
struct icaltimetype icaltime_normalize(struct icaltimetype t);
short icaltime_day_of_year(struct icaltimetype t);
struct icaltimetype icaltime_from_day_of_year(short doy,  short year);
short icaltime_day_of_week(struct icaltimetype t);
short icaltime_start_doy_of_week(struct icaltimetype t);
struct icaltimetype icaltime_from_timet(time_t v, int is_date, int is_utc);
struct icaltimetype icaltime_from_string(const char* str);
time_t icaltime_as_timet(struct icaltimetype);
char* icaltime_as_ctime(struct icaltimetype);
short icaltime_week_number(short day_of_month, short month, short year);
struct icaltimetype icaltime_from_week_number(short week_number, short year);
int icaltime_compare(struct icaltimetype a,struct icaltimetype b);
short icaltime_days_in_month(short month,short year);
time_t icaltime_utc_offset(struct icaltimetype tt, const char* tzid);
time_t icaltime_local_utc_offset();
struct icaltimetype icaltime_as_utc(struct icaltimetype tt,const char* tzid);
struct icaltimetype icaltime_as_zone(struct icaltimetype tt,const char* tzid);
struct icaldurationtype
{
	int is_neg;
	unsigned int days;
	unsigned int weeks;
	unsigned int hours;
	unsigned int minutes;
	unsigned int seconds;
};
struct icaldurationtype icaldurationtype_from_timet(time_t t);
struct icaldurationtype icaldurationtype_from_string(const char*);
time_t icaldurationtype_as_timet(struct icaldurationtype duration);
struct icalperiodtype 
{
	struct icaltimetype start; 	
	struct icaltimetype end; 
	struct icaldurationtype duration;
};
time_t icalperiodtype_duration(struct icalperiodtype period);
time_t icalperiodtype_end(struct icalperiodtype period);
struct icaltimetype  icaltime_add(struct icaltimetype t,
				  struct icaldurationtype  d);
struct icaldurationtype  icaltime_subtract(struct icaltimetype t1,
					   struct icaltimetype t2);
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
    ICAL_XLICINVALID_COMPONENT,
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
    ICAL_XLICMIMECONTENTTYPE_PROPERTY,
    ICAL_XLICMIMEENCODING_PROPERTY,
    ICAL_XLICMIMECID_PROPERTY,
    ICAL_XLICMIMEFILENAME_PROPERTY,
    ICAL_XLICMIMECHARSET_PROPERTY,
    ICAL_XLICMIMEOPTINFO_PROPERTY,
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
    ICAL_STATUS_NONE,
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
    ICAL_STATUS_VALUE, 
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
    ICAL_PARTSTAT_XNAME,
    ICAL_PARTSTAT_NONE
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
    ICAL_XLICERRORTYPE_PARAMETERVALUEPARSEERROR,
    ICAL_XLICERRORTYPE_PARAMETERNAMEPARSEERROR,
    ICAL_XLICERRORTYPE_PROPERTYPARSEERROR,
    ICAL_XLICERRORTYPE_VALUEPARSEERROR,
    ICAL_XLICERRORTYPE_UNKVCALPROP,
    ICAL_XLICERRORTYPE_INVALIDITIP,
    ICAL_XLICERRORTYPE_MIMEPARSEERROR
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
const char* icalenum_reqstat_desc(icalrequeststatus stat);
short icalenum_reqstat_major(icalrequeststatus stat);
short icalenum_reqstat_minor(icalrequeststatus stat);
icalrequeststatus icalenum_num_to_reqstat(short major, short minor);
const char* icalenum_property_kind_to_string(icalproperty_kind kind);
icalproperty_kind icalenum_string_to_property_kind(char* string);
const char* icalenum_value_kind_to_string(icalvalue_kind kind);
icalvalue_kind icalenum_value_kind_by_prop(icalproperty_kind kind);
const char* icalenum_parameter_kind_to_string(icalparameter_kind kind);
icalparameter_kind icalenum_string_to_parameter_kind(char* string);
const char* icalenum_component_kind_to_string(icalcomponent_kind kind);
icalcomponent_kind icalenum_string_to_component_kind(char* string);
icalvalue_kind icalenum_property_kind_to_value_kind(icalproperty_kind kind);
const char* icalenum_method_to_string(icalproperty_method);
icalproperty_method icalenum_string_to_method(const char* string);
const char* icalenum_status_to_string(icalproperty_status);
icalproperty_status icalenum_string_to_status(const char* string);
struct icalattachtype
{
	void* binary;
	int owns_binary; 
	char* base64;
	int owns_base64;
	char* url;
	int refcount; 
};
struct icalattachtype* icalattachtype_new(void);
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
					   
union icaltriggertype 
{
	struct icaltimetype time; 
	struct icaldurationtype duration;
};
struct icalreqstattype {
	icalrequeststatus code;
	const char* desc;
	const char* debug;
};
struct icalreqstattype icalreqstattype_from_string(char* str);
char* icalreqstattype_as_string(struct icalreqstattype);
                          
typedef void icalvalue;
icalvalue* icalvalue_new(icalvalue_kind kind);
icalvalue* icalvalue_new_clone(icalvalue* value);
icalvalue* icalvalue_new_from_string(icalvalue_kind kind, const char* str);
void icalvalue_free(icalvalue* value);
int icalvalue_is_valid(icalvalue* value);
const char* icalvalue_as_ical_string(icalvalue* value);
icalvalue_kind icalvalue_isa(icalvalue* value);
int icalvalue_isa_value(void*);
icalparameter_xliccomparetype
icalvalue_compare(icalvalue* a, icalvalue *b);
icalvalue* icalvalue_new_attach(struct icalattachtype v);
struct icalattachtype icalvalue_get_attach(icalvalue* value);
void icalvalue_set_attach(icalvalue* value, struct icalattachtype v);
icalvalue* icalvalue_new_binary(const char* v);
const char* icalvalue_get_binary(icalvalue* value);
void icalvalue_set_binary(icalvalue* value, const char* v);
icalvalue* icalvalue_new_boolean(int v);
int icalvalue_get_boolean(icalvalue* value);
void icalvalue_set_boolean(icalvalue* value, int v);
icalvalue* icalvalue_new_caladdress(const char* v);
const char* icalvalue_get_caladdress(icalvalue* value);
void icalvalue_set_caladdress(icalvalue* value, const char* v);
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
icalvalue* icalvalue_new_string(const char* v);
const char* icalvalue_get_string(icalvalue* value);
void icalvalue_set_string(icalvalue* value, const char* v);
icalvalue* icalvalue_new_text(const char* v);
const char* icalvalue_get_text(icalvalue* value);
void icalvalue_set_text(icalvalue* value, const char* v);
icalvalue* icalvalue_new_time(struct icaltimetype v);
struct icaltimetype icalvalue_get_time(icalvalue* value);
void icalvalue_set_time(icalvalue* value, struct icaltimetype v);
icalvalue* icalvalue_new_trigger(union icaltriggertype v);
union icaltriggertype icalvalue_get_trigger(icalvalue* value);
void icalvalue_set_trigger(icalvalue* value, union icaltriggertype v);
icalvalue* icalvalue_new_uri(const char* v);
const char* icalvalue_get_uri(icalvalue* value);
void icalvalue_set_uri(icalvalue* value, const char* v);
icalvalue* icalvalue_new_utcoffset(int v);
int icalvalue_get_utcoffset(icalvalue* value);
void icalvalue_set_utcoffset(icalvalue* value, int v);
icalvalue* icalvalue_new_query(const char* v);
const char* icalvalue_get_query(icalvalue* value);
void icalvalue_set_query(icalvalue* value, const char* v);
icalvalue* icalvalue_new_status(icalproperty_status v);
icalproperty_status icalvalue_get_status(icalvalue* value);
void icalvalue_set_status(icalvalue* value, icalproperty_status v);
typedef void icalparameter;
icalparameter* icalparameter_new(icalparameter_kind kind);
icalparameter* icalparameter_new_clone(icalparameter* p);
icalparameter* icalparameter_new_from_string(icalparameter_kind kind, char* value);
void icalparameter_free(icalparameter* parameter);
char* icalparameter_as_ical_string(icalparameter* parameter);
int icalparameter_is_valid(icalparameter* parameter);
icalparameter_kind icalparameter_isa(icalparameter* parameter);
int icalparameter_isa_parameter(void* param);
void icalparameter_set_xname (icalparameter* param, const char* v);
const char* icalparameter_get_xname(icalparameter* param);
void icalparameter_set_xvalue (icalparameter* param, const char* v);
const char* icalparameter_get_xvalue(icalparameter* param);
icalparameter* icalparameter_new_altrep(const char* v);
const char* icalparameter_get_altrep(icalparameter* value);
void icalparameter_set_altrep(icalparameter* value, const char* v);
icalparameter* icalparameter_new_cn(const char* v);
const char* icalparameter_get_cn(icalparameter* value);
void icalparameter_set_cn(icalparameter* value, const char* v);
icalparameter* icalparameter_new_cutype(icalparameter_cutype v);
icalparameter_cutype icalparameter_get_cutype(icalparameter* value);
void icalparameter_set_cutype(icalparameter* value, icalparameter_cutype v);
icalparameter* icalparameter_new_delegatedfrom(const char* v);
const char* icalparameter_get_delegatedfrom(icalparameter* value);
void icalparameter_set_delegatedfrom(icalparameter* value, const char* v);
icalparameter* icalparameter_new_delegatedto(const char* v);
const char* icalparameter_get_delegatedto(icalparameter* value);
void icalparameter_set_delegatedto(icalparameter* value, const char* v);
icalparameter* icalparameter_new_dir(const char* v);
const char* icalparameter_get_dir(icalparameter* value);
void icalparameter_set_dir(icalparameter* value, const char* v);
icalparameter* icalparameter_new_encoding(icalparameter_encoding v);
icalparameter_encoding icalparameter_get_encoding(icalparameter* value);
void icalparameter_set_encoding(icalparameter* value, icalparameter_encoding v);
icalparameter* icalparameter_new_fbtype(icalparameter_fbtype v);
icalparameter_fbtype icalparameter_get_fbtype(icalparameter* value);
void icalparameter_set_fbtype(icalparameter* value, icalparameter_fbtype v);
icalparameter* icalparameter_new_fmttype(const char* v);
const char* icalparameter_get_fmttype(icalparameter* value);
void icalparameter_set_fmttype(icalparameter* value, const char* v);
icalparameter* icalparameter_new_language(const char* v);
const char* icalparameter_get_language(icalparameter* value);
void icalparameter_set_language(icalparameter* value, const char* v);
icalparameter* icalparameter_new_member(const char* v);
const char* icalparameter_get_member(icalparameter* value);
void icalparameter_set_member(icalparameter* value, const char* v);
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
icalparameter* icalparameter_new_sentby(const char* v);
const char* icalparameter_get_sentby(icalparameter* value);
void icalparameter_set_sentby(icalparameter* value, const char* v);
icalparameter* icalparameter_new_tzid(const char* v);
const char* icalparameter_get_tzid(icalparameter* value);
void icalparameter_set_tzid(icalparameter* value, const char* v);
icalparameter* icalparameter_new_value(icalparameter_value v);
icalparameter_value icalparameter_get_value(icalparameter* value);
void icalparameter_set_value(icalparameter* value, icalparameter_value v);
icalparameter* icalparameter_new_x(const char* v);
const char* icalparameter_get_x(icalparameter* value);
void icalparameter_set_x(icalparameter* value, const char* v);
icalparameter* icalparameter_new_xlicerrortype(icalparameter_xlicerrortype v);
icalparameter_xlicerrortype icalparameter_get_xlicerrortype(icalparameter* value);
void icalparameter_set_xlicerrortype(icalparameter* value, icalparameter_xlicerrortype v);
icalparameter* icalparameter_new_xliccomparetype(icalparameter_xliccomparetype v);
icalparameter_xliccomparetype icalparameter_get_xliccomparetype(icalparameter* value);
void icalparameter_set_xliccomparetype(icalparameter* value, icalparameter_xliccomparetype v);
typedef void icalproperty;
icalproperty* icalproperty_new(icalproperty_kind kind);
icalproperty* icalproperty_new_clone(icalproperty * prop);
icalproperty* icalproperty_new_from_string(char* str);
char* icalproperty_as_ical_string(icalproperty* prop);
void  icalproperty_free(icalproperty* prop);
icalproperty_kind icalproperty_isa(icalproperty* property);
int icalproperty_isa_property(void* property);
void icalproperty_add_parameter(icalproperty* prop,icalparameter* parameter);
void icalproperty_set_parameter(icalproperty* prop,icalparameter* parameter);
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
icalproperty* icalproperty_new_xlicmimecid(const char* v);
void icalproperty_set_xlicmimecid(icalproperty* prop, const char* v);
const char* icalproperty_get_xlicmimecid(icalproperty* prop);
icalproperty* icalproperty_new_lastmodified(struct icaltimetype v);
void icalproperty_set_lastmodified(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_lastmodified(icalproperty* prop);
icalproperty* icalproperty_new_uid(const char* v);
void icalproperty_set_uid(icalproperty* prop, const char* v);
const char* icalproperty_get_uid(icalproperty* prop);
icalproperty* icalproperty_new_prodid(const char* v);
void icalproperty_set_prodid(icalproperty* prop, const char* v);
const char* icalproperty_get_prodid(icalproperty* prop);
icalproperty* icalproperty_new_status(icalproperty_status v);
void icalproperty_set_status(icalproperty* prop, icalproperty_status v);
icalproperty_status icalproperty_get_status(icalproperty* prop);
icalproperty* icalproperty_new_description(const char* v);
void icalproperty_set_description(icalproperty* prop, const char* v);
const char* icalproperty_get_description(icalproperty* prop);
icalproperty* icalproperty_new_duration(struct icaldurationtype v);
void icalproperty_set_duration(icalproperty* prop, struct icaldurationtype v);
struct icaldurationtype icalproperty_get_duration(icalproperty* prop);
icalproperty* icalproperty_new_categories(const char* v);
void icalproperty_set_categories(icalproperty* prop, const char* v);
const char* icalproperty_get_categories(icalproperty* prop);
icalproperty* icalproperty_new_version(const char* v);
void icalproperty_set_version(icalproperty* prop, const char* v);
const char* icalproperty_get_version(icalproperty* prop);
icalproperty* icalproperty_new_tzoffsetfrom(int v);
void icalproperty_set_tzoffsetfrom(icalproperty* prop, int v);
int icalproperty_get_tzoffsetfrom(icalproperty* prop);
icalproperty* icalproperty_new_attendee(const char* v);
void icalproperty_set_attendee(icalproperty* prop, const char* v);
const char* icalproperty_get_attendee(icalproperty* prop);
icalproperty* icalproperty_new_contact(const char* v);
void icalproperty_set_contact(icalproperty* prop, const char* v);
const char* icalproperty_get_contact(icalproperty* prop);
icalproperty* icalproperty_new_xlicmimecontenttype(const char* v);
void icalproperty_set_xlicmimecontenttype(icalproperty* prop, const char* v);
const char* icalproperty_get_xlicmimecontenttype(icalproperty* prop);
icalproperty* icalproperty_new_xlicmimeoptinfo(const char* v);
void icalproperty_set_xlicmimeoptinfo(icalproperty* prop, const char* v);
const char* icalproperty_get_xlicmimeoptinfo(icalproperty* prop);
icalproperty* icalproperty_new_relatedto(const char* v);
void icalproperty_set_relatedto(icalproperty* prop, const char* v);
const char* icalproperty_get_relatedto(icalproperty* prop);
icalproperty* icalproperty_new_organizer(const char* v);
void icalproperty_set_organizer(icalproperty* prop, const char* v);
const char* icalproperty_get_organizer(icalproperty* prop);
icalproperty* icalproperty_new_comment(const char* v);
void icalproperty_set_comment(icalproperty* prop, const char* v);
const char* icalproperty_get_comment(icalproperty* prop);
icalproperty* icalproperty_new_xlicerror(const char* v);
void icalproperty_set_xlicerror(icalproperty* prop, const char* v);
const char* icalproperty_get_xlicerror(icalproperty* prop);
icalproperty* icalproperty_new_trigger(union icaltriggertype v);
void icalproperty_set_trigger(icalproperty* prop, union icaltriggertype v);
union icaltriggertype icalproperty_get_trigger(icalproperty* prop);
icalproperty* icalproperty_new_class(const char* v);
void icalproperty_set_class(icalproperty* prop, const char* v);
const char* icalproperty_get_class(icalproperty* prop);
icalproperty* icalproperty_new_x(const char* v);
void icalproperty_set_x(icalproperty* prop, const char* v);
const char* icalproperty_get_x(icalproperty* prop);
icalproperty* icalproperty_new_tzoffsetto(int v);
void icalproperty_set_tzoffsetto(icalproperty* prop, int v);
int icalproperty_get_tzoffsetto(icalproperty* prop);
icalproperty* icalproperty_new_transp(const char* v);
void icalproperty_set_transp(icalproperty* prop, const char* v);
const char* icalproperty_get_transp(icalproperty* prop);
icalproperty* icalproperty_new_xlicmimeencoding(const char* v);
void icalproperty_set_xlicmimeencoding(icalproperty* prop, const char* v);
const char* icalproperty_get_xlicmimeencoding(icalproperty* prop);
icalproperty* icalproperty_new_sequence(int v);
void icalproperty_set_sequence(icalproperty* prop, int v);
int icalproperty_get_sequence(icalproperty* prop);
icalproperty* icalproperty_new_location(const char* v);
void icalproperty_set_location(icalproperty* prop, const char* v);
const char* icalproperty_get_location(icalproperty* prop);
icalproperty* icalproperty_new_requeststatus(const char* v);
void icalproperty_set_requeststatus(icalproperty* prop, const char* v);
const char* icalproperty_get_requeststatus(icalproperty* prop);
icalproperty* icalproperty_new_exdate(struct icaltimetype v);
void icalproperty_set_exdate(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_exdate(icalproperty* prop);
icalproperty* icalproperty_new_tzid(const char* v);
void icalproperty_set_tzid(icalproperty* prop, const char* v);
const char* icalproperty_get_tzid(icalproperty* prop);
icalproperty* icalproperty_new_resources(const char* v);
void icalproperty_set_resources(icalproperty* prop, const char* v);
const char* icalproperty_get_resources(icalproperty* prop);
icalproperty* icalproperty_new_tzurl(const char* v);
void icalproperty_set_tzurl(icalproperty* prop, const char* v);
const char* icalproperty_get_tzurl(icalproperty* prop);
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
icalproperty* icalproperty_new_summary(const char* v);
void icalproperty_set_summary(icalproperty* prop, const char* v);
const char* icalproperty_get_summary(icalproperty* prop);
icalproperty* icalproperty_new_dtend(struct icaltimetype v);
void icalproperty_set_dtend(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_dtend(icalproperty* prop);
icalproperty* icalproperty_new_tzname(const char* v);
void icalproperty_set_tzname(icalproperty* prop, const char* v);
const char* icalproperty_get_tzname(icalproperty* prop);
icalproperty* icalproperty_new_rdate(struct icalperiodtype v);
void icalproperty_set_rdate(icalproperty* prop, struct icalperiodtype v);
struct icalperiodtype icalproperty_get_rdate(icalproperty* prop);
icalproperty* icalproperty_new_xlicmimefilename(const char* v);
void icalproperty_set_xlicmimefilename(icalproperty* prop, const char* v);
const char* icalproperty_get_xlicmimefilename(icalproperty* prop);
icalproperty* icalproperty_new_url(const char* v);
void icalproperty_set_url(icalproperty* prop, const char* v);
const char* icalproperty_get_url(icalproperty* prop);
icalproperty* icalproperty_new_xlicclustercount(int v);
void icalproperty_set_xlicclustercount(icalproperty* prop, int v);
int icalproperty_get_xlicclustercount(icalproperty* prop);
icalproperty* icalproperty_new_attach(struct icalattachtype v);
void icalproperty_set_attach(icalproperty* prop, struct icalattachtype v);
struct icalattachtype icalproperty_get_attach(icalproperty* prop);
icalproperty* icalproperty_new_query(const char* v);
void icalproperty_set_query(icalproperty* prop, const char* v);
const char* icalproperty_get_query(icalproperty* prop);
icalproperty* icalproperty_new_percentcomplete(int v);
void icalproperty_set_percentcomplete(icalproperty* prop, int v);
int icalproperty_get_percentcomplete(icalproperty* prop);
icalproperty* icalproperty_new_calscale(const char* v);
void icalproperty_set_calscale(icalproperty* prop, const char* v);
const char* icalproperty_get_calscale(icalproperty* prop);
icalproperty* icalproperty_new_created(struct icaltimetype v);
void icalproperty_set_created(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_created(icalproperty* prop);
icalproperty* icalproperty_new_geo(struct icalgeotype v);
void icalproperty_set_geo(icalproperty* prop, struct icalgeotype v);
struct icalgeotype icalproperty_get_geo(icalproperty* prop);
icalproperty* icalproperty_new_xlicmimecharset(const char* v);
void icalproperty_set_xlicmimecharset(icalproperty* prop, const char* v);
const char* icalproperty_get_xlicmimecharset(icalproperty* prop);
icalproperty* icalproperty_new_completed(struct icaltimetype v);
void icalproperty_set_completed(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_completed(icalproperty* prop);
icalproperty* icalproperty_new_dtstamp(struct icaltimetype v);
void icalproperty_set_dtstamp(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_dtstamp(icalproperty* prop);
icalproperty* icalproperty_new_due(struct icaltimetype v);
void icalproperty_set_due(icalproperty* prop, struct icaltimetype v);
struct icaltimetype icalproperty_get_due(icalproperty* prop);
icalproperty* icalproperty_new_action(const char* v);
void icalproperty_set_action(icalproperty* prop, const char* v);
const char* icalproperty_get_action(icalproperty* prop);
typedef void* pvl_list;
typedef void* pvl_elem;
typedef struct pvl_elem_t
{
	int MAGIC;			
	void *d;			
	struct pvl_elem_t *next;	
	struct pvl_elem_t *prior;	
} pvl_elem_t;
pvl_elem pvl_new_element(void* d, pvl_elem next,pvl_elem prior);
pvl_list pvl_newlist(void);
void pvl_free(pvl_list);
void pvl_unshift(pvl_list l,void *d);
void* pvl_shift(pvl_list l);
pvl_elem pvl_head(pvl_list);
void pvl_push(pvl_list l,void *d);
void* pvl_pop(pvl_list l);
pvl_elem pvl_tail(pvl_list);
typedef int (*pvl_comparef)(void* a, void* b); 
void pvl_insert_ordered(pvl_list l,pvl_comparef f,void *d);
void pvl_insert_after(pvl_list l,pvl_elem e,void *d);
void pvl_insert_before(pvl_list l,pvl_elem e,void *d);
void* pvl_remove(pvl_list,pvl_elem); 
void pvl_clear(pvl_list); 
int pvl_count(pvl_list);
pvl_elem pvl_next(pvl_elem e);
pvl_elem pvl_prior(pvl_elem e);
void* pvl_data(pvl_elem);
typedef int (*pvl_findf)(void* a, void* b); 
pvl_elem pvl_find(pvl_list l,pvl_findf f,void* v);
pvl_elem pvl_find_next(pvl_list l,pvl_findf f,void* v);
typedef void (*pvl_applyf)(void* a, void* b); 
void pvl_apply(pvl_list l,pvl_applyf f, void *v);
typedef void icalcomponent;
typedef struct icalcompiter
{
	icalcomponent_kind kind;
	pvl_elem iter;
} icalcompiter;
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
icalcompiter icalcomponent_end_component(icalcomponent* component,
					 icalcomponent_kind kind);
icalcomponent* icalcomponent_get_current_component (icalcomponent* component);
icalcomponent* icalcomponent_get_first_component(icalcomponent* component,
					      icalcomponent_kind kind);
icalcomponent* icalcomponent_get_next_component(icalcomponent* component,
					      icalcomponent_kind kind);
int icalcomponent_count_errors(icalcomponent* component);
void icalcomponent_strip_errors(icalcomponent* component);
void icalcomponent_convert_errors(icalcomponent* component);
icalcomponent* icalcomponent_get_parent(icalcomponent* component);
void icalcomponent_set_parent(icalcomponent* component, 
			      icalcomponent* parent);
icalcomponent* icalcompiter_next(icalcompiter* i);
icalcomponent* icalcompiter_prior(icalcompiter* i);
icalcomponent* icalcompiter_deref(icalcompiter* i);
icalcomponent* icalcomponent_get_first_real_component(icalcomponent *c);
struct icaltime_span icalcomponent_get_span(icalcomponent* comp);
void icalcomponent_set_dtstart(icalcomponent* comp, struct icaltimetype v);
struct icaltimetype icalcomponent_get_dtstart(icalcomponent* comp);
struct icaltimetype icalcomponent_get_dtend(icalcomponent* comp);
void icalcomponent_set_dtend(icalcomponent* comp, struct icaltimetype v);
void icalcomponent_set_duration(icalcomponent* comp, 
				struct icaldurationtype v);
struct icaldurationtype icalcomponent_get_duration(icalcomponent* comp);
void icalcomponent_set_method(icalcomponent* comp, icalproperty_method method);
icalproperty_method icalcomponent_get_method(icalcomponent* comp);
struct icaltimetype icalcomponent_get_dtstamp(icalcomponent* comp);
void icalcomponent_set_dtstamp(icalcomponent* comp, struct icaltimetype v);
void icalcomponent_set_summary(icalcomponent* comp, const char* v);
const char* icalcomponent_get_summary(icalcomponent* comp);
void icalcomponent_set_comment(icalcomponent* comp, const char* v);
const char* icalcomponent_get_comment(icalcomponent* comp);
void icalcomponent_set_organizer(icalcomponent* comp, const char* v);
const char* icalcomponent_get_organizer(icalcomponent* comp);
void icalcomponent_set_uid(icalcomponent* comp, const char* v);
const char* icalcomponent_get_uid(icalcomponent* comp);
void icalcomponent_set_recurrenceid(icalcomponent* comp, 
				    struct icaltimetype v);
struct icaltimetype icalcomponent_get_recurrenceid(icalcomponent* comp);
icalcomponent* icalcomponent_new_vcalendar();
icalcomponent* icalcomponent_new_vevent();
icalcomponent* icalcomponent_new_vtodo();
icalcomponent* icalcomponent_new_vjournal();
icalcomponent* icalcomponent_new_vfreebusy();
icalcomponent* icalcomponent_new_vtimezone();
icalcomponent* icalcomponent_new_xstandard();
icalcomponent* icalcomponent_new_xdaylight();
typedef void* icalparser;
typedef enum icalparser_state {
    ICALPARSER_ERROR,
    ICALPARSER_SUCCESS,
    ICALPARSER_BEGIN_COMP,
    ICALPARSER_END_COMP,
    ICALPARSER_IN_PROGRESS
} icalparser_state;
icalparser* icalparser_new(void);
icalcomponent* icalparser_add_line(icalparser* parser, char* str );
icalcomponent* icalparser_claim(icalparser* parser);
icalcomponent* icalparser_clean(icalparser* parser);
icalparser_state icalparser_get_state(icalparser* parser);
void icalparser_free(icalparser* parser);
icalcomponent* icalparser_parse_string(char* str);
icalvalue*  icalparser_parse_value(icalvalue_kind kind, 
				   const char* str, icalcomponent** errors);
char* string_line_generator(char *out, size_t buf_size, void *d);
void* icalmemory_tmp_buffer(size_t size);
char* icalmemory_tmp_copy(const char* str);
void  icalmemory_add_tmp_buffer(void*);
void icalmemory_free_ring(void);
void* icalmemory_new_buffer(size_t size);
void* icalmemory_resize_buffer(void* buf, size_t size);
void icalmemory_free_buffer(void* buf);
void icalmemory_append_string(char** buf, char** pos, size_t* buf_size, 
			      const char* string);
void icalmemory_append_char(char** buf, char** pos, size_t* buf_size, 
			      char ch);
char* icalmemory_strdup(const char *s);
void icalerror_stop_here(void);
void icalerror_crash_here(void);
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
    ICAL_TIMEDOUT_ERROR,
    ICAL_UNKNOWN_ERROR 
} icalerrorenum;
void icalerror_clear_errno(void);
void icalerror_set_errno(icalerrorenum);
char* icalerror_strerror(icalerrorenum e);
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
int
icalrestriction_is_parameter_allowed(icalproperty_kind property,
                                       icalparameter_kind parameter);
int icalrestriction_check(icalcomponent* comp);
enum {
    ICAL_RECURRENCE_ARRAY_MAX = 0x7f7f,
    ICAL_RECURRENCE_ARRAY_MAX_BYTE = 0x7f
};
    
