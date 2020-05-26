Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D311BA78C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgD0PNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49009 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728032AbgD0PNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8D6475C00D9;
        Mon, 27 Apr 2020 11:13:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=WvjGDBFEwymostXPewBS+i6fLC/eFmKuqPLLP6P7QGQ=; b=BpInFu2T
        /mxnguKWxgX2qg22ubSh36TlsCSnW/N9/Vc4begjEaOwk0whlAiiXn+vXMiAqu5x
        m6LcyGPNUs1lhNUJIqWPggWqMeScA5ybDOkNEpbVf09lgfQsgo8JrbXmB7lfLQoQ
        BczneNrGmy1jNC3JqHbwUM7XcGOSUB8a/LoJvVXWWm2ypzMVaGtIo9aoKKODxWPG
        2Ff9W/CPyjnMqR4sqqzfiilrKHJsjsso0GHgNOLa/7xH9V5yM5jJVww3kTr1R4Ma
        HEtte5PLNafT/DwgvVWcajlm94wuPuNdQBPpS1GJfq0zmFc9bmsJBUQtgdXFtE7E
        +s6EMXnQ6dh+Kg==
X-ME-Sender: <xms:oPamXg7zFqO3JN46mjvvZWGsOSu1BtdvxaHpEIzwhAz4mIyZTFiE4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:oPamXj6mDzQbzvF27GbSLOTapeTF6aurcGf-3fnZN0xpyLFyEN9eyw>
    <xmx:oPamXjtnkOHm_3P-_KSvosEIa-n2twAZgjLgvTg73Uy0LiaZq8aBsQ>
    <xmx:oPamXgG8IK3zIxHGcIVJCzd5Ngf0pEjgr36OmZA00LW84j-HCI_Mhw>
    <xmx:oPamXq4OVCHFZrv4Tv_9NvNnWzdeGQOl_-e_-28OmYhDVkE9IgG7MQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51E323280059;
        Mon, 27 Apr 2020 11:13:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/13] mlxsw: spectrum: Push matchall bits into a separate file
Date:   Mon, 27 Apr 2020 18:13:01 +0300
Message-Id: <20200427151310.3950411-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Similar to flower, have matchall related code in a separate file.
Do some small renaming on the way (consistent "mall" prefixes,
dropped "_tc_", dropped "_port_" where suitable).

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 186 +---------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  28 +--
 .../mellanox/mlxsw/spectrum_matchall.c        | 202 ++++++++++++++++++
 4 files changed, 214 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index 59cbf02d6731..4aeabb35c943 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -21,7 +21,7 @@ mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
 				   spectrum_acl_atcam.o spectrum_acl_erp.o \
 				   spectrum1_acl_tcam.o spectrum2_acl_tcam.o \
 				   spectrum_acl_bloom_filter.o spectrum_acl.o \
-				   spectrum_flow.o \
+				   spectrum_flow.o spectrum_matchall.o \
 				   spectrum_flower.o spectrum_cnt.o \
 				   spectrum_fid.o spectrum_ipip.o \
 				   spectrum_acl_flex_actions.o \
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f64e8da21d4a..ff25f8fc55e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -25,9 +25,7 @@
 #include <linux/log2.h>
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
-#include <net/tc_act/tc_mirred.h>
 #include <net/netevent.h>
-#include <net/tc_act/tc_sample.h>
 #include <net/addrconf.h>
 
 #include "spectrum.h"
@@ -582,16 +580,6 @@ static int mlxsw_sp_base_mac_get(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 }
 
