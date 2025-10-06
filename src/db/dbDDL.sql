-- public.adm_masterdata definition

-- Drop table

-- DROP TABLE public.adm_masterdata;

CREATE TABLE public.adm_masterdata (
	id bigserial NOT NULL,
	code varchar NULL,
	"name" varchar NULL,
	masterdata_group_code varchar NULL,
	status varchar NULL DEFAULT 1,
	created_user varchar NULL,
	created_date timestamp NULL DEFAULT now(),
	updated_user varchar NULL,
	updated_date timestamp NULL,
	sort int4 NULL DEFAULT 0
);


-- public.adm_masterdata_group definition

-- Drop table

-- DROP TABLE public.adm_masterdata_group;

CREATE TABLE public.adm_masterdata_group (
	id bigserial NOT NULL,
	code varchar NULL,
	"name" varchar NULL,
	status int4 NULL DEFAULT 1,
	created_user varchar NULL,
	created_date timestamp NULL DEFAULT now(),
	updated_user varchar NULL,
	updated_date timestamp NULL DEFAULT now()
);


-- public.attendance_logs definition

-- Drop table

-- DROP TABLE public.attendance_logs;

CREATE TABLE public.attendance_logs (
	id bigserial NOT NULL,
	employee_id int4 NULL,
	event_time timestamptz NOT NULL,
	direction text NOT NULL,
	device_id text NULL,
	raw_payload jsonb NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	CONSTRAINT attendance_logs_direction_check CHECK ((direction = ANY (ARRAY['IN'::text, 'OUT'::text])))
);


-- public.contracts definition

-- Drop table

-- DROP TABLE public.contracts;

CREATE TABLE public.contracts (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	contract_type_code varchar NULL,
	start_date date NOT NULL,
	end_date date NULL,
	probation_months int4 NULL,
	document_url text NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	CONSTRAINT contracts_probation_months_check CHECK ((probation_months >= 0))
);


-- public.departments definition

-- Drop table

-- DROP TABLE public.departments;

CREATE TABLE public.departments (
	id serial4 NOT NULL,
	code text NOT NULL,
	"name" text NOT NULL,
	manager_employee_id int8 NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	status int4 NULL,
	CONSTRAINT departments_code_key UNIQUE (code)
);


-- public.employee_benefits definition

-- Drop table

-- DROP TABLE public.employee_benefits;

CREATE TABLE public.employee_benefits (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	benefit_type_code varchar NULL,
	start_date date NOT NULL,
	end_date date NULL,
	amount_per_month numeric(14, 2) NOT NULL DEFAULT 0,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL
);


-- public.employees definition

-- Drop table

-- DROP TABLE public.employees;

CREATE TABLE public.employees (
	id bigserial NOT NULL,
	employee_code text NOT NULL,
	status text NOT NULL,
	first_name text NOT NULL,
	last_name text NOT NULL,
	middle_name text NULL,
	display_name text NULL GENERATED ALWAYS AS ((COALESCE(first_name, ''::text) || ' '::text) || COALESCE(last_name, ''::text)) STORED,
	dob date NULL,
	gender text NULL,
	national_id text NULL,
	email_work text NULL,
	email_personal text NULL,
	phone_work text NULL,
	phone_personal text NULL,
	address text NULL,
	provice_code varchar NULL,
	region_code varchar NULL,
	country_code varchar NULL,
	hire_date date NULL,
	termination_date date NULL,
	termination_reason text NULL,
	manager_id int4 NULL,
	department_id int4 NULL,
	position_id int4 NULL,
	employment_type_code varchar NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	CONSTRAINT employees_gender_check CHECK ((gender = ANY (ARRAY['M'::text, 'F'::text, 'O'::text]))),
	CONSTRAINT employees_status_check CHECK ((status = ANY (ARRAY['ACTIVE'::text, 'INACTIVE'::text, 'ON_LEAVE'::text, 'TERMINATED'::text])))
);


-- public.employment_history definition

-- Drop table

-- DROP TABLE public.employment_history;

CREATE TABLE public.employment_history (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	department_id int8 NULL,
	position_id int8 NULL,
	start_date date NOT NULL,
	end_date date NULL,
	reason text NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL
);


-- public.jobs definition

-- Drop table

-- DROP TABLE public.jobs;

