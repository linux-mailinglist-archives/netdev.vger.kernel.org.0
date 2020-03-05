Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B196717B213
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgCEXLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:11:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCEXLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 18:11:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D72215BF4CA0;
        Thu,  5 Mar 2020 15:11:17 -0800 (PST)
Date:   Thu, 05 Mar 2020 15:11:16 -0800 (PST)
Message-Id: <20200305.151116.1903646395885882747.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
Subject: Re: [PATCH net-next ct-offload 02/13] net/sched: act_ct:
 Instantiate flow table entry actions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583422468-8456-3-git-send-email-paulb@mellanox.com>
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
        <1583422468-8456-3-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 15:11:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Thu,  5 Mar 2020 17:34:17 +0200

> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 23eba61..0773456 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -55,7 +55,199 @@ struct tcf_ct_flow_table {
>  	.automatic_shrinking = true,
>  };
>  
> +static inline struct flow_action_entry *
> +tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)

Please don't use inline in foo.c files.

Thank you.
