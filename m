Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B365260E65
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgIHJMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:17 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52507 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729124AbgIHJL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1EBA5386;
        Tue,  8 Sep 2020 05:11:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=hDXhsSn/I+yPTiT2ofVCnkTI0j5EpZozPLPr7PAGbvA=; b=XqCHNPEE
        Up5nbDCpfDEi5Idi3D2hmKUIm4q0HMxKe2DDEqV3jLbNcM+6j6eNtYSL4Q7t4Qoa
        VCxbLAfJLeg/JPIqu74fh235MYZXm5SOo+ZNgTAXiELj+HNB6A4STWRpine/rk8V
        AQ/mI+k9qCJuPrg/vshP7/I5Q1sTyORaaUnhWplNz29BryrUfwZEn4x5b/P5Ymgl
        AYZNswK3sKDNoFSnKPlPQtT1VqNAI2lwLtcAXqUjia4u4vxcbxLhtZtNCyG1aLyf
        ZOnxdTSpwukuVwVgY3eRqm3YKM3FvlGhZysmdxnceBk1ixBwzmEo3tlSzoKX4g79
        tO4QRNAkGU1p4g==
X-ME-Sender: <xms:20pXX2Gb_PRA3ehXkIX3gAl4N4MbZrbbgqYtBZ9RN2P8doVHXWVMuw>
    <xme:20pXX3VqieY8HPiBILymxkWdLNgTr27EBQ_e5uvwnfWTuysNtAMN7LV5mQKr8jwE4
    8CzgqKBDbqGbYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:20pXXwLKYy9VAcaUqM4PcALvhASBSGOF3cWU_aDOwqepIUTYYV6Tgg>
    <xmx:20pXXwE7tg_SQfJwUqOcV1r_1uoEK0CVtnF5MzoTMSb1o1tGmaZgbw>
    <xmx:20pXX8XJyegwJFLkOW4xnqbgy2jatN60SMFEpJjOCooVpx9s89gD7A>
    <xmx:20pXXzT8yJ4pPI-622STJNKwmi7iSMcyuRcV9ag61_e9cjNJR7SBMw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53B303064605;
        Tue,  8 Sep 2020 05:11:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 20/22] netdevsim: Add dummy implementation for nexthop offload
Date:   Tue,  8 Sep 2020 12:10:35 +0300
Message-Id: <20200908091037.2709823-21-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement dummy nexthop "offload" in the driver by storing currently
"programmed" nexthops in a hash table. Each nexthop in the hash table is
marked with "trap" indication and increments the nexthops resource
occupancy.

This will later allow us to test the nexthop offload API on top of
netdevsim.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 232 +++++++++++++++++++++++++++++++++++-
 1 file changed, 229 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 3ec0f8896efe..196deed0aa97 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -25,6 +25,7 @@
 #include <net/ip6_fib.h>
 #include <net/fib_rules.h>
 #include <net/net_namespace.h>
+#include <net/nexthop.h>
 
 #include "netdevsim.h"
 
@@ -46,6 +47,8 @@ struct nsim_fib_data {
 	struct rhashtable fib_rt_ht;
 	struct list_head fib_rt_list;
 	spinlock_t fib_lock;	/* Protects hashtable, list and accounting */
+	struct notifier_block nexthop_nb;
+	struct rhashtable nexthop_ht;
 	struct devlink *devlink;
 };
 
@@ -87,6 +90,19 @@ static const struct rhashtable_params nsim_fib_rt_ht_params = {
 	.automatic_shrinking = true,
 };
 
+struct nsim_nexthop {
+	struct rhash_head ht_node;
+	u64 occ;
+	u32 id;
+};
+
+static const struct rhashtable_params nsim_nexthop_ht_params = {
+	.key_offset = offsetof(struct nsim_nexthop, id),
+	.head_offset = offsetof(struct nsim_nexthop, ht_node),
+	.key_len = sizeof(u32),
+	.automatic_shrinking = true,
+};
+
 u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 		     enum nsim_resource_id res_id, bool max)
 {
@@ -845,6 +861,196 @@ static void nsim_fib_dump_inconsistent(struct notifier_block *nb)
 	data->ipv6.rules.num = 0ULL;
 }
 