CREATE TABLE public.jobs (
	id bigserial NOT NULL,
	code text NOT NULL,
	"name" text NOT NULL,
	description text NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	status int4 NULL DEFAULT 1
);


-- public.leave_manage definition

-- Drop table

-- DROP TABLE public.leave_manage;

CREATE TABLE public.leave_manage (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	"year" int4 NOT NULL,
	leave_amount numeric NULL DEFAULT 0,
	remaining_amount numeric NULL DEFAULT 0,
	updated_user varchar NULL,
	updated_date timestamp NULL DEFAULT CURRENT_TIMESTAMP
);


-- public.leave_request definition

-- Drop table

-- DROP TABLE public.leave_request;

CREATE TABLE public.leave_request (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	leave_type_code varchar NULL,
	start_date date NULL,
	end_date date NULL,
	days numeric NULL,
	status text NOT NULL DEFAULT 'PENDING'::text,
	reason text NULL,
	approver_id int8 NULL,
	created_user varchar NULL,
	created_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	updated_user varchar NULL,
	updated_date timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT leave_request_status_check CHECK ((status = ANY (ARRAY['PENDING'::text, 'APPROVED'::text, 'REJECTED'::text, 'CANCELLED'::text])))
);


-- public.payroll_factor definition

-- Drop table

-- DROP TABLE public.payroll_factor;

CREATE TABLE public.payroll_factor (
	id bigserial NOT NULL,
	"name" varchar(250) NULL,
	value numeric NULL,
	status varchar NULL,
	created_user varchar(25) NULL,
	created_date timestamp NULL,
	updated_user varchar(25) NULL,
	updated_date timestamp NULL
);


-- public.payroll_monthly_salary definition

-- Drop table

-- DROP TABLE public.payroll_monthly_salary;

CREATE TABLE public.payroll_monthly_salary (
	id int8 NOT NULL,
	"year" int4 NULL,
	"month" int4 NULL,
	employee_id int8 NULL,
	enought_days numeric NULL,
	working_days numeric NULL,
	gross_salary numeric(12, 2) NULL,
	net_salary numeric(12, 2) NULL,
	salary_group_id int8 NULL,
	status varchar(20) NULL,
	created_user varchar(50) NULL,
	created_date timestamp NULL,
	updated_by varchar(50) NULL,
	updated_date timestamp NULL
);


-- public.payroll_salary_group definition

-- Drop table

-- DROP TABLE public.payroll_salary_group;

CREATE TABLE public.payroll_salary_group (
	id bigserial NOT NULL,
	"name" varchar(250) NULL,
	formula varchar(1000) NULL,
	"year" int4 NULL,
	director varchar(50) NULL,
	type_group_salary varchar(50) NULL,
	approver_id int8 NULL,
	status varchar NULL,
	created_user varchar(25) NULL,
	created_date timestamp NULL,
	updated_user varchar(25) NULL,
	updated_date timestamp NULL
);


-- public.payroll_salary_group_mapping definition

-- Drop table

-- DROP TABLE public.payroll_salary_group_mapping;

CREATE TABLE public.payroll_salary_group_mapping (
	id int8 NOT NULL,
	employee_id int8 NOT NULL,
	payroll_salary_group_id int8 NOT NULL,
	created_user varchar(25) NULL,
	created_date timestamp NULL,
	updated_user varchar(25) NULL,
	updated_date timestamp NULL
);


-- public.permissions definition

-- Drop table

-- DROP TABLE public.permissions;

CREATE TABLE public.permissions (
	id bigserial NOT NULL,
	code varchar(100) NOT NULL,
	description text NULL,
	created_date timestamptz NULL DEFAULT now(),
	CONSTRAINT permissions_code_key UNIQUE (code)
);


-- public.positions definition

-- Drop table

-- DROP TABLE public.positions;

CREATE TABLE public.positions (
	id bigserial NOT NULL,
	department_id int8 NULL,
	job_id int8 NULL,
	code text NOT NULL,
	"name" text NULL,
	budgeted bool NOT NULL DEFAULT true,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	status int4 NULL DEFAULT 1
);


-- public.role_permissions definition

-- Drop table

-- DROP TABLE public.role_permissions;

CREATE TABLE public.role_permissions (
	id bigserial NOT NULL,
	role_id int8 NULL,
	permission_id int8 NULL,
	status int4 NULL DEFAULT 1,
	updated_date timestamp NULL
);


