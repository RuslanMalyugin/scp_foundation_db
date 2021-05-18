DROP SCHEMA IF EXISTS scpfoundation CASCADE;
CREATE SCHEMA scpfoundation;

---Основные таблички---
DROP TABLE IF EXISTS scpfoundation.daily_log;
CREATE TABLE scpfoundation.daily_log
(
    daily_log_id integer   NOT NULL UNIQUE PRIMARY KEY,
    data_td      timestamp NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.current_state_log;
CREATE TABLE scpfoundation.current_state_log
(
    current_state_log_id integer NOT NULL UNIQUE PRIMARY KEY,
    object_id            integer NOT NULL,
    zone_id              integer NOT NULL,
    state_desc           text    NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.experiment_log;
CREATE TABLE scpfoundation.experiment_log
(
    experiment_log_id integer NOT NULL UNIQUE PRIMARY KEY,
    reason_txt        text    NOT NULL,
    zone_id           integer NOT NULL,
    resources_txt     text,
    result_dsc        text    NOT NULL,
    experiment_dsc    text    NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.contaiment_breach_log;
CREATE TABLE scpfoundation.contaiment_breach_log
(
    contaiment_breach_log_id integer NOT NULL UNIQUE PRIMARY KEY,
    experiment_dsc           text    NOT NULL,
    zone_id                  integer NOT NULL,
    victims_nm               text,
    damage_dsc               text
);

DROP TABLE IF EXISTS scpfoundation.zone;
CREATE TABLE scpfoundation.zone
(
    zone_id      integer      NOT NULL UNIQUE PRIMARY KEY,
    name_nm      varchar(255) NOT NULL,
    class_code   varchar(255) NOT NULL,
    purpose_dsc  text,
    location_dsc text         NOT NULL,
    zone_dsc     text,
    annex_dsc    text
);

DROP TABLE IF EXISTS scpfoundation.object;
CREATE TABLE scpfoundation.object
(
    object_id                  integer      NOT NULL UNIQUE PRIMARY KEY,
    object_nm                  varchar(255) NOT NULL,
    object_class_code          varchar(255) NOT NULL,
    containment_procedures_dsc text         NOT NULL,
    description_dsc            text,
    annex_dsc                  text
);

DROP TABLE IF EXISTS scpfoundation.employee;
CREATE TABLE scpfoundation.employee
(
    employee_id       integer      NOT NULL UNIQUE PRIMARY KEY,
    name_nm           varchar(255) NOT NULL,
    birth_dt          timestamp    NOT NULL,
    sex_value         varchar(255) NOT NULL,
    position_nm       varchar(255) NOT NULL,
    education_dsc     text,
    specialization_nm text,
    access_level_code integer NOT NULL,
    biography_dsc     text,
    annex_dsc         text
);


---Промежуточные таблички---

DROP TABLE IF EXISTS scpfoundation.experiment_log_x_daily_log;
CREATE TABLE scpfoundation.experiment_log_x_daily_log
(
    daily_log_id      integer NOT NULL,
    experiment_log_id integer NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.contaiment_breach_log_x_daily_log;
CREATE TABLE scpfoundation.contaiment_breach_log_x_daily_log
(
    daily_log_id             integer NOT NULL,
    contaiment_breach_log_id integer NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.current_state_log_x_daily_log;
CREATE TABLE scpfoundation.current_state_log_x_daily_log
(
    current_state_log_id integer NOT NULL,
    daily_log_id         integer NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.experiment_log_x_employee;
CREATE TABLE scpfoundation.experiment_log_x_employee
(
    experiment_log_id integer NOT NULL,
    employee_id       integer NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.experiment_log_x_object;
CREATE TABLE scpfoundation.experiment_log_x_object
(
    experiment_log_id integer NOT NULL,
    object_id         integer NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.contaiment_breach_log_x_object;
CREATE TABLE scpfoundation.contaiment_breach_log_x_object
(
    object_id                integer NOT NULL,
    contaiment_breach_log_id integer NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.contaiment_breach_log_x_employee;
CREATE TABLE scpfoundation.contaiment_breach_log_x_employee
(
    employee_id              integer NOT NULL,
    contaiment_breach_log_id integer NOT NULL
);

DROP TABLE IF EXISTS scpfoundation.current_state_log_x_employee;
CREATE TABLE scpfoundation.current_state_log_x_employee
(
    employee_id          integer NOT NULL,
    current_state_log_id integer NOT NULL
);


---Вставка данных---
---Изначально наберем сотрудников штат, добавим объекты и зоны и на основе этого будем добавлять отчеты по ним---

INSERT INTO scpfoundation.employee (employee_id, name_nm, birth_dt, sex_value, position_nm, education_dsc,
                                  specialization_nm, access_level_code, biography_dsc)
VALUES (1, 'Kondraki', '19.02.1978', 'man', 'Doctor', 'Doctor of Biological Sciences in Chicago University',
        'work with botany', 4, 'Some bio'),
       (2, 'Cleff', '28.11.1976', 'man', 'Doctor', NULL, 'working with meme-active objects', 4, 'Some bio'),
       (3, 'Bright', '09.08.1876', 'man', 'Doctor', NULL, 'bioengineering and genetics', 5, 'Some bio');

---Объекты - самое интересное, поэтому у них я сразу добавил описание---
INSERT INTO scpfoundation.object (object_id, object_nm, object_class_code, containment_procedures_dsc, description_dsc,
                                  annex_dsc)
VALUES (682, 'Hard-to-Destroy Reptile', 'Keter',
        'SCP-682 must be destroyed as soon as possible. At this time, no means available to SCP teams are capable of destroying SCP-682, only able to cause massive physical damage. SCP-682 should be contained within a 5 m x 5 m x 5 m chamber with 25 cm reinforced acid-resistant steel plate lining all inside surfaces. The containment chamber should be filled with hydrochloric acid until SCP-682 is submerged and incapacitated. Any attempts of SCP-682 to move, speak, or breach containment should be reacted to quickly and with full force as called for by the circumstances.
        Personnel are forbidden to speak to SCP-682, for fear of provoking a rage-state. All unauthorized personnel attempting to communicate to SCP-682 will be restrained and removed by force.
        Due to its frequent attempts at containment breach, difficulty of containment and incapacitation, and high threat of Foundation Exposure, SCP-682 is to be contained in site [REDACTED]. The Foundation will use the best of its resources to maintain all land within fifty (50) kilometers clear of human development.',
        'SCP-682 is a large, vaguely reptile-like creature of unknown origin. It appears to be extremely intelligent, and was observed to engage in complex communication with SCP-079 during their limited time of exposure. SCP-682 appears to have a hatred of all life, which has been expressed in several interviews during containment. (See Addendum 682-B).
        SCP-682 has always been observed to have extremely high strength, speed, and reflexes, though exact levels vary with its form. SCP-682''s physical body grows and changes very quickly, growing or decreasing in size as it consumes or sheds material. SCP-682 gains energy from anything it ingests, organic or inorganic. Digestion seems to be aided by a set of filtering gills inside of SCP-682''s nostrils, which are able to remove usable matter from any liquid solution, enabling it to constantly regenerate from the acid it is contained in. SCP-682''s regenerative capabilities and resilience are staggering, and SCP-682 has been seen moving and speaking with its body 87% destroyed or rotted.
        In case of containment breach, SCP-682 is to be tracked and re-captured by all available Mobile Task Forces, and no teams with fewer than seven (7) members are cleared to engage it. To date (██-██-████), attempted breaches have numbered at seventeen (17), while successful breaches have numbered at six (6). (See Addendum 682-D).
        ', NULL),
       (096, 'The "Shy Guy"', 'Euclid',
        'SCP-096 is to be contained in its cell, a 5 m x 5 m x 5 m airtight steel cube, at all times. Weekly checks for any cracks or holes are mandatory. There are to be absolutely no video surveillance or optical tools of any kind inside SCP-096''s cell. Security personnel will use pre-installed pressure sensors and laser detectors to ensure SCP-096''s presence inside the cell.
        Any and all photos, video, or recordings of SCP-096''s likeness are strictly forbidden without approval from Dr. ███ and O5-█.',
        'SCP-096 is a humanoid creature measuring approximately 2.38 meters in height. Subject shows very little muscle mass, with preliminary analysis of body mass suggesting mild malnutrition. Arms are grossly out of proportion with the rest of the subject''s body, with an approximate length of 1.5 meters each. Skin is mostly devoid of pigmentation, with no sign of any body hair.
        SCP-096''s jaw can open to four (4) times the norm of an average human. Other facial features remain similar to an average human, with the exception of the eyes, which are also devoid of pigmentation. It is not yet known whether SCP-096 is blind or not. It shows no signs of any higher brain functions, and is not considered to be sapient.
        SCP-096 is normally extremely docile, with pressure sensors inside its cell indicating it spends most of the day pacing by the eastern wall. However, when someone views SCP-096''s face, whether it be directly, via video recording, or even a photograph, it will enter a stage of considerable emotional distress. SCP-096 will cover its face with its hands and begin screaming, crying, and babbling incoherently. Approximately one (1) to two (2) minutes after the first viewing, SCP-096 will begin running to the person who viewed its face (who will from this point on be referred to as SCP-096-1).
        Documented speeds have varied from thirty-five (35) km/h to ███ km/h, and seems to depend on distance from SCP-096-1. At this point, no known material or method can impede SCP-096''s progress. The actual position of SCP-096-1 does not seem to affect SCP-096''s response; it seems to have an innate sense of SCP-096-1''s location. Note: This reaction does not occur when viewing artistic depictions (see Document 096-1).
        Upon arriving at SCP-096-1''s location, SCP-096 will proceed to kill and [DATA EXPUNGED] SCP-096-1. 100% of cases have left no traces of SCP-096-1. SCP-096 will then sit down for several minutes before regaining its composure and becoming docile once again. It will then attempt to make its way back to its natural habitat, [DATA REDACTED]
        Due to the possibility of a mass chain reaction, including breach of Foundation secrecy and large civilian loss of life, retrieval of subject should be considered Alpha priority.
        Dr. ███ has also petitioned for immediate termination of SCP-096 (see Interview 096-1). Order is awaiting approval. Termination order has been approved, and is to be carried out by Dr. ███ on [DATA REDACTED]. See Incident-096-1-A.',
        NULL),
       (173, 'The Sculpture', 'Euclid',
        'Item SCP-173 is to be kept in a locked container at all times. When personnel must enter SCP-173''s container, no fewer than 3 may enter at any time and the door is to be relocked behind them. At all times, two persons must maintain direct eye contact with SCP-173 until all personnel have vacated and relocked the container.',
        'Moved to Site-19 1993. Origin is as of yet unknown. It is constructed from concrete and rebar with traces of Krylon brand spray paint. SCP-173 is animate and extremely hostile. The object cannot move while within a direct line of sight. Line of sight must not be broken at any time with SCP-173. Personnel assigned to enter container are instructed to alert one another before blinking. Object is reported to attack by snapping the neck at the base of the skull, or by strangulation. In the event of an attack, personnel are to observe Class 4 hazardous object containment procedures.
        Personnel report sounds of scraping stone originating from within the container when no one is present inside. This is considered normal, and any change in this behaviour should be reported to the acting HMCL supervisor on duty.
        The reddish brown substance on the floor is a combination of feces and blood. Origin of these materials is unknown. The enclosure must be cleaned on a bi-weekly basis.',
        NULL);

INSERT INTO scpfoundation.zone (zone_id, name_nm, class_code, purpose_dsc, location_dsc, zone_dsc)
VALUES (19, 'Alpha-USA', 'Yellow', 'Researching, containing Euclids and Safes', 'North America', 'some description'),
       (45, 'Factory', 'Green', 'Meeting the needs of the foundation through production with abnormal technologies',
        'Russia', 'some description'),
       (113, 'Pandora box', 'Red', 'Containing Keters and some dangerous Euclids', 'Pacific ocean', 'some description');

---Вставим ежедневный отчет---
---Допустим сегодня относительно спокойный день и мы просто составили отчет о состоянии объекта 173---
---Все это происходило в зоне 19, с доктором Клефом---

INSERT INTO scpfoundation.daily_log(daily_log_id, data_td)
VALUES (1, '22.03.2021');
INSERT INTO scpfoundation.current_state_log_x_daily_log(current_state_log_id, daily_log_id)
VALUES (1, 1);
INSERT INTO scpfoundation.current_state_log(current_state_log_id, object_id, zone_id, state_desc)
VALUES (1, 173, 19, 'Normal...');
INSERT INTO scpfoundation.current_state_log_x_employee
VALUES (2, 1);

---Вставим один эксперимент---
---Допустим он произошел все-же сегодня)---
INSERT INTO scpfoundation.experiment_log_x_daily_log(daily_log_id, experiment_log_id)
VALUES (1, 1);
INSERT INTO scpfoundation.experiment_log(experiment_log_id, reason_txt, zone_id, resources_txt, result_dsc,
                                         experiment_dsc)
VALUES (1, 'Who will win 096 or 682 in fight?', 113, NULL,
        '096 sits and cries in the corner, 682 lost 70% of body mass', 'some description...');
INSERT INTO scpfoundation.experiment_log_x_object(experiment_log_id, object_id)
VALUES (1, 096),
       (1, 682);
INSERT INTO scpfoundation.experiment_log_x_employee
VALUES (1, 3);


---Напишем несколько запросов---
---Достанем всех кетеров из базы---
SELECT object_id, object_nm
FROM scpfoundation.object
WHERE object_class_code = 'Keter';

---Сколько раз кетеры нарушали условия содержания в зоне 19---

SELECT count(cbl.contaiment_breach_log_id)
FROM scpfoundation.contaiment_breach_log  cbl join scpfoundation.contaiment_breach_log_x_object cblo on cbl.contaiment_breach_log_id = cblo.contaiment_breach_log_id
join scpfoundation.object o on o.object_id = cblo.object_id
WHERE o.object_class_code = 'Keter';

---Самый молодой сотрудник с максимальным уровнем доступа---
SELECT name_nm, birth_dt
FROM scpfoundation.employee e
WHERE e.access_level_code = (select max(access_level_code) as mx from scpfoundation.employee)
GROUP BY name_nm, birth_dt
HAVING min(birth_dt) = birth_dt;

---Сколько сотрудников с каждым уровнем доступа---
SELECT access_level_code, count(employee_id) as cnt
FROM scpfoundation.employee e
GROUP BY access_level_code;

---Аналогично можно с объектами---
SELECT object_class_code, count(object_class_code) as cnt
FROM scpfoundation.object o
GROUP BY object_class_code;
