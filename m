Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17B3652CA
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 10:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfGKIGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 04:06:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50216 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGKIGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 04:06:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so4694209wml.0
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 01:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oqevrJONN3ESE3CjylotV1W6S3M7ydqFWBZGqjrV1NY=;
        b=C6lT9nFuC8TjHGW/BTSALfjVVEooDIQ9l8HaogcFwGTl7L40yJ/qOFPdqzRTWHyE8w
         SHK+623z1/EH3B+OhmjvwYyRU2HhVplmRAkOFnUt3M8zOlb6bcPRIkJxMGjo6sOY4kW6
         mW0q6JZigXj31NjNy0r4dRphQEGbhbLB6j4OjQ/Wro1Uxcm2JW/BNsDFn3z5Ie0fIG6u
         Goh6UYBFlKYLHSW/h8Ec97N8UyHFicv+B0u4ttYKht4l1nsATdF4TH4iGLyPdDxw+PCG
         /u0ZxrntTBlWMj0Ki5IHEzPd0/Bks+tTHIV0TIhnqHC0rHpcHoWV8M8itHQnoAKxzhty
         tdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oqevrJONN3ESE3CjylotV1W6S3M7ydqFWBZGqjrV1NY=;
        b=eAg6JlA7XlSEURvOzrDlOPxlBeoFrzn8uY8Op15MaCV6YtIl+Evq0EpWRJ1f/uWCDw
         nUUNWsoUlQbdbBETXg7rLVtaawmo7XET+h/5vIc7xLIMoif4a5mhZih4rJ8gzi/goDat
         yj9jD9/Usy7b9xWAp3hp0bX41JYtyEo4ff4e5YTaJWJhDrK++ziK6IwpmJopOv5Lhdx4
         ex10MK6ynZVJD3PvE/fmHlXrs8IDO3q1aBy0Kb3o6zhT4O7zjl3gZZPkPV+0mvC6qf80
         Mk5BEkWTABQDhmtpj/iNzEAs8Va1IdrFrcDzs+dWwD3gQNTqjgkwvQZk/gfOeE/Hh0y5
         TsbQ==
X-Gm-Message-State: APjAAAWP8NfRa1GH5+pYm2jtqnC2+QaNuH9dmkrF8d+IjuewAMoYJIFO
        GoMsFvP04d3tMwm3Ufs5a4I=
X-Google-Smtp-Source: APXvYqwXVe9uhwha5MkOtC649NgbGAuRdLheslz4p7UscFaD8Aag70Kd2T9mNS2wlzagDrzobIyWTg==
X-Received: by 2002:a7b:c313:: with SMTP id k19mr2574081wmj.2.1562832370554;
        Thu, 11 Jul 2019 01:06:10 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id 18sm4920224wmg.43.2019.07.11.01.06.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 01:06:09 -0700 (PDT)
Date:   Thu, 11 Jul 2019 10:06:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 3/3] net: flow_offload: add flow_block structure
 and use it
Message-ID: <20190711080609.GF2291@nanopsycho>
References: <20190711001235.20686-1-pablo@netfilter.org>
 <20190711001235.20686-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711001235.20686-3-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 11, 2019 at 02:12:35AM CEST, pablo@netfilter.org wrote:
