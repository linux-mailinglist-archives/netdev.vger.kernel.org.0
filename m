Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00F922FE27
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgG0XrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgG0XrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 19:47:18 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D38AC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:47:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so10877474pgf.0
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2/ePdQ1+2lRPwjj7Pg+gyaIU4G/5I+wTrTdQoFYIEn4=;
        b=THT5gBLSgx+151MRmY+lLwEczuCLGCEA/W/3xWQ8iRm0WfVP8Cv3a5KE6+Ga/YjgIF
         0xVrAxHd65Kbe1IAWDNM6/POqwzOwB3V3wXzwj41c1VaQHBNjXwK9yvIJxtA+O10HT8s
         8jKZh9iOygpSlQRKcIs0alrxp4N5xUXqvbqjkQthUqOg+hIozI0NW2tLlxVnbWqiF5BS
         /XydiZrqSatfRbMw7XinxzUXOs6g9p3WuOfT2kbaulcmhnVvXxmleOnRryEZSeSS/2lq
         +smUplNSYRJHjKH8RZIMvIRDqgiXAcMXA1FRoW0X/NR6cix1tyj9jp94Cu6hIMaupvDS
         UwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/ePdQ1+2lRPwjj7Pg+gyaIU4G/5I+wTrTdQoFYIEn4=;
        b=uIhkSCKFkz3pyF0MJua9C8Yqp9XUfALwhfJfAaywN9BRRIr0E93I+9Bj/bSa9iPKB6
         PlvxjtomgqenTZwmaSi+/s/uOEuo4PJ0+D5UXBLgZiiTvys5K2wZM5i0b0VMcwyTfK8I
         kYbHycJiWl8tKMLoHjvBku7RemflVUn+6BMS18GEQYSjq8HBfHPXGl2fjP2Ur25p8nfC
         ny4LGnjeblfQzzGB+NstGP8Ph9a5kYbigWfSCSnSvvACdqlQElXZ90xQascpjVPjcB0k
         IBomcgWqpxc1w8n4aSzg1eEaMxutDgN/hvch/vKpaT3Wfpy2k5hN4ZFnCkkEsjgMJ7Vi
         fygA==
X-Gm-Message-State: AOAM5325dw9iqJYy7joZf9nrUC+TQtvoVs+1iUK691JvKsxcqm28QdgH
        NroYYyNGDgNL2OrRGvLOBahphw==
X-Google-Smtp-Source: ABdhPJxiowOePwCv/elB6jl0CQ8fRalMigh3wi1sCGQ12+6qXzH7+EvzATVgQdxdE4HhiFsJ+cDxJg==
X-Received: by 2002:a63:7d16:: with SMTP id y22mr20799078pgc.136.1595893637766;
        Mon, 27 Jul 2020 16:47:17 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g6sm16055247pfr.129.2020.07.27.16.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 16:47:17 -0700 (PDT)
Date:   Mon, 27 Jul 2020 16:47:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Briana Oursler <briana.oursler@gmail.com>
Cc:     netdev@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Petr Machata <petrm@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: Question Print Formatting iproute2
Message-ID: <20200727164714.6ee94a11@hermes.lan>
In-Reply-To: <20200727044616.735-1-briana.oursler@gmail.com>
References: <20200727044616.735-1-briana.oursler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jul 2020 21:46:16 -0700
Briana Oursler <briana.oursler@gmail.com> wrote:

> I have a patch I've written to address a format specifier change that
> breaks some tests in tc-testing, but I wanted to ask about the change
> and for some guidance with respect to how formatters are approached in
> iproute2. 
> 
> On a recent run of tdc tests I ran ./tdc.py -c qdisc and found:
> 
> 1..91
> not ok 1 8b6e - Create RED with no flags
>         Could not match regex pattern. Verify command output:
> qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kb
> 
> not ok 2 342e - Create RED with adaptive flag
>         Could not match regex pattern. Verify command output:
> qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbadaptive
> 
> not ok 3 2d4b - Create RED with ECN flag
>         Could not match regex pattern. Verify command output:
> qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn
> 
> not ok 4 650f - Create RED with flags ECN, adaptive
>         Could not match regex pattern. Verify command output:
> qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn adaptive
> 
> not ok 5 5f15 - Create RED with flags ECN, harddrop
>         Could not match regex pattern. Verify command output:
> qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn harddrop
> 
> not ok 6 53e8 - Create RED with flags ECN, nodrop
>         Could not match regex pattern. Verify command output:
> qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn nodrop
> 
> ok 7 d091 - Fail to create RED with only nodrop flag
> not ok 8 af8e - Create RED with flags ECN, nodrop, harddrop
>         Could not match regex pattern. Verify command output:
> qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn harddrop
> nodrop
> 
> I git bisected and found d0e450438571("tc: q_red: Add support for
> qevents "mark" and "early_drop"), the commit that introduced the
> formatting change causing the break. 
> 
> -       print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
> +       print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
> 
> I made a patch that adds a space after the format specifier in the
> iproute2 tc/q_red.c and tested it using: tdc.py -c qdisc. After the
> change, all the broken tdc qdisc red tests return ok. I'm including the
> patch under the scissors line.
> 
> I wanted to ask the ML if adding the space after the specifier is preferred usage.
> The commit also had: 
>  -               print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
>  +               print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
> 
> so I wanted to check with everyone.
> 
> Thanks 
> >8------------------------------------------------------------------------8<  
> From 1e7bee22a799a320bd230ad959d459b386bec26d Mon Sep 17 00:00:00 2001
> Subject: [RFC iproute2-next] tc: Add space after format specifier
> 
> Add space after format specifier in print_string call. Fixes broken
> qdisc tests within tdc testing suite.
> 
> Fixes: d0e450438571("tc: q_red: Add support for
> qevents "mark" and "early_drop")
> 
> Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
> ---
>  tc/q_red.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/q_red.c b/tc/q_red.c
> index dfef1bf8..7106645a 100644
> --- a/tc/q_red.c
> +++ b/tc/q_red.c
> @@ -222,7 +222,7 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
>  	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt->qth_min, b2));
>  	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
> -	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
> +	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
>  
>  	tc_red_print_flags(qopt->flags);
>  
> 
> base-commit: 1ca65af1c5e131861a3989cca3c7ca8b067e0833

Looks fine, please resend a normal patch targeted at current iproute2
not next.

