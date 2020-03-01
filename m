Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD090174E0E
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 16:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCAPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 10:47:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41512 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgCAPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 10:47:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id v4so9323173wrs.8
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 07:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1oe8WNwD29ev+pV0WnLrQLgORqaqrYFwtbScC2cFpT0=;
        b=iQNDMAxng0wKHpqaBRzutQjfe3gvvzpjqHcJDEocFheArkEuTDpa6dTO81iekOgJbL
         Rg7ExrKJG4ogQfHyyoWe23hRU3vibHgRg3zBiQ3wQ3KoSXuGrfVU0c3RLwUFix6yF95M
         kc27pWCZnwRDwud2i2lt3NZk7d2jaTCD/hk8CiGWtbmTwmko0ejX0FJJDY6W50nA0L+o
         AX4S3oioizGKfsJvfrFyDqByB4HWl+giaLlpxj2IhpP14WdHXTt/E9Up7SKxl/FVwfxU
         SribZoZlDbWPTy4DQ8QxqhfEgLPeeUZzWS2GgTJI7fH6qrXg/ou2y56ltNjMuPuaUbie
         fWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1oe8WNwD29ev+pV0WnLrQLgORqaqrYFwtbScC2cFpT0=;
        b=TN6NEaol4A6ShioWcoZPjG0GRLEdyceH9m+GH5GMYTa3fZ7NKu96tyVYxGeuLGHBam
         8ejGgySU1qdA+6hWZkUUsA/U155NQo6qbjfOI+7EZwpMyEKhDADb82zkhQggBYBCFMNn
         v0IYWIM1K1FPTYLWUNwQIb1+mjV1zI4C/1J9avfdXZlsDErgJ9wiH8wxAbqWDMfVjI8d
         dOh9j0B3NU4u8fbsWzKVNMkRSLvGA6j8KANcRZGxfWTVEMqQE2FfRBAOo6FHavGOYSmf
         3P3EySkX1hYl5tG2YgbhdNyrIukQIghNNRSc1P4uadHKYxYHtYlVED7HVyV+KefN8dxi
         I06w==
X-Gm-Message-State: APjAAAV+ztzdJUfGOWl5gGA8DSqfwUOmvu5zES++Lf6LXkRDUQ0kF2+w
        PTyHHqnWrYHE6oQsyLIJxdWZcA==
X-Google-Smtp-Source: APXvYqx6JpkZ7XjvCzOd5uVMm0MKtgMxJ2Y7JUGMMVGxmTtD6cMkUPXWWqoPDPWutrcg/RuD31G1FQ==
X-Received: by 2002:a5d:55ca:: with SMTP id i10mr16594831wrw.111.1583077622828;
        Sun, 01 Mar 2020 07:47:02 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id o11sm10716188wrn.6.2020.03.01.07.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 07:47:02 -0800 (PST)
Date:   Sun, 1 Mar 2020 16:47:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v2 1/3] net/sched: act_ct: Create nf flow table
 per zone
Message-ID: <20200301154701.GU26061@nanopsycho>
References: <1583067523-1960-1-git-send-email-paulb@mellanox.com>
 <1583067523-1960-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583067523-1960-2-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 01, 2020 at 01:58:41PM CET, paulb@mellanox.com wrote:
>Use the NF flow tables infrastructure for CT offload.
>
>Create a nf flow table per zone.
>
>Next patches will add FT entries to this table, and do
>the software offload.
>
>Signed-off-by: Paul Blakey <paulb@mellanox.com>
>---
>Changelog:
>  v1->v2:
>    Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>    Free ft on last tc act instance instead of last instance + last offloaded tuple,
>    this removes cleanup cb and netfilter patches, and is simpler
>    Removed accidental mlx5/core/en_tc.c change
>    Removed reviewed by Jiri - patch changed
>
> include/net/tc_act/tc_ct.h |   2 +
> net/sched/Kconfig          |   2 +-
> net/sched/act_ct.c         | 143 ++++++++++++++++++++++++++++++++++++++++++++-
> 3 files changed, 145 insertions(+), 2 deletions(-)
>
>diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
>index a8b1564..cf3492e 100644
>--- a/include/net/tc_act/tc_ct.h
>+++ b/include/net/tc_act/tc_ct.h
>@@ -25,6 +25,8 @@ struct tcf_ct_params {
> 	u16 ct_action;
> 
> 	struct rcu_head rcu;
>+
>+	struct tcf_ct_flow_table *ct_ft;
> };
> 
> struct tcf_ct {
>diff --git a/net/sched/Kconfig b/net/sched/Kconfig
>index edde0e5..bfbefb7 100644
>--- a/net/sched/Kconfig
>+++ b/net/sched/Kconfig
>@@ -972,7 +972,7 @@ config NET_ACT_TUNNEL_KEY
> 
> config NET_ACT_CT
> 	tristate "connection tracking tc action"
>-	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
>+	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
> 	help
> 	  Say Y here to allow sending the packets to conntrack module.
> 
>diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>index f685c0d..43dfdd1 100644
>--- a/net/sched/act_ct.c
>+++ b/net/sched/act_ct.c
>@@ -15,6 +15,7 @@
> #include <linux/pkt_cls.h>
> #include <linux/ip.h>
> #include <linux/ipv6.h>
>+#include <linux/rhashtable.h>
> #include <net/netlink.h>
> #include <net/pkt_sched.h>
> #include <net/pkt_cls.h>
>@@ -24,6 +25,7 @@
> #include <uapi/linux/tc_act/tc_ct.h>
> #include <net/tc_act/tc_ct.h>
> 
>+#include <net/netfilter/nf_flow_table.h>
> #include <net/netfilter/nf_conntrack.h>
> #include <net/netfilter/nf_conntrack_core.h>
> #include <net/netfilter/nf_conntrack_zones.h>
>@@ -31,6 +33,117 @@
> #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
> #include <uapi/linux/netfilter/nf_nat.h>
> 
>+static struct workqueue_struct *act_ct_wq;
>+static struct rhashtable zones_ht;
>+static DEFINE_SPINLOCK(zones_lock);
>+
>+struct tcf_ct_flow_table {
>+	struct rhash_head node; /* In zones tables */
>+
>+	struct rcu_work rwork;
>+	struct nf_flowtable nf_ft;
>+	u16 zone;
>+	u32 ref;
>+
>+	bool dying;
>+};
>+
>+static const struct rhashtable_params zones_params = {
>+	.head_offset = offsetof(struct tcf_ct_flow_table, node),
>+	.key_offset = offsetof(struct tcf_ct_flow_table, zone),
>+	.key_len = sizeof_field(struct tcf_ct_flow_table, zone),
>+	.automatic_shrinking = true,
>+};
>+
>+static struct nf_flowtable_type flowtable_ct = {
>+	.owner		= THIS_MODULE,
>+};
>+
>+static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>+{
>+	struct tcf_ct_flow_table *ct_ft, *new_ct_ft;
>+	int err;
>+
>+	spin_lock_bh(&zones_lock);
>+	ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
>+	if (ct_ft)
>+		goto take_ref;
>+
>+	spin_unlock_bh(&zones_lock);
>+	new_ct_ft = kzalloc(sizeof(*new_ct_ft), GFP_KERNEL);

Don't unlock-lock and just use GFP_ATOMIC.


>+	if (!new_ct_ft)
>+		return -ENOMEM;
>+
>+	new_ct_ft->zone = params->zone;
>+	spin_lock_bh(&zones_lock);
>+	ct_ft = rhashtable_lookup_get_insert_fast(&zones_ht, &new_ct_ft->node,
>+						  zones_params);
>+	if (IS_ERR(ct_ft)) {
>+		err = PTR_ERR(ct_ft);
>+		goto err_insert;
>+	} else if (ct_ft) {
>+		/* Already exists */
>+		kfree(new_ct_ft);
>+		goto take_ref;
>+	}
>+
>+	ct_ft = new_ct_ft;
>+	ct_ft->nf_ft.type = &flowtable_ct;
>+	err = nf_flow_table_init(&ct_ft->nf_ft);
>+	if (err)
>+		goto err_init;
>+
>+	__module_get(THIS_MODULE);
>+take_ref:
>+	params->ct_ft = ct_ft;
>+	ct_ft->ref++;
>+	spin_unlock_bh(&zones_lock);
>+
>+	return 0;
>+
>+err_init:
>+	rhashtable_remove_fast(&zones_ht, &new_ct_ft->node, zones_params);
>+err_insert:
>+	spin_unlock_bh(&zones_lock);
>+	kfree(new_ct_ft);
>+	return err;
>+}
>+
>+static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
>+{
>+	struct tcf_ct_flow_table *ct_ft;
>+
>+	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
>+			     rwork);
>+	nf_flow_table_free(&ct_ft->nf_ft);
>+	kfree(ct_ft);
>+
>+	module_put(THIS_MODULE);
>+}
>+
>+static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
>+{
>+	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
>+
>+	spin_lock_bh(&zones_lock);
>+	if (--params->ct_ft->ref == 0) {
>+		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
>+		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
>+		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
>+	}
>+	spin_unlock_bh(&zones_lock);
>+}
>+
>+static int tcf_ct_flow_tables_init(void)
>+{
>+	return rhashtable_init(&zones_ht, &zones_params);
>+}
>+
>+static void tcf_ct_flow_tables_uninit(void)
>+{
>+	rhashtable_destroy(&zones_ht);
>+}
>+
> static struct tc_action_ops act_ct_ops;
> static unsigned int ct_net_id;
> 
>@@ -207,6 +320,8 @@ static void tcf_ct_params_free(struct rcu_head *head)
> 	struct tcf_ct_params *params = container_of(head,
> 						    struct tcf_ct_params, rcu);
> 
>+	tcf_ct_flow_table_put(params);
>+
> 	if (params->tmpl)
> 		nf_conntrack_put(&params->tmpl->ct_general);
> 	kfree(params);
>@@ -730,6 +845,10 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
> 	if (err)
> 		goto cleanup;
> 
>+	err = tcf_ct_flow_table_get(params);
>+	if (err)
>+		goto cleanup;
>+
> 	spin_lock_bh(&c->tcf_lock);
> 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> 	params = rcu_replace_pointer(c->params, params,
>@@ -974,12 +1093,34 @@ static void __net_exit ct_exit_net(struct list_head *net_list)
> 
> static int __init ct_init_module(void)
> {
>-	return tcf_register_action(&act_ct_ops, &ct_net_ops);
>+	int err;
>+
>+	act_ct_wq = alloc_ordered_workqueue("act_ct_workqueue", 0);
>+	if (!act_ct_wq)
>+		return -ENOMEM;
>+
>+	err = tcf_ct_flow_tables_init();
>+	if (err)
>+		goto err_tbl_init;
>+
>+	err = tcf_register_action(&act_ct_ops, &ct_net_ops);
>+	if (err)
>+		goto err_register;
>+
>+	return 0;
>+
>+err_tbl_init:
>+	destroy_workqueue(act_ct_wq);
>+err_register:
>+	tcf_ct_flow_tables_uninit();
>+	return err;
> }
> 
> static void __exit ct_cleanup_module(void)
> {
> 	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
>+	tcf_ct_flow_tables_uninit();
>+	destroy_workqueue(act_ct_wq);
> }
> 
> module_init(ct_init_module);
>-- 
>1.8.3.1
>
