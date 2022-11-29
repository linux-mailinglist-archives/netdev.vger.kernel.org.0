Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1F063BF72
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 12:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiK2Lyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 06:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiK2Lyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 06:54:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C11054B3B;
        Tue, 29 Nov 2022 03:54:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1170E616E3;
        Tue, 29 Nov 2022 11:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A2CC433C1;
        Tue, 29 Nov 2022 11:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669722882;
        bh=B358EqJzHqfHpVOoVQSjd9p9tjUfi8PFDuOsY9VvxPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V6eqmIXK18Ikxo0VVZTQfqu8URAT72PYmw1ka2tAjj0v65afbAjuu6S6P+nZLpKJr
         rMDKhgjld9Q+zpQoNind9nqQ/DYr/XdcS8tTzrAxMTckFAqHn+xSs5XhDAvG8/LL1a
         Ekalo/xJ2HTUz0lLYBwArSwqKpJlYFSBgtbgKbIXrGWkSS8lOLUE6HzOol9YXJkAqb
         tAMUfiRhUKfb2uNqCa4Tg6pmbF0qG9N85XCIF6MKJ73D4ZkXYnjKseCsIpUM862AXr
         zrmhqJClU3zMQ6WRaoSDrgx13+ZgWXerhu3AH0Op9HMjrXA7U/H58Jc5glcZN9yfan
         EYTdRFs1+MzGw==
Date:   Tue, 29 Nov 2022 12:54:39 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/4] sched/isolation: Improve documentation
Message-ID: <20221129115439.GA1715045@lothringen>
References: <20221013184028.129486-1-leobras@redhat.com>
 <20221013184028.129486-3-leobras@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013184028.129486-3-leobras@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 03:40:27PM -0300, Leonardo Bras wrote:
> Improve documentation on housekeeping types and what to expect from
> housekeeping functions.
> 
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
> ---
>  include/linux/sched/isolation.h | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index 762701f295d1c..9333c28153a7a 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -7,18 +7,25 @@
>  #include <linux/tick.h>
>  
>  enum hk_type {
> -	HK_TYPE_TIMER,
> -	HK_TYPE_RCU,
> -	HK_TYPE_MISC,
> -	HK_TYPE_SCHED,
> -	HK_TYPE_TICK,
> -	HK_TYPE_DOMAIN,
> -	HK_TYPE_WQ,
> -	HK_TYPE_MANAGED_IRQ,
> -	HK_TYPE_KTHREAD,
> +	HK_TYPE_TIMER,		/* Timer interrupt, watchdogs */

More precisely:

     /* Unbound timer callbacks */

> +	HK_TYPE_RCU,		/* RCU callbacks */

More generally, because it's more than just about callbacks:

     /* Unbound RCU work */

> +	HK_TYPE_MISC,		/* Minor housekeeping categories */
> +	HK_TYPE_SCHED,		/* Scheduling and idle load balancing */
> +	HK_TYPE_TICK,		/* See isolcpus=nohz boot parameter */

Yes or nohz_full=

> +	HK_TYPE_DOMAIN,		/* See isolcpus=domain boot parameter*/
> +	HK_TYPE_WQ,		/* Work Queues*/

  /* Unbound workqueues */

> +	HK_TYPE_MANAGED_IRQ,	/* See isolcpus=managed_irq boot parameter */
> +	HK_TYPE_KTHREAD,	/* kernel threads */

  /* Unbound kernel threads */


>  	HK_TYPE_MAX
>  };
>  
> +/* Kernel parameters like nohz_full and isolcpus allow passing cpu numbers
> + * for disabling housekeeping types.
> + *
> + * The functions bellow work the opposite way, by referencing which cpus
> + * are able to perform the housekeeping type in parameter.
> + */

*below

Thanks!

> +
>  #ifdef CONFIG_CPU_ISOLATION
>  DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
>  int housekeeping_any_cpu(enum hk_type type);
> -- 
> 2.38.0
> 
