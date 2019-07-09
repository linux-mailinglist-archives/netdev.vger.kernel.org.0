Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB7363CFF
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfGIU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:56:45 -0400
Received: from mail.us.es ([193.147.175.20]:37360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729054AbfGIU4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:56:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DC4D7288049B
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4FE21021A6
        for <netdev@vger.kernel.org>; Tue,  9 Jul 2019 22:56:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C2846A6A8; Tue,  9 Jul 2019 22:56:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7661DA732;
        Tue,  9 Jul 2019 22:56:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jul 2019 22:56:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.194.134])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A68FE4265A31;
        Tue,  9 Jul 2019 22:56:25 +0200 (CEST)
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
Subject: [PATCH net-next,v4 11/12] net: flow_offload: rename tc_cls_flower_offload to flow_cls_offload
Date:   Tue,  9 Jul 2019 22:55:49 +0200
Message-Id: <20190709205550.3160-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190709205550.3160-1-pablo@netfilter.org>
References: <20190709205550.3160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And any other existing fields in this structure that refer to tc.
Specifically:

* tc_cls_flower_offload_flow_rule() to flow_cls_offload_flow_rule().
* TC_CLSFLOWER_* to FLOW_CLS_*.
* tc_cls_common_offload to tc_cls_common_offload.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: new patch, rename tc definitions and structures - Jakub Kicinski and Jiri Pirko.

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       | 18 ++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h       |  4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  8 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 22 +++++------
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |  6 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 22 +++++------
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 22 +++++------
 drivers/net/ethernet/intel/igb/igb_main.c          | 16 ++++----
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  6 +--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |  8 ++--
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 18 ++++-----
 .../ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    |  4 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  | 10 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  8 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 16 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 34 ++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  6 +--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 12 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     | 10 ++---
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  | 34 ++++++++---------
 drivers/net/ethernet/mscc/ocelot_flower.c          | 22 +++++------
 drivers/net/ethernet/netronome/nfp/flower/action.c | 14 +++----
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  6 +--
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 44 +++++++++++-----------
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    | 30 +++++++--------
 drivers/net/ethernet/qlogic/qede/qede.h            |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  8 ++--
 include/net/flow_offload.h                         | 30 +++++++++++++++
 include/net/pkt_cls.h                              | 40 +++-----------------
 net/sched/cls_flower.c                             | 24 ++++++------
 32 files changed, 254 insertions(+), 254 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 44d6c5743fb9..6fe4a7174271 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -170,10 +170,10 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
 }
 
 static int bnxt_tc_parse_flow(struct bnxt *bp,
-			      struct tc_cls_flower_offload *tc_flow_cmd,
+			      struct flow_cls_offload *tc_flow_cmd,
 			      struct bnxt_tc_flow *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(tc_flow_cmd);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(tc_flow_cmd);
 	struct flow_dissector *dissector = rule->match.dissector;
 
 	/* KEY_CONTROL and KEY_BASIC are needed for forming a meaningful key */
@@ -1262,7 +1262,7 @@ static void bnxt_tc_set_src_fid(struct bnxt *bp, struct bnxt_tc_flow *flow,
  * The hash-tables are already protected by the rhashtable API.
  */
 static int bnxt_tc_add_flow(struct bnxt *bp, u16 src_fid,
-			    struct tc_cls_flower_offload *tc_flow_cmd)
+			    struct flow_cls_offload *tc_flow_cmd)
 {
 	struct bnxt_tc_flow_node *new_node, *old_node;
 	struct bnxt_tc_info *tc_info = bp->tc_info;
@@ -1348,7 +1348,7 @@ static int bnxt_tc_add_flow(struct bnxt *bp, u16 src_fid,
 }
 
 static int bnxt_tc_del_flow(struct bnxt *bp,
-			    struct tc_cls_flower_offload *tc_flow_cmd)
+			    struct flow_cls_offload *tc_flow_cmd)
 {
 	struct bnxt_tc_info *tc_info = bp->tc_info;
 	struct bnxt_tc_flow_node *flow_node;
@@ -1363,7 +1363,7 @@ static int bnxt_tc_del_flow(struct bnxt *bp,
 }
 
 static int bnxt_tc_get_flow_stats(struct bnxt *bp,
-				  struct tc_cls_flower_offload *tc_flow_cmd)
+				  struct flow_cls_offload *tc_flow_cmd)
 {
 	struct bnxt_tc_flow_stats stats, *curr_stats, *prev_stats;
 	struct bnxt_tc_info *tc_info = bp->tc_info;
@@ -1585,14 +1585,14 @@ void bnxt_tc_flow_stats_work(struct bnxt *bp)
 }
 
 int bnxt_tc_setup_flower(struct bnxt *bp, u16 src_fid,
-			 struct tc_cls_flower_offload *cls_flower)
+			 struct flow_cls_offload *cls_flower)
 {
 	switch (cls_flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return bnxt_tc_add_flow(bp, src_fid, cls_flower);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return bnxt_tc_del_flow(bp, cls_flower);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return bnxt_tc_get_flow_stats(bp, cls_flower);
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
index 8a0968967bc5..ffec57d1a5ec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -196,7 +196,7 @@ struct bnxt_tc_flow_node {
 };
 
 int bnxt_tc_setup_flower(struct bnxt *bp, u16 src_fid,
-			 struct tc_cls_flower_offload *cls_flower);
+			 struct flow_cls_offload *cls_flower);
 int bnxt_init_tc(struct bnxt *bp);
 void bnxt_shutdown_tc(struct bnxt *bp);
 void bnxt_tc_flow_stats_work(struct bnxt *bp);
@@ -209,7 +209,7 @@ static inline bool bnxt_tc_flower_enabled(struct bnxt *bp)
 #else /* CONFIG_BNXT_FLOWER_OFFLOAD */
 
 static inline int bnxt_tc_setup_flower(struct bnxt *bp, u16 src_fid,
-				       struct tc_cls_flower_offload *cls_flower)
+				       struct flow_cls_offload *cls_flower)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index fdc8ca4f8891..67202b6f352e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3135,14 +3135,14 @@ static int cxgb_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 }
 
 static int cxgb_setup_tc_flower(struct net_device *dev,
-				struct tc_cls_flower_offload *cls_flower)
+				struct flow_cls_offload *cls_flower)
 {
 	switch (cls_flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return cxgb4_tc_flower_replace(dev, cls_flower);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return cxgb4_tc_flower_destroy(dev, cls_flower);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return cxgb4_tc_flower_stats(dev, cls_flower);
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index cfaf8f618d1f..312599c6b35a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -80,10 +80,10 @@ static struct ch_tc_flower_entry *ch_flower_lookup(struct adapter *adap,
 }
 
 static void cxgb4_process_flow_match(struct net_device *dev,
-				     struct tc_cls_flower_offload *cls,
+				     struct flow_cls_offload *cls,
 				     struct ch_filter_specification *fs)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	u16 addr_type = 0;
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
@@ -223,9 +223,9 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 }
 
 static int cxgb4_validate_flow_match(struct net_device *dev,
-				     struct tc_cls_flower_offload *cls)
+				     struct flow_cls_offload *cls)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 ethtype_mask = 0;
 	u16 ethtype_key = 0;
@@ -378,10 +378,10 @@ static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
 }
 
 static void cxgb4_process_flow_actions(struct net_device *in,
-				       struct tc_cls_flower_offload *cls,
+				       struct flow_cls_offload *cls,
 				       struct ch_filter_specification *fs)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_action_entry *act;
 	int i;
 
@@ -544,9 +544,9 @@ static bool valid_pedit_action(struct net_device *dev,
 }
 
 static int cxgb4_validate_flow_actions(struct net_device *dev,
-				       struct tc_cls_flower_offload *cls)
+				       struct flow_cls_offload *cls)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(cls);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_action_entry *act;
 	bool act_redir = false;
 	bool act_pedit = false;
