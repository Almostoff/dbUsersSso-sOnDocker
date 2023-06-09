create table public.users
(
    id                bigserial
        constraint users_pk
            primary key,
    is_blocked        boolean      default false,
    blocked_until     timestamp    default '0001-01-01 00:00:00'::timestamp without time zone,
    language          varchar(53)  default 'eng'::character varying,
    registration_date timestamp    default '0001-01-01 00:00:00'::timestamp without time zone,
    last_entry        timestamp    default '0001-01-01 00:00:00'::timestamp without time zone,
    nickname          varchar(255)               not null,
    avatar             varchar(525)               not null,
    is_dnd            boolean      default false,
    email             varchar(255),
    bio               varchar(525) default ''::character varying,
    last_activity     timestamp    default '0001-01-01 00:00:00'::timestamp without time zone,
    ip                varchar(255) default ''::character varying,
    merchant          boolean      default false not null
);

create unique index users_id_uindex
    on public.users (id);

create table public.inner_connection
(
    id       bigserial
        constraint inner_connection_pm_pk
            primary key,
    base_url text        not null,
    public   text        not null,
    private  text        not null,
    name     varchar(25) not null,
    test     boolean default false
);

create unique index inner_connection_id_uindex
    on public.inner_connection (id);

create table public.languages
(
    id        serial
        primary key,
    code      varchar(2)            not null,
    language  varchar(30),
    available boolean default false not null
);

create table public.notice
(
    id          bigserial
        constraint notice_pk
            primary key,
    internal_id varchar(255) not null,
    client_id   bigint       not null,
    type        varchar(155) default 'new_order'::character varying,
    is_read     boolean      default false,
    create_time timestamp    default '0001-01-01 00:00:00'::timestamp without time zone
);


create table public.notice_new_order
(
    id                integer,
    amount_to         double precision,
    amount_to_token   varchar(55),
    amount_from       double precision,
    amount_from_token varchar(55),
    nickname          varchar(255)
);

create table public.client_user
(
    id          bigserial
        primary key,
    user_id     bigint        not null,
    client_uuid varchar(255)  not null
);

create table public.nickname_history
(
    id           bigserial,
    client_id    bigint,
    old_nickname varchar(55),
    change_time  timestamp not null
);


create table public.kyc_auth
(
    client_id   bigint not null,
    create_time timestamp,
    auth_kyc    varchar(255),
    is_active   boolean default true
);