+static struct nsim_nexthop *nsim_nexthop_create(struct nsim_fib_data *data,
+						struct nh_notifier_info *info)
+{
+	struct nsim_nexthop *nexthop;
+	u64 occ = 0;
+	int i;
+
+	nexthop = kzalloc(sizeof(*nexthop), GFP_KERNEL);
+	if (!nexthop)
+		return NULL;
+
+	nexthop->id = info->id;
+
+	/* Determine the number of nexthop entries the new nexthop will
+	 * occupy.
+	 */
+
+	if (!info->is_grp) {
+		occ = 1;
+		goto out;
+	}
+
+	for (i = 0; i < info->nh_grp->num_nh; i++)
+		occ += info->nh_grp->nh_entries[i].weight;
+
+out:
+	nexthop->occ = occ;
+	return nexthop;
+}
+
+static void nsim_nexthop_destroy(struct nsim_nexthop *nexthop)
+{
+	kfree(nexthop);
+}
+
+static int nsim_nexthop_account(struct nsim_fib_data *data, u64 occ,
+				bool add, struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	if (add) {
+		if (data->nexthops.num + occ <= data->nexthops.max) {
+			data->nexthops.num += occ;
+		} else {
+			err = -ENOSPC;
+			NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported nexthops");
+		}
+	} else {
+		if (WARN_ON(occ > data->nexthops.num))
+			return -EINVAL;
+		data->nexthops.num -= occ;
+	}
+
+	return err;
+}
+
+static int nsim_nexthop_add(struct nsim_fib_data *data,
+			    struct nsim_nexthop *nexthop,
+			    struct netlink_ext_ack *extack)
+{
+	struct net *net = devlink_net(data->devlink);
+	int err;
+
+	err = nsim_nexthop_account(data, nexthop->occ, true, extack);
+	if (err)
+		return err;
+
+	err = rhashtable_insert_fast(&data->nexthop_ht, &nexthop->ht_node,
+				     nsim_nexthop_ht_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to insert nexthop");
+		goto err_nexthop_dismiss;
+	}
+
+	nexthop_hw_flags_set(net, nexthop->id, false, true);
+
+	return 0;
+
+err_nexthop_dismiss:
+	nsim_nexthop_account(data, nexthop->occ, false, extack);
+	return err;
+}
+
+static int nsim_nexthop_replace(struct nsim_fib_data *data,
+				struct nsim_nexthop *nexthop,
+				struct nsim_nexthop *nexthop_old,
+				struct netlink_ext_ack *extack)
+{
+	struct net *net = devlink_net(data->devlink);
+	int err;
+
+	err = nsim_nexthop_account(data, nexthop->occ, true, extack);
+	if (err)
+		return err;
+
+	err = rhashtable_replace_fast(&data->nexthop_ht,
+				      &nexthop_old->ht_node, &nexthop->ht_node,
+				      nsim_nexthop_ht_params);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to replace nexthop");
+		goto err_nexthop_dismiss;
+	}
+
+	nexthop_hw_flags_set(net, nexthop->id, false, true);
+	nsim_nexthop_account(data, nexthop_old->occ, false, extack);
+	nsim_nexthop_destroy(nexthop_old);
+
+	return 0;
+
+err_nexthop_dismiss:
+	nsim_nexthop_account(data, nexthop->occ, false, extack);
+	return err;
+}
+
+static int nsim_nexthop_insert(struct nsim_fib_data *data,
+			       struct nh_notifier_info *info)
+{
+	struct nsim_nexthop *nexthop, *nexthop_old;
+	int err;
+
+	nexthop = nsim_nexthop_create(data, info);
+	if (!nexthop)
+		return -ENOMEM;
+
+	nexthop_old = rhashtable_lookup_fast(&data->nexthop_ht, &info->id,
+					     nsim_nexthop_ht_params);
+	if (!nexthop_old)
+		err = nsim_nexthop_add(data, nexthop, info->extack);
+	else
+		err = nsim_nexthop_replace(data, nexthop, nexthop_old,
+					   info->extack);
+
+	if (err)
+		nsim_nexthop_destroy(nexthop);
+
+	return err;
+}
+
+static void nsim_nexthop_remove(struct nsim_fib_data *data,
+				struct nh_notifier_info *info)
+{
+	struct nsim_nexthop *nexthop;
+
+	nexthop = rhashtable_lookup_fast(&data->nexthop_ht, &info->id,
+					 nsim_nexthop_ht_params);
+	if (!nexthop)
+		return;
+
+	rhashtable_remove_fast(&data->nexthop_ht, &nexthop->ht_node,
+			       nsim_nexthop_ht_params);
+	nsim_nexthop_account(data, nexthop->occ, false, info->extack);
+	nsim_nexthop_destroy(nexthop);
+}
+
+static int nsim_nexthop_event_nb(struct notifier_block *nb, unsigned long event,
+				 void *ptr)
+{
+	struct nsim_fib_data *data = container_of(nb, struct nsim_fib_data,
+						  nexthop_nb);
+	struct nh_notifier_info *info = ptr;
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	switch (event) {
+	case NEXTHOP_EVENT_REPLACE:
+		err = nsim_nexthop_insert(data, info);
+		break;
+	case NEXTHOP_EVENT_DEL:
+		nsim_nexthop_remove(data, info);
+		break;
+	default:
+		break;
+	}
+
+	return notifier_from_errno(err);
+}
+
+static void nsim_nexthop_free(void *ptr, void *arg)
+{
+	struct nsim_nexthop *nexthop = ptr;
+	struct nsim_fib_data *data = arg;
+	struct net *net;
+
+	net = devlink_net(data->devlink);
+	nexthop_hw_flags_set(net, nexthop->id, false, false);
+	nsim_nexthop_account(data, nexthop->occ, false, NULL);
+	nsim_nexthop_destroy(nexthop);
+}
+
 static u64 nsim_fib_ipv4_resource_occ_get(void *priv)
 {
 	struct nsim_fib_data *data = priv;
@@ -912,20 +1118,32 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 		return ERR_PTR(-ENOMEM);
 	data->devlink = devlink;
 
+	err = rhashtable_init(&data->nexthop_ht, &nsim_nexthop_ht_params);
+	if (err)
+		goto err_data_free;
+
 	spin_lock_init(&data->fib_lock);
 	INIT_LIST_HEAD(&data->fib_rt_list);
 	err = rhashtable_init(&data->fib_rt_ht, &nsim_fib_rt_ht_params);
 	if (err)
-		goto err_data_free;
+		goto err_rhashtable_nexthop_destroy;
 
 	nsim_fib_set_max_all(data, devlink);
 
+	data->nexthop_nb.notifier_call = nsim_nexthop_event_nb;
+	err = register_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb,
+					extack);
+	if (err) {
+		pr_err("Failed to register nexthop notifier\n");
+		goto err_rhashtable_fib_destroy;
+	}
+
 	data->fib_nb.notifier_call = nsim_fib_event_nb;
 	err = register_fib_notifier(devlink_net(devlink), &data->fib_nb,
 				    nsim_fib_dump_inconsistent, extack);
 	if (err) {
 		pr_err("Failed to register fib notifier\n");
-		goto err_rhashtable_destroy;
+		goto err_nexthop_nb_unregister;
 	}
 
 	devlink_resource_occ_get_register(devlink,
@@ -950,9 +1168,14 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 					  data);
 	return data;
 
-err_rhashtable_destroy:
+err_nexthop_nb_unregister:
+	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
+err_rhashtable_fib_destroy:
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
+err_rhashtable_nexthop_destroy:
+	rhashtable_free_and_destroy(&data->nexthop_ht, nsim_nexthop_free,
+				    data);
 err_data_free:
 	kfree(data);
 	return ERR_PTR(err);
@@ -971,8 +1194,11 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 	devlink_resource_occ_get_unregister(devlink,
 					    NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
+	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
+	rhashtable_free_and_destroy(&data->nexthop_ht, nsim_nexthop_free,
+				    data);
 	WARN_ON_ONCE(!list_empty(&data->fib_rt_list));
 	kfree(data);
 }
-- 
2.26.2

