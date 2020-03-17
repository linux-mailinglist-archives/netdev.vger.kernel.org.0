Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA77188F17
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgCQUh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:37:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46910 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgCQUh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:37:29 -0400
Received: by mail-pf1-f196.google.com with SMTP id c19so12580366pfo.13
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 13:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ia3F2HvTleBUd5k0glVvssWumV1C7B/usfl4j8ziVTk=;
        b=VhA6UQpxRprIfMALPyddXrkODXZ1mLdlDqeNGMb/3XLpomhqvXD/+V+AruOkekOaF1
         ejFlvWGOo7GdRrpAASBGuJFIbWqayHNGCIpceSescVLPpHaGkP4C9LXseHm2+vBBHXw4
         Hqp9Hka0S/2cM5QLCYK7oVtsa/KWy84dn77Mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ia3F2HvTleBUd5k0glVvssWumV1C7B/usfl4j8ziVTk=;
        b=btTGCNpEAWMN/AQTSnSies6e/HWEndPqN6y94YOgiuyLZl0rxJH74542BaLD2/PEfb
         95aZeJebTBL7PEjdaxTP2UJUAuJNBFbUa/usMPiOqpawsjvzEsXqLyCgj97f9FhHndK+
         9yfUGDKU8+uUC9iptz/R124QWRwlSe4Gb8vy3CnhBkaKsJVESo3YZy0LO0tfFfuEdKRQ
         H4Lmr8PQZWOfXcROUGQa8pxbO09hj8Ja6Gv/8+3D+9wHmOe1osVIBsQZ0dcfLf2X7P1U
         mpRYZDzhA/HMQRx+GUVfeAF2wCFa0cdWXvlk1CI/FtoBTx6EfWdsSZeHD6AmUGiF5e3G
         M0Tg==
X-Gm-Message-State: ANhLgQ1MfJJiH3j/KSJKmP4ZZvlYR6HEmalR2hNqdpfqI0TkfbA6DLJT
        gaILxAoox79ZqcFiKgMd922raw==
X-Google-Smtp-Source: ADFU+vubc5WMN81vQ0fe8aciie9n6/qdhF8awX9OBaYM/+OhP6oVuSINpp+M/RKBOM/oxWdetcPIUQ==
X-Received: by 2002:a63:8b42:: with SMTP id j63mr953821pge.27.1584477447536;
        Tue, 17 Mar 2020 13:37:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 72sm3509508pgd.86.2020.03.17.13.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 13:37:26 -0700 (PDT)
Date:   Tue, 17 Mar 2020 13:37:25 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v3 5/6] kselftest: add fixture variants
Message-ID: <202003171337.900705E@keescook>
References: <20200316225647.3129354-1-kuba@kernel.org>
 <20200316225647.3129354-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316225647.3129354-7-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3.1 ;) My suggestions stand for the expansion of this commit log,
though. :)

-Kees