>This object stores the flow block callbacks that are attached to this
>block. This patch restores block sharing.
>
>Fixes: da3eeb904ff4 ("net: flow_offload: add list handling functions")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
> include/net/flow_offload.h        |  5 +++++
> include/net/netfilter/nf_tables.h |  5 +++--
> include/net/sch_generic.h         |  2 +-
> net/core/flow_offload.c           |  2 +-
> net/netfilter/nf_tables_api.c     |  2 +-
> net/netfilter/nf_tables_offload.c |  5 +++--
> net/sched/cls_api.c               | 10 +++++++---
> 7 files changed, 21 insertions(+), 10 deletions(-)
>
>diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>index 98bf3af5c84d..e50d94736829 100644
>--- a/include/net/flow_offload.h
>+++ b/include/net/flow_offload.h
>@@ -248,6 +248,10 @@ enum flow_block_binder_type {
> 	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
> };
> 
>+struct flow_block {
>+	struct list_head cb_list;
>+};
>+
> struct netlink_ext_ack;
> 
> struct flow_block_offload {
>@@ -255,6 +259,7 @@ struct flow_block_offload {
> 	enum flow_block_binder_type binder_type;
> 	bool block_shared;
> 	struct net *net;
>+	struct flow_block *block;
> 	struct list_head cb_list;
> 	struct list_head *driver_block_list;
> 	struct netlink_ext_ack *extack;
>diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
>index 35dfdd9f69b3..00658462f89b 100644
>--- a/include/net/netfilter/nf_tables.h
>+++ b/include/net/netfilter/nf_tables.h
>@@ -11,6 +11,7 @@
> #include <linux/rhashtable.h>
> #include <net/netfilter/nf_flow_table.h>
> #include <net/netlink.h>
>+#include <net/flow_offload.h>
> 
> struct module;
> 
>@@ -951,7 +952,7 @@ struct nft_stats {
>  *	@stats: per-cpu chain stats
>  *	@chain: the chain
>  *	@dev_name: device name that this base chain is attached to (if any)
>- *	@cb_list: list of flow block callbacks (for hardware offload)
>+ *	@block: flow block (for hardware offload)
>  */
> struct nft_base_chain {
> 	struct nf_hook_ops		ops;
>@@ -961,7 +962,7 @@ struct nft_base_chain {
> 	struct nft_stats __percpu	*stats;
> 	struct nft_chain		chain;
> 	char 				dev_name[IFNAMSIZ];
>-	struct list_head		cb_list;
>+	struct flow_block		block;
> };
> 
> static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chain)
>diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>index 9482e060483b..58041cb0ce15 100644
>--- a/include/net/sch_generic.h
>+++ b/include/net/sch_generic.h
>@@ -399,7 +399,7 @@ struct tcf_block {
> 	refcount_t refcnt;
> 	struct net *net;
> 	struct Qdisc *q;
>-	struct list_head cb_list;
>+	struct flow_block flow;

It is not a "flow", that is confusing. It should be named "flow_block".


> 	struct list_head owner_list;
> 	bool keep_dst;
> 	unsigned int offloadcnt; /* Number of oddloaded filters */
>diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
>index a800fa78d96c..935c7f81a9ef 100644
>--- a/net/core/flow_offload.c
>+++ b/net/core/flow_offload.c
>@@ -198,7 +198,7 @@ struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
> {
> 	struct flow_block_cb *block_cb;
> 
>-	list_for_each_entry(block_cb, f->driver_block_list, driver_list) {
>+	list_for_each_entry(block_cb, &f->block->cb_list, list) {

Please made struct flow_block *block and argument of cb_lookup instead
of struct flow_block_offload *f (as it was previously).


> 		if (block_cb->cb == cb &&
> 		    block_cb->cb_ident == cb_ident)
> 			return block_cb;
>diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>index ed17a7c29b86..c565f146435b 100644
>--- a/net/netfilter/nf_tables_api.c
>+++ b/net/netfilter/nf_tables_api.c
>@@ -1662,7 +1662,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
> 
> 		chain->flags |= NFT_BASE_CHAIN | flags;
> 		basechain->policy = NF_ACCEPT;
>-		INIT_LIST_HEAD(&basechain->cb_list);
>+		INIT_LIST_HEAD(&basechain->block.cb_list);
> 	} else {
> 		chain = kzalloc(sizeof(*chain), GFP_KERNEL);
> 		if (chain == NULL)
>diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
>index 2c3302845f67..2a184277ee58 100644
>--- a/net/netfilter/nf_tables_offload.c
>+++ b/net/netfilter/nf_tables_offload.c
>@@ -116,7 +116,7 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
> 	struct flow_block_cb *block_cb;
> 	int err;
> 
>-	list_for_each_entry(block_cb, &basechain->cb_list, list) {
>+	list_for_each_entry(block_cb, &basechain->block.cb_list, list) {
> 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
> 		if (err < 0)
> 			return err;
>@@ -154,7 +154,7 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
> static int nft_flow_offload_bind(struct flow_block_offload *bo,
> 				 struct nft_base_chain *basechain)
> {
>-	list_splice(&bo->cb_list, &basechain->cb_list);
>+	list_splice(&bo->cb_list, &basechain->block.cb_list);
> 	return 0;
> }
> 
>@@ -198,6 +198,7 @@ static int nft_flow_offload_chain(struct nft_trans *trans,
> 		return -EOPNOTSUPP;
> 
> 	bo.command = cmd;
>+	bo.block = &basechain->block;
> 	bo.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
> 	bo.extack = &extack;
> 	INIT_LIST_HEAD(&bo.cb_list);
>diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>index 51fbe6e95a92..66181961ad6f 100644
>--- a/net/sched/cls_api.c
>+++ b/net/sched/cls_api.c
>@@ -691,6 +691,8 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
> 	if (!indr_dev->block)
> 		return;
> 
>+	bo.block = &indr_dev->block->flow;
>+
> 	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
> 			  &bo);
> 	tcf_block_setup(indr_dev->block, &bo);
>@@ -775,6 +777,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
> 		.command	= command,
> 		.binder_type	= ei->binder_type,
> 		.net		= dev_net(dev),
>+		.block		= &block->flow,
> 		.block_shared	= tcf_block_shared(block),
> 		.extack		= extack,
> 	};
>@@ -810,6 +813,7 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
> 	bo.net = dev_net(dev);
> 	bo.command = command;
> 	bo.binder_type = ei->binder_type;
>+	bo.block = &block->flow;
> 	bo.block_shared = tcf_block_shared(block);
> 	bo.extack = extack;
> 	INIT_LIST_HEAD(&bo.cb_list);
>@@ -988,7 +992,7 @@ static struct tcf_block *tcf_block_create(struct net *net, struct Qdisc *q,
> 	}
> 	mutex_init(&block->lock);
> 	INIT_LIST_HEAD(&block->chain_list);
>-	INIT_LIST_HEAD(&block->cb_list);
>+	INIT_LIST_HEAD(&block->flow.cb_list);

With introduction of struct flow_block, please introduce also a helper
to init this struct. Does not look right to init it from user codes
(tc/nft).


> 	INIT_LIST_HEAD(&block->owner_list);
> 	INIT_LIST_HEAD(&block->chain0.filter_chain_list);
> 
>@@ -1570,7 +1574,7 @@ static int tcf_block_bind(struct tcf_block *block,
> 
> 		i++;
> 	}
>-	list_splice(&bo->cb_list, &block->cb_list);
>+	list_splice(&bo->cb_list, &block->flow.cb_list);
> 
> 	return 0;
> 
>@@ -3155,7 +3159,7 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> 	if (block->nooffloaddevcnt && err_stop)
> 		return -EOPNOTSUPP;
> 
>-	list_for_each_entry(block_cb, &block->cb_list, list) {
>+	list_for_each_entry(block_cb, &block->flow.cb_list, list) {
> 		err = block_cb->cb(type, type_data, block_cb->cb_priv);
> 		if (err) {
> 			if (err_stop)
>-- 
>2.11.0
>
>
