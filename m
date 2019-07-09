Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAB563CEA
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfGIU4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:11 -0400
Received: from mail.us.es ([193.147.175.20]:36706 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729814AbfGIU4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1A9A285E3A3
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C15FF10219C
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A6B0758F; Tue,  9 Jul 2019 22:56:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52906DA4D0;
        Tue,  9 Jul 2019 22:56:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3B1BC4265A31;
        Tue,  9 Jul 2019 22:56:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v4 02/12] net: flow_offload: rename TC_BLOCK_{UN}BIND to FLOW_BLOCK_{UN}BIND
Date:   Tue,  9 Jul 2019 22:55:40 +0200
Message-Id: <20190709205550.3160-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename from TC_BLOCK_{UN}BIND to FLOW_BLOCK_{UN}BIND and remove
temporary tc_block_command alias.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes.

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  4 ++--
 drivers/net/ethernet/mscc/ocelot_tc.c              |  4 ++--
 .../net/ethernet/netronome/nfp/flower/offload.c    |  8 ++++----
 include/net/flow_offload.h                         |  4 ++--
 include/net/pkt_cls.h                              |  1 -
 net/core/flow_offload.c                            |  4 ++--
 net/dsa/slave.c                                    |  4 ++--
 net/sched/cls_api.c                                | 22 +++++++++++-----------
 9 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 5b5c4ecf4214..a13139a5a5ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -704,7 +704,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
 		if (indr_priv)
 			return -EEXIST;
@@ -727,7 +727,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		}
 
 		return err;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
 		if (!indr_priv)
 			return -ENOENT;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ce285fbeebd3..9cf61a9d8291 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1679,7 +1679,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		err = tcf_block_cb_register(f->block, cb, mlxsw_sp_port,
 					    mlxsw_sp_port, f->extack);
 		if (err)
@@ -1692,7 +1692,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 			return err;
 		}
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
 						      f->block, ingress);
 		tcf_block_cb_unregister(f->block, cb, mlxsw_sp_port);
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 72084306240d..c84942ef8e7b 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -147,14 +147,14 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 	}
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		ret = tcf_block_cb_register(f->block, cb, port,
 					    port, f->extack);
 		if (ret)
 			return ret;
 
 		return ocelot_setup_tc_block_flower_bind(port, f);
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		ocelot_setup_tc_block_flower_unbind(port, f);
 		tcf_block_cb_unregister(f->block, cb, port);
 		return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 6dbe947269c3..7c94f5142076 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1315,11 +1315,11 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 	repr_priv->block_shared = tcf_block_shared(f->block);
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		return tcf_block_cb_register(f->block,
 					     nfp_flower_setup_tc_block_cb,
 					     repr, repr, f->extack);
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		tcf_block_cb_unregister(f->block,
 					nfp_flower_setup_tc_block_cb,
 					repr);
@@ -1395,7 +1395,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		cb_priv = kmalloc(sizeof(*cb_priv), GFP_KERNEL);
 		if (!cb_priv)
 			return -ENOMEM;
