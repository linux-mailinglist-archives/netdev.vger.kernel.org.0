Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5567736B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfGZVZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:25:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45780 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbfGZVZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:25:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so25325007pgp.12
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 14:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LekkghtlH5FinA+DVS2eRfWC67+I3bndZnDiQBCuUPc=;
        b=zCYWxn7KxFaU0faZkK/mK3QZOLUFygPML+d+uzotHRxoLM7/9c+VNuv8Vgspe62/KW
         usF1k6/kKGUtTTt2fR7cWZcRCjK09VI+SU6npfRycoVAEs7yFHqhzC07MeF2hLCNdsub
         htRyuDFyshJYgpGxY7FpC8k6TuQcVyty2a4l6WHz9n2IiMpsffd7I23hxrSYTP52m2Z8
         mmsUpQTx+hk7sFfGYQPngsPot6cRdiRpY42rC138R8CqcMJvsqhhsfmHOPcaGFUv9zhJ
         3HttcgU99063wxmfyr7iur6LT12zp20POmJy4xzWcdPZEQTU7Y4bwscosMPuetp86MvD
         NDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LekkghtlH5FinA+DVS2eRfWC67+I3bndZnDiQBCuUPc=;
        b=R8XQp09jGc/Vb04/SU/WMtmnIKDX93aO1VTO05KPwq3bFlOi+2fwH0WHchx1IwsnCv
         Gnh5dtM5mFGPi9NmpaKk0fxCVSubP+mu2x6RQmTBiyAXJGJjmQzx/m6qrMaiRKOK9olp
         1mIX8pwxVY1DrtXmRMsXuVSHqmhSo9NoT2bQLc0GkEGrC3QqsQrqkXqmHJkWQteOjmdi
         fWPH/mb6clOk2zE9Ns1UMgdAkRwR6hYe9lfq83EBdW2N84M8jT2/YFtQgaESwthjYAbq
         cBGOvOxh2IvCNn8S44EYH5iPeigOe71Finq97vnNkCIUp4Th/myduDxH3ST6LWSMYbTk
         mfUA==
X-Gm-Message-State: APjAAAUWhXXpKceSRmYwSPxmwpbjwxRQdhd80nxFo+bJRd3zJwZWnkln
        18mloN1SyGkV9apm00gWuuzx4N8U
X-Google-Smtp-Source: APXvYqyo4DOiONwY5o1vr2YAOCJv8E+jLqVrwDcKSWelapx6OfkM56yi6ZFGij+6DA3eK/G4j8tsiQ==
X-Received: by 2002:aa7:8acb:: with SMTP id b11mr23527596pfd.109.1564176349747;
        Fri, 26 Jul 2019 14:25:49 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id j6sm40127452pfa.141.2019.07.26.14.25.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 14:25:48 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:25:47 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/9] selftests/bpf: add test selectors by number
 and name to test_progs
Message-ID: <20190726212547.GB24397@mini-arch>
References: <20190726203747.1124677-1-andriin@fb.com>
 <20190726203747.1124677-4-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726203747.1124677-4-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/26, Andrii Nakryiko wrote:
> Add ability to specify either test number or test name substring to
> narrow down a set of test to run.
> 
> Usage:
> sudo ./test_progs -n 1
> sudo ./test_progs -t attach_probe
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 43 +++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index eea88ba59225..6e04b9f83777 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -4,6 +4,7 @@
>  #include "test_progs.h"
>  #include "bpf_rlimit.h"
>  #include <argp.h>
> +#include <string.h>
>  
>  int error_cnt, pass_cnt;
>  bool jit_enabled;
> @@ -164,6 +165,7 @@ void *spin_lock_thread(void *arg)
>  
>  struct prog_test_def {
>  	const char *test_name;
> +	int test_num;
>  	void (*run_test)(void);
>  };
>  
> @@ -181,26 +183,49 @@ const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
>  const char argp_program_doc[] = "BPF selftests test runner";
>  
>  enum ARG_KEYS {
> +	ARG_TEST_NUM = 'n',
> +	ARG_TEST_NAME = 't',
>  	ARG_VERIFIER_STATS = 's',
>  };
>  	
>  static const struct argp_option opts[] = {
> +	{ "num", ARG_TEST_NUM, "NUM", 0,
> +	  "Run test number NUM only " },
> +	{ "name", ARG_TEST_NAME, "NAME", 0,
> +	  "Run tests with names containing NAME" },
>  	{ "verifier-stats", ARG_VERIFIER_STATS, NULL, 0,
>  	  "Output verifier statistics", },
>  	{},
>  };
>  
>  struct test_env {
> +	int test_num_selector;
> +	const char *test_name_selector;
>  	bool verifier_stats;
>  };
>  
> -static struct test_env env = {};
> +static struct test_env env = {
> +	.test_num_selector = -1,
> +};
>  
>  static error_t parse_arg(int key, char *arg, struct argp_state *state)
>  {
>  	struct test_env *env = state->input;
>  
>  	switch (key) {
[..]
> +	case ARG_TEST_NUM: {
> +		int test_num;
> +
> +		errno = 0;
> +		test_num = strtol(arg, NULL, 10);
> +		if (errno)
> +			return -errno;
> +		env->test_num_selector = test_num;
> +		break;
> +	}
Do you think it's really useful? I agree about running by name (I
usually used grep -v in the Makefile :-), but I'm not sure about running
by number.

Or is the idea is that you can just copy-paste this number from the
test_progs output to rerun the tests? In this case, why not copy-paste
the name instead?

> +	case ARG_TEST_NAME:
> +		env->test_name_selector = arg;
> +		break;
>  	case ARG_VERIFIER_STATS:
>  		env->verifier_stats = true;
>  		break;
> @@ -223,7 +248,7 @@ int main(int argc, char **argv)
>  		.parser = parse_arg,
>  		.doc = argp_program_doc,
>  	};
> -	const struct prog_test_def *def;
> +	struct prog_test_def *test;
>  	int err, i;
>  
>  	err = argp_parse(&argp, argc, argv, 0, NULL, &env);
> @@ -237,8 +262,18 @@ int main(int argc, char **argv)
>  	verifier_stats = env.verifier_stats;
>  
>  	for (i = 0; i < ARRAY_SIZE(prog_test_defs); i++) {
> -		def = &prog_test_defs[i];
> -		def->run_test();
> +		test = &prog_test_defs[i];
> +
> +		test->test_num = i + 1;
> +
> +		if (env.test_num_selector >= 0 &&
> +		    test->test_num != env.test_num_selector)
> +			continue;
> +		if (env.test_name_selector &&
> +		    !strstr(test->test_name, env.test_name_selector))
> +			continue;
> +
> +		test->run_test();
>  	}
>  
>  	printf("Summary: %d PASSED, %d FAILED\n", pass_cnt, error_cnt);
> -- 
> 2.17.1
> 
