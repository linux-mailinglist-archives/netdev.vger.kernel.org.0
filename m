Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E65AD2F21
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfJJRBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:01:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35900 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfJJRBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 13:01:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id y22so4294044pfr.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 10:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+quEkQlNjfZMmbACMnpxPeMglJvzNs5pK9V2vk7Is/8=;
        b=fNKv+2vy62Bd+riJV5NvJGX5HZpaHu7FGSGvXryy6onBTM6h5fo/JVGBikuDr+lJEE
         iP9453zC29fbazVkUVq5kpZNYwe41jlOFhcQI1tHeYCpLL6bLu3wy1rbaU4dE2kxbXSM
         4L/wvLIpOR22JPWc8tQ8SrbwvYfEaDCqxLwCrrbm5h+jcZ0+SqkoXLwmih3L6BcSk+yw
         OBX9hwpg2rn8sN11t7Fpf78WBZmwX+iNBfbDfEF02nedItORjBfbeuXRX2seVmfnUupG
         a99Fz37e63q5q3/oRUekblVI/s0lZP5vPf7HmmtCLKN6yOZ8CF6adlCwYgRQnNpUfWEs
         acmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+quEkQlNjfZMmbACMnpxPeMglJvzNs5pK9V2vk7Is/8=;
        b=Cd5l+vvEDKCUzrG5ONAydQ2m36Cx6Ygt/gUSeJ3IKxV9+IwvakxNMKjB40GvAUA7Jd
         2IQfVTxR+kMVQ78xvJV8KXEsdy0J+tC46NJnq5v7G9m6J1DwUXGbtC4IywHMEpQXGGs1
         2DTE55DrA0GXXs08qzWIfw4Nxo6QyRVmb2ThGgTcUOQ75Rof9ZGIL1lPwJqeE0mACj1s
         f/GzVzEd0wds0efrftOPm7NpLuHegC5RceF8tXVfs9gX3OvYdCc4x0rWacJfjJ31WsVO
         Na4to3JrYwHH6cTubY6SJou6TnXFYdyHRnsaXPfGZTXCGq20YQjqxq+pnLoatcPOt28l
         ENhQ==
X-Gm-Message-State: APjAAAUlBOyVvmM01bVDjdSPrMKrkYQUVQEnlTnxpghUAZCfZ05J5JlR
        YzUAS+NyeHrdJMrXz2exXmn2QA==
X-Google-Smtp-Source: APXvYqwmaCglJE5ryxlXx3WyWtrq9TrqXV4jZ3IVKRRJMpiYtMim5Xfmj9wlqZX2RnyBbzyoFPBGYA==
X-Received: by 2002:a65:4bc2:: with SMTP id p2mr12022286pgr.177.1570726878954;
        Thu, 10 Oct 2019 10:01:18 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id h186sm10554590pfb.63.2019.10.10.10.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 10:01:18 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:01:17 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATH bpf-next 2/2] selftests/bpf: Check that flow dissector can
 be re-attached
Message-ID: <20191010170117.GG2096@mini-arch>
References: <20191009094312.15284-1-jakub@cloudflare.com>
 <20191009094312.15284-2-jakub@cloudflare.com>
 <20191009163341.GE2096@mini-arch>
 <87lfts25mq.fsf@cloudflare.com>
 <20191010163157.GF2096@mini-arch>
 <87k19c1r6l.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k19c1r6l.fsf@cloudflare.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10, Jakub Sitnicki wrote:
> On Thu, Oct 10, 2019 at 06:31 PM CEST, Stanislav Fomichev wrote:
> > On 10/10, Jakub Sitnicki wrote:
> >> On Wed, Oct 09, 2019 at 06:33 PM CEST, Stanislav Fomichev wrote:
> >> > On 10/09, Jakub Sitnicki wrote:
> 
> [...]
> 
> >> >> +/* Not used here. For CHECK macro sake only. */
> >> >> +static int duration;
> >> > nit: you can use CHECK_FAIL macro instead which doesn't require this.
> >> >
> >> > if (CHECK_FAIL(expr)) {
> >> > 	printf("something bad has happened\n");
> >> > 	return/goto;
> >> > }
> >> >
> >> > It may be more verbose than doing CHECK() with its embedded error
> >> > message, so I leave it up to you to decide on whether you want to switch
> >> > to CHECK_FAIL or stick to CHECK.
> >> >
> >>
> >> I wouldn't mind switching to CHECK_FAIL. It reads better than CHECK with
> >> error message stuck in the if expression. (There is a side-issue with
> >> printf(). Will explain at the end [*].)
> >>
> >> Another thing to consider is that with CHECK the message indicating a
> >> failure ("<test>:FAIL:<lineno>") and the actual explanation message are
> >> on the same line. This makes the error log easier to reason.
> >>
> >> I'm torn here, and considering another alternative to address at least
> >> the readability issue:
> >>
> >> if (fail_expr) {
> >>         CHECK(1, "action", "explanation");
> >>         return;
> >> }
> > Can we use perror for the error reporting?
> >
> > if (CHECK(fail_expr)) {
> > 	perror("failed to do something"); // will print errno as well
> > }
> >
> > This should give all the info needed to grep for this message and debug
> > the problem.
> >
> > Alternatively, we can copy/move log_err() from the cgroup_helpers.h,
> > and use it in test_progs; it prints file:line:errno <msg>.
> 
> CHECK_FAIL + perror() works for me. I've been experimenting with
> extracting a new macro-helper (patch below) but perhaps it's an
> overkill.
If you want to go the route with the new helpers let's maybe have something
similar to what we have in the kernel? Stuff like pr_err (which is familiar)
so then the pattern can be:

