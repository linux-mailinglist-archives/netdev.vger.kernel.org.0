Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2F460A17A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 13:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiJXLZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 07:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJXLZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 07:25:08 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1355E356ED;
        Mon, 24 Oct 2022 04:25:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c7-20020a05600c0ac700b003c6cad86f38so9545864wmr.2;
        Mon, 24 Oct 2022 04:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OUUR35ehTDFeN/H0q3a+pIzaAP2B8nf388n1HNF1xIs=;
        b=QlxMZYYHGRrb2rT/b6TCaawgOBRWG+HIR0OimIYlvEjcEYjU61F1DSrs4FIEvY8SYz
         a83Ur5fildb9klN+aiwXRRSB98/Kn8qMmOXrnsTBvGWa80ecgSAd9T40VM9CZRHy31CI
         duV/EakH9w/RuqKmEz9WKK/Y8E2pxALdhHBp2iP6QkB6cyRcwMI5CH5gR1BTWDAvETMI
         D5u6FhzCxcVNr47UNw09bBUhjWIjNcXIF7lQKKN3Z4Atm+vQxmUmom/ysNnBQCI+4PdA
         tpB+UW2CQbXcul0uChU3DctLEXQn3DOojo1VYkbGUfm7zCquSVdE320Kjf6ALfc+pNRm
         1+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUUR35ehTDFeN/H0q3a+pIzaAP2B8nf388n1HNF1xIs=;
        b=EKdVikUmNA0KbsESYJcZgaU97LFMNNPPfe87lgZdnmF+fsUoGuGyE8dLk/t93HEcrl
         9DDgp0bHYQzS+mp6tNUl8DZuv7NFLvgWsvM+iT0grs1IjhwnOjOJnneCI6eRDfqwebuw
         8OI/iydwWgYSmQR24x8VYQO/dn6f8cUyNpEIdgLk6HFypyuxj8TYBX1pAJjFQhbNLRZI
         bGU7+XGbkHlomawjK5nikQ6gMDaDt6jYksd/YFarPG0/LPAxgOyeGHz8o7t2Wab8OHb9
         YPADIC19OqOT5LTn/daO7af+uC4MP+ADfx7uCzBt27fh9vQTWFStBOdk+yRFoT2XxSzv
         r5lg==
X-Gm-Message-State: ACrzQf1dJliqEkslW2n5lHRUsWo+xD1AdqOFT4QhkiaETYCXG5knOBJE
        R8+8S3X9H/1BVo8C2SUqE9U=
X-Google-Smtp-Source: AMsMyM69nlhAUhYdqXBkR5szRfh39YjsZOPs6Nz40gMi1UXNLpVk7sLvOI8t8zIMCojUPg8E4eFP7A==
X-Received: by 2002:a1c:7215:0:b0:3c7:130c:a77f with SMTP id n21-20020a1c7215000000b003c7130ca77fmr14290061wmc.151.1666610702487;
        Mon, 24 Oct 2022 04:25:02 -0700 (PDT)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id f9-20020a5d5689000000b002322bff5b3bsm8300379wrv.54.2022.10.24.04.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 04:25:02 -0700 (PDT)
