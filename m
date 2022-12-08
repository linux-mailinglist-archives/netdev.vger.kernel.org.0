Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D5F647725
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiLHUWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiLHUW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:22:29 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A5E5AE1C;
        Thu,  8 Dec 2022 12:22:28 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vv4so6727130ejc.2;
        Thu, 08 Dec 2022 12:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lkh1P1g6SdIbuYu0UMr6qddEILkP0nJO6Y1lmSw3rRI=;
        b=HfC+cuf95xAP9a2NmUTOfNtQEUuignCAFg9w1eMrFdH6Vo8UMj9zVH4SEFLTl6ra7I
         wAQoJ4WXvv3xjUOCtCeVj31tds1y+iyM/Sq3m9+eVgf3hNnwvdSJLX5GlZkwxZqDrTLQ
         3i5cCJDaaHmRj8mscGATkZi3irV4X3C1AJQ4STWcY63q1i8cQYiUjWF1Dg3SzQKh717L
         RgcjlRxo+ndmNDqS/VKJw4ihlMJ1Bi0WTOEMRfAkHlew1ZE/DnXV837j76uPn0X6AeiO
         UxoQC8+ffaO2oC3rQ2vTC8toMBaQu4mAglUCbRXC1f0VjU4QSKa81Xt9E1IyXx5535Ib
         SG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkh1P1g6SdIbuYu0UMr6qddEILkP0nJO6Y1lmSw3rRI=;
        b=f+EEh/Zl+PUq0D5bz01xfADkpo5hxluzi1yi9aQQOMt0f5i0jWUpRdzuXcMdLt9If2
         YQf0L9HdJ5crUSWvflh6Taz6OUdbyfO0OyHaLnSfycmfrH0VWF9ooXiXEoM8/Tocw99j
         lQBblO/lP7VpGhu31Rqv6XgEbLYrFLzVhHRnpO7ch0jK7jokHZQ0qSD5wx6doCSF9mDS
         xNtqtsK8Yh78Gs3l5E5CC59szb/dR/HnbNytsN0fejaBSFNOO9hDHgDjkZpT+icJp6SM
         1fkZf8IN5EIVJz2KhkH3OVicqDI/2/nXMuzY+iagGJWdTuxBYazRdbDLBhqtrzw6aTpg
         dfXg==
X-Gm-Message-State: ANoB5pmlLYIq5IWLSjpMySkZNydZ4aodstRfdDDQ0UZ2kLUgAeEIMaMz
        JwJ+jJQibJYZst74d2Ban1Y=
X-Google-Smtp-Source: AA0mqf4EjMWAqV4kOPGD+L7AFqn8+NNq78OATWVuNAGBCyxTjPGCQQsP8ASH/8u4kktDI/IID9hynA==
X-Received: by 2002:a17:907:76f2:b0:7c0:eb3c:1037 with SMTP id kg18-20020a17090776f200b007c0eb3c1037mr14884853ejc.663.1670530947039;
        Thu, 08 Dec 2022 12:22:27 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id p10-20020a170906838a00b007c0dacbe00bsm6439680ejx.115.2022.12.08.12.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 12:22:26 -0800 (PST)
Message-ID: <1efd1d75-9c5d-4827-3d28-bef044801859@gmail.com>
Date:   Thu, 8 Dec 2022 22:22:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 0/5] cpumask: improve on cpumask_local_spread()
 locality
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
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
References: <20221208183101.1162006-1-yury.norov@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221208183101.1162006-1-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2022 8:30 PM, Yury Norov wrote:
> cpumask_local_spread() currently checks local node for presence of i'th
> CPU, and then if it finds nothing makes a flat search among all non-local
> CPUs. We can do it better by checking CPUs per NUMA hops.
> 
> This series is inspired by Tariq Toukan and Valentin Schneider's
> "net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
> hints"
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/
> 
> According to their measurements, for mlx5e:
> 
>          Bottleneck in RX side is released, reached linerate (~1.8x speedup).
>          ~30% less cpu util on TX.
> 
> This patch makes cpumask_local_spread() traversing CPUs based on NUMA
> distance, just as well, and I expect comparable improvement for its
> users, as in case of mlx5e.
> 
> I tested new behavior on my VM with the following NUMA configuration:
> 
> root@debian:~# numactl -H
> available: 4 nodes (0-3)
> node 0 cpus: 0 1 2 3
> node 0 size: 3869 MB
> node 0 free: 3740 MB
> node 1 cpus: 4 5
> node 1 size: 1969 MB
> node 1 free: 1937 MB
> node 2 cpus: 6 7
> node 2 size: 1967 MB
> node 2 free: 1873 MB
> node 3 cpus: 8 9 10 11 12 13 14 15
> node 3 size: 7842 MB
> node 3 free: 7723 MB
> node distances:
> node   0   1   2   3
>    0:  10  50  30  70
>    1:  50  10  70  30
>    2:  30  70  10  50
>    3:  70  30  50  10
> 
> And the cpumask_local_spread() for each node and offset traversing looks
> like this:
> 
> node 0:   0   1   2   3   6   7   4   5   8   9  10  11  12  13  14  15
> node 1:   4   5   8   9  10  11  12  13  14  15   0   1   2   3   6   7
> node 2:   6   7   0   1   2   3   8   9  10  11  12  13  14  15   4   5
> node 3:   8   9  10  11  12  13  14  15   4   5   6   7   0   1   2   3
> 
> v1: https://lore.kernel.org/lkml/20221111040027.621646-5-yury.norov@gmail.com/T/
> v2: https://lore.kernel.org/all/20221112190946.728270-3-yury.norov@gmail.com/T/
> v3:
>   - fix typo in find_nth_and_andnot_bit();
>   - add 5th patch that simplifies cpumask_local_spread();
>   - address various coding style nits.
> 
> Yury Norov (5):
>    lib/find: introduce find_nth_and_andnot_bit
>    cpumask: introduce cpumask_nth_and_andnot
>    sched: add sched_numa_find_nth_cpu()
>    cpumask: improve on cpumask_local_spread() locality
>    lib/cpumask: reorganize cpumask_local_spread() logic
> 
>   include/linux/cpumask.h  | 20 ++++++++++++++
>   include/linux/find.h     | 33 +++++++++++++++++++++++
>   include/linux/topology.h |  8 ++++++
>   kernel/sched/topology.c  | 57 ++++++++++++++++++++++++++++++++++++++++
>   lib/cpumask.c            | 26 +++++-------------
>   lib/find_bit.c           |  9 +++++++
>   6 files changed, 134 insertions(+), 19 deletions(-)
> 

Acked-by: Tariq Toukan <tariqt@nvidia.com>
