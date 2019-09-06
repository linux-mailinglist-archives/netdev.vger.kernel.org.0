Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AB9AC312
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405491AbfIFXbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 19:31:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41895 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405354AbfIFXbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:31:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so5557649pfo.8;
        Fri, 06 Sep 2019 16:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SQjSnJNJU1DdxchJMC/G1usRxJ9DGlAOVDt5OIAWEIM=;
        b=OfYDOtkAPn55J/GFccGgpHGhJaaQ0/ESjPcoJx0MjfKalKLhPkRD8x0t1hBMA3FfAK
         uVymWSL6AQne/M6bZ5IhnoVumioi6UBXfIC/KU9/CkZIHIwDbO1EL2xYRNcFpkQs7mVp
         4CMLw2SYsUYqoFKQiJCyrvOBOHdbm8D/hvmKoe+cMFfqYApxsr4nPcw0zlmKy8q82l/i
         Pz2P+qS/G1PrxOY7zTh8x5Y0wEYC5pGwCsvb5Igwbz5N+x3qbwUIB+NuLpMEkNU8zDKN
         n8uKjjUMsJqZl0c/1LSygKaiHTWjQa63xdgAlCavXMRHHt9HnmWhMH4VoN5Ieau9I+as
         jNWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SQjSnJNJU1DdxchJMC/G1usRxJ9DGlAOVDt5OIAWEIM=;
        b=KOtMi76LZxHSABV76B43GZZeRN21ZT5ZsdG9H8KwUEA6V8QJlniZcjjHFIJk52kGHs
         tecbtPl4QPXVWtxi5HRpmHvtfbixUoE8LHmM0/2z+hu5b9FfwosGwVFOIshTYP3PIuXR
         HK57v8tzPnLpv/4mOAwXNAogG5AQmJ50HDvuyAeQA8YQf+tQwqJEVxBVq+eHQyNnHD96
         YO7fuJfWJsPL+mvHoSaBJlqKsG3kLX1CqY/uVNTocYTxgrhGqVdRmtcakAvDW9sjfX2S
         ta4OpVJaTmgnyMWOs71O0qWqeurjfqWHQufkAChL8rqSUEmYqEy/cylLcrvXbOseFpqm
         Inxw==
X-Gm-Message-State: APjAAAVprftQQ8F47dNZErZvvfKyhAO5ngcsHHWqQa1ynC3b0+tpjzqT
        VIYUDH0E5uu+dT6iptoIBRY=
X-Google-Smtp-Source: APXvYqyohMK2Sa4UkHMdy7FHCRPoPAlddUUVpl0RMdphR8hzl8HPCjopKTnAZ0csXJL1qptqS7oMpg==
X-Received: by 2002:a17:90a:c706:: with SMTP id o6mr7967364pjt.56.1567812702047;
        Fri, 06 Sep 2019 16:31:42 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:46a4])
        by smtp.gmail.com with ESMTPSA id y194sm9649282pfg.186.2019.09.06.16.31.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 16:31:41 -0700 (PDT)
Date:   Fri, 6 Sep 2019 16:31:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 2/8] samples: bpf: Makefile: remove target for
 native build
Message-ID: <20190906233138.4d4fqdnlbikemhau@ast-mbp.dhcp.thefacebook.com>
References: <20190904212212.13052-1-ivan.khoronzhuk@linaro.org>
 <20190904212212.13052-3-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904212212.13052-3-ivan.khoronzhuk@linaro.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 12:22:06AM +0300, Ivan Khoronzhuk wrote:
> No need to set --target for native build, at least for arm, the
> default target will be used anyway. In case of arm, for at least
> clang 5 - 10 it causes error like:
> 
> clang: warning: unknown platform, assuming -mfloat-abi=soft
> LLVM ERROR: Unsupported calling convention
> make[2]: *** [/home/root/snapshot/samples/bpf/Makefile:299:
> /home/root/snapshot/samples/bpf/sockex1_kern.o] Error 1
> 
> Only set to real triple helps: --target=arm-linux-gnueabihf
> or just drop the target key to use default one. Decision to just
> drop it and thus default target will be used (wich is native),
> looks better.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  samples/bpf/Makefile | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 61b7394b811e..a2953357927e 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -197,8 +197,6 @@ BTF_PAHOLE ?= pahole
>  ifdef CROSS_COMPILE
>  HOSTCC = $(CROSS_COMPILE)gcc
>  CLANG_ARCH_ARGS = --target=$(notdir $(CROSS_COMPILE:%-=%))
> -else
> -CLANG_ARCH_ARGS = -target $(ARCH)
>  endif

I don't follow here.
Didn't you introduce this bug in patch 1 and now fixing it in patch 2?

