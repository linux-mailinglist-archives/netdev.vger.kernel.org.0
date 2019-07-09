Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D0763CEE
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbfGIU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:14 -0400
Received: from mail.us.es ([193.147.175.20]:36764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729817AbfGIU4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B0B92880496
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 304E4115104
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 29B0811510C; Tue,  9 Jul 2019 22:56:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E24B7DA704;
        Tue,  9 Jul 2019 22:56:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CDA4E4265A31;
        Tue,  9 Jul 2019 22:56:04 +0200 (CEST)
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
Subject: [PATCH net-next,v4 03/12] net: flow_offload: rename TCF_BLOCK_BINDER_TYPE_* to FLOW_BLOCK_BINDER_TYPE_*
Date:   Tue,  9 Jul 2019 22:55:41 +0200
Message-Id: <20190709205550.3160-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename from TCF_BLOCK_BINDER_TYPE_* to FLOW_BLOCK_BINDER_TYPE_* and
remove temporary tcf_block_binder_type alias.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes.

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      |  4 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c           |  2 +-
 drivers/net/ethernet/mscc/ocelot_tc.c               |  4 ++--
 drivers/net/ethernet/netronome/nfp/flower/offload.c |  6 +++---
 include/net/flow_offload.h                          |  6 +++---
 include/net/pkt_cls.h                               |  3 +--
 net/core/flow_offload.c                             |  2 +-
 net/dsa/slave.c                                     |  4 ++--
 net/sched/cls_api.c                                 | 14 +++++++-------
 net/sched/sch_ingress.c                             |  6 +++---
 11 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a13139a5a5ca..f5c430973b35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -700,7 +700,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 	struct mlx5e_rep_indr_block_priv *indr_priv;
 	int err = 0;
 
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 9cf61a9d8291..a178d082f061 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1668,10 +1668,10 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	bool ingress;
 	int err;
 
-	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = mlxsw_sp_setup_tc_block_cb_matchall_ig;
 		ingress = true;
-	} else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
+	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
 		cb = mlxsw_sp_setup_tc_block_cb_matchall_eg;
 		ingress = false;
 	} else {
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 8778dee5a471..b682f08a93b4 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -306,7 +306,7 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 	struct tcf_block_cb *block_cb;
 	int ret;
 
-	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		return -EOPNOTSUPP;
 
 	block_cb = tcf_block_cb_lookup(f->block,
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index c84942ef8e7b..58a0b5f8850c 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -137,10 +137,10 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
 		   f->command, f->binder_type);
 
-	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = ocelot_setup_tc_block_cb_ig;
 		port->tc.block_shared = tcf_block_shared(f->block);
-	} else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
+	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
 		cb = ocelot_setup_tc_block_cb_eg;
 	} else {
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 7c94f5142076..46041e509150 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1308,7 +1308,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 	struct nfp_repr *repr = netdev_priv(netdev);
 	struct nfp_flower_repr_priv *repr_priv;
 
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	repr_priv = repr->app_priv;
@@ -1389,8 +1389,8 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 	struct nfp_flower_priv *priv = app->priv;
 	int err;
 
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
-	    !(f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	    !(f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
 	      nfp_flower_internal_port_can_offload(app, netdev)))
 		return -EOPNOTSUPP;
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 965b0f1133b3..0d7d1e6d6f2a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -239,9 +239,9 @@ enum flow_block_command {
 };
 
 enum flow_block_binder_type {
-	TCF_BLOCK_BINDER_TYPE_UNSPEC,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
+	FLOW_BLOCK_BINDER_TYPE_UNSPEC,
+	FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
 };
 
 struct tcf_block;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 1a96f469164f..e4499526fde8 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -27,10 +27,9 @@ int register_tcf_proto_ops(struct tcf_proto_ops *ops);
 int unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
 
 #define tc_block_offload flow_block_offload
-#define tcf_block_binder_type flow_block_binder_type
 
 struct tcf_block_ext_info {
-	enum tcf_block_binder_type binder_type;
+	enum flow_block_binder_type binder_type;
 	tcf_chain_head_change_t *chain_head_change;
 	void *chain_head_change_priv;
 	u32 block_index;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 593e73f7593a..6d8187e8effc 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -172,7 +172,7 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       bool ingress_only)
 {
 	if (ingress_only &&
-	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	f->driver_block_list = driver_block_list;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 58a71ee0747a..9b5e202c255e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -947,9 +947,9 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 {
 	tc_setup_cb_t *cb;
 
-	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		cb = dsa_slave_setup_tc_block_cb_ig;
-	else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+	else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		cb = dsa_slave_setup_tc_block_cb_eg;
 	else
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5597bed80d9c..fa0c451aca59 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -678,7 +678,7 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 {
 	struct tc_block_offload bo = {
 		.command	= command,
-		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.block		= indr_dev->block,
 	};
 
@@ -1340,17 +1340,17 @@ static void tcf_block_release(struct Qdisc *q, struct tcf_block *block,
 struct tcf_block_owner_item {
 	struct list_head list;
 	struct Qdisc *q;
-	enum tcf_block_binder_type binder_type;
+	enum flow_block_binder_type binder_type;
 };
 
 static void
 tcf_block_owner_netif_keep_dst(struct tcf_block *block,
 			       struct Qdisc *q,
-			       enum tcf_block_binder_type binder_type)
+			       enum flow_block_binder_type binder_type)
 {
 	if (block->keep_dst &&
-	    binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
-	    binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+	    binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	    binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		netif_keep_dst(qdisc_dev(q));
 }
 
@@ -1367,7 +1367,7 @@ EXPORT_SYMBOL(tcf_block_netif_keep_dst);
 
 static int tcf_block_owner_add(struct tcf_block *block,
 			       struct Qdisc *q,
-			       enum tcf_block_binder_type binder_type)
+			       enum flow_block_binder_type binder_type)
 {
 	struct tcf_block_owner_item *item;
 
@@ -1382,7 +1382,7 @@ static int tcf_block_owner_add(struct tcf_block *block,
 
 static void tcf_block_owner_del(struct tcf_block *block,
 				struct Qdisc *q,
-				enum tcf_block_binder_type binder_type)
+				enum flow_block_binder_type binder_type)
 {
 	struct tcf_block_owner_item *item;
 
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 599730f804d7..bf56aa519797 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -83,7 +83,7 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
 
 	mini_qdisc_pair_init(&q->miniqp, sch, &dev->miniq_ingress);
 
-	q->block_info.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	q->block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	q->block_info.chain_head_change = clsact_chain_head_change;
 	q->block_info.chain_head_change_priv = &q->miniqp;
 
@@ -217,7 +217,7 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 
 	mini_qdisc_pair_init(&q->miniqp_ingress, sch, &dev->miniq_ingress);
 
-	q->ingress_block_info.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
+	q->ingress_block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
 	q->ingress_block_info.chain_head_change = clsact_chain_head_change;
 	q->ingress_block_info.chain_head_change_priv = &q->miniqp_ingress;
 
@@ -228,7 +228,7 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
 
 	mini_qdisc_pair_init(&q->miniqp_egress, sch, &dev->miniq_egress);
 
-	q->egress_block_info.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS;
+	q->egress_block_info.binder_type = FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS;
 	q->egress_block_info.chain_head_change = clsact_chain_head_change;
 	q->egress_block_info.chain_head_change_priv = &q->miniqp_egress;
 
-- 
2.11.0