@@ -633,7 +633,7 @@ static int cxgb4_validate_flow_actions(struct net_device *dev,
 }
 
 int cxgb4_tc_flower_replace(struct net_device *dev,
-			    struct tc_cls_flower_offload *cls)
+			    struct flow_cls_offload *cls)
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct ch_tc_flower_entry *ch_flower;
@@ -709,7 +709,7 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 }
 
 int cxgb4_tc_flower_destroy(struct net_device *dev,
-			    struct tc_cls_flower_offload *cls)
+			    struct flow_cls_offload *cls)
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct ch_tc_flower_entry *ch_flower;
@@ -783,7 +783,7 @@ static void ch_flower_stats_cb(struct timer_list *t)
 }
 
 int cxgb4_tc_flower_stats(struct net_device *dev,
-			  struct tc_cls_flower_offload *cls)
+			  struct flow_cls_offload *cls)
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct ch_tc_flower_stats *ofld_stats;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index 050c8a50ae41..eb4c95248baf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -109,11 +109,11 @@ struct ch_tc_pedit_fields {
 #define PEDIT_UDP_SPORT_DPORT		0x0
 
 int cxgb4_tc_flower_replace(struct net_device *dev,
-			    struct tc_cls_flower_offload *cls);
+			    struct flow_cls_offload *cls);
 int cxgb4_tc_flower_destroy(struct net_device *dev,
-			    struct tc_cls_flower_offload *cls);
+			    struct flow_cls_offload *cls);
 int cxgb4_tc_flower_stats(struct net_device *dev,
-			  struct tc_cls_flower_offload *cls);
+			  struct flow_cls_offload *cls);
 
 int cxgb4_init_tc_flower(struct adapter *adap);
 void cxgb4_cleanup_tc_flower(struct adapter *adap);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 7be1080680f5..9ebbe3da61bb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7759,15 +7759,15 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 /**
  * i40e_parse_cls_flower - Parse tc flower filters provided by kernel
  * @vsi: Pointer to VSI
- * @cls_flower: Pointer to struct tc_cls_flower_offload
+ * @cls_flower: Pointer to struct flow_cls_offload
  * @filter: Pointer to cloud filter structure
  *
  **/
 static int i40e_parse_cls_flower(struct i40e_vsi *vsi,
-				 struct tc_cls_flower_offload *f,
+				 struct flow_cls_offload *f,
 				 struct i40e_cloud_filter *filter)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 n_proto_mask = 0, n_proto_key = 0, addr_type = 0;
 	struct i40e_pf *pf = vsi->back;
