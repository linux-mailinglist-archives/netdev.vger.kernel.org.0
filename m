Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF905FEC8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfGDXtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:49:41 -0400
Received: from mail.us.es ([193.147.175.20]:33834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbfGDXtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 19:49:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D12B280D1D
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0410DA704
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9F74D1150DE; Fri,  5 Jul 2019 01:49:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-106.5 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_SBL,URIBL_SBL_A,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96D41DA4D1;
        Fri,  5 Jul 2019 01:49:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 01:49:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 520DC4265A31;
        Fri,  5 Jul 2019 01:49:30 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        cphealy@gmail.com
Subject: [PATCH 14/15 net-next,v2] net: flow_offload: rename TCF_BLOCK_BINDER_TYPE_* to FLOW_BLOCK_BINDER_TYPE_*
Date:   Fri,  5 Jul 2019 01:48:42 +0200
Message-Id: <20190704234843.6601-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704234843.6601-1-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not tc specific anymore, rename this.

Suggested-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Actually a new patch (no previous v1), requested by Jiri.

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      | 4 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c           | 2 +-
 drivers/net/ethernet/mscc/ocelot_tc.c               | 4 ++--
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 6 +++---
 include/net/flow_offload.h                          | 6 +++---
 net/core/flow_offload.c                             | 2 +-
 net/dsa/slave.c                                     | 4 ++--
 net/sched/cls_api.c                                 | 6 +++---
 net/sched/sch_ingress.c                             | 6 +++---
 10 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index d05888dff503..bde200cbedd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -710,7 +710,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 	struct mlx5e_rep_indr_block_priv *indr_priv;
 	struct flow_block_cb *block_cb;
 
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 8083491b2172..5b1a4160dfd9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1682,10 +1682,10 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	f->block_cb_list = &mlxsw_block_cb_list;
 
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
index 3dd8acc255ae..8921953cb32c 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -313,7 +313,7 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 	struct flow_block_cb *block_cb;
 	int ret;
 
-	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		return -EOPNOTSUPP;
 
 	block_cb = flow_block_cb_lookup(f, ocelot_setup_tc_block_cb_flower,
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index d92de65176b5..b9769e4411e7 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -140,10 +140,10 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
 		   f->command, f->binder_type);
 
-	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
 		cb = ocelot_setup_tc_block_cb_ig;
 		port->tc.block_shared = f->block_shared;
-	} else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
+	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
 		cb = ocelot_setup_tc_block_cb_eg;
 	} else {
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index c52b8349b9f1..b926c1639c1d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1309,7 +1309,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 	struct nfp_flower_repr_priv *repr_priv;
 	struct flow_block_cb *block_cb;
 
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	repr_priv = repr->app_priv;
@@ -1407,8 +1407,8 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 	struct nfp_flower_priv *priv = app->priv;
 	struct flow_block_cb *block_cb;
 
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
-	    !(f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	    !(f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
 	      nfp_flower_internal_port_can_offload(app, netdev)))
 		return -EOPNOTSUPP;
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 744eb474c823..f955c906116b 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -240,9 +240,9 @@ enum flow_block_command {
 };
 
 enum flow_block_binder_type {
-	TCF_BLOCK_BINDER_TYPE_UNSPEC,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
+	FLOW_BLOCK_BINDER_TYPE_UNSPEC,
+	FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+	FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
 };
 
 struct flow_block_offload {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index eaff06ee313d..5614a637f1fd 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -264,7 +264,7 @@ int flow_block_setup_offload(struct flow_block_offload *f,
 	f->block_cb_list = block_cb_list;
 
 	if (ingress_only &&
-	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 636a22201654..0c1900b2f5f1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -952,9 +952,9 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 
 	f->block_cb_list = &dsa_slave_block_cb_list;
 
-	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		cb = dsa_slave_setup_tc_block_cb_ig;
-	else if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+	else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		cb = dsa_slave_setup_tc_block_cb_eg;
 	else
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 00f4303dc6e5..1f9d742345a6 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -895,7 +895,7 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 {
 	struct flow_block_offload bo = {
 		.command	= command,
-		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.net		= dev_net(indr_dev->dev),
 		.block_shared	= tcf_block_shared(indr_dev->block),
 	};
@@ -1478,8 +1478,8 @@ tcf_block_owner_netif_keep_dst(struct tcf_block *block,
 			       enum flow_block_binder_type binder_type)
 {
 	if (block->keep_dst &&
-	    binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
-	    binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+	    binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	    binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		netif_keep_dst(qdisc_dev(q));
 }
 
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