-static int mlxsw_sp_port_sample_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				    bool enable, u32 rate)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char mpsc_pl[MLXSW_REG_MPSC_LEN];
-
-	mlxsw_reg_mpsc_pack(mpsc_pl, mlxsw_sp_port->local_port, enable, rate);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpsc), mpsc_pl);
-}
-
 static int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					  bool is_up)
 {
@@ -1362,181 +1350,15 @@ static int mlxsw_sp_port_kill_vid(struct net_device *dev,
 	return 0;
 }
 
-static struct mlxsw_sp_port_mall_tc_entry *
-mlxsw_sp_port_mall_tc_entry_find(struct mlxsw_sp_port *port,
-				 unsigned long cookie) {
-	struct mlxsw_sp_port_mall_tc_entry *mall_tc_entry;
-
-	list_for_each_entry(mall_tc_entry, &port->mall_tc_list, list)
-		if (mall_tc_entry->cookie == cookie)
-			return mall_tc_entry;
-
-	return NULL;
-}
-
-static int
-mlxsw_sp_port_add_cls_matchall_mirror(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct mlxsw_sp_port_mall_mirror_tc_entry *mirror,
-				      const struct flow_action_entry *act,
-				      bool ingress)
-{
-	enum mlxsw_sp_span_type span_type;
-
-	if (!act->dev) {
-		netdev_err(mlxsw_sp_port->dev, "Could not find requested device\n");
-		return -EINVAL;
-	}
-
-	mirror->ingress = ingress;
-	span_type = ingress ? MLXSW_SP_SPAN_INGRESS : MLXSW_SP_SPAN_EGRESS;
-	return mlxsw_sp_span_mirror_add(mlxsw_sp_port, act->dev, span_type,
-					true, &mirror->span_id);
-}
-
-static void
-mlxsw_sp_port_del_cls_matchall_mirror(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct mlxsw_sp_port_mall_mirror_tc_entry *mirror)
-{
-	enum mlxsw_sp_span_type span_type;
-
-	span_type = mirror->ingress ?
-			MLXSW_SP_SPAN_INGRESS : MLXSW_SP_SPAN_EGRESS;
-	mlxsw_sp_span_mirror_del(mlxsw_sp_port, mirror->span_id,
-				 span_type, true);
-}
-
-static int
-mlxsw_sp_port_add_cls_matchall_sample(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct tc_cls_matchall_offload *cls,
-				      const struct flow_action_entry *act,
-				      bool ingress)
-{
-	int err;
-
-	if (!mlxsw_sp_port->sample)
-		return -EOPNOTSUPP;
-	if (rtnl_dereference(mlxsw_sp_port->sample->psample_group)) {
-		netdev_err(mlxsw_sp_port->dev, "sample already active\n");
-		return -EEXIST;
-	}
-	if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
-		netdev_err(mlxsw_sp_port->dev, "sample rate not supported\n");
-		return -EOPNOTSUPP;
-	}
-
-	rcu_assign_pointer(mlxsw_sp_port->sample->psample_group,
-			   act->sample.psample_group);
-	mlxsw_sp_port->sample->truncate = act->sample.truncate;
-	mlxsw_sp_port->sample->trunc_size = act->sample.trunc_size;
-	mlxsw_sp_port->sample->rate = act->sample.rate;
-
-	err = mlxsw_sp_port_sample_set(mlxsw_sp_port, true, act->sample.rate);
-	if (err)
-		goto err_port_sample_set;
-	return 0;
-
-err_port_sample_set:
-	RCU_INIT_POINTER(mlxsw_sp_port->sample->psample_group, NULL);
-	return err;
-}
-
-static void
-mlxsw_sp_port_del_cls_matchall_sample(struct mlxsw_sp_port *mlxsw_sp_port)
-{
-	if (!mlxsw_sp_port->sample)
-		return;
-
-	mlxsw_sp_port_sample_set(mlxsw_sp_port, false, 1);
-	RCU_INIT_POINTER(mlxsw_sp_port->sample->psample_group, NULL);
-}
-
-static int mlxsw_sp_port_add_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
-					  struct tc_cls_matchall_offload *f,
-					  bool ingress)
-{
-	struct mlxsw_sp_port_mall_tc_entry *mall_tc_entry;
-	__be16 protocol = f->common.protocol;
-	struct flow_action_entry *act;
-	int err;
-
-	if (!flow_offload_has_one_action(&f->rule->action)) {
-		netdev_err(mlxsw_sp_port->dev, "only singular actions are supported\n");
-		return -EOPNOTSUPP;
-	}
-
-	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
-	if (!mall_tc_entry)
-		return -ENOMEM;
-	mall_tc_entry->cookie = f->cookie;
-
-	act = &f->rule->action.entries[0];
-
-	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
-		struct mlxsw_sp_port_mall_mirror_tc_entry *mirror;
-
-		mall_tc_entry->type = MLXSW_SP_PORT_MALL_MIRROR;
-		mirror = &mall_tc_entry->mirror;
-		err = mlxsw_sp_port_add_cls_matchall_mirror(mlxsw_sp_port,
-							    mirror, act,
-							    ingress);
-	} else if (act->id == FLOW_ACTION_SAMPLE &&
-		   protocol == htons(ETH_P_ALL)) {
-		mall_tc_entry->type = MLXSW_SP_PORT_MALL_SAMPLE;
-		err = mlxsw_sp_port_add_cls_matchall_sample(mlxsw_sp_port, f,
-							    act, ingress);
-	} else {
-		err = -EOPNOTSUPP;
-	}
-
-	if (err)
-		goto err_add_action;
-
-	list_add_tail(&mall_tc_entry->list, &mlxsw_sp_port->mall_tc_list);
-	return 0;
-
-err_add_action:
-	kfree(mall_tc_entry);
-	return err;
-}
-
-static void mlxsw_sp_port_del_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
-					   struct tc_cls_matchall_offload *f)
-{
-	struct mlxsw_sp_port_mall_tc_entry *mall_tc_entry;
-
-	mall_tc_entry = mlxsw_sp_port_mall_tc_entry_find(mlxsw_sp_port,
-							 f->cookie);
-	if (!mall_tc_entry) {
-		netdev_dbg(mlxsw_sp_port->dev, "tc entry not found on port\n");
-		return;
-	}
-	list_del(&mall_tc_entry->list);
-
-	switch (mall_tc_entry->type) {
-	case MLXSW_SP_PORT_MALL_MIRROR:
-		mlxsw_sp_port_del_cls_matchall_mirror(mlxsw_sp_port,
-						      &mall_tc_entry->mirror);
-		break;
-	case MLXSW_SP_PORT_MALL_SAMPLE:
-		mlxsw_sp_port_del_cls_matchall_sample(mlxsw_sp_port);
-		break;
-	default:
-		WARN_ON(1);
-	}
-
-	kfree(mall_tc_entry);
-}
-
 static int mlxsw_sp_setup_tc_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
 					  struct tc_cls_matchall_offload *f,
 					  bool ingress)
 {
 	switch (f->command) {
 	case TC_CLSMATCHALL_REPLACE:
-		return mlxsw_sp_port_add_cls_matchall(mlxsw_sp_port, f,
-						      ingress);
+		return mlxsw_sp_mall_replace(mlxsw_sp_port, f, ingress);
 	case TC_CLSMATCHALL_DESTROY:
-		mlxsw_sp_port_del_cls_matchall(mlxsw_sp_port, f);
+		mlxsw_sp_mall_destroy(mlxsw_sp_port, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1800,7 +1622,7 @@ static int mlxsw_sp_feature_hw_tc(struct net_device *dev, bool enable)
 	if (!enable) {
 		if (mlxsw_sp_flow_block_rule_count(mlxsw_sp_port->ing_flow_block) ||
 		    mlxsw_sp_flow_block_rule_count(mlxsw_sp_port->eg_flow_block) ||
-		    !list_empty(&mlxsw_sp_port->mall_tc_list)) {
+		    !list_empty(&mlxsw_sp_port->mall_list)) {
 			netdev_err(dev, "Active offloaded tc filters, can't turn hw_tc_offload off\n");
 			return -EINVAL;
 		}
@@ -3696,7 +3518,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	mlxsw_sp_port->mapping = *port_mapping;
 	mlxsw_sp_port->link.autoneg = 1;
 	INIT_LIST_HEAD(&mlxsw_sp_port->vlans_list);
-	INIT_LIST_HEAD(&mlxsw_sp_port->mall_tc_list);
+	INIT_LIST_HEAD(&mlxsw_sp_port->mall_list);
 
 	mlxsw_sp_port->pcpu_stats =
 		netdev_alloc_pcpu_stats(struct mlxsw_sp_port_pcpu_stats);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index d4ef079aab4b..5c2f1af53e53 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -109,25 +109,6 @@ struct mlxsw_sp_mid {
 	unsigned long *ports_in_mid; /* bits array */
 };
 
-enum mlxsw_sp_port_mall_action_type {
-	MLXSW_SP_PORT_MALL_MIRROR,
-	MLXSW_SP_PORT_MALL_SAMPLE,
-};
-
-struct mlxsw_sp_port_mall_mirror_tc_entry {
-	int span_id;
-	bool ingress;
-};
-
-struct mlxsw_sp_port_mall_tc_entry {
-	struct list_head list;
-	unsigned long cookie;
-	enum mlxsw_sp_port_mall_action_type type;
-	union {
-		struct mlxsw_sp_port_mall_mirror_tc_entry mirror;
-	};
-};
-
 struct mlxsw_sp_sb;
 struct mlxsw_sp_bridge;
 struct mlxsw_sp_router;
@@ -274,8 +255,7 @@ struct mlxsw_sp_port {
 					       * the same localport can have
 					       * different mapping.
 					       */
-	/* TC handles */
-	struct list_head mall_tc_list;
+	struct list_head mall_list;
 	struct {
 		#define MLXSW_HW_STATS_UPDATE_TIME HZ
 		struct rtnl_link_stats64 stats;
@@ -913,6 +893,12 @@ extern const struct mlxsw_afa_ops mlxsw_sp2_act_afa_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 
+/* spectrum_matchall.c */
+int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_cls_matchall_offload *f, bool ingress);
+void mlxsw_sp_mall_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct tc_cls_matchall_offload *f);
+
 /* spectrum_flower.c */
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_flow_block *block,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
new file mode 100644
index 000000000000..56f21cfdb48e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2017-2020 Mellanox Technologies. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <net/flow_offload.h>
+
+#include "spectrum.h"
+#include "spectrum_span.h"
+#include "reg.h"
+
+enum mlxsw_sp_mall_action_type {
+	MLXSW_SP_MALL_ACTION_TYPE_MIRROR,
+	MLXSW_SP_MALL_ACTION_TYPE_SAMPLE,
+};
+
+struct mlxsw_sp_mall_mirror_entry {
+	int span_id;
+	bool ingress;
+};
+
+struct mlxsw_sp_mall_entry {
+	struct list_head list;
+	unsigned long cookie;
+	enum mlxsw_sp_mall_action_type type;
+	union {
+		struct mlxsw_sp_mall_mirror_entry mirror;
+	};
+};
+
+static struct mlxsw_sp_mall_entry *
+mlxsw_sp_mall_entry_find(struct mlxsw_sp_port *port, unsigned long cookie)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+
+	list_for_each_entry(mall_entry, &port->mall_list, list)
+		if (mall_entry->cookie == cookie)
+			return mall_entry;
+
+	return NULL;
+}
+
+static int
+mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
+			      struct mlxsw_sp_mall_mirror_entry *mirror,
+			      const struct flow_action_entry *act,
+			      bool ingress)
+{
+	enum mlxsw_sp_span_type span_type;
+
+	if (!act->dev) {
+		netdev_err(mlxsw_sp_port->dev, "Could not find requested device\n");
+		return -EINVAL;
+	}
+
+	mirror->ingress = ingress;
+	span_type = ingress ? MLXSW_SP_SPAN_INGRESS : MLXSW_SP_SPAN_EGRESS;
+	return mlxsw_sp_span_mirror_add(mlxsw_sp_port, act->dev, span_type,
+					true, &mirror->span_id);
+}
+
+static void
+mlxsw_sp_mall_port_mirror_del(struct mlxsw_sp_port *mlxsw_sp_port,
+			      struct mlxsw_sp_mall_mirror_entry *mirror)
+{
+	enum mlxsw_sp_span_type span_type;
+
+	span_type = mirror->ingress ? MLXSW_SP_SPAN_INGRESS :
+				      MLXSW_SP_SPAN_EGRESS;
+	mlxsw_sp_span_mirror_del(mlxsw_sp_port, mirror->span_id,
+				 span_type, true);
+}
+
+static int mlxsw_sp_mall_port_sample_set(struct mlxsw_sp_port *mlxsw_sp_port,
+					 bool enable, u32 rate)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char mpsc_pl[MLXSW_REG_MPSC_LEN];
+
+	mlxsw_reg_mpsc_pack(mpsc_pl, mlxsw_sp_port->local_port, enable, rate);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpsc), mpsc_pl);
+}
+
+static int
+mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
+			      struct tc_cls_matchall_offload *cls,
+			      const struct flow_action_entry *act, bool ingress)
+{
+	int err;
+
+	if (!mlxsw_sp_port->sample)
+		return -EOPNOTSUPP;
+	if (rtnl_dereference(mlxsw_sp_port->sample->psample_group)) {
+		netdev_err(mlxsw_sp_port->dev, "sample already active\n");
+		return -EEXIST;
+	}
+	if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
+		netdev_err(mlxsw_sp_port->dev, "sample rate not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	rcu_assign_pointer(mlxsw_sp_port->sample->psample_group,
+			   act->sample.psample_group);
+	mlxsw_sp_port->sample->truncate = act->sample.truncate;
+	mlxsw_sp_port->sample->trunc_size = act->sample.trunc_size;
+	mlxsw_sp_port->sample->rate = act->sample.rate;
+
+	err = mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, true,
+					    act->sample.rate);
+	if (err)
+		goto err_port_sample_set;
+	return 0;
+
+err_port_sample_set:
+	RCU_INIT_POINTER(mlxsw_sp_port->sample->psample_group, NULL);
+	return err;
+}
+
+static void
+mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	if (!mlxsw_sp_port->sample)
+		return;
+
+	mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, false, 1);
+	RCU_INIT_POINTER(mlxsw_sp_port->sample->psample_group, NULL);
+}
+
+int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_cls_matchall_offload *f, bool ingress)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+	__be16 protocol = f->common.protocol;
+	struct flow_action_entry *act;
+	int err;
+
+	if (!flow_offload_has_one_action(&f->rule->action)) {
+		netdev_err(mlxsw_sp_port->dev, "only singular actions are supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	mall_entry = kzalloc(sizeof(*mall_entry), GFP_KERNEL);
+	if (!mall_entry)
+		return -ENOMEM;
+	mall_entry->cookie = f->cookie;
+
+	act = &f->rule->action.entries[0];
+
+	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
+		struct mlxsw_sp_mall_mirror_entry *mirror;
+
+		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
+		mirror = &mall_entry->mirror;
+		err = mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mirror, act,
+						    ingress);
+	} else if (act->id == FLOW_ACTION_SAMPLE &&
+		   protocol == htons(ETH_P_ALL)) {
+		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_SAMPLE;
+		err = mlxsw_sp_mall_port_sample_add(mlxsw_sp_port, f, act,
+						    ingress);
+	} else {
+		err = -EOPNOTSUPP;
+	}
+
+	if (err)
+		goto err_add_action;
+
+	list_add_tail(&mall_entry->list, &mlxsw_sp_port->mall_list);
+	return 0;
+
+err_add_action:
+	kfree(mall_entry);
+	return err;
+}
+
+void mlxsw_sp_mall_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct tc_cls_matchall_offload *f)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+
+	mall_entry = mlxsw_sp_mall_entry_find(mlxsw_sp_port, f->cookie);
+	if (!mall_entry) {
+		netdev_dbg(mlxsw_sp_port->dev, "tc entry not found on port\n");
+		return;
+	}
+	list_del(&mall_entry->list);
+
+	switch (mall_entry->type) {
+	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
+		mlxsw_sp_mall_port_mirror_del(mlxsw_sp_port,
+					      &mall_entry->mirror);
+		break;
+	case MLXSW_SP_MALL_ACTION_TYPE_SAMPLE:
+		mlxsw_sp_mall_port_sample_del(mlxsw_sp_port);
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	kfree(mall_entry);
+}
-- 
2.24.1