@@ -8001,11 +8001,11 @@ static int i40e_handle_tclass(struct i40e_vsi *vsi, u32 tc,
 /**
  * i40e_configure_clsflower - Configure tc flower filters
  * @vsi: Pointer to VSI
- * @cls_flower: Pointer to struct tc_cls_flower_offload
+ * @cls_flower: Pointer to struct flow_cls_offload
  *
  **/
 static int i40e_configure_clsflower(struct i40e_vsi *vsi,
-				    struct tc_cls_flower_offload *cls_flower)
+				    struct flow_cls_offload *cls_flower)
 {
 	int tc = tc_classid_to_hwtc(vsi->netdev, cls_flower->classid);
 	struct i40e_cloud_filter *filter = NULL;
@@ -8097,11 +8097,11 @@ static struct i40e_cloud_filter *i40e_find_cloud_filter(struct i40e_vsi *vsi,
 /**
  * i40e_delete_clsflower - Remove tc flower filters
  * @vsi: Pointer to VSI
- * @cls_flower: Pointer to struct tc_cls_flower_offload
+ * @cls_flower: Pointer to struct flow_cls_offload
  *
  **/
 static int i40e_delete_clsflower(struct i40e_vsi *vsi,
-				 struct tc_cls_flower_offload *cls_flower)
+				 struct flow_cls_offload *cls_flower)
 {
 	struct i40e_cloud_filter *filter = NULL;
 	struct i40e_pf *pf = vsi->back;
@@ -8144,16 +8144,16 @@ static int i40e_delete_clsflower(struct i40e_vsi *vsi,
  * @type_data: offload data
  **/
 static int i40e_setup_tc_cls_flower(struct i40e_netdev_priv *np,
-				    struct tc_cls_flower_offload *cls_flower)
+				    struct flow_cls_offload *cls_flower)
 {
 	struct i40e_vsi *vsi = np->vsi;
 
 	switch (cls_flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return i40e_configure_clsflower(vsi, cls_flower);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return i40e_delete_clsflower(vsi, cls_flower);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return -EOPNOTSUPP;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 05eca6f2e890..9d2b50964a08 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2699,14 +2699,14 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 /**
  * iavf_parse_cls_flower - Parse tc flower filters provided by kernel
  * @adapter: board private structure
- * @cls_flower: pointer to struct tc_cls_flower_offload
+ * @cls_flower: pointer to struct flow_cls_offload
  * @filter: pointer to cloud filter structure
  */
 static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
-				 struct tc_cls_flower_offload *f,
+				 struct flow_cls_offload *f,
 				 struct iavf_cloud_filter *filter)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 n_proto_mask = 0;
 	u16 n_proto_key = 0;
@@ -2971,10 +2971,10 @@ static int iavf_handle_tclass(struct iavf_adapter *adapter, u32 tc,
 /**
  * iavf_configure_clsflower - Add tc flower filters
  * @adapter: board private structure
- * @cls_flower: Pointer to struct tc_cls_flower_offload
+ * @cls_flower: Pointer to struct flow_cls_offload
  */
 static int iavf_configure_clsflower(struct iavf_adapter *adapter,
-				    struct tc_cls_flower_offload *cls_flower)
+				    struct flow_cls_offload *cls_flower)
 {
 	int tc = tc_classid_to_hwtc(adapter->netdev, cls_flower->classid);
 	struct iavf_cloud_filter *filter = NULL;
@@ -3050,10 +3050,10 @@ static struct iavf_cloud_filter *iavf_find_cf(struct iavf_adapter *adapter,
 /**
  * iavf_delete_clsflower - Remove tc flower filters
  * @adapter: board private structure
- * @cls_flower: Pointer to struct tc_cls_flower_offload
+ * @cls_flower: Pointer to struct flow_cls_offload
  */
 static int iavf_delete_clsflower(struct iavf_adapter *adapter,
-				 struct tc_cls_flower_offload *cls_flower)
+				 struct flow_cls_offload *cls_flower)
 {
 	struct iavf_cloud_filter *filter = NULL;
 	int err = 0;
@@ -3077,17 +3077,17 @@ static int iavf_delete_clsflower(struct iavf_adapter *adapter,
  * @type_data: offload data
  */
 static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
-				    struct tc_cls_flower_offload *cls_flower)
+				    struct flow_cls_offload *cls_flower)
 {
 	if (cls_flower->common.chain_index)
 		return -EOPNOTSUPP;
 
 	switch (cls_flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return iavf_configure_clsflower(adapter, cls_flower);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return iavf_delete_clsflower(adapter, cls_flower);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return -EOPNOTSUPP;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 00e8186e2c59..b4df3e319467 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2578,11 +2578,11 @@ static int igb_offload_cbs(struct igb_adapter *adapter,
 #define VLAN_PRIO_FULL_MASK (0x07)
 
 static int igb_parse_cls_flower(struct igb_adapter *adapter,
-				struct tc_cls_flower_offload *f,
+				struct flow_cls_offload *f,
 				int traffic_class,
 				struct igb_nfc_filter *input)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	struct netlink_ext_ack *extack = f->common.extack;
 
@@ -2660,7 +2660,7 @@ static int igb_parse_cls_flower(struct igb_adapter *adapter,
 }
 
 static int igb_configure_clsflower(struct igb_adapter *adapter,
-				   struct tc_cls_flower_offload *cls_flower)
+				   struct flow_cls_offload *cls_flower)
 {
 	struct netlink_ext_ack *extack = cls_flower->common.extack;
 	struct igb_nfc_filter *filter, *f;
@@ -2722,7 +2722,7 @@ static int igb_configure_clsflower(struct igb_adapter *adapter,
 }
 
 static int igb_delete_clsflower(struct igb_adapter *adapter,
-				struct tc_cls_flower_offload *cls_flower)
+				struct flow_cls_offload *cls_flower)
 {
 	struct igb_nfc_filter *filter;
 	int err;
@@ -2752,14 +2752,14 @@ static int igb_delete_clsflower(struct igb_adapter *adapter,
 }
 
 static int igb_setup_tc_cls_flower(struct igb_adapter *adapter,
-				   struct tc_cls_flower_offload *cls_flower)
+				   struct flow_cls_offload *cls_flower)
 {
 	switch (cls_flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return igb_configure_clsflower(adapter, cls_flower);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return igb_delete_clsflower(adapter, cls_flower);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return -EOPNOTSUPP;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 3739646b653f..a6a52806be45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -452,7 +452,7 @@ int mlx5e_tc_tun_init_encap_attr(struct net_device *tunnel_dev,
 int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 		       struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
-		       struct tc_cls_flower_offload *f,
+		       struct flow_cls_offload *f,
 		       void *headers_c,
 		       void *headers_v, u8 *match_level)
 {
@@ -489,11 +489,11 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 
 int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 				 struct mlx5_flow_spec *spec,
-				 struct tc_cls_flower_offload *f,
+				 struct flow_cls_offload *f,
 				 void *headers_c,
 				 void *headers_v)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_match_ports enc_ports;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 3c48f7e62505..c362b9225dc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -33,12 +33,12 @@ struct mlx5e_tc_tunnel {
 				   struct mlx5e_encap_entry *e);
 	int (*parse_udp_ports)(struct mlx5e_priv *priv,
 			       struct mlx5_flow_spec *spec,
-			       struct tc_cls_flower_offload *f,
+			       struct flow_cls_offload *f,
 			       void *headers_c,
 			       void *headers_v);
 	int (*parse_tunnel)(struct mlx5e_priv *priv,
 			    struct mlx5_flow_spec *spec,
-			    struct tc_cls_flower_offload *f,
+			    struct flow_cls_offload *f,
 			    void *headers_c,
 			    void *headers_v);
 };
@@ -68,13 +68,13 @@ bool mlx5e_tc_tun_device_to_offload(struct mlx5e_priv *priv,
 int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 		       struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
-		       struct tc_cls_flower_offload *f,
+		       struct flow_cls_offload *f,
 		       void *headers_c,
 		       void *headers_v, u8 *match_level);
 
 int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 				 struct mlx5_flow_spec *spec,
-				 struct tc_cls_flower_offload *f,
+				 struct flow_cls_offload *f,
 				 void *headers_c,
 				 void *headers_v);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 238ae85d07cc..951ea26d96bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -20,9 +20,9 @@ static int mlx5e_tc_tun_calc_hlen_geneve(struct mlx5e_encap_entry *e)
 }
 
 static int mlx5e_tc_tun_check_udp_dport_geneve(struct mlx5e_priv *priv,
-					       struct tc_cls_flower_offload *f)
+					       struct flow_cls_offload *f)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_match_ports enc_ports;
 
@@ -48,7 +48,7 @@ static int mlx5e_tc_tun_check_udp_dport_geneve(struct mlx5e_priv *priv,
 
 static int mlx5e_tc_tun_parse_udp_ports_geneve(struct mlx5e_priv *priv,
 					       struct mlx5_flow_spec *spec,
-					       struct tc_cls_flower_offload *f,
+					       struct flow_cls_offload *f,
 					       void *headers_c,
 					       void *headers_v)
 {
@@ -122,9 +122,9 @@ static int mlx5e_gen_ip_tunnel_header_geneve(char buf[],
 
 static int mlx5e_tc_tun_parse_geneve_vni(struct mlx5e_priv *priv,
 					 struct mlx5_flow_spec *spec,
-					 struct tc_cls_flower_offload *f)
+					 struct flow_cls_offload *f)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_match_enc_keyid enc_keyid;
 	void *misc_c, *misc_v;
@@ -154,11 +154,11 @@ static int mlx5e_tc_tun_parse_geneve_vni(struct mlx5e_priv *priv,
 
 static int mlx5e_tc_tun_parse_geneve_options(struct mlx5e_priv *priv,
 					     struct mlx5_flow_spec *spec,
-					     struct tc_cls_flower_offload *f)
+					     struct flow_cls_offload *f)
 {
 	u8 max_tlv_option_data_len = MLX5_CAP_GEN(priv->mdev, max_geneve_tlv_option_data_len);
 	u8 max_tlv_options = MLX5_CAP_GEN(priv->mdev, max_geneve_tlv_options);
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	void *misc_c, *misc_v, *misc_3_c, *misc_3_v;
 	struct geneve_opt *option_key, *option_mask;
@@ -277,7 +277,7 @@ static int mlx5e_tc_tun_parse_geneve_options(struct mlx5e_priv *priv,
 
 static int mlx5e_tc_tun_parse_geneve_params(struct mlx5e_priv *priv,
 					    struct mlx5_flow_spec *spec,
-					    struct tc_cls_flower_offload *f)
+					    struct flow_cls_offload *f)
 {
 	void *misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	void *misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,  misc_parameters);
@@ -306,7 +306,7 @@ static int mlx5e_tc_tun_parse_geneve_params(struct mlx5e_priv *priv,
 
 static int mlx5e_tc_tun_parse_geneve(struct mlx5e_priv *priv,
 				     struct mlx5_flow_spec *spec,
-				     struct tc_cls_flower_offload *f,
+				     struct flow_cls_offload *f,
 				     void *headers_c,
 				     void *headers_v)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
index 06908441d932..58b13192df23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
@@ -54,13 +54,13 @@ static int mlx5e_gen_ip_tunnel_header_gretap(char buf[],
 
 static int mlx5e_tc_tun_parse_gretap(struct mlx5e_priv *priv,
 				     struct mlx5_flow_spec *spec,
-				     struct tc_cls_flower_offload *f,
+				     struct flow_cls_offload *f,
 				     void *headers_c,
 				     void *headers_v)
 {
 	void *misc_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	void *misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 
 	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ip_protocol);
 	MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_protocol, IPPROTO_GRE);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 2857b38527d6..37b176801bcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -16,9 +16,9 @@ static int mlx5e_tc_tun_calc_hlen_vxlan(struct mlx5e_encap_entry *e)
 }
 
 static int mlx5e_tc_tun_check_udp_dport_vxlan(struct mlx5e_priv *priv,
-					      struct tc_cls_flower_offload *f)
+					      struct flow_cls_offload *f)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_match_ports enc_ports;
 
@@ -44,7 +44,7 @@ static int mlx5e_tc_tun_check_udp_dport_vxlan(struct mlx5e_priv *priv,
 
 static int mlx5e_tc_tun_parse_udp_ports_vxlan(struct mlx5e_priv *priv,
 					      struct mlx5_flow_spec *spec,
-					      struct tc_cls_flower_offload *f,
+					      struct flow_cls_offload *f,
 					      void *headers_c,
 					      void *headers_v)
 {
@@ -100,11 +100,11 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 
 static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 				    struct mlx5_flow_spec *spec,
-				    struct tc_cls_flower_offload *f,
+				    struct flow_cls_offload *f,
 				    void *headers_c,
 				    void *headers_v)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct flow_match_enc_keyid enc_keyid;
 	void *misc_c, *misc_v;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 10ee7c96d542..09963defcd16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3426,17 +3426,17 @@ static int mlx5e_setup_tc_mqprio(struct net_device *netdev,
 
 #ifdef CONFIG_MLX5_ESWITCH
 static int mlx5e_setup_tc_cls_flower(struct mlx5e_priv *priv,
-				     struct tc_cls_flower_offload *cls_flower,
+				     struct flow_cls_offload *cls_flower,
 				     int flags)
 {
 	switch (cls_flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return mlx5e_configure_flower(priv->netdev, priv, cls_flower,
 					      flags);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return mlx5e_delete_flower(priv->netdev, priv, cls_flower,
 					   flags);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return mlx5e_stats_flower(priv->netdev, priv, cls_flower,
 					  flags);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index b976f16e828c..1a13df235f6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -655,7 +655,7 @@ static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
 
 static int
 mlx5e_rep_indr_offload(struct net_device *netdev,
-		       struct tc_cls_flower_offload *flower,
+		       struct flow_cls_offload *flower,
 		       struct mlx5e_rep_indr_block_priv *indr_priv)
 {
 	struct mlx5e_priv *priv = netdev_priv(indr_priv->rpriv->netdev);
@@ -663,13 +663,13 @@ mlx5e_rep_indr_offload(struct net_device *netdev,
 	int err = 0;
 
 	switch (flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		err = mlx5e_configure_flower(netdev, priv, flower, flags);
 		break;
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		err = mlx5e_delete_flower(netdev, priv, flower, flags);
 		break;
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		err = mlx5e_stats_flower(netdev, priv, flower, flags);
 		break;
 	default:
@@ -1169,16 +1169,16 @@ static int mlx5e_rep_get_phys_port_name(struct net_device *dev,
 
 static int
 mlx5e_rep_setup_tc_cls_flower(struct mlx5e_priv *priv,
-			      struct tc_cls_flower_offload *cls_flower, int flags)
+			      struct flow_cls_offload *cls_flower, int flags)
 {
 	switch (cls_flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return mlx5e_configure_flower(priv->netdev, priv, cls_flower,
 					      flags);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return mlx5e_delete_flower(priv->netdev, priv, cls_flower,
 					   flags);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return mlx5e_stats_flower(priv->netdev, priv, cls_flower,
 					  flags);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3ac9b1e423ee..2d6436257f9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1350,7 +1350,7 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct mlx5_flow_spec *spec,
-			     struct tc_cls_flower_offload *f,
+			     struct flow_cls_offload *f,
 			     struct net_device *filter_dev, u8 *match_level)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
@@ -1358,7 +1358,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 				       outer_headers);
 	void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				       outer_headers);
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	int err;
 
 	err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
@@ -1478,7 +1478,7 @@ static void *get_match_headers_value(u32 flags,
 
 static int __parse_cls_flower(struct mlx5e_priv *priv,
 			      struct mlx5_flow_spec *spec,
-			      struct tc_cls_flower_offload *f,
+			      struct flow_cls_offload *f,
 			      struct net_device *filter_dev,
 			      u8 *match_level, u8 *tunnel_match_level)
 {
@@ -1491,7 +1491,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				    misc_parameters);
 	void *misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    misc_parameters);
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
@@ -1831,7 +1831,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 static int parse_cls_flower(struct mlx5e_priv *priv,
 			    struct mlx5e_tc_flow *flow,
 			    struct mlx5_flow_spec *spec,
-			    struct tc_cls_flower_offload *f,
+			    struct flow_cls_offload *f,
 			    struct net_device *filter_dev)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
@@ -3115,7 +3115,7 @@ static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
 
 static int
 mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
-		 struct tc_cls_flower_offload *f, u16 flow_flags,
+		 struct flow_cls_offload *f, u16 flow_flags,
 		 struct mlx5e_tc_flow_parse_attr **__parse_attr,
 		 struct mlx5e_tc_flow **__flow)
 {
@@ -3149,7 +3149,7 @@ static void
 mlx5e_flow_esw_attr_init(struct mlx5_esw_flow_attr *esw_attr,
 			 struct mlx5e_priv *priv,
 			 struct mlx5e_tc_flow_parse_attr *parse_attr,
-			 struct tc_cls_flower_offload *f,
+			 struct flow_cls_offload *f,
 			 struct mlx5_eswitch_rep *in_rep,
 			 struct mlx5_core_dev *in_mdev)
 {
@@ -3171,13 +3171,13 @@ mlx5e_flow_esw_attr_init(struct mlx5_esw_flow_attr *esw_attr,
 
 static struct mlx5e_tc_flow *
 __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
-		     struct tc_cls_flower_offload *f,
+		     struct flow_cls_offload *f,
 		     u16 flow_flags,
 		     struct net_device *filter_dev,
 		     struct mlx5_eswitch_rep *in_rep,
 		     struct mlx5_core_dev *in_mdev)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_tc_flow *flow;
@@ -3221,7 +3221,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	return ERR_PTR(err);
 }
 
-static int mlx5e_tc_add_fdb_peer_flow(struct tc_cls_flower_offload *f,
+static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
 				      struct mlx5e_tc_flow *flow,
 				      u16 flow_flags)
 {
@@ -3273,7 +3273,7 @@ static int mlx5e_tc_add_fdb_peer_flow(struct tc_cls_flower_offload *f,
 
 static int
 mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
-		   struct tc_cls_flower_offload *f,
+		   struct flow_cls_offload *f,
 		   u16 flow_flags,
 		   struct net_device *filter_dev,
 		   struct mlx5e_tc_flow **__flow)
@@ -3307,12 +3307,12 @@ mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 
 static int
 mlx5e_add_nic_flow(struct mlx5e_priv *priv,
-		   struct tc_cls_flower_offload *f,
+		   struct flow_cls_offload *f,
 		   u16 flow_flags,
 		   struct net_device *filter_dev,
 		   struct mlx5e_tc_flow **__flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5e_tc_flow *flow;
@@ -3358,7 +3358,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 
 static int
 mlx5e_tc_add_flow(struct mlx5e_priv *priv,
-		  struct tc_cls_flower_offload *f,
+		  struct flow_cls_offload *f,
 		  int flags,
 		  struct net_device *filter_dev,
 		  struct mlx5e_tc_flow **flow)
@@ -3383,7 +3383,7 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 }
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
-			   struct tc_cls_flower_offload *f, int flags)
+			   struct flow_cls_offload *f, int flags)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct rhashtable *tc_ht = get_tc_ht(priv, flags);
@@ -3430,7 +3430,7 @@ static bool same_flow_direction(struct mlx5e_tc_flow *flow, int flags)
 }
 
 int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
-			struct tc_cls_flower_offload *f, int flags)
+			struct flow_cls_offload *f, int flags)
 {
 	struct rhashtable *tc_ht = get_tc_ht(priv, flags);
 	struct mlx5e_tc_flow *flow;
@@ -3449,7 +3449,7 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 }
 
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
-		       struct tc_cls_flower_offload *f, int flags)
+		       struct flow_cls_offload *f, int flags)
 {
 	struct mlx5_devcom *devcom = priv->mdev->priv.devcom;
 	struct rhashtable *tc_ht = get_tc_ht(priv, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 8f288cc53cee..3ab39275ca7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -54,12 +54,12 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht);
 void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht);
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
-			   struct tc_cls_flower_offload *f, int flags);
+			   struct flow_cls_offload *f, int flags);
 int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
-			struct tc_cls_flower_offload *f, int flags);
+			struct flow_cls_offload *f, int flags);
 
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
-		       struct tc_cls_flower_offload *f, int flags);
+		       struct flow_cls_offload *f, int flags);
 
 struct mlx5e_encap_entry;
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 35adc174f277..4d34d42b3b0e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1508,21 +1508,21 @@ static int mlxsw_sp_setup_tc_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int
 mlxsw_sp_setup_tc_cls_flower(struct mlxsw_sp_acl_block *acl_block,
-			     struct tc_cls_flower_offload *f)
+			     struct flow_cls_offload *f)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_acl_block_mlxsw_sp(acl_block);
 
 	switch (f->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return mlxsw_sp_flower_replace(mlxsw_sp, acl_block, f);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		mlxsw_sp_flower_destroy(mlxsw_sp, acl_block, f);
 		return 0;
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return mlxsw_sp_flower_stats(mlxsw_sp, acl_block, f);
-	case TC_CLSFLOWER_TMPLT_CREATE:
+	case FLOW_CLS_TMPLT_CREATE:
 		return mlxsw_sp_flower_tmplt_create(mlxsw_sp, acl_block, f);
-	case TC_CLSFLOWER_TMPLT_DESTROY:
+	case FLOW_CLS_TMPLT_DESTROY:
 		mlxsw_sp_flower_tmplt_destroy(mlxsw_sp, acl_block, f);
 		return 0;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index abbb563db440..a252b080dda9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -807,19 +807,19 @@ extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 /* spectrum_flower.c */
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_block *block,
-			    struct tc_cls_flower_offload *f);
+			    struct flow_cls_offload *f);
 void mlxsw_sp_flower_destroy(struct mlxsw_sp *mlxsw_sp,
 			     struct mlxsw_sp_acl_block *block,
-			     struct tc_cls_flower_offload *f);
+			     struct flow_cls_offload *f);
 int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_acl_block *block,
