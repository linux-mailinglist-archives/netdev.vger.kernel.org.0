Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C9D3E976E
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhHKSSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhHKSSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19AB60D07;
        Wed, 11 Aug 2021 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705892;
        bh=iq2b46/0gk3WcDqj+EdHnrBCgL8v6cQtryVXow+nUIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ParH1Owc/SEw6pVxSthq2+3PI/sWevreoCyWInRE2DVDbKlFaGsy4ZTVci0s8l25q
         xFMS85Xv+Yxqv9gObn739pS18nJtDa9DkRX1bSXT2iwDGDjD1UHcTpG6n4FhmPNQXF
         HP1tfhfCJnmNExwrtYMDEXy7CkGUr01xjth53cmRglxX/bmfomygNTKMgzsESs5OWY
         3qzodKosY2j3fkvvgajq7PmV7kkRu+AO7B6oGZbS8Q0AK9t/eQFRz1bCwdnUYHcgXY
         ObUtkNO/bR7jtJN9NnD1sfs3FgnU5eTahZ3t5dOKXIMPY1zLZfJULyVspD6Wie8hY6
         AO8L7MLiwUAlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/12] net/mlx5: Fix typo in comments
Date:   Wed, 11 Aug 2021 11:16:47 -0700
Message-Id: <20210811181658.492548-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cai Huoqing <caihuoqing@baidu.com>

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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
index c06267477b27..538bc2419bd8 100644
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
index 8f0c82448eec..756f806401d7 100644
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
index e5c4344a114e..d6ad7328f298 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -97,7 +97,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[MARK_TO_REG] = mark_to_reg_ct,
 	[LABELS_TO_REG] = labels_to_reg_ct,
 	[FTEID_TO_REG] = fteid_to_reg_ct,
-	/* For NIC rules we store the retore metadata directly
+	/* For NIC rules we store the restore metadata directly
 	 * into reg_b that is passed to SW since we don't
 	 * jump between steering domains.
 	 */
@@ -2448,7 +2448,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_3;
 		}
 	}
-	/* Currenlty supported only for MPLS over UDP */
+	/* Currently supported only for MPLS over UDP */
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS) &&
 	    !netif_is_bareudp(filter_dev)) {
 		NL_SET_ERR_MSG_MOD(extack,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7ffea2350f44..2fde9f59e8b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1492,7 +1492,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
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
index 8481027e493c..fee51050ed64 100644
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
index 720195c4be7c..13891fdc607e 100644
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
index af4dd6e9f97f..524051d1b2e3 100644
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
2.31.1

