Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 599F9188EEF
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgCQUX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:23:29 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36414 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgCQUX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:23:27 -0400
Received: by mail-pj1-f67.google.com with SMTP id nu11so249825pjb.1
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 13:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zSe8rWeFlsZU0i7SSuhjlg2s06lvOZ+QgAEbRnXRKCw=;
        b=L9OCTGRmtGM0cSyfUndXTADSKHCyCWwkd8y+0Iq1lernFN6S/gSBxFugqQCSM3a41w
         Hbws/X3PlJembs2iaA/CtPF9h3RDr2QAQlu0p0DPMfpKUF1OLPx5ZBh1s0+QBY3G4sHl
         PxZvzJ7TCTYRkl345izjxFZUqQWGq+Mg5DsjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zSe8rWeFlsZU0i7SSuhjlg2s06lvOZ+QgAEbRnXRKCw=;
        b=fNSd1zXAB9u1syU3RI0R1e63sDDEyha9Eu1n0gX+/CHRVRXeMtnt7Q0KmSdune79cV
         pctrm8ucOCsaW66wTG2boBmJqhM8o7xixO+eiEYHbqUrRRZuOvyv1cOMYpCFSIijl2jT
         MNAM5hAYDJqp+QQFpf2lD3FHW+gwHP2e+AYabl/Lb2Whdlv0QRMVBzZQUErGYD17onmX
         93tpLYmDB5yYEPfUSCHEnoFLWipd6gBZeXpdYYZDORpyYDQOz7qHdtji6ABUp+vpxgLc
         cvtMX+lKTbwdsJVzMF3AVKG0BdFmXSsvfn5lH1x4KJQYZQGgJz5FzzKWT6GOgXB0O/jE
         iKGQ==
X-Gm-Message-State: ANhLgQ2N/+NrLUs9GJBNG+YU6vywlTB1e30pMJN6Acm23EW9Mj4uyzsx
        6RRkbYkAQKm40jNsj8DjiPeBSw==
X-Google-Smtp-Source: ADFU+vv3DNRu8Nu5EhpiP8v6utskBwT0IOzS4pn9YJ+qbpl6DgviLHuFEBc0pWxb6jnlHg7nOiuKZA==
X-Received: by 2002:a17:90a:bf0b:: with SMTP id c11mr1079314pjs.28.1584476604873;
        Tue, 17 Mar 2020 13:23:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h4sm3971934pfg.177.2020.03.17.13.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 13:23:24 -0700 (PDT)
Date:   Tue, 17 Mar 2020 13:23:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v3 3/6] kselftest: create fixture objects
Message-ID: <202003171323.7A18C455@keescook>
References: <20200316225647.3129354-1-kuba@kernel.org>
 <20200316225647.3129354-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316225647.3129354-4-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 03:56:43PM -0700, Jakub Kicinski wrote:
> Grouping tests by fixture will allow us to parametrize
> test runs. Create full objects for fixtures.
> 
> Add a "global" fixture for tests without a fixture.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  tools/testing/selftests/kselftest_harness.h | 46 ++++++++++++++++-----
>  1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> index aaf58fffc8f7..0f68943d6f04 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -169,8 +169,10 @@
>  #define __TEST_IMPL(test_name, _signal) \
>  	static void test_name(struct __test_metadata *_metadata); \
>  	static struct __test_metadata _##test_name##_object = \
> -		{ .name = "global." #test_name, \
> -		  .fn = &test_name, .termsig = _signal, \
> +		{ .name = #test_name, \
> +		  .fn = &test_name, \
> +		  .fixture = &_fixture_global, \
> +		  .termsig = _signal, \
>  		  .timeout = TEST_TIMEOUT_DEFAULT, }; \
>  	static void __attribute__((constructor)) _register_##test_name(void) \
>  	{ \
> @@ -212,10 +214,12 @@
>   * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
>   */
>  #define FIXTURE(fixture_name) \
> +	static struct __fixture_metadata _##fixture_name##_fixture_object = \
> +		{ .name =  #fixture_name, }; \
>  	static void __attribute__((constructor)) \
>  	_register_##fixture_name##_data(void) \
>  	{ \
> -		__fixture_count++; \
> +		__register_fixture(&_##fixture_name##_fixture_object); \
>  	} \
>  	FIXTURE_DATA(fixture_name)
>  
> @@ -309,8 +313,9 @@
>  	} \
>  	static struct __test_metadata \
>  		      _##fixture_name##_##test_name##_object = { \
> -		.name = #fixture_name "." #test_name, \
> +		.name = #test_name, \
>  		.fn = &wrapper_##fixture_name##_##test_name, \
> +		.fixture = &_##fixture_name##_fixture_object, \
>  		.termsig = signal, \
>  		.timeout = tmout, \
>  	 }; \
> @@ -654,10 +659,33 @@
>  	} \
>  }
>  
> +/* Contains all the information about a fixture */
> +struct __fixture_metadata {
> +	const char *name;
> +	struct __fixture_metadata *prev, *next;
> +} _fixture_global __attribute__((unused)) = {
> +	.name = "global",
> +	.prev = &_fixture_global,
> +};
> +
> +static struct __fixture_metadata *__fixture_list = &_fixture_global;
> +static unsigned int __fixture_count;
> +static int __constructor_order;
> +
> +#define _CONSTRUCTOR_ORDER_FORWARD   1
> +#define _CONSTRUCTOR_ORDER_BACKWARD -1
> +
> +static inline void __register_fixture(struct __fixture_metadata *f)
> +{
> +	__fixture_count++;
> +	__LIST_APPEND(__fixture_list, f);
> +}
> +
>  /* Contains all the information for test execution and status checking. */
>  struct __test_metadata {
>  	const char *name;
>  	void (*fn)(struct __test_metadata *);
> +	struct __fixture_metadata *fixture;
>  	int termsig;
>  	int passed;
>  	int trigger; /* extra handler after the evaluation */
> @@ -670,11 +698,6 @@ struct __test_metadata {
>  /* Storage for the (global) tests to be run. */
>  static struct __test_metadata *__test_list;
>  static unsigned int __test_count;
> -static unsigned int __fixture_count;
> -static int __constructor_order;
> -
> -#define _CONSTRUCTOR_ORDER_FORWARD   1
> -#define _CONSTRUCTOR_ORDER_BACKWARD -1
>  
>  /*
>   * Since constructors are called in reverse order, reverse the test
> @@ -708,7 +731,7 @@ void __run_test(struct __test_metadata *t)
>  
>  	t->passed = 1;
>  	t->trigger = 0;
> -	printf("[ RUN      ] %s\n", t->name);
> +	printf("[ RUN      ] %s.%s\n", t->fixture->name, t->name);
>  	alarm(t->timeout);
>  	child_pid = fork();
>  	if (child_pid < 0) {
> @@ -757,7 +780,8 @@ void __run_test(struct __test_metadata *t)
>  				status);
>  		}
>  	}
> -	printf("[     %4s ] %s\n", (t->passed ? "OK" : "FAIL"), t->name);
> +	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
> +	       t->fixture->name, t->name);
>  	alarm(0);
>  }
>  
> -- 
> 2.24.1
> 

-- 
Kees Cook
