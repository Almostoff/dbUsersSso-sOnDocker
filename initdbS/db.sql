create table public.auth_admin
(
    id                bigserial
        constraint admin_auth_pk
            primary key,
    admin_id          bigint not null
        unique,
    nickname          varchar(255),
    password          varchar(255),
    second_password   varchar(255),
    registration_date timestamp default '0001-01-01 00:00:00'::timestamp without time zone
);

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TYPE codes AS ENUM ('recovery_by_email', 'email_confirm', 'KYC', 'phone_confirm', 'confirm_withdraw');


create unique index users_id_uindex
    on public.auth_admin (id);

create table public.auth_clients
(
    id                bigserial
        constraint clients_auth_pk
            primary key,
    client_id         bigint not null
        unique,
    nickname          varchar(255),
    email             varchar(255),
    phone             varchar(255),
    tg                varchar(255),
    password          varchar(255),
    registration_date timestamp    default '0001-01-01 00:00:00'::timestamp without time zone,
    is_dnd            boolean      default false,
    secret_totp       varchar(255) default ' '::character varying,
    tg_id             bigint       default 0
);


create unique index auth_clients_id_uindex
    on public.auth_clients (id);

create table public.auth_clients_level
(
    id              bigserial
        constraint auth_clients_level_pk
            primary key,
    email_confirm   boolean,
    phone_confirm   boolean,
    kyc_confirm     boolean,
    totp_confirm    boolean default false,
    strong_password boolean default false
);


create table public.auth_codes_confirms
(
    id          bigserial
        constraint codes_auth_pk
            primary key,
    type        varchar(255),
    code_need   varchar(255),
    date        timestamp default '0001-01-01 00:00:00'::timestamp without time zone,
    destination varchar(255),
    client_id   bigint
);


create table public.auth_history_password
(
    id        bigserial
        constraint auth_history_password_pk
            primary key,
    client_id bigint       not null,
    password  varchar(255) not null
);


create unique index auth_history_password_id_uindex
    on public.auth_history_password (id);

create table public.user_agent
(
    id           bigserial
        constraint auth_user_agents_pk
            primary key,
    client_id    bigint not null,
    ua           varchar(255),
    sign_in_date timestamp    default '0001-01-01 00:00:00'::timestamp without time zone,
    logout_date  timestamp    default '0001-01-01 00:00:00'::timestamp without time zone,
    logout       boolean,
    ip           varchar(255) default ' '::character varying,
    location     varchar(255) default ''::character varying
);


create table public.client  /*  main table */
(
    client_uuid       varchar(255) default uuid_generate_v4(), /* поле */
    language          varchar(55)  default 'ru'::character varying,
    nickname          varchar(255) default ''::character varying,
    registration_date timestamp    default (now() + '03:00:00'::interval),
    last_activity     timestamp    default (now() + '03:00:00'::interval),
    last_login        timestamp    default (now() + '03:00:00'::interval)
);

create table public.client_contact /*  откуда беру меил */
(
    client_uuid varchar(255)                               not null
        unique,
    email       varchar(255)                               not null,
    phone       varchar(255) default ''::character varying not null,
    tg          varchar(255) default ''::character varying not null
);

create table public.ver_level
(
    client_uuid     varchar(255) not null
        unique,
    kyc             boolean default false,
    email           boolean default false,
    phone           boolean default false,
    tg              boolean default false,
    totp            boolean default false,
    resolved_ip     boolean default false,
    strong_password boolean default false
);


create table public.credential
(
    client_uuid varchar(255) not null
        unique,
    password    varchar(255),
    totp_secret varchar(255) default ''::character varying,
    tg_id       bigint       default 0
);


create table public.session_history
(
    client_uuid varchar(255) not null,
    ip          varchar(255) not null,
    ua          varchar(255) not null,
    login_time  timestamp default (now() + '03:00:00'::interval),
    logout_time timestamp default '0001-01-01 00:00:00'::timestamp without time zone,
    is_logout   boolean   default false,
    id          bigserial
);


create table public.codes_confirms
(
    client_uuid varchar(255) not null,
    type_code   codes        not null,
    code_need   varchar(255) not null,
    create_time timestamp    default (now() + '03:00:00'::interval),
    destination varchar(255) default ''::character varying
);

create table public.history_passwords
(
    id          bigserial
        constraint history_passwords_pk
            primary key,
    client_uuid varchar(255) not null,
    password    varchar(255) not null,
    change_time timestamp default (now() + '03:00:00'::interval)
);


create table public.history_nickname
(
    id           bigserial
        constraint history_nickname_pk
            primary key,
    client_uuid  varchar(255) not null,
    old_nickname varchar(255) not null,
    change_time  timestamp default (now() + '03:00:00'::interval)
);

create table inner_connection (
    id bigserial not null
        constraint inner_connection_pm_pk
        primary key,
    base_url text not null,
    public text not null,
    private text not null,
    name varchar(25) not null
);

create unique index inner_connection_id_uindex
    on inner_connection (id);
