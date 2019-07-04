Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1065FEC7
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfGDXtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:49:42 -0400
Received: from mail.us.es ([193.147.175.20]:33700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbfGDXti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 19:49:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC8AC81426
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B8CB115103
        for <netdev@vger.kernel.org>; Fri,  5 Jul 2019 01:49:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B4EA1021B2; Fri,  5 Jul 2019 01:49:35 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-106.5 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_SBL,URIBL_SBL_A,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1BAD115109;
        Fri,  5 Jul 2019 01:49:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 01:49:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9C4CA4265A31;
        Fri,  5 Jul 2019 01:49:28 +0200 (CEST)
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
Subject: [PATCH 13/15 net-next,v2] net: flow_offload: rename TC_BLOCK_{UN}BIND to FLOW_BLOCK_{UN}BIND
Date:   Fri,  5 Jul 2019 01:48:41 +0200
Message-Id: <20190704234843.6601-14-pablo@netfilter.org>
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

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  4 ++--
 drivers/net/ethernet/mscc/ocelot_tc.c              |  4 ++--
 .../net/ethernet/netronome/nfp/flower/offload.c    |  8 ++++----
 include/net/flow_offload.h                         |  4 ++--
 net/core/flow_offload.c                            |  4 ++--
 net/dsa/slave.c                                    |  4 ++--
 net/sched/cls_api.c                                | 24 +++++++++++-----------
 8 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 2d26af759997..d05888dff503 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -714,7 +714,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
 		if (indr_priv)
 			return -EEXIST;
@@ -739,7 +739,7 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		flow_block_cb_add(block_cb, f);
 
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
 		if (!indr_priv)
 			return -ENOENT;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3ecb51a05961..8083491b2172 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1693,7 +1693,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f, cb, mlxsw_sp_port,
 					       mlxsw_sp_port, NULL);
 		if (IS_ERR(block_cb))
@@ -1706,7 +1706,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 		}
 		flow_block_cb_add(block_cb, f);
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
 						      f, ingress);
 		block_cb = flow_block_cb_lookup(f, cb, mlxsw_sp_port);
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 17fca31206c7..d92de65176b5 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -152,7 +152,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 	f->block_cb_list = &ocelot_block_cb_list;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f, cb, port, port, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
@@ -164,7 +164,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 		}
 		flow_block_cb_add(block_cb, f);
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		block_cb = flow_block_cb_lookup(f, cb, port);
 		if (!block_cb)
 			return -ENOENT;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 6b2f31ed2315..c52b8349b9f1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1316,7 +1316,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 	repr_priv->block_shared = f->block_shared;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f,
 					       nfp_flower_setup_tc_block_cb,
 					       repr, repr, NULL);
@@ -1325,7 +1325,7 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		block_cb = flow_block_cb_lookup(f,
 						nfp_flower_setup_tc_block_cb,
 						repr);
@@ -1413,7 +1413,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		cb_priv = kmalloc(sizeof(*cb_priv), GFP_KERNEL);
 		if (!cb_priv)
 			return -ENOMEM;
@@ -1434,7 +1434,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
 		if (!cb_priv)
 			return -ENOENT;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 390e74ed42cb..744eb474c823 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -235,8 +235,8 @@ static inline void flow_stats_update(struct flow_stats *flow_stats,
 #include <net/sch_generic.h> /* for tc_setup_cb_t. */
 
 enum flow_block_command {
-	TC_BLOCK_BIND,
-	TC_BLOCK_UNBIND,
+	FLOW_BLOCK_BIND,
+	FLOW_BLOCK_UNBIND,
 };
 
 enum flow_block_binder_type {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 8392cf2b5ea7..eaff06ee313d 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -268,14 +268,14 @@ int flow_block_setup_offload(struct flow_block_offload *f,
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f, cb, cb_ident, cb_priv, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		block_cb = flow_block_cb_lookup(f, cb, cb_ident);
 		if (!block_cb)
 			return -ENOENT;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 504c4183af71..636a22201654 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -960,14 +960,14 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		block_cb = flow_block_cb_alloc(f, cb, dev, dev, NULL);
 		if (IS_ERR(block_cb))
 			return PTR_ERR(block_cb);
 
 		flow_block_cb_add(block_cb, f);
 		return 0;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		block_cb = flow_block_cb_lookup(f, cb, dev);
 		if (!block_cb)
 			return -ENOENT;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5635b6f63015..00f4303dc6e5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -767,10 +767,10 @@ static int tcf_block_setup(struct tcf_block *block,
 	int err;
 
 	switch (bo->command) {
-	case TC_BLOCK_BIND:
+	case FLOW_BLOCK_BIND:
 		err = tcf_block_bind(block, bo);
 		break;
-	case TC_BLOCK_UNBIND:
+	case FLOW_BLOCK_UNBIND:
 		err = 0;
 		tcf_block_unbind(block, bo);
 		break;
@@ -904,8 +904,8 @@ static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 	if (!indr_dev->block)
 		return;
 
-	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
-			  &bo);
+	indr_block_cb->cb(indr_dev->dev, indr_block_cb->cb_priv,
+			  TC_SETUP_BLOCK, &bo);
 	tcf_block_setup(indr_dev->block, &bo);
 }
 
@@ -925,7 +925,7 @@ int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 	if (err)
 		goto err_dev_put;
 
-	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, TC_BLOCK_BIND);
+	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, FLOW_BLOCK_BIND);
 	return 0;
 
 err_dev_put:
@@ -962,7 +962,7 @@ void __tc_indr_block_cb_unregister(struct net_device *dev,
 		return;
 
 	/* Send unbind message if required to free any block cbs. */
-	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, TC_BLOCK_UNBIND);
+	tc_indr_block_ing_cmd(indr_dev, indr_block_cb, FLOW_BLOCK_UNBIND);
 	tc_indr_block_cb_del(indr_block_cb);
 	tc_indr_block_dev_put(indr_dev);
 }
@@ -997,7 +997,7 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 	if (!indr_dev)
 		return;
 
-	indr_dev->block = command == TC_BLOCK_BIND ? block : NULL;
+	indr_dev->block = command == FLOW_BLOCK_BIND ? block : NULL;
 
 	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
 		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
@@ -1047,20 +1047,20 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
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
 
@@ -1070,11 +1070,11 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
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