On Mon, Mar 16, 2020 at 03:56:46PM -0700, Jakub Kicinski wrote:
> Allow users to pass parameters to fixtures.
> 
> Each fixture will be evaluated for each of its variants.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> v3:
>  - separate variant name out with a dot;
>  - count variants as "cases" in the opening print.
> ---
>  Documentation/dev-tools/kselftest.rst       |   3 +-
>  tools/testing/selftests/kselftest_harness.h | 145 ++++++++++++++++----
>  2 files changed, 121 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
> index 61ae13c44f91..5d1f56fcd2e7 100644
> --- a/Documentation/dev-tools/kselftest.rst
> +++ b/Documentation/dev-tools/kselftest.rst
> @@ -301,7 +301,8 @@ Helpers
>  
>  .. kernel-doc:: tools/testing/selftests/kselftest_harness.h
>      :functions: TH_LOG TEST TEST_SIGNAL FIXTURE FIXTURE_DATA FIXTURE_SETUP
> -                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN
> +                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN FIXTURE_VARIANT
> +                FIXTURE_VARIANT_ADD
>  
>  Operators
>  ---------
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> index 36ab1b92eb35..1a079afa2d01 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -168,9 +168,15 @@
>  
>  #define __TEST_IMPL(test_name, _signal) \
>  	static void test_name(struct __test_metadata *_metadata); \
> +	static inline void wrapper_##test_name( \
> +		struct __test_metadata *_metadata, \
> +		struct __fixture_variant_metadata *variant) \
> +	{ \
> +		test_name(_metadata); \
> +	} \
>  	static struct __test_metadata _##test_name##_object = \
>  		{ .name = #test_name, \
> -		  .fn = &test_name, \
> +		  .fn = &wrapper_##test_name, \
>  		  .fixture = &_fixture_global, \
>  		  .termsig = _signal, \
>  		  .timeout = TEST_TIMEOUT_DEFAULT, }; \
> @@ -214,6 +220,7 @@
>   * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
>   */
>  #define FIXTURE(fixture_name) \
> +	FIXTURE_VARIANT(fixture_name); \
>  	static struct __fixture_metadata _##fixture_name##_fixture_object = \
>  		{ .name =  #fixture_name, }; \
>  	static void __attribute__((constructor)) \
> @@ -245,7 +252,9 @@
>  #define FIXTURE_SETUP(fixture_name) \
>  	void fixture_name##_setup( \
>  		struct __test_metadata __attribute__((unused)) *_metadata, \
> -		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
> +		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
> +		const FIXTURE_VARIANT(fixture_name) __attribute__((unused)) *variant)
> +
>  /**
>   * FIXTURE_TEARDOWN(fixture_name)
>   * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
> @@ -267,6 +276,58 @@
>  		struct __test_metadata __attribute__((unused)) *_metadata, \
>  		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
>  
> +/**
> + * FIXTURE_VARIANT(fixture_name) - Optionally called once per fixture
> + * to declare fixture variant
> + *
> + * @fixture_name: fixture name
> + *
> + * .. code-block:: c
> + *
> + *     FIXTURE_VARIANT(datatype name) {
> + *       type property1;
> + *       ...
> + *     };
> + *
> + * Defines type of constant parameters provided to FIXTURE_SETUP() and TEST_F()
> + * as *variant*. Variants allow the same tests to be run with different
> + * arguments.
> + */
> +#define FIXTURE_VARIANT(fixture_name) struct _fixture_variant_##fixture_name
> +
> +/**
> + * FIXTURE_VARIANT_ADD(fixture_name, variant_name) - Called once per fixture
> + * variant to setup and register the data
> + *
> + * @fixture_name: fixture name
> + * @variant_name: name of the parameter set
> + *
> + * .. code-block:: c
> + *
> + *     FIXTURE_ADD(datatype name) {
> + *       .property1 = val1;
> + *       ...
> + *     };
> + *
> + * Defines a variant of the test fixture, provided to FIXTURE_SETUP() and
> + * TEST_F() as *variant*. Tests of each fixture will be run once for each
> + * variant.
> + */
> +#define FIXTURE_VARIANT_ADD(fixture_name, variant_name) \
> +	extern FIXTURE_VARIANT(fixture_name) \
> +		_##fixture_name##_##variant_name##_variant; \
> +	static struct __fixture_variant_metadata \
> +		_##fixture_name##_##variant_name##_object = \
> +		{ .name = #variant_name, \
> +		  .data = &_##fixture_name##_##variant_name##_variant}; \
> +	static void __attribute__((constructor)) \
> +		_register_##fixture_name##_##variant_name(void) \
> +	{ \
> +		__register_fixture_variant(&_##fixture_name##_fixture_object, \
> +			&_##fixture_name##_##variant_name##_object);	\
> +	} \
> +	FIXTURE_VARIANT(fixture_name) _##fixture_name##_##variant_name##_variant =
> +
>  /**
>   * TEST_F(fixture_name, test_name) - Emits test registration and helpers for
>   * fixture-based test cases
> @@ -297,18 +358,20 @@
>  #define __TEST_F_IMPL(fixture_name, test_name, signal, tmout) \
>  	static void fixture_name##_##test_name( \
>  		struct __test_metadata *_metadata, \
> -		FIXTURE_DATA(fixture_name) *self); \
> +		FIXTURE_DATA(fixture_name) *self, \
> +		const FIXTURE_VARIANT(fixture_name) *variant); \
>  	static inline void wrapper_##fixture_name##_##test_name( \
> -		struct __test_metadata *_metadata) \
> +		struct __test_metadata *_metadata, \
> +		struct __fixture_variant_metadata *variant) \
>  	{ \
>  		/* fixture data is alloced, setup, and torn down per call. */ \
>  		FIXTURE_DATA(fixture_name) self; \
>  		memset(&self, 0, sizeof(FIXTURE_DATA(fixture_name))); \
> -		fixture_name##_setup(_metadata, &self); \
> +		fixture_name##_setup(_metadata, &self, variant->data); \
>  		/* Let setup failure terminate early. */ \
>  		if (!_metadata->passed) \
>  			return; \
> -		fixture_name##_##test_name(_metadata, &self); \
> +		fixture_name##_##test_name(_metadata, &self, variant->data); \
>  		fixture_name##_teardown(_metadata, &self); \
>  	} \
>  	static struct __test_metadata \
> @@ -326,7 +389,8 @@
>  	} \
>  	static void fixture_name##_##test_name( \
>  		struct __test_metadata __attribute__((unused)) *_metadata, \
> -		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
> +		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
> +		const FIXTURE_VARIANT(fixture_name) __attribute__((unused)) *variant)
>  
>  /**
>   * TEST_HARNESS_MAIN - Simple wrapper to run the test harness
> @@ -661,10 +725,12 @@
>  
>  /* Contains all the information about a fixture */
>  struct __test_metadata;
> +struct __fixture_variant_metadata;
>  
>  struct __fixture_metadata {
>  	const char *name;
>  	struct __test_metadata *tests;
> +	struct __fixture_variant_metadata *variant;
>  	struct __fixture_metadata *prev, *next;
>  } _fixture_global __attribute__((unused)) = {
>  	.name = "global",
> @@ -672,7 +738,6 @@ struct __fixture_metadata {
>  };
>  
>  static struct __fixture_metadata *__fixture_list = &_fixture_global;
> -static unsigned int __fixture_count;
>  static int __constructor_order;
>  
>  #define _CONSTRUCTOR_ORDER_FORWARD   1
> @@ -680,14 +745,27 @@ static int __constructor_order;
>  
>  static inline void __register_fixture(struct __fixture_metadata *f)
>  {
> -	__fixture_count++;
>  	__LIST_APPEND(__fixture_list, f);
>  }
>  
> +struct __fixture_variant_metadata {
> +	const char *name;
> +	const void *data;
> +	struct __fixture_variant_metadata *prev, *next;
> +};
> +
> +static inline void
> +__register_fixture_variant(struct __fixture_metadata *f,
> +			  struct __fixture_variant_metadata *variant)
> +{
> +	__LIST_APPEND(f->variant, variant);
> +}
> +
>  /* Contains all the information for test execution and status checking. */
>  struct __test_metadata {
>  	const char *name;
> -	void (*fn)(struct __test_metadata *);
> +	void (*fn)(struct __test_metadata *,
> +		   struct __fixture_variant_metadata *);
>  	struct __fixture_metadata *fixture;
>  	int termsig;
>  	int passed;
> @@ -698,9 +776,6 @@ struct __test_metadata {
>  	struct __test_metadata *prev, *next;
>  };
>  
> -/* Storage for the (global) tests to be run. */
> -static unsigned int __test_count;
> -
>  /*
>   * Since constructors are called in reverse order, reverse the test
>   * list so tests are run in source declaration order.
> @@ -714,7 +789,6 @@ static inline void __register_test(struct __test_metadata *t)
>  {
>  	struct __fixture_metadata *f = t->fixture;
>  
> -	__test_count++;
>  	__LIST_APPEND(f->tests, t);
>  }
>  
> @@ -729,21 +803,27 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
>  }
>  
>  void __run_test(struct __fixture_metadata *f,
> +		struct __fixture_variant_metadata *variant,
>  		struct __test_metadata *t)
>  {
>  	pid_t child_pid;
>  	int status;
>  
> +	/* reset test struct */
>  	t->passed = 1;
>  	t->trigger = 0;
> -	printf("[ RUN      ] %s.%s\n", f->name, t->name);
> +	t->step = 0;
> +	t->no_print = 0;
> +
> +	printf("[ RUN      ] %s%s%s.%s\n",
> +	       f->name, variant->name[0] ? "." : "", variant->name, t->name);
>  	alarm(t->timeout);
>  	child_pid = fork();
>  	if (child_pid < 0) {
>  		printf("ERROR SPAWNING TEST CHILD\n");
>  		t->passed = 0;
>  	} else if (child_pid == 0) {
> -		t->fn(t);
> +		t->fn(t, variant);
>  		/* return the step that failed or 0 */
>  		_exit(t->passed ? 0 : t->step);
>  	} else {
> @@ -785,31 +865,44 @@ void __run_test(struct __fixture_metadata *f,
>  				status);
>  		}
>  	}
> -	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
> -	       f->name, t->name);
> +	printf("[     %4s ] %s%s%s.%s\n", (t->passed ? "OK" : "FAIL"),
> +	       f->name, variant->name[0] ? "." : "", variant->name, t->name);
>  	alarm(0);
>  }
>  
>  static int test_harness_run(int __attribute__((unused)) argc,
>  			    char __attribute__((unused)) **argv)
>  {
> +	struct __fixture_variant_metadata no_variant = { .name = "", };
> +	struct __fixture_variant_metadata *v;
>  	struct __fixture_metadata *f;
>  	struct __test_metadata *t;
>  	int ret = 0;
> +	unsigned int case_count = 0, test_count = 0;
>  	unsigned int count = 0;
>  	unsigned int pass_count = 0;
>  
> +	for (f = __fixture_list; f; f = f->next) {
> +		for (v = f->variant ?: &no_variant; v; v = v->next) {
> +			case_count++;
> +			for (t = f->tests; t; t = t->next)
> +				test_count++;
> +		}
> +	}
> +
>  	/* TODO(wad) add optional arguments similar to gtest. */
>  	printf("[==========] Running %u tests from %u test cases.\n",
> -	       __test_count, __fixture_count + 1);
> +	       test_count, case_count);
>  	for (f = __fixture_list; f; f = f->next) {
> -		for (t = f->tests; t; t = t->next) {
> -			count++;
> -			__run_test(f, t);
> -			if (t->passed)
> -				pass_count++;
> -			else
> -				ret = 1;
> +		for (v = f->variant ?: &no_variant; v; v = v->next) {
> +			for (t = f->tests; t; t = t->next) {
> +				count++;
> +				__run_test(f, v, t);
> +				if (t->passed)
> +					pass_count++;
> +				else
> +					ret = 1;
> +			}
>  		}
>  	}
>  	printf("[==========] %u / %u tests passed.\n", pass_count, count);
> -- 
> 2.24.1
> 

-- 
Kees Cook
