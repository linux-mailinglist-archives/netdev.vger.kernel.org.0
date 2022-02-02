Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2524A7321
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiBBOaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239923AbiBBOaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:30:14 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20C4C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 06:30:13 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id r65so61459782ybc.11
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 06:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AtBUzEXlokDPtVqQC8pBOs9TZYcQuHKdADMkbK89jZ8=;
        b=iX+ru3dN33ojS86l4c5m0UABFV/m6hwXh86VKfIbvsnxQGv4/VCTxdZVTVE1bbYT9p
         fQtvGVunD+zO+2T6UmgYiQ56ZPNRLvJBfuBOUmMqtRzacA6Ho+swyiZ5iU7m6AuqKkUc
         VekGDy51ZRmOOWW64AKWfeUghbeIzSsjpQ2s/3cprFs/2cPxzP6kYUaJ9bu5ccRGPxJH
         ObJP2ygPcWvS10Dzqj3zJx4Xe8VLGUbDVh4N0kNw64wihNJl2H4exvn32lJkgNLH+qLo
         1AA6GpdsYxAEHD19Ni1fIt0zHiCnYzr8KOpfFp+vi2lZihNmb726pQAsublHq5MaLTOE
         DIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AtBUzEXlokDPtVqQC8pBOs9TZYcQuHKdADMkbK89jZ8=;
        b=rlPVdAbPxvMzO3Ic4j0n8Oprhjdgf0BI+XNqAjlgXhpuiFDqX9hL/WoHzi+XSIRZnq
         /Dv6zn/L3Rc5Lzlk4jtnblspJjt+DZq0hxE3SYNkKC3xAefKsD3cbafBgZsuv5QK4Ths
         7pnZTw6i/63e08VbGzR31oQOT8tOG8B/oeSmghdPQxqs6PyijGPCsSqIk6IQIXkTkCqt
         R6kd+FbwRJfmmNabldJxbzY/+/ZmCvbLoylRtxelIV3+5WYa7swF9O/yzZIYND5yOvUG
         ATpNoG0SWGN2ln4uA9r9Br/6eLJ7Y+puSvEFvf84yhSlmDIAIWaUhqDyU1LXslg+NzEF
         fjbw==
X-Gm-Message-State: AOAM531KHwgGmzemlcs0Xc6Bd+dv9kgowVKmY3Y3rp2W2W6u7QNaappf
        xVgEorhnaYj5YhJw7pAhJ4Pja6Kzrbg1QiOtWCUuIw==
X-Google-Smtp-Source: ABdhPJxbBhAFJrSFnbS91u7pIReOzo6o3c8rT059RP1GyQwn1zF0hegnVw8hrU8SDJTlAvqDi9rNkayxHwZozyFe/+o=
X-Received: by 2002:a5b:a03:: with SMTP id k3mr42798925ybq.219.1643812213182;
 Wed, 02 Feb 2022 06:30:13 -0800 (PST)
MIME-Version: 1.0
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 2 Feb 2022 16:29:35 +0200
Message-ID: <CAC_iWj+7+2oxNc78PnQAdgeTM09nWai+TA+icPncTpa3NxEmcg@mail.gmail.com>
Subject: Re: [net-next v3 00/10] page_pool: Add page_pool stat counters
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org, Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

Again thanks for the patches!

On Wed, 2 Feb 2022 at 03:13, Joe Damato <jdamato@fastly.com> wrote:
>
> Greetings:
>
> Sending a v3 as I noted some issues with the procfs code in patch 10 I
> submit in v2 (thanks, kernel test robot) and fixing the placement of the
> refill stat increment in patch 8.
>
> I only modified the placement of the refill stat, but decided to re-run the
> benchmarks used in the v2 [1], and the results are:
>
> Test system:
>         - 2x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
>         - 2 NUMA zones, with 18 cores per zone and 2 threads per core
>
> bench_page_pool_simple results:
> test name                       stats enabled           stats disabled
>                                 cycles  nanosec         cycles  nanosec
>
> for_loop                        0       0.335           0       0.334
> atomic_inc                      13      6.028           13      6.035
> lock                            32      14.017          31      13.552
>
> no-softirq-page_pool01          45      19.832          46      20.193
> no-softirq-page_pool02          44      19.478          46      20.083
> no-softirq-page_pool03          110     48.365          109     47.699
>
> tasklet_page_pool01_fast_path   14      6.204           13      6.021
> tasklet_page_pool02_ptr_ring    41      18.115          42      18.699
> tasklet_page_pool03_slow        110     48.085          108     47.395
>
> bench_page_pool_cross_cpu results:
> test name                       stats enabled           stats disabled
>                                 cycles  nanosec         cycles  nanosec
>
> page_pool_cross_cpu CPU(0)      2216    966.179         2101    915.692
> page_pool_cross_cpu CPU(1)      2211    963.914         2159    941.087
> page_pool_cross_cpu CPU(2)      1108    483.097         1079    470.573
>
> page_pool_cross_cpu average     1845    -               1779    -
>
> v2 -> v3:
>         - patch 8/10 ("Add stat tracking cache refill") fixed placement of
>           counter increment.
>         - patch 10/10 ("net-procfs: Show page pool stats in proc") updated:
>                 - fix unused label warning from kernel test robot,
>                 - fixed page_pool_seq_show to only display the refill stat
>                   once,
>                 - added a remove_proc_entry for page_pool_stat to
>                   dev_proc_net_exit.
>
> v1 -> v2:
>         - A new kernel config option has been added, which defaults to N,
>            preventing this code from being compiled in by default
>         - The stats structure has been converted to a per-cpu structure
>         - The stats are now exported via proc (/proc/net/page_pool_stat)
>

CC'ing Saeed since he is interested on page pool stats for mlx5.
I'd be much happier if we had per cpu per pool stats and a way to pick
them up via ethtool, instead of global page pool stats in /proc.
Anyone has an opinion on this?

[...]

Thanks!
/Ilias
