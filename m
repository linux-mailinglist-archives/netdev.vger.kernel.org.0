Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF32676D0A
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 13:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjAVM5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 07:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjAVM5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 07:57:09 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A496D1E2B0;
        Sun, 22 Jan 2023 04:57:06 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so8801242wml.3;
        Sun, 22 Jan 2023 04:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ds9eHrh5fPy69DV2J5X1CR6AKO2KdJRDO5B1jSOga3Q=;
        b=BMpKQxNbE54yCMh1h/0jzupGK87VXMQfsQ0knLKZCaPvhnBJrZ+AECOoahQXVatgGw
         SwZBMl2wxUbNvHL8PQ4ItNjnjbs4nlLZwl0G3MVcLTVUyTUq4w0JgsepICHMIlAhInGG
         Mpx1UPkY7JdCYiRykIZVw5bbRMTi8Z9GW0xZLuFk76iOHQp4lamQsTlbRBJDBuat7QRU
         I9dAscJVi/xIUbNjnVQl+jrkPqPwB9cVJ6fdso6+Ij/gjk72MnQKn6mYDyHjEcf43sox
         yPrbCTGzUj3Y5zDbDtU6NPF/P2lExRz3ziZsApPxVojb3umnwlFSUylZoKysfR4qrE1x
         c1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ds9eHrh5fPy69DV2J5X1CR6AKO2KdJRDO5B1jSOga3Q=;
        b=hGlQ3uvsIV9eeOXbF/Fo8tMxJyUCRkE3gk96XmEkYQZiW829LrGnraQ1LbcyxgmFS2
         Xwvt+yxJcMT2KhNlhOX36wj2b4UIkhy/hzsalX+VnuyXoxJKI8+LVp5czD5kE397mekR
         WIo196O3dqHsp0x6n+1ijjBaBrU2K2yNGAyJwVhl3ITfcL4d2WPbv8xsY/xC5x2G18Xn
         OEQkQQN7FcDeQ3xpWJd4gl1Ybuez36ptAZfiou/ZO8/GVB3qhCyYoNCFBF75nMU2f0j4
         Kcz4JViZRuMg+/cpKbV+Uk1mZezG0e0aW/4OzNXe5BRhIu1xOPA93hIvIn3/bDITeORD
         dBMA==
X-Gm-Message-State: AFqh2koyeePHhcRI4Splhkdlz1xkMrZ6Udgk2hTzpcq5pQV0/O/Qok7J
        oKKJDX4w/OUdqM3HuQssQYc=
X-Google-Smtp-Source: AMrXdXu21Cw8EDdWLJE+Gx2QhAU+kUhfWLZe3K99P+q3DN9Bvd1zXYiqY7mxt2PlUBK/y56bnEYjNg==
X-Received: by 2002:a1c:f317:0:b0:3d0:480b:ac53 with SMTP id q23-20020a1cf317000000b003d0480bac53mr20802700wmq.12.1674392225125;
        Sun, 22 Jan 2023 04:57:05 -0800 (PST)
Received: from [192.168.0.103] ([77.126.105.148])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c458600b003da286f8332sm8081607wmo.18.2023.01.22.04.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 04:57:04 -0800 (PST)
Message-ID: <4dc2a367-d3b1-e73e-5f42-166e9cf84bac@gmail.com>
Date:   Sun, 22 Jan 2023 14:57:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RESEND 0/9] sched: cpumask: improve on
 cpumask_local_spread() locality
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20230121042436.2661843-1-yury.norov@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/01/2023 6:24, Yury Norov wrote:
> cpumask_local_spread() currently checks local node for presence of i'th
> CPU, and then if it finds nothing makes a flat search among all non-local
> CPUs. We can do it better by checking CPUs per NUMA hops.
> 
> This has significant performance implications on NUMA machines, for example
> when using NUMA-aware allocated memory together with NUMA-aware IRQ
> affinity hints.
> 
> Performance tests from patch 8 of this series for mellanox network
> driver show:
> 
>    TCP multi-stream, using 16 iperf3 instances pinned to 16 cores (with aRFS on).
>    Active cores: 64,65,72,73,80,81,88,89,96,97,104,105,112,113,120,121
>    
>    +-------------------------+-----------+------------------+------------------+
>    |                         | BW (Gbps) | TX side CPU util | RX side CPU util |
>    +-------------------------+-----------+------------------+------------------+
>    | Baseline                | 52.3      | 6.4 %            | 17.9 %           |
>    +-------------------------+-----------+------------------+------------------+
>    | Applied on TX side only | 52.6      | 5.2 %            | 18.5 %           |
>    +-------------------------+-----------+------------------+------------------+
>    | Applied on RX side only | 94.9      | 11.9 %           | 27.2 %           |
>    +-------------------------+-----------+------------------+------------------+
>    | Applied on both sides   | 95.1      | 8.4 %            | 27.3 %           |
>    +-------------------------+-----------+------------------+------------------+
>    
>    Bottleneck in RX side is released, reached linerate (~1.8x speedup).
>    ~30% less cpu util on TX.
> 
> This series was supposed to be included in v6.2, but that didn't happen. It
> spent enough in -next without any issues, so I hope we'll finally see it
> in v6.3.
> 
> I believe, the best way would be moving it with scheduler patches, but I'm
> OK to try again with bitmap branch as well.

Now that Yury dropped several controversial bitmap patches form the PR, 
the rest are mostly in sched, or new API that's used by sched.

Valentin, what do you think? Can you take it to your sched branch?

> 
> Tariq Toukan (1):
>    net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
>      hints
> 
> Valentin Schneider (2):
>    sched/topology: Introduce sched_numa_hop_mask()
>    sched/topology: Introduce for_each_numa_hop_mask()
> 
> Yury Norov (6):
>    lib/find: introduce find_nth_and_andnot_bit
>    cpumask: introduce cpumask_nth_and_andnot
>    sched: add sched_numa_find_nth_cpu()
>    cpumask: improve on cpumask_local_spread() locality
>    lib/cpumask: reorganize cpumask_local_spread() logic
>    lib/cpumask: update comment for cpumask_local_spread()
> 
>   drivers/net/ethernet/mellanox/mlx5/core/eq.c | 18 +++-
>   include/linux/cpumask.h                      | 20 +++++
>   include/linux/find.h                         | 33 +++++++
>   include/linux/topology.h                     | 33 +++++++
>   kernel/sched/topology.c                      | 90 ++++++++++++++++++++
>   lib/cpumask.c                                | 52 ++++++-----
>   lib/find_bit.c                               |  9 ++
>   7 files changed, 230 insertions(+), 25 deletions(-)
> 
