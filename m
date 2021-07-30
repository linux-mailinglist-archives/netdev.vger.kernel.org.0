Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47153DB1A9
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhG3DDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 23:03:25 -0400
Received: from mx21.baidu.com ([220.181.3.85]:38036 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234815AbhG3DDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:18 -0400
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id 19C7B80CD1D32785048F;
        Fri, 30 Jul 2021 11:03:08 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Fri, 30 Jul 2021 11:03:07 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Fri, 30 Jul 2021 11:03:07 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <saeedm@nvidia.com>, <leonro@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] net/mlx5: Fix typo in comments
Date:   Fri, 30 Jul 2021 11:03:00 +0800
Message-ID: <20210730030300.2459-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex10.internal.baidu.com (172.31.51.50) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo:
*vectores  ==> vectors
*realeased  ==> released
*erros  ==> errors
*namepsace  ==> namespace
*trafic  ==> traffic
*proccessed  ==> processed
*retore  ==> restore
*Currenlty  ==> Currently
*crated  ==> created
*chane  ==> change
*cannnot  ==> cannot
*usuallly  ==> usually
*failes  ==> fails
*importent  ==> important
*reenabled  ==> re-enabled
*alocation  ==> allocation
*recived  ==> received
*tanslation  ==> translation

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h       | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c       | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c      | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c       | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c      | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c   | 2 +-
 include/linux/mlx5/device.h                            | 2 +-
 include/linux/mlx5/driver.h                            | 4 ++--
 16 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 8f79f04eccd6..a61731cb6045 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -520,7 +520,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	e->out_dev = attr.out_dev;
 	e->route_dev_ifindex = attr.route_dev->ifindex;
 
-	/* It's importent to add the neigh to the hash table before checking
+	/* It's important to add the neigh to the hash table before checking
 	 * the neigh validity state. So if we'll get a notification, in case the
 	 * neigh changes it's validity state, we would find the relevant neigh
 	 * in the hash.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index ab485d082729..b1832e6a5c4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -126,7 +126,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	/* Create a separate SQ, so that when the buff pool is disabled, we could
 	 * close this SQ safely and stop receiving CQEs. In other case, e.g., if
 	 * the XDPSQ was used instead, we might run into trouble when the buff pool
-	 * is disabled and then reenabled, but the SQ continues receiving CQEs
+	 * is disabled and then re-enabled, but the SQ continues receiving CQEs
 	 * from the old buff pool.
 	 */
 	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, pool, &c->xsksq, true);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index c4db367d4baf..84eb7201c142 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -33,7 +33,7 @@
 #include "en.h"
 
 /* mlx5e global resources should be placed in this file.
- * Global resources are common to all the netdevices crated on the same nic.
+ * Global resources are common to all the netdevices created on the same nic.
  */
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 47a2dfb7792a..1088d6aa6237 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -146,7 +146,7 @@ struct mlx5e_neigh_hash_entry {
 	 */
 	refcount_t refcnt;
 
-	/* Save the last reported time offloaded trafic pass over one of the
+	/* Save the last reported time offloaded traffic pass over one of the
 	 * neigh hash entry flows. Use it to periodically update the neigh
 	 * 'used' value and avoid neigh deleting by the kernel.
 	 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2ef02fea119a..c90eb9e48b6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -103,7 +103,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[MARK_TO_REG] = mark_to_reg_ct,
 	[LABELS_TO_REG] = labels_to_reg_ct,
 	[FTEID_TO_REG] = fteid_to_reg_ct,
-	/* For NIC rules we store the retore metadata directly
+	/* For NIC rules we store the restore metadata directly
 	 * into reg_b that is passed to SW since we don't
 	 * jump between steering domains.
 	 */
@@ -2445,7 +2445,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_3;
 		}
 	}