Message-ID: <f250fc62-a4a6-6543-d688-e755729a7291@gmail.com>
Date:   Mon, 24 Oct 2022 14:24:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v5 3/3] net/mlx5e: Improve remote NUMA preferences used
 for the IRQ affinity hints
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20221021121927.2893692-1-vschneid@redhat.com>
 <20221021121927.2893692-4-vschneid@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221021121927.2893692-4-vschneid@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/2022 3:19 PM, Valentin Schneider wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> In the IRQ affinity hints, replace the binary NUMA preference (local /
> remote) with the improved for_each_numa_hop_cpu() API that minds the
> actual distances, so that remote NUMAs with short distance are preferred
> over farther ones.
> 
> This has significant performance implications when using NUMA-aware
> allocated memory (follow [1] and derivatives for example).
> 
> [1]
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c :: mlx5e_open_channel()
>     int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
> 
> Performance tests:
> 
> TCP multi-stream, using 16 iperf3 instances pinned to 16 cores (with aRFS on).
> Active cores: 64,65,72,73,80,81,88,89,96,97,104,105,112,113,120,121
> 
> +-------------------------+-----------+------------------+------------------+
> |                         | BW (Gbps) | TX side CPU util | RX side CPU util |
> +-------------------------+-----------+------------------+------------------+
> | Baseline                | 52.3      | 6.4 %            | 17.9 %           |
> +-------------------------+-----------+------------------+------------------+
> | Applied on TX side only | 52.6      | 5.2 %            | 18.5 %           |
> +-------------------------+-----------+------------------+------------------+
> | Applied on RX side only | 94.9      | 11.9 %           | 27.2 %           |
> +-------------------------+-----------+------------------+------------------+
> | Applied on both sides   | 95.1      | 8.4 %            | 27.3 %           |
> +-------------------------+-----------+------------------+------------------+
> 
> Bottleneck in RX side is released, reached linerate (~1.8x speedup).
> ~30% less cpu util on TX.
> 
> * CPU util on active cores only.
> 
> Setups details (similar for both sides):
> 
> NIC: ConnectX6-DX dual port, 100 Gbps each.
> Single port used in the tests.
> 
> $ lscpu
> Architecture:        x86_64
> CPU op-mode(s):      32-bit, 64-bit
> Byte Order:          Little Endian
> CPU(s):              256
> On-line CPU(s) list: 0-255
> Thread(s) per core:  2
> Core(s) per socket:  64
> Socket(s):           2
> NUMA node(s):        16
> Vendor ID:           AuthenticAMD
> CPU family:          25
> Model:               1
> Model name:          AMD EPYC 7763 64-Core Processor
> Stepping:            1
> CPU MHz:             2594.804
> BogoMIPS:            4890.73
> Virtualization:      AMD-V
> L1d cache:           32K
> L1i cache:           32K
> L2 cache:            512K
> L3 cache:            32768K
> NUMA node0 CPU(s):   0-7,128-135
> NUMA node1 CPU(s):   8-15,136-143
> NUMA node2 CPU(s):   16-23,144-151
> NUMA node3 CPU(s):   24-31,152-159
> NUMA node4 CPU(s):   32-39,160-167
> NUMA node5 CPU(s):   40-47,168-175
> NUMA node6 CPU(s):   48-55,176-183
> NUMA node7 CPU(s):   56-63,184-191
> NUMA node8 CPU(s):   64-71,192-199
> NUMA node9 CPU(s):   72-79,200-207
> NUMA node10 CPU(s):  80-87,208-215
> NUMA node11 CPU(s):  88-95,216-223
> NUMA node12 CPU(s):  96-103,224-231
> NUMA node13 CPU(s):  104-111,232-239
> NUMA node14 CPU(s):  112-119,240-247
> NUMA node15 CPU(s):  120-127,248-255
> ..
...
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> [Tweaked API use]

Thanks for your modification.
It looks good to me.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/eq.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> index a0242dc15741c..7acbeb3d51846 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
> @@ -812,9 +812,12 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
>   static int comp_irqs_request(struct mlx5_core_dev *dev)
>   {
>   	struct mlx5_eq_table *table = dev->priv.eq_table;
> +	const struct cpumask *prev = cpu_none_mask;
> +	const struct cpumask *mask;
>   	int ncomp_eqs = table->num_comp_eqs;
>   	u16 *cpus;
>   	int ret;
> +	int cpu;
>   	int i;
>   
>   	ncomp_eqs = table->num_comp_eqs;
> @@ -833,8 +836,19 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
>   		ret = -ENOMEM;
>   		goto free_irqs;
>   	}
> -	for (i = 0; i < ncomp_eqs; i++)
> -		cpus[i] = cpumask_local_spread(i, dev->priv.numa_node);
> +
> +	i = 0;
> +	rcu_read_lock();
> +	for_each_numa_hop_mask(mask, dev->priv.numa_node) {
> +		for_each_cpu_andnot(cpu, mask, prev) {
> +			cpus[i] = cpu;
> +			if (++i == ncomp_eqs)
> +				goto spread_done;
> +		}
> +		prev = mask;
> +	}
> +spread_done:
> +	rcu_read_unlock();
>   	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
>   	kfree(cpus);
>   	if (ret < 0)
