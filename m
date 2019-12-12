Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E9E11D858
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbfLLVMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:12:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40848 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731036AbfLLVMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:12:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so4193017wmi.5
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 13:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PcmogneKF3nOjBA/T+Cz4S9PAlLf7HeJNjnctWOigOA=;
        b=ImfmKt+bsixOfBnjE0ET8eegWSCQmsWgJkdDh8wX+cMo85ikcy0yblgThwbBXFZXCG
         8jUEyGehhm6+FGVYCbh9WOp0o71kzFYMiyg7F9T4wvMB6sha9BqJOsUDU3SjNsCthVIt
         rW91aCBzrKiBsCls17Kxmz466Sf9dw5VuRiRYMiM+pkvXw0O57Y5aW2S52YrEJw+fkz8
         9LcXbGdnwcGs5DGyB8WyUw/r1oashn+OaraZXWi0RBpZ3QoIOB+JNfu2SJCuZW1kSN/R
         coI/XBtHSOinLFQ4YBf0ROtYdf8DZNyCFBULnzH4XaBlnHyw3iiQ1f1gahjlqhHOFNZN
         oCXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PcmogneKF3nOjBA/T+Cz4S9PAlLf7HeJNjnctWOigOA=;
        b=EPTbrUvdbe1l6d/B21/Lc78BfF6hgNPLC4Sl2SGwLHor734IvNb9itHNVscviEeEoO
         mXIMb/wb2vaYnmODQ9cXIAt0TzlEpQrW7nca76Tp3Ln7IkKQfVZouOd/yY6qrtyGOjyy
         eHaj2Kf/sp8d1gljRQYDjkifQdhDntDO/XvRICNGLewrTk4W7kbeeikwjqd8QMkcBADV
         eObX9FHYsvWNvfDbSSDQozCIJrNH+Z5BuNGE2Efel8mbp4fFIA9OqNRmwU5AmkgTEF9J
         eTZ1KPPArW1DxxMN19m+YGRgXDVS/tDL8B9oaYfERsu6yEOIUeKsGUNVoYAP6nItprda
         DisA==
X-Gm-Message-State: APjAAAXH3UmvexAjq0PnYviX0w5/KB8LNpv4NyKnw7xQOCKbZRE3Kplw
        xllvj/zl3muxBpRi5035iByo4Q==
X-Google-Smtp-Source: APXvYqwTx0NSImnQ1KZPvlDXsPTwe7ZlXGBepFXFruy07ymD6hKLHCCYdzypIrdIquGlIf+sDbuzoA==
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr9195722wmk.68.1576185152533;
        Thu, 12 Dec 2019 13:12:32 -0800 (PST)
Received: from [192.168.1.2] ([194.53.186.39])
        by smtp.gmail.com with ESMTPSA id u22sm7821466wru.30.2019.12.12.13.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 13:12:31 -0800 (PST)
Subject: Re: [PATCH v2 bpf-next 15/15] bpftool: add `gen skeleton` BASH
 completions
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191212164129.494329-1-andriin@fb.com>
 <20191212164129.494329-16-andriin@fb.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <8b39cb0b-9372-4f68-cded-e464d5b80ec2@netronome.com>
Date:   Thu, 12 Dec 2019 21:12:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191212164129.494329-16-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-12-12 08:41 UTC-0800 ~ Andrii Nakryiko <andriin@fb.com>
> Add BASH completions for gen sub-command.
> 
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/bpf/bpftool/bash-completion/bpftool         | 11 +++++++++++
>  tools/bpf/bpftool/main.c                          |  2 +-
>  tools/testing/selftests/bpf/prog_tests/skeleton.c |  6 ++++--
>  tools/testing/selftests/bpf/progs/test_skeleton.c |  3 ++-
>  4 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 70493a6da206..986519cc58d1 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -716,6 +716,17 @@ _bpftool()
>                      ;;
>              esac
>              ;;
> +        gen)
> +            case $command in
> +                skeleton)
> +                    _filedir
> +		    ;;
> +                *)
> +                    [[ $prev == $object ]] && \
> +                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
> +                    ;;
> +            esac
> +            ;;

Hi Andrii,

Bpftool completion looks OK to me...

>          cgroup)
>              case $command in
>                  show|list|tree)
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 758b294e8a7d..1fe91c558508 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
>  		"       %s batch file FILE\n"
>  		"       %s version\n"
>  		"\n"
> -		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf }\n"
> +		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen }\n"

... but this is part of the usage message, and ideally should be added
when you add the new feature to bpftool in patch 11. Not a major issue,
but ...

>  		"       " HELP_SPEC_OPTIONS "\n"
>  		"",
>  		bin_name, bin_name, bin_name);
> diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
> index d65a0203e1df..94e0300f437a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
> +++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
> @@ -39,8 +39,10 @@ void test_skeleton(void)
>  	CHECK(bss->out2 != 2, "res2", "got %lld != exp %d\n", bss->out2, 2);
>  	CHECK(bss->out3 != 3, "res3", "got %d != exp %d\n", (int)bss->out3, 3);
>  	CHECK(bss->out4 != 4, "res4", "got %lld != exp %d\n", bss->out4, 4);
> -	CHECK(bss->out5.a != 5, "res5", "got %d != exp %d\n", bss->out5.a, 5);
> -	CHECK(bss->out5.b != 6, "res6", "got %lld != exp %d\n", bss->out5.b, 6);
> +	CHECK(bss->handler_out5.a != 5, "res5", "got %d != exp %d\n",
> +	      bss->handler_out5.a, 5);
> +	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
> +	      bss->handler_out5.b, 6);

... This and the code below does not seem to relate to bpftool
completion at all. And it was not present in v1. I suspect this code was
not intended to end up in this patch?

>  
>  cleanup:
>  	test_skeleton__destroy(skel);
> diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
> index 303a841c4d1c..db4fd88f3ecb 100644
> --- a/tools/testing/selftests/bpf/progs/test_skeleton.c
> +++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
> @@ -16,7 +16,6 @@ long long in4 __attribute__((aligned(64))) = 0;
>  struct s in5 = {};
>  
>  long long out2 = 0;
> -struct s out5 = {};
>  char out3 = 0;
>  long long out4 = 0;
>  int out1 = 0;
> @@ -25,6 +24,8 @@ int out1 = 0;
>  SEC("raw_tp/sys_enter")
>  int handler(const void *ctx)
>  {
> +	static volatile struct s out5;
> +
>  	out1 = in1;
>  	out2 = in2;
>  	out3 = in3;
> 