@@ -1413,7 +1413,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		}
 
 		return err;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
 		if (!cb_priv)
 			return -ENOENT;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6afc6009c6ab..965b0f1133b3 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -234,8 +234,8 @@ static inline void flow_stats_update(struct flow_stats *flow_stats,
 }
 
 enum flow_block_command {
-	TC_BLOCK_BIND,
-	TC_BLOCK_UNBIND,
+	FLOW_BLOCK_BIND,
+	FLOW_BLOCK_UNBIND,
 };
 
 enum flow_block_binder_type {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index b6c306fa9541..1a96f469164f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -27,7 +27,6 @@ int register_tcf_proto_ops(struct tcf_proto_ops *ops);
 int unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
 
 #define tc_block_offload flow_block_offload
-#define tc_block_command flow_block_command
 #define tcf_block_binder_type flow_block_binder_type
 
 struct tcf_block_ext_info {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index e31c0fdb6b01..593e73f7593a 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -178,10 +178,10 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 	f->driver_block_list = driver_block_list;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		return tcf_block_cb_register(f->block, cb, cb_ident, cb_priv,
 					     f->extack);
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		tcf_block_cb_unregister(f->block, cb, cb_ident);
 		return 0;
 	default:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 99673f6b07f6..58a71ee0747a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -955,9 +955,9 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		return tcf_block_cb_register(f->block, cb, dev, dev, f->extack);
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		tcf_block_cb_unregister(f->block, cb, dev);
 		return 0;
 	default:
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ad36bbcc583e..5597bed80d9c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -674,7 +674,7 @@ static void tc_indr_block_cb_del(struct tc_indr_block_cb *indr_block_cb)
 
 static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 				  struct tc_indr_block_cb *indr_block_cb,
-				  enum tc_block_command command)
+				  enum flow_block_command command)
 {
 	struct tc_block_offload bo = {
 		.command	= command,
@@ -705,7 +705,7 @@ int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 	if (err)
 		goto err_dev_put;
 
-	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, TC_BLOCK_BIND);
+	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, FLOW_BLOCK_BIND);
 	return 0;
 
 err_dev_put:
@@ -742,7 +742,7 @@ void __tc_indr_block_cb_unregister(struct net_device *dev,
 		return;
 
 	/* Send unbind message if required to free any block cbs. */
-	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, TC_BLOCK_UNBIND);
+	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, FLOW_BLOCK_UNBIND);
 	tc_indr_block_cb_del(indr_block_cb);
 	tc_indr_block_dev_put(indr_dev);
 }
@@ -759,7 +759,7 @@ EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
 
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
-			       enum tc_block_command command,
+			       enum flow_block_command command,
 			       struct netlink_ext_ack *extack)
 {
 	struct tc_indr_block_cb *indr_block_cb;
@@ -775,7 +775,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	if (!indr_dev)
 		return;
 
-	indr_dev->block = command == TC_BLOCK_BIND ? block : NULL;
+	indr_dev->block = command == FLOW_BLOCK_BIND ? block : NULL;
 
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
@@ -790,7 +790,7 @@ static bool tcf_block_offload_in_use(struct tcf_block *block)
 static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct net_device *dev,
 				 struct tcf_block_ext_info *ei,
-				 enum tc_block_command command,
+				 enum flow_block_command command,
 				 struct netlink_ext_ack *extack)
 {
 	struct tc_block_offload bo = {};
@@ -820,20 +820,20 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 		return -EOPNOTSUPP;
 	}
 
-	err = tcf_block_offload_cmd(block, dev, ei, TC_BLOCK_BIND, extack);
+	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_BIND, extack);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_inc;
 	if (err)
 		return err;
 
-	tc_indr_block_call(block, dev, ei, TC_BLOCK_BIND, extack);
+	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
 	return 0;
 
 no_offload_dev_inc:
 	if (tcf_block_offload_in_use(block))
 		return -EOPNOTSUPP;
 	block->nooffloaddevcnt++;
-	tc_indr_block_call(block, dev, ei, TC_BLOCK_BIND, extack);
+	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_BIND, extack);
 	return 0;
 }
 
@@ -843,11 +843,11 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	struct net_device *dev = q->dev_queue->dev;
 	int err;
 
-	tc_indr_block_call(block, dev, ei, TC_BLOCK_UNBIND, NULL);
+	tc_indr_block_call(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
 
 	if (!dev->netdev_ops->ndo_setup_tc)
 		goto no_offload_dev_dec;
-	err = tcf_block_offload_cmd(block, dev, ei, TC_BLOCK_UNBIND, NULL);
+	err = tcf_block_offload_cmd(block, dev, ei, FLOW_BLOCK_UNBIND, NULL);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_dec;
 	return;
-- 
2.11.0