if (CHECK(expr)) {
	pr_err("description"); // prints file:line:errno
	[return;]
}

But I'd stick with perror, grepping the message shouldn't be that hard
since we have a rule to not break the error strings.

> 
> [...]
> 
> >> [*] The printf() issue.
> >>
> >> I've noticed that stdio hijacking that test_progs runner applies doesn't
> >> quite work. printf() seems to skip the FILE stream buffer and write
> >> whole lines directly to stdout. This results in reordered messages on
> >> output.
> >>
> >> Here's a distilled reproducer for what test_progs does:
> >>
> >> int main(void)
> >> {
> >> 	FILE *stream;
> >> 	char *buf;
> >> 	size_t cnt;
> >>
> >> 	stream = stdout;
> >> 	stdout = open_memstream(&buf, &cnt);
> >> 	if (!stdout)
> >> 		error(1, errno, "open_memstream");
> >>
> >> 	printf("foo");
> >> 	printf("bar\n");
> >> 	printf("baz");
> >> 	printf("qux\n");
> >>
> >> 	fflush(stdout);
> >> 	fclose(stdout);
> >>
> >> 	buf[cnt] = '\0';
> >> 	fprintf(stream, "<<%s>>", buf);
> >> 	if (buf[cnt-1] != '\n')
> >> 		fprintf(stream, "\n");
> >>
> >> 	free(buf);
> >> 	return 0;
> >> }
> >>
> >> On output we get:
> >>
> >> $ ./hijack_stdout
> >> bar
> >> qux
> >> <<foobaz>>
> >> $
> > What glibc do you have? I don't see any issues with your reproducer
> > on my setup:
> >
> > $ ./a.out
> > <<foobar
> > bazqux
> >>>$
> >
> > $ ldd --version
> > ldd (Debian GLIBC 2.28-10) 2.28
> >
> 
> Interesting. I'm on the same version, different distro:
> 
> $ rpm -q glibc
> glibc-2.28-33.fc29.x86_64
> glibc-2.28-33.fc29.i686
> 
> I'll need to dig deeper. Thanks for keeping me honest here.
I also tried it on my other box with 2.29 and now I see the issue you're
reporting:

$ gcc tmp.c && ./a.out 
bar
qux
<<foobaz>>

But what's interesting:

$ gcc -static tmp.c && ./a.out 
<<foobar
bazqux
>>$ 

> -Jakub
> 
> ---8<---
> 
> From 66fd85cd3bbb36cf99c8b6cbbb161d3c0533263b Mon Sep 17 00:00:00 2001
> From: Jakub Sitnicki <jakub@cloudflare.com>
> Date: Thu, 10 Oct 2019 15:29:28 +0200
> Subject: [PATCH net-next] selftests/bpf: test_progs: Extract a macro for
>  logging failures
> 
> When selecting a macro-helper to use for logging a test failure we are
> faced with a choice between the shortcomings of CHECK and CHECK_FAIL.
> 
> CHECK is intended to be used in conjunction with bpf_prog_test_run(). It
> expects a program run duration to be passed to it as an implicit argument.
> 
> While CHECK_FAIL is more generic but compared to CHECK doesn't allow
> logging a custom error message to explain the failure.
> 
> Introduce a new macro-helper - FAIL, that is lower-level than the above it
> and it intended to be used just log the failure with an explanation for it.
> 
> Because FAIL does in part what CHECK and CHECK_FAIL do, we can reuse it in
> these macros. One side-effect is a slight the change in the log format. We
> always display the line number where a check has passed/failed.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/testing/selftests/bpf/test_progs.h | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index 0c48f64f732b..9e203ff71b78 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -92,15 +92,19 @@ struct ipv6_packet {
>  } __packed;
>  extern struct ipv6_packet pkt_v6;
>  
> +#define FAIL(tag, format...) ({						\
> +	test__fail();							\
> +	printf("%s:%d:FAIL:%s ", __func__, __LINE__, tag);		\
> +	printf(format);							\
> +})
> +
>  #define _CHECK(condition, tag, duration, format...) ({			\
>  	int __ret = !!(condition);					\
>  	if (__ret) {							\
> -		test__fail();						\
> -		printf("%s:FAIL:%s ", __func__, tag);			\
> -		printf(format);						\
> +		FAIL(tag, format);					\
>  	} else {							\
> -		printf("%s:PASS:%s %d nsec\n",				\
> -		       __func__, tag, duration);			\
> +		printf("%s:%d:PASS:%s %d nsec\n",			\
> +		       __func__, __LINE__, tag, duration);		\
>  	}								\
>  	__ret;								\
>  })
> @@ -108,8 +112,7 @@ extern struct ipv6_packet pkt_v6;
>  #define CHECK_FAIL(condition) ({					\
>  	int __ret = !!(condition);					\
>  	if (__ret) {							\
> -		test__fail();						\
> -		printf("%s:FAIL:%d\n", __func__, __LINE__);		\
> +		FAIL("", #condition "\n");				\
>  	}								\
>  	__ret;								\
>  })
> -- 
> 2.20.1
> 
