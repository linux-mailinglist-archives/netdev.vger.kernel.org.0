Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB80C9FD9
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfJCNus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 09:50:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43864 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbfJCNur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 09:50:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id c3so3621226qtv.10;
        Thu, 03 Oct 2019 06:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=wd7tBqBSSEmGFgyOp4VhZ6hdLUak5SsJ+mT0116Ujn0=;
        b=RcDHF1VBJS1LsGtb3uKaw5MRfIH9CAzxBc4pP7oERBIZ8PJxMZzBOhU/NFKlnu4cqT
         bEJGo9oXggGTXeWJ7BF3s30XqWk+LQEbRyUZcEU71pY+vETYUnnoQaUHhsSknD7B8gOE
         +cRzS85acUz/tA1cijRJHWhohvTK19yU8v6LSjJg+vBYzvKGszfA8Km5np2/mbZ8ciPI
         Da95gmg+Xqm5MQOzo+lvzSPYJoFi6KX82f9Qh1Y8nysIW+5LH7ck36SEZbHjfjqD8Kjs
         SUdFSfEH/4O1bbDYhY7tytV5+Pb9zfESiofz5CsNucT+SZW6KfiaNEUmVdoIZ7YP76z4
         hOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=wd7tBqBSSEmGFgyOp4VhZ6hdLUak5SsJ+mT0116Ujn0=;
        b=mzLb8FuIFnfS7j+gA0yRef2LGR9Midv2t7g+qDo6IZSh2Os3/6F4kmfPgnEML2J/h6
         yYQYt0apL0nP9u6ChWgSGRCoRVh16kM0YxFKqtNUxupH7HiDDemK7aHkUzOA9PW6y9Fu
         +gsf/BizZG2F0KEtxJQX+HMV4FZaCOSoLj0fpVJX/gB9vqFhIxMVdmNjcZcNENDjp8Hu
         EXZyD4jnF9NQCyRFHeAazMm/qyNSuevY8/pkfgyrf5fX7F4b4KLSlbgxnEKB1ZgUPhgf
         FRsZOd+ZFGDbs55IjzMVj6gcswms4NK5xH0LGYgtb5KeLtvIUS+mDO9s3XuKFookRvQo
         hR/Q==
X-Gm-Message-State: APjAAAUapJgCllneyAjA3bDtY8iVeHqXrR4c84qL4NGc7cTN9Q9iSrco
        3lb4KfGVSLOVKEtgxhTBgoE=
X-Google-Smtp-Source: APXvYqxHZtIth9FbpgdLK6Ef363ni24MYUaFEHRAqKVcuMuiQ3qJHYf0ICzlNtr9yuxMKPDU4/EnPA==
X-Received: by 2002:a0c:f6cd:: with SMTP id d13mr8594377qvo.146.1570110646613;
        Thu, 03 Oct 2019 06:50:46 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id u27sm2057569qta.90.2019.10.03.06.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 06:50:44 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4E24E40DD3; Thu,  3 Oct 2019 10:50:42 -0300 (-03)
Date:   Thu, 3 Oct 2019 10:50:42 -0300
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, adrian.hunter@intel.com, jolsa@kernel.org,
        namhyung@kernel.org
Subject: Re: [PATCH 1/2] perf tools: Make usage of test_attr__* optional for
 perf-sys.h
Message-ID: <20191003135042.GA18973@kernel.org>
References: <20191001113307.27796-1-bjorn.topel@gmail.com>
 <20191001113307.27796-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191001113307.27796-2-bjorn.topel@gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Oct 01, 2019 at 01:33:06PM +0200, Björn Töpel escreveu:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> For users of perf-sys.h outside perf, e.g. samples/bpf/bpf_load.c,
> it's convenient not to depend on test_attr__*.
> 
> After commit 91854f9a077e ("perf tools: Move everything related to
> sys_perf_event_open() to perf-sys.h"), all users of perf-sys.h will
> depend on test_attr__enabled and test_attr__open.
> 
> This commit enables a user to define HAVE_ATTR_TEST to zero in order
> to omit the test dependency.

Woah, I wasn't expecting tools/perf/ stuff to be included from outside
tools/perf/, so thanks for fixing that odd user.

Applied.

- Arnaldo
 
> Fixes: 91854f9a077e ("perf tools: Move everything related to sys_perf_event_open() to perf-sys.h")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  tools/perf/perf-sys.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
> index 63e4349a772a..15e458e150bd 100644
> --- a/tools/perf/perf-sys.h
> +++ b/tools/perf/perf-sys.h
> @@ -15,7 +15,9 @@ void test_attr__init(void);
>  void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
>  		     int fd, int group_fd, unsigned long flags);
>  
> -#define HAVE_ATTR_TEST
> +#ifndef HAVE_ATTR_TEST
> +#define HAVE_ATTR_TEST 1
> +#endif
>  
>  static inline int
>  sys_perf_event_open(struct perf_event_attr *attr,
> @@ -27,7 +29,7 @@ sys_perf_event_open(struct perf_event_attr *attr,
>  	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
>  		     group_fd, flags);
>  
> -#ifdef HAVE_ATTR_TEST
> +#if HAVE_ATTR_TEST
>  	if (unlikely(test_attr__enabled))
>  		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
>  #endif
> -- 
> 2.20.1

-- 

- Arnaldo