-			  struct tc_cls_flower_offload *f);
+			  struct flow_cls_offload *f);
 int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_block *block,
-				 struct tc_cls_flower_offload *f);
+				 struct flow_cls_offload *f);
 void mlxsw_sp_flower_tmplt_destroy(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_acl_block *block,
-				   struct tc_cls_flower_offload *f);
+				   struct flow_cls_offload *f);
 
 /* spectrum_qdisc.c */
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index a83e1a986ef1..202e9a246019 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -121,10 +121,10 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
-				      struct tc_cls_flower_offload *f,
+				      struct flow_cls_offload *f,
 				      struct mlxsw_sp_acl_block *block)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct net_device *ingress_dev;
 	struct flow_match_meta match;
@@ -164,7 +164,7 @@ static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
 }
 
 static void mlxsw_sp_flower_parse_ipv4(struct mlxsw_sp_acl_rule_info *rulei,
-				       struct tc_cls_flower_offload *f)
+				       struct flow_cls_offload *f)
 {
 	struct flow_match_ipv4_addrs match;
 
@@ -179,7 +179,7 @@ static void mlxsw_sp_flower_parse_ipv4(struct mlxsw_sp_acl_rule_info *rulei,
 }
 
 static void mlxsw_sp_flower_parse_ipv6(struct mlxsw_sp_acl_rule_info *rulei,
-				       struct tc_cls_flower_offload *f)
+				       struct flow_cls_offload *f)
 {
 	struct flow_match_ipv6_addrs match;
 
@@ -213,10 +213,10 @@ static void mlxsw_sp_flower_parse_ipv6(struct mlxsw_sp_acl_rule_info *rulei,
 
 static int mlxsw_sp_flower_parse_ports(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_acl_rule_info *rulei,
-				       struct tc_cls_flower_offload *f,
+				       struct flow_cls_offload *f,
 				       u8 ip_proto)
 {
-	const struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	const struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_match_ports match;
 
 	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS))
@@ -240,10 +240,10 @@ static int mlxsw_sp_flower_parse_ports(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_flower_parse_tcp(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_acl_rule_info *rulei,
-				     struct tc_cls_flower_offload *f,
+				     struct flow_cls_offload *f,
 				     u8 ip_proto)
 {
-	const struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	const struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_match_tcp match;
 
 	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP))
@@ -265,10 +265,10 @@ static int mlxsw_sp_flower_parse_tcp(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_flower_parse_ip(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_acl_rule_info *rulei,
-				    struct tc_cls_flower_offload *f,
+				    struct flow_cls_offload *f,
 				    u16 n_proto)
 {
-	const struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	const struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_match_ip match;
 
 	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP))
@@ -299,9 +299,9 @@ static int mlxsw_sp_flower_parse_ip(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_block *block,
 				 struct mlxsw_sp_acl_rule_info *rulei,
-				 struct tc_cls_flower_offload *f)
+				 struct flow_cls_offload *f)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 n_proto_mask = 0;
 	u16 n_proto_key = 0;