-- public.roles definition

-- Drop table

-- DROP TABLE public.roles;

CREATE TABLE public.roles (
	id bigserial NOT NULL,
	"name" varchar(50) NOT NULL,
	description text NULL,
	is_system_role bool NULL DEFAULT false,
	created_date timestamptz NULL DEFAULT now(),
	CONSTRAINT roles_name_key UNIQUE (name)
);


-- public.salary_history definition

-- Drop table

-- DROP TABLE public.salary_history;

CREATE TABLE public.salary_history (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	currency_code varchar NULL,
	base_salary numeric(14, 2) NOT NULL,
	allowance numeric(14, 2) NOT NULL DEFAULT 0,
	effective_from date NOT NULL,
	effective_to date NULL,
	reason text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL
);


-- public.shifts definition

-- Drop table

-- DROP TABLE public.shifts;

CREATE TABLE public.shifts (
	id bigserial NOT NULL,
	code text NOT NULL,
	"name" text NOT NULL,
	start_time time NOT NULL,
	end_time time NOT NULL,
	break_minutes int4 NOT NULL DEFAULT 60,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	status int4 NULL DEFAULT 1,
	CONSTRAINT shifts_code_key UNIQUE (code)
);


-- public.timesheet_entries definition

-- Drop table

-- DROP TABLE public.timesheet_entries;

CREATE TABLE public.timesheet_entries (
	id bigserial NOT NULL,
	timesheet_id int8 NULL,
	work_date date NOT NULL,
	project_code text NULL,
	hours_worked numeric(5, 2) NOT NULL,
	attendance_status_id int4 NULL,
	note text NULL,
	CONSTRAINT timesheet_entries_hours_worked_check CHECK (((hours_worked >= (0)::numeric) AND (hours_worked <= (24)::numeric)))
);


-- public.timesheets definition

-- Drop table

-- DROP TABLE public.timesheets;

CREATE TABLE public.timesheets (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	week_start date NOT NULL,
	status text NOT NULL DEFAULT 'DRAFT'::text,
	approver_id int8 NULL,
	submitted_date timestamptz NULL,
	approved_date timestamptz NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL,
	CONSTRAINT timesheets_status_check CHECK ((status = ANY (ARRAY['DRAFT'::text, 'SUBMITTED'::text, 'APPROVED'::text, 'REJECTED'::text])))
);


-- public.user_roles definition

-- Drop table

-- DROP TABLE public.user_roles;

CREATE TABLE public.user_roles (
	user_id int8 NOT NULL,
	role_id int8 NOT NULL,
	updated_date timestamptz NULL DEFAULT now(),
	CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id)
);


-- public.user_sessions definition

-- Drop table

-- DROP TABLE public.user_sessions;

CREATE TABLE public.user_sessions (
	id bigserial NOT NULL,
	user_id int8 NULL,
	"token" text NOT NULL,
	ip_address inet NULL,
	user_agent text NULL,
	created_at timestamptz NULL DEFAULT now(),
	expires_at timestamptz NULL
);


-- public.users definition

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users (
	id bigserial NOT NULL,
	username varchar(50) NOT NULL,
	email varchar(100) NOT NULL,
	phone varchar(10) NOT NULL,
	password_hash text NOT NULL,
	employee_id int8 NULL,
	is_active bool NULL DEFAULT true,
	last_login_at timestamptz NULL,
	created_date timestamptz NULL DEFAULT now(),
	updated_date timestamptz NULL DEFAULT now(),
	CONSTRAINT users_username_key UNIQUE (username)
);


-- public.work_schedules definition

-- Drop table

-- DROP TABLE public.work_schedules;

CREATE TABLE public.work_schedules (
	id bigserial NOT NULL,
	employee_id int8 NULL,
	effective_from date NOT NULL,
	effective_to date NULL,
	mon_shift_id int8 NULL,
	tue_shift_id int8 NULL,
	wed_shift_id int8 NULL,
	thu_shift_id int8 NULL,
	fri_shift_id int8 NULL,
	sat_shift_id int8 NULL,
	sun_shift_id int8 NULL,
	created_date timestamptz NOT NULL DEFAULT now(),
	created_user text NULL,
	updated_date timestamptz NOT NULL DEFAULT now(),
	updated_user text NULL
);