-	/* Currenlty supported only for MPLS over UDP */
+	/* Currently supported only for MPLS over UDP */
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS) &&
 	    !netif_is_bareudp(filter_dev)) {
 		NL_SET_ERR_MSG_MOD(extack,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 97e6cb6f13c1..c47bde52f882 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1494,7 +1494,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 /**
  * mlx5_eswitch_enable - Enable eswitch
  * @esw:	Pointer to eswitch
- * @num_vfs:	Enable eswitch swich for given number of VFs.
+ * @num_vfs:	Enable eswitch switch for given number of VFs.
  *		Caller must pass num_vfs > 0 when enabling eswitch for
  *		vf vports.
  * mlx5_eswitch_enable() returns 0 on success or error code on failure.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index d713ae24d6b6..a1ac3a654962 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -27,7 +27,7 @@ static int pcie_core(struct notifier_block *, unsigned long, void *);
 static int forward_event(struct notifier_block *, unsigned long, void *);
 
 static struct mlx5_nb events_nbs_ref[] = {
-	/* Events to be proccessed by mlx5_core */
+	/* Events to be processed by mlx5_core */
 	{.nb.notifier_call = any_notifier,  .event_type = MLX5_EVENT_TYPE_NOTIFY_ANY },
 	{.nb.notifier_call = temp_warn,     .event_type = MLX5_EVENT_TYPE_TEMP_WARN_EVENT },
 	{.nb.notifier_call = port_module,   .event_type = MLX5_EVENT_TYPE_PORT_MODULE_EVENT },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 0bba92cf5dc0..8ec148010d62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -1516,7 +1516,7 @@ static int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 	mutex_lock(&fpga_xfrm->lock);
 
 	if (!fpga_xfrm->sa_ctx)
-		/* Unbounded xfrm, chane only sw attrs */
+		/* Unbounded xfrm, change only sw attrs */
 		goto change_sw_xfrm_attrs;
 
 	/* copy original hw sa */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index c0697e1b7118..ec77e4859bf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2493,7 +2493,7 @@ static void set_prio_attrs_in_prio(struct fs_prio *prio, int acc_level)
 		acc_level_ns = set_prio_attrs_in_ns(ns, acc_level);
 
 		/* If this a prio with chains, and we can jump from one chain
-		 * (namepsace) to another, so we accumulate the levels
+		 * (namespace) to another, so we accumulate the levels
 		 */
 		if (prio->node.type == FS_TYPE_PRIO_CHAINS)
 			acc_level = acc_level_ns;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 9abeb80ffa31..4a7de1259004 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -170,7 +170,7 @@ static bool reset_fw_if_needed(struct mlx5_core_dev *dev)
 
 	/* The reset only needs to be issued by one PF. The health buffer is
 	 * shared between all functions, and will be cleared during a reset.
-	 * Check again to avoid a redundant 2nd reset. If the fatal erros was
+	 * Check again to avoid a redundant 2nd reset. If the fatal errors was
 	 * PCI related a reset won't help.
 	 */
 	fatal_error = mlx5_health_check_fatal_sensors(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index ce696d523493..ffac8a0e7a23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -749,7 +749,7 @@ static int mlx5_pps_event(struct notifier_block *nb,
 		} else {
 			ptp_event.type = PTP_CLOCK_EXTTS;
 		}
-		/* TODOL clock->ptp can be NULL if ptp_clock_register failes */
+		/* TODOL clock->ptp can be NULL if ptp_clock_register fails */
 		ptp_clock_event(clock->ptp, &ptp_event);
 		break;
 	case PTP_PF_PEROUT:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index 38084400ee8f..e3b0a131c3e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -40,7 +40,7 @@
 
 struct mlx5_vxlan {
 	struct mlx5_core_dev		*mdev;
-	/* max_num_ports is usuallly 4, 16 buckets is more than enough */
+	/* max_num_ports is usually 4, 16 buckets is more than enough */
 	DECLARE_HASHTABLE(htable, 4);
 	struct mutex                    sync_lock; /* sync add/del port HW operations */
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index b25f764daa08..9fb75d79bf08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -18,7 +18,7 @@
 
 #define MLX5_SFS_PER_CTRL_IRQ 64
 #define MLX5_IRQ_CTRL_SF_MAX 8
-/* min num of vectores for SFs to be enabled */
+/* min num of vectors for SFs to be enabled */
 #define MLX5_IRQ_VEC_COMP_BASE_SF 2
 
 #define MLX5_EQ_SHARE_IRQ_MAX_COMP (8)
@@ -597,7 +597,7 @@ void mlx5_irq_table_destroy(struct mlx5_core_dev *dev)
 		return;
 
 	/* There are cases where IRQs still will be in used when we reaching
-	 * to here. Hence, making sure all the irqs are realeased.
+	 * to here. Hence, making sure all the irqs are released.
 	 */
 	irq_pools_destroy(table);
 	pci_free_irq_vectors(dev->pdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 1be048769309..ce2c5e576c47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -476,7 +476,7 @@ static void mlx5_sf_table_disable(struct mlx5_sf_table *table)
 		return;
 
 	/* Balances with refcount_set; drop the reference so that new user cmd cannot start
-	 * and new vhca event handler cannnot run.
+	 * and new vhca event handler cannot run.
 	 */
 	mlx5_sf_table_put(table);
 	wait_for_completion(&table->disable_complete);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0025913505ab..1e9d55dc1a9c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1038,7 +1038,7 @@ enum {
 struct mlx5_mkey_seg {
 	/* This is a two bit field occupying bits 31-30.
 	 * bit 31 is always 0,
-	 * bit 30 is zero for regular MRs and 1 (e.g free) for UMRs that do not have tanslation
+	 * bit 30 is zero for regular MRs and 1 (e.g free) for UMRs that do not have translation
 	 */
 	u8		status;
 	u8		pcie_control;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1efe37466969..51c1d37e7c28 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -581,7 +581,7 @@ struct mlx5_priv {
 	/* end: qp staff */
 
 	/* start: alloc staff */
-	/* protect buffer alocation according to numa node */
+	/* protect buffer allocation according to numa node */
 	struct mutex            alloc_mutex;
 	int                     numa_node;
 
@@ -1111,7 +1111,7 @@ static inline u8 mlx5_mkey_variant(u32 mkey)
 }
 
 /* Async-atomic event notifier used by mlx5 core to forward FW
- * evetns recived from event queue to mlx5 consumers.
+ * evetns received from event queue to mlx5 consumers.
  * Optimise event queue dipatching.
  */
 int mlx5_notifier_register(struct mlx5_core_dev *dev, struct notifier_block *nb);
-- 
2.25.1