@@ -426,7 +426,7 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_block *block,
-			    struct tc_cls_flower_offload *f)
+			    struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_rule_info *rulei;
 	struct mlxsw_sp_acl_ruleset *ruleset;
@@ -473,7 +473,7 @@ int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
 
 void mlxsw_sp_flower_destroy(struct mlxsw_sp *mlxsw_sp,
 			     struct mlxsw_sp_acl_block *block,
-			     struct tc_cls_flower_offload *f)
+			     struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset;
 	struct mlxsw_sp_acl_rule *rule;
@@ -495,7 +495,7 @@ void mlxsw_sp_flower_destroy(struct mlxsw_sp *mlxsw_sp,
 
 int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_acl_block *block,
-			  struct tc_cls_flower_offload *f)
+			  struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset;
 	struct mlxsw_sp_acl_rule *rule;
@@ -531,7 +531,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 
 int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_block *block,
-				 struct tc_cls_flower_offload *f)
+				 struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset;
 	struct mlxsw_sp_acl_rule_info rulei;
@@ -552,7 +552,7 @@ int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
 
 void mlxsw_sp_flower_tmplt_destroy(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_acl_block *block,
-				   struct tc_cls_flower_offload *f)
+				   struct flow_cls_offload *f)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 5b92c2a03f3d..7aaddc09c185 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -19,7 +19,7 @@ static u16 get_prio(u32 prio)
 	return prio >> 16;
 }
 
