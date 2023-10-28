BEGIN

CREATE TYPE order_status_enum AS ENUM (
    'processing',
    'shipping',
    'completed',
    'canceled'
);

CREATE TYPE ranking_type AS ENUM (
    'admin',
    'quest'
);

CREATE TABLE addresses (
    addresses_id SERIAL PRIMARY KEY,
    addresses_user_id integer,
    addresses_adress character varying(120),
    CONSTRAINT fk_addresses_user FOREIGN KEY (adresses_user_id) 
               REFERENCES "user"(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE brand (
    brand_id SERIAL PRIMARY KEY,
    brand_name character varying(50)
);

CREATE TABLE cart_items (
    cart_items_product_variant_id integer NOT NULL,
    cart_items_user_id integer NOT NULL,
    cart_items_quantity integer,
    PRIMARY KEY (cart_items_product_variant_id, cart_items_user_id),
    CONSTRAINT fk_cart_items_product FOREIGN KEY (cart_items_product_variant_id)
    	REFERENCES product_variant (product_variant_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_user FOREIGN KEY (cart_items_user_id)
    	REFERENCES "user"(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE category
(
    category_id SERIAL PRIMARY KEY,
    category_parent_category_id integer,
    category_name character varying(50),
    CONSTRAINT unq_category_name UNIQUE (category_name),
    CONSTRAINT fk_category_category FOREIGN KEY (category_parent_category_id)
        REFERENCES category (category_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE color
(
    color_id SERIAL PRIMARY KEY,
    color_name character varying(50),
    CONSTRAINT unq_color_name UNIQUE (color_name)
);

CREATE TABLE size
(
    size_id integer SERIAL PRIMARY KEY,
    size_name character varying(50),
    CONSTRAINT unq_size_name UNIQUE (size_name)
)

CREATE TABLE media
(
    media_id SERIAL PRIMARY KEY,
    media_product_id integer,
    media_bytes bytea,
    media_file_type character varying(50) COLLATE pg_catalog."default",
    media_file_name character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT pk_media PRIMARY KEY (media_id),
    CONSTRAINT unq_media_file_type_name UNIQUE (media_file_name),
    CONSTRAINT fk_media_product FOREIGN KEY (media_product_id)
        REFERENCES product (product_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "order"
(
    order_id SERIAL PRIMARY KEY,
    order_user_id integer,
    order_price money,
    order_address_id integer,
    order_created_at timestamp without time zone,
    order_status order_status_enum,
    CONSTRAINT fk_order_address FOREIGN KEY (order_address_id)
	REFERENCES addresses (addresses_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_user FOREIGN KEY (order_user_id)
        REFERENCES "user" (user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE order_items
(
    order_items_product_variant_id integer NOT NULL,
    order_items_order_id integer NOT NULL,
    order_items_quantity integer,
    PRIMARY KEY (order_items_product_variant_id, order_items_order_id),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_items_order_id)
        REFERENCES "order" (order_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product_variant FOREIGN KEY (order_items_product_variant_id)
        REFERENCES product_variant (product_variant_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE order_transactions
(
    order_transactions_order_id integer NOT NULL,
    order_transactions_status order_status_enum NOT NULL,
    order_transactions_updated_at timestamp,
    PRIMARY KEY (order_transactions_order_id, order_transactions_status),
    CONSTRAINT fk_order_transactions_order FOREIGN KEY (order_transactions_order_id)
        REFERENCES "order" (order_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX by_order_and_status ON order_transactions 
    (
	order_transactions_status, 
	order_transactions_order_id
    );

CREATE TABLE product
(
    product_id SERIAL PRIMARY KEY
    product_brand_id integer,
    product_category_id integer,
    product_name character varying(50),
    product_price money,
    product_average_rating numeric(3,2),
    CONSTRAINT unq_p_name UNIQUE (product_name),
    CONSTRAINT fk_product_brand FOREIGN KEY (product_brand_id)
        REFERENCES brand (brand_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_category FOREIGN KEY (product_category_id)
        REFERENCES category (category_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX products_by_brand_and_category ON product
(
	product_brand_id,
	product_category_id
);

CREATE TABLE product_variant
(
    product_variant_id SERIAL PRIMARY KEY,
    product_variant_color_id integer,
    product_variant_size_id integer,
    product_variant_product_id integer,
    product_variant_quantity integer,
    product_variant_sku character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT unq_product_variant_sku UNIQUE (product_variant_sku),
    CONSTRAINT fk_product_variant_color FOREIGN KEY (product_variant_color_id)
        REFERENCES color (color_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_variant_product FOREIGN KEY (product_variant_product_id)
        REFERENCES product (product_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_variant_size FOREIGN KEY (product_variant_size_id)
        REFERENCES size (size_id) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE review
(
    review_id SERIAL PRIMARY KEY,
    review_product_id integer,
    review_user_id integer,
    review_raiting integer,
    review_title character varying(50),
    review_comment character varying(2000),
    review_created_at timestamp,
    CONSTRAINT fk_review_product FOREIGN KEY (review_product_id)
        REFERENCES product (product_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (review_user_id)
        REFERENCES "user" (user_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX review_by_product_and_rating ON review 
(
	review_product_id, 
	review_raiting 
);

CREATE TABLE section
(
    section_id SERIAL PRIMARY KEY,
    section_name character varying(50),
    CONSTRAINT unq_sections_name UNIQUE (section_name)
);

CREATE TABLE section_category
(
    section_category_category_id integer NOT NULL,
    section_category_section_id integer NOT NULL,
    CONSTRAINT pk_section_category PRIMARY KEY 
	(section_category_category_id, section_category_section_id),
    CONSTRAINT fk_section_category_category FOREIGN KEY (section_category_category_id)
        REFERENCES category (category_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_section_category_section FOREIGN KEY (section_category_section_id)
        REFERENCES section (section_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE "user"
(
    user_id SERIAL PRIMARY KEY,
    user_type ranking_type,
    user_email character varying(50),
    user_password character varying(100),
    user_phone character varying(50),
    user_first_name character varying(50),
    user_last_name character varying(50),
    CONSTRAINT unq_user_email_phone UNIQUE (user_phone, user_email)
);