-static int ocelot_flower_parse_action(struct tc_cls_flower_offload *f,
+static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				      struct ocelot_ace_rule *rule)
 {
 	const struct flow_action_entry *a;
@@ -44,10 +44,10 @@ static int ocelot_flower_parse_action(struct tc_cls_flower_offload *f,
 	return 0;
 }
 
-static int ocelot_flower_parse(struct tc_cls_flower_offload *f,
+static int ocelot_flower_parse(struct flow_cls_offload *f,
 			       struct ocelot_ace_rule *ocelot_rule)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 
 	if (dissector->used_keys &
@@ -174,7 +174,7 @@ static int ocelot_flower_parse(struct tc_cls_flower_offload *f,
 }
 
 static
-struct ocelot_ace_rule *ocelot_ace_rule_create(struct tc_cls_flower_offload *f,
+struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
 					       struct ocelot_port_block *block)
 {
 	struct ocelot_ace_rule *rule;
@@ -188,7 +188,7 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct tc_cls_flower_offload *f,
 	return rule;
 }
 
-static int ocelot_flower_replace(struct tc_cls_flower_offload *f,
+static int ocelot_flower_replace(struct flow_cls_offload *f,
 				 struct ocelot_port_block *port_block)
 {
 	struct ocelot_ace_rule *rule;
@@ -212,7 +212,7 @@ static int ocelot_flower_replace(struct tc_cls_flower_offload *f,
 	return 0;
 }
 
-static int ocelot_flower_destroy(struct tc_cls_flower_offload *f,
+static int ocelot_flower_destroy(struct flow_cls_offload *f,
 				 struct ocelot_port_block *port_block)
 {
 	struct ocelot_ace_rule rule;
@@ -230,7 +230,7 @@ static int ocelot_flower_destroy(struct tc_cls_flower_offload *f,
 	return 0;
 }
 
-static int ocelot_flower_stats_update(struct tc_cls_flower_offload *f,
+static int ocelot_flower_stats_update(struct flow_cls_offload *f,
 				      struct ocelot_port_block *port_block)
 {
 	struct ocelot_ace_rule rule;
@@ -247,15 +247,15 @@ static int ocelot_flower_stats_update(struct tc_cls_flower_offload *f,
 	return 0;
 }
 
-static int ocelot_setup_tc_cls_flower(struct tc_cls_flower_offload *f,
+static int ocelot_setup_tc_cls_flower(struct flow_cls_offload *f,
 				      struct ocelot_port_block *port_block)
 {
 	switch (f->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return ocelot_flower_replace(f, port_block);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return ocelot_flower_destroy(f, port_block);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return ocelot_flower_stats_update(f, port_block);
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index b6bd31fe44b2..5a54fe848de4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -171,7 +171,7 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 }
 
 static bool
-nfp_flower_tun_is_gre(struct tc_cls_flower_offload *flow, int start_idx)
+nfp_flower_tun_is_gre(struct flow_cls_offload *flow, int start_idx)
 {
 	struct flow_action_entry *act = flow->rule->action.entries;
 	int num_act = flow->rule->action.num_entries;
@@ -188,7 +188,7 @@ nfp_flower_tun_is_gre(struct tc_cls_flower_offload *flow, int start_idx)
 
 static enum nfp_flower_tun_type
 nfp_fl_get_tun_from_act(struct nfp_app *app,
-			struct tc_cls_flower_offload *flow,
+			struct flow_cls_offload *flow,
 			const struct flow_action_entry *act, int act_idx)
 {
 	const struct ip_tunnel_info *tun = act->tunnel;
@@ -669,11 +669,11 @@ struct nfp_flower_pedit_acts {
 };
 
 static int
-nfp_fl_commit_mangle(struct tc_cls_flower_offload *flow, char *nfp_action,
+nfp_fl_commit_mangle(struct flow_cls_offload *flow, char *nfp_action,
 		     int *a_len, struct nfp_flower_pedit_acts *set_act,
 		     u32 *csum_updated)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	size_t act_size = 0;
 	u8 ip_proto = 0;
 
@@ -771,7 +771,7 @@ nfp_fl_commit_mangle(struct tc_cls_flower_offload *flow, char *nfp_action,
 
 static int
 nfp_fl_pedit(const struct flow_action_entry *act,
-	     struct tc_cls_flower_offload *flow, char *nfp_action, int *a_len,
+	     struct flow_cls_offload *flow, char *nfp_action, int *a_len,
 	     u32 *csum_updated, struct nfp_flower_pedit_acts *set_act,
 	     struct netlink_ext_ack *extack)
 {
@@ -858,7 +858,7 @@ nfp_flower_output_action(struct nfp_app *app,
 
 static int
 nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
-		       struct tc_cls_flower_offload *flow,
+		       struct flow_cls_offload *flow,
 		       struct nfp_fl_payload *nfp_fl, int *a_len,
 		       struct net_device *netdev,
 		       enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
@@ -1021,7 +1021,7 @@ static bool nfp_fl_check_mangle_end(struct flow_action *flow_act,
 }
 
 int nfp_flower_compile_action(struct nfp_app *app,
-			      struct tc_cls_flower_offload *flow,
+			      struct flow_cls_offload *flow,
 			      struct net_device *netdev,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 1f165d89582d..af9441d5787f 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -343,19 +343,19 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 				     struct nfp_fl_payload *sub_flow1,
 				     struct nfp_fl_payload *sub_flow2);
 int nfp_flower_compile_flow_match(struct nfp_app *app,
-				  struct tc_cls_flower_offload *flow,
+				  struct flow_cls_offload *flow,
 				  struct nfp_fl_key_ls *key_ls,
 				  struct net_device *netdev,
 				  struct nfp_fl_payload *nfp_flow,
 				  enum nfp_flower_tun_type tun_type,
 				  struct netlink_ext_ack *extack);
 int nfp_flower_compile_action(struct nfp_app *app,
-			      struct tc_cls_flower_offload *flow,
+			      struct flow_cls_offload *flow,
 			      struct net_device *netdev,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct netlink_ext_ack *extack);
 int nfp_compile_flow_metadata(struct nfp_app *app,
-			      struct tc_cls_flower_offload *flow,
+			      struct flow_cls_offload *flow,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct net_device *netdev,
 			      struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index c1690de19172..9cc3ba17ff69 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -10,9 +10,9 @@
 static void
 nfp_flower_compile_meta_tci(struct nfp_flower_meta_tci *ext,
 			    struct nfp_flower_meta_tci *msk,
-			    struct tc_cls_flower_offload *flow, u8 key_type)
+			    struct flow_cls_offload *flow, u8 key_type)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	u16 tmp_tci;
 
 	memset(ext, 0, sizeof(struct nfp_flower_meta_tci));
@@ -78,9 +78,9 @@ nfp_flower_compile_port(struct nfp_flower_in_port *frame, u32 cmsg_port,
 static void
 nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
 		       struct nfp_flower_mac_mpls *msk,
-		       struct tc_cls_flower_offload *flow)
+		       struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	memset(ext, 0, sizeof(struct nfp_flower_mac_mpls));
 	memset(msk, 0, sizeof(struct nfp_flower_mac_mpls));
@@ -130,9 +130,9 @@ nfp_flower_compile_mac(struct nfp_flower_mac_mpls *ext,
 static void
 nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
 			 struct nfp_flower_tp_ports *msk,
-			 struct tc_cls_flower_offload *flow)
+			 struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	memset(ext, 0, sizeof(struct nfp_flower_tp_ports));
 	memset(msk, 0, sizeof(struct nfp_flower_tp_ports));
@@ -151,9 +151,9 @@ nfp_flower_compile_tport(struct nfp_flower_tp_ports *ext,
 static void
 nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
 			  struct nfp_flower_ip_ext *msk,
-			  struct tc_cls_flower_offload *flow)
+			  struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
@@ -225,9 +225,9 @@ nfp_flower_compile_ip_ext(struct nfp_flower_ip_ext *ext,
 static void
 nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
 			struct nfp_flower_ipv4 *msk,
-			struct tc_cls_flower_offload *flow)
+			struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct flow_match_ipv4_addrs match;
 
 	memset(ext, 0, sizeof(struct nfp_flower_ipv4));
@@ -247,9 +247,9 @@ nfp_flower_compile_ipv4(struct nfp_flower_ipv4 *ext,
 static void
 nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
 			struct nfp_flower_ipv6 *msk,
-			struct tc_cls_flower_offload *flow)
+			struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	memset(ext, 0, sizeof(struct nfp_flower_ipv6));
 	memset(msk, 0, sizeof(struct nfp_flower_ipv6));
@@ -269,7 +269,7 @@ nfp_flower_compile_ipv6(struct nfp_flower_ipv6 *ext,
 
 static int
 nfp_flower_compile_geneve_opt(void *ext, void *msk,
-			      struct tc_cls_flower_offload *flow)
+			      struct flow_cls_offload *flow)
 {
 	struct flow_match_enc_opts match;
 
@@ -283,9 +283,9 @@ nfp_flower_compile_geneve_opt(void *ext, void *msk,
 static void
 nfp_flower_compile_tun_ipv4_addrs(struct nfp_flower_tun_ipv4 *ext,
 				  struct nfp_flower_tun_ipv4 *msk,
-				  struct tc_cls_flower_offload *flow)
+				  struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
 		struct flow_match_ipv4_addrs match;
@@ -301,9 +301,9 @@ nfp_flower_compile_tun_ipv4_addrs(struct nfp_flower_tun_ipv4 *ext,
 static void
 nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 			      struct nfp_flower_tun_ip_ext *msk,
-			      struct tc_cls_flower_offload *flow)
+			      struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
 		struct flow_match_ip match;
@@ -319,9 +319,9 @@ nfp_flower_compile_tun_ip_ext(struct nfp_flower_tun_ip_ext *ext,
 static void
 nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 				struct nfp_flower_ipv4_gre_tun *msk,
-				struct tc_cls_flower_offload *flow)
+				struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	memset(ext, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
 	memset(msk, 0, sizeof(struct nfp_flower_ipv4_gre_tun));
@@ -348,9 +348,9 @@ nfp_flower_compile_ipv4_gre_tun(struct nfp_flower_ipv4_gre_tun *ext,
 static void
 nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 				struct nfp_flower_ipv4_udp_tun *msk,
-				struct tc_cls_flower_offload *flow)
+				struct flow_cls_offload *flow)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 
 	memset(ext, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
 	memset(msk, 0, sizeof(struct nfp_flower_ipv4_udp_tun));
@@ -371,7 +371,7 @@ nfp_flower_compile_ipv4_udp_tun(struct nfp_flower_ipv4_udp_tun *ext,
 }
 
 int nfp_flower_compile_flow_match(struct nfp_app *app,
-				  struct tc_cls_flower_offload *flow,
+				  struct flow_cls_offload *flow,
 				  struct nfp_fl_key_ls *key_ls,
 				  struct net_device *netdev,
 				  struct nfp_fl_payload *nfp_flow,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index dae60961c1eb..7c4a15e967df 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -290,7 +290,7 @@ nfp_check_mask_remove(struct nfp_app *app, char *mask_data, u32 mask_len,
 }
 
 int nfp_compile_flow_metadata(struct nfp_app *app,
-			      struct tc_cls_flower_offload *flow,
+			      struct flow_cls_offload *flow,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct net_device *netdev,
 			      struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 1b38cfeb646c..7e725fa60347 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -121,9 +121,9 @@ nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 	return 0;
 }
 
-static bool nfp_flower_check_higher_than_mac(struct tc_cls_flower_offload *f)
+static bool nfp_flower_check_higher_than_mac(struct flow_cls_offload *f)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 
 	return flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS) ||
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS) ||
@@ -131,9 +131,9 @@ static bool nfp_flower_check_higher_than_mac(struct tc_cls_flower_offload *f)
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
 }
 
-static bool nfp_flower_check_higher_than_l3(struct tc_cls_flower_offload *f)
+static bool nfp_flower_check_higher_than_l3(struct flow_cls_offload *f)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 
 	return flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS) ||
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
@@ -212,11 +212,11 @@ static int
 nfp_flower_calculate_key_layers(struct nfp_app *app,
 				struct net_device *netdev,
 				struct nfp_fl_key_ls *ret_key_ls,
-				struct tc_cls_flower_offload *flow,
+				struct flow_cls_offload *flow,
 				enum nfp_flower_tun_type *tun_type,
 				struct netlink_ext_ack *extack)
 {
-	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(flow);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct flow_dissector *dissector = rule->match.dissector;
 	struct flow_match_basic basic = { NULL, NULL};
 	struct nfp_flower_priv *priv = app->priv;
@@ -866,7 +866,7 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 				     struct nfp_fl_payload *sub_flow1,
 				     struct nfp_fl_payload *sub_flow2)
 {
-	struct tc_cls_flower_offload merge_tc_off;
+	struct flow_cls_offload merge_tc_off;
 	struct nfp_flower_priv *priv = app->priv;
 	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *merge_flow;
@@ -962,7 +962,7 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
  */
 static int
 nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
-		       struct tc_cls_flower_offload *flow)
+		       struct flow_cls_offload *flow)
 {
 	enum nfp_flower_tun_type tun_type = NFP_FL_TUNNEL_NONE;
 	struct nfp_flower_priv *priv = app->priv;
@@ -1125,7 +1125,7 @@ nfp_flower_del_linked_merge_flows(struct nfp_app *app,
  */
 static int
 nfp_flower_del_offload(struct nfp_app *app, struct net_device *netdev,
-		       struct tc_cls_flower_offload *flow)
+		       struct flow_cls_offload *flow)
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct netlink_ext_ack *extack = NULL;
@@ -1232,7 +1232,7 @@ nfp_flower_update_merge_stats(struct nfp_app *app,
  */
 static int
 nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
-		     struct tc_cls_flower_offload *flow)
+		     struct flow_cls_offload *flow)
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct netlink_ext_ack *extack = NULL;
@@ -1265,17 +1265,17 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 
 static int
 nfp_flower_repr_offload(struct nfp_app *app, struct net_device *netdev,
-			struct tc_cls_flower_offload *flower)
+			struct flow_cls_offload *flower)
 {
 	if (!eth_proto_is_802_3(flower->common.protocol))
 		return -EOPNOTSUPP;
 
 	switch (flower->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return nfp_flower_add_offload(app, netdev, flower);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return nfp_flower_del_offload(app, netdev, flower);
-	case TC_CLSFLOWER_STATS:
+	case FLOW_CLS_STATS:
 		return nfp_flower_get_stats(app, netdev, flower);
 	default:
 		return -EOPNOTSUPP;
@@ -1385,7 +1385,7 @@ static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
 					  void *type_data, void *cb_priv)
 {
 	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
-	struct tc_cls_flower_offload *flower = type_data;
+	struct flow_cls_offload *flower = type_data;
 
 	if (flower->common.chain_index)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index b972ab07c18b..0e931c04fecf 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -551,7 +551,7 @@ int qede_txq_has_work(struct qede_tx_queue *txq);
 void qede_recycle_rx_bd_ring(struct qede_rx_queue *rxq, u8 count);
 void qede_update_rx_prod(struct qede_dev *edev, struct qede_rx_queue *rxq);
 int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
-			    struct tc_cls_flower_offload *f);
+			    struct flow_cls_offload *f);
 
 #define RX_RING_SIZE_POW	13
 #define RX_RING_SIZE		((u16)BIT(RX_RING_SIZE_POW))
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index add922b93d2c..9a6a9a008714 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1943,7 +1943,7 @@ qede_parse_flow_attr(struct qede_dev *edev, __be16 proto,
 }
 
 int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
-			    struct tc_cls_flower_offload *f)
+			    struct flow_cls_offload *f)
 {
 	struct qede_arfs_fltr_node *n;
 	int min_hlen, rc = -EINVAL;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 1be593a6e20d..8d1c208f778f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -548,13 +548,13 @@ static int qede_setup_tc(struct net_device *ndev, u8 num_tc)
 }
 
 static int
-qede_set_flower(struct qede_dev *edev, struct tc_cls_flower_offload *f,
+qede_set_flower(struct qede_dev *edev, struct flow_cls_offload *f,
 		__be16 proto)
 {
 	switch (f->command) {
-	case TC_CLSFLOWER_REPLACE:
+	case FLOW_CLS_REPLACE:
 		return qede_add_tc_flower_fltr(edev, proto, f);
-	case TC_CLSFLOWER_DESTROY:
+	case FLOW_CLS_DESTROY:
 		return qede_delete_flow_filter(edev, f->cookie);
 	default:
 		return -EOPNOTSUPP;
@@ -564,7 +564,7 @@ qede_set_flower(struct qede_dev *edev, struct tc_cls_flower_offload *f,
 static int qede_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 				  void *cb_priv)
 {
-	struct tc_cls_flower_offload *f;
+	struct flow_cls_offload *f;
 	struct qede_dev *edev = cb_priv;
 
 	if (!tc_cls_can_offload_and_chain0(edev->ndev, type_data))
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 2e780dbee168..8ec683bc44d4 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -298,4 +298,34 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_list, tc_setup_cb_t *cb,
 			       void *cb_ident, void *cb_priv, bool ingress_only);
 
+enum flow_cls_command {
+	FLOW_CLS_REPLACE,
+	FLOW_CLS_DESTROY,
+	FLOW_CLS_STATS,
+	FLOW_CLS_TMPLT_CREATE,
+	FLOW_CLS_TMPLT_DESTROY,
+};
+
+struct flow_cls_common_offload {
+	u32 chain_index;
+	__be16 protocol;
+	u32 prio;
+	struct netlink_ext_ack *extack;
+};
+
+struct flow_cls_offload {
+	struct flow_cls_common_offload common;
+	enum flow_cls_command command;
+	unsigned long cookie;
+	struct flow_rule *rule;
+	struct flow_stats stats;
+	u32 classid;
+};
+
+static inline struct flow_rule *
+flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
+{
+	return flow_cmd->rule;
+}
+
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 17c388090c3c..b03d466182db 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -535,13 +535,6 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
 
-struct tc_cls_common_offload {
-	u32 chain_index;
-	__be16 protocol;
-	u32 prio;
-	struct netlink_ext_ack *extack;
-};
-
 struct tc_cls_u32_knode {
 	struct tcf_exts *exts;
 	struct tcf_result *res;
@@ -569,7 +562,7 @@ enum tc_clsu32_command {
 };
 
 struct tc_cls_u32_offload {
-	struct tc_cls_common_offload common;
+	struct flow_cls_common_offload common;
 	/* knode values */
 	enum tc_clsu32_command command;
 	union {
@@ -596,7 +589,7 @@ static inline bool tc_can_offload_extack(const struct net_device *dev,
 
 static inline bool
 tc_cls_can_offload_and_chain0(const struct net_device *dev,
-			      struct tc_cls_common_offload *common)
+			      struct flow_cls_common_offload *common)
 {
 	if (!tc_can_offload_extack(dev, common->extack))
 		return false;
@@ -638,7 +631,7 @@ static inline bool tc_in_hw(u32 flags)
 }
 
 static inline void
-tc_cls_common_offload_init(struct tc_cls_common_offload *cls_common,
+tc_cls_common_offload_init(struct flow_cls_common_offload *cls_common,
 			   const struct tcf_proto *tp, u32 flags,
 			   struct netlink_ext_ack *extack)
 {
@@ -649,29 +642,6 @@ tc_cls_common_offload_init(struct tc_cls_common_offload *cls_common,
 		cls_common->extack = extack;
 }
 
-enum tc_fl_command {
-	TC_CLSFLOWER_REPLACE,
-	TC_CLSFLOWER_DESTROY,
-	TC_CLSFLOWER_STATS,
-	TC_CLSFLOWER_TMPLT_CREATE,
-	TC_CLSFLOWER_TMPLT_DESTROY,
-};
-
-struct tc_cls_flower_offload {
-	struct tc_cls_common_offload common;
-	enum tc_fl_command command;
-	unsigned long cookie;
-	struct flow_rule *rule;
-	struct flow_stats stats;
-	u32 classid;
-};
-
-static inline struct flow_rule *
-tc_cls_flower_offload_flow_rule(struct tc_cls_flower_offload *tc_flow_cmd)
-{
-	return tc_flow_cmd->rule;
-}
-
 enum tc_matchall_command {
 	TC_CLSMATCHALL_REPLACE,
 	TC_CLSMATCHALL_DESTROY,
@@ -679,7 +649,7 @@ enum tc_matchall_command {
 };
 
 struct tc_cls_matchall_offload {
-	struct tc_cls_common_offload common;
+	struct flow_cls_common_offload common;
 	enum tc_matchall_command command;
 	struct flow_rule *rule;
 	struct flow_stats stats;
@@ -692,7 +662,7 @@ enum tc_clsbpf_command {
 };
 
 struct tc_cls_bpf_offload {
-	struct tc_cls_common_offload common;
+	struct flow_cls_common_offload common;
 	enum tc_clsbpf_command command;
 	struct tcf_exts *exts;
 	struct bpf_prog *prog;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index ce2e9b1c9850..db7210b1cfd2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -390,14 +390,14 @@ static void fl_destroy_filter_work(struct work_struct *work)
 static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 				 bool rtnl_held, struct netlink_ext_ack *extack)
 {
-	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
 
 	if (!rtnl_held)
 		rtnl_lock();
 
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
-	cls_flower.command = TC_CLSFLOWER_DESTROY;
+	cls_flower.command = FLOW_CLS_DESTROY;
 	cls_flower.cookie = (unsigned long) f;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
@@ -415,8 +415,8 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 				struct netlink_ext_ack *extack)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
-	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
 	bool skip_sw = tc_skip_sw(f->flags);
 	int err = 0;
 
@@ -430,7 +430,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	}
 
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
-	cls_flower.command = TC_CLSFLOWER_REPLACE;
+	cls_flower.command = FLOW_CLS_REPLACE;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.rule->match.dissector = &f->mask->dissector;
 	cls_flower.rule->match.mask = &f->mask->key;
@@ -479,14 +479,14 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 			       bool rtnl_held)
 {
-	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
 
 	if (!rtnl_held)
 		rtnl_lock();
 
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, NULL);
-	cls_flower.command = TC_CLSFLOWER_STATS;
+	cls_flower.command = FLOW_CLS_STATS;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.classid = f->res.classid;
 
@@ -1736,8 +1736,8 @@ fl_get_next_hw_filter(struct tcf_proto *tp, struct cls_fl_filter *f, bool add)
 static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			void *cb_priv, struct netlink_ext_ack *extack)
 {
-	struct tc_cls_flower_offload cls_flower = {};
 	struct tcf_block *block = tp->chain->block;
+	struct flow_cls_offload cls_flower = {};
 	struct cls_fl_filter *f = NULL;
 	int err;
 
@@ -1758,7 +1758,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 		tc_cls_common_offload_init(&cls_flower.common, tp, f->flags,
 					   extack);
 		cls_flower.command = add ?
-			TC_CLSFLOWER_REPLACE : TC_CLSFLOWER_DESTROY;
+			FLOW_CLS_REPLACE : FLOW_CLS_DESTROY;
 		cls_flower.cookie = (unsigned long)f;
 		cls_flower.rule->match.dissector = &f->mask->dissector;
 		cls_flower.rule->match.mask = &f->mask->key;
@@ -1802,7 +1802,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 static int fl_hw_create_tmplt(struct tcf_chain *chain,
 			      struct fl_flow_tmplt *tmplt)
 {
-	struct tc_cls_flower_offload cls_flower = {};
+	struct flow_cls_offload cls_flower = {};
 	struct tcf_block *block = chain->block;
 
 	cls_flower.rule = flow_rule_alloc(0);
@@ -1810,7 +1810,7 @@ static int fl_hw_create_tmplt(struct tcf_chain *chain,
 		return -ENOMEM;
 
 	cls_flower.common.chain_index = chain->index;
-	cls_flower.command = TC_CLSFLOWER_TMPLT_CREATE;
+	cls_flower.command = FLOW_CLS_TMPLT_CREATE;
 	cls_flower.cookie = (unsigned long) tmplt;
 	cls_flower.rule->match.dissector = &tmplt->dissector;
 	cls_flower.rule->match.mask = &tmplt->mask;
@@ -1828,11 +1828,11 @@ static int fl_hw_create_tmplt(struct tcf_chain *chain,
 static void fl_hw_destroy_tmplt(struct tcf_chain *chain,
 				struct fl_flow_tmplt *tmplt)
 {
-	struct tc_cls_flower_offload cls_flower = {};
+	struct flow_cls_offload cls_flower = {};
 	struct tcf_block *block = chain->block;
 
 	cls_flower.common.chain_index = chain->index;
-	cls_flower.command = TC_CLSFLOWER_TMPLT_DESTROY;
+	cls_flower.command = FLOW_CLS_TMPLT_DESTROY;
 	cls_flower.cookie = (unsigned long) tmplt;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
-- 
2.11.0


