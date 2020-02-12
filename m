Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD53B15B2C7
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgBLVeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:34:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:18127 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbgBLVeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:34:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 13:34:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233911719"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 13:34:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 15/15] ice: Trivial fixes
Date:   Wed, 12 Feb 2020 13:33:57 -0800
Message-Id: <20200212213357.2198911-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
References: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

This is a collection of trivial fixes including fixing whitespace, typos,
function headers, reverse Christmas tree, etc.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h  |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c      |  4 ++--
 drivers/net/ethernet/intel/ice/ice_dcb.c         |  8 ++++----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c     |  4 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c     | 14 +++++++-------
 drivers/net/ethernet/intel/ice/ice_lib.c         |  7 ++++---
 drivers/net/ethernet/intel/ice/ice_main.c        |  4 +++-
 drivers/net/ethernet/intel/ice/ice_txrx.c        |  9 ++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.h        |  4 ++--
 drivers/net/ethernet/intel/ice/ice_type.h        |  2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  3 +--
 11 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 4459bc564b11..6873998cf145 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1660,6 +1660,7 @@ struct ice_aqc_get_pkg_info_resp {
 	__le32 count;
 	struct ice_aqc_get_pkg_info pkg_info[1];
 };
+
 /**
  * struct ice_aq_desc - Admin Queue (AQ) descriptor
  * @flags: ICE_AQ_FLAG_* flags
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index a46d51357650..04d5db0a25bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -588,10 +588,10 @@ void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf)
 }
 
 /**
- * ice_get_itr_intrl_gran - determine int/intrl granularity
+ * ice_get_itr_intrl_gran
  * @hw: pointer to the HW struct
  *
- * Determines the ITR/intrl granularities based on the maximum aggregate
+ * Determines the ITR/INTRL granularities based on the maximum aggregate
  * bandwidth according to the device's configuration during power-on.
  */
 static void ice_get_itr_intrl_gran(struct ice_hw *hw)
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 713e8a892e14..adb8dab765c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -1323,13 +1323,13 @@ enum ice_status ice_set_dcb_cfg(struct ice_port_info *pi)
 }
 
 /**
- * ice_aq_query_port_ets - query port ets configuration
+ * ice_aq_query_port_ets - query port ETS configuration
  * @pi: port information structure
  * @buf: pointer to buffer
  * @buf_size: buffer size in bytes
  * @cd: pointer to command details structure or NULL
  *
- * query current port ets configuration
+ * query current port ETS configuration
  */
 static enum ice_status
 ice_aq_query_port_ets(struct ice_port_info *pi,
@@ -1416,13 +1416,13 @@ ice_update_port_tc_tree_cfg(struct ice_port_info *pi,
 }
 
 /**
- * ice_query_port_ets - query port ets configuration
+ * ice_query_port_ets - query port ETS configuration
  * @pi: port information structure
  * @buf: pointer to buffer
  * @buf_size: buffer size in bytes
  * @cd: pointer to command details structure or NULL
  *
- * query current port ets configuration and update the
+ * query current port ETS configuration and update the
  * SW DB with the TC changes
  */
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index adc69fe1bd64..7108fb41b604 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -412,9 +412,9 @@ static int ice_dcb_init_cfg(struct ice_pf *pf, bool locked)
 }
 
 /**
- * ice_dcb_sw_default_config - Apply a default DCB config
+ * ice_dcb_sw_dflt_cfg - Apply a default DCB config
  * @pf: PF to apply config to
- * @ets_willing: configure ets willing
+ * @ets_willing: configure ETS willing
  * @locked: was this function called with RTNL held
  */
 static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool ets_willing, bool locked)
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4b29d1ae56a7..b002ab4e5838 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3800,11 +3800,11 @@ ice_get_module_eeprom(struct net_device *netdev,
 static const struct ethtool_ops ice_ethtool_ops = {
 	.get_link_ksettings	= ice_get_link_ksettings,
 	.set_link_ksettings	= ice_set_link_ksettings,
-	.get_drvinfo            = ice_get_drvinfo,
-	.get_regs_len           = ice_get_regs_len,
-	.get_regs               = ice_get_regs,
-	.get_msglevel           = ice_get_msglevel,
-	.set_msglevel           = ice_set_msglevel,
+	.get_drvinfo		= ice_get_drvinfo,
+	.get_regs_len		= ice_get_regs_len,
+	.get_regs		= ice_get_regs,
+	.get_msglevel		= ice_get_msglevel,
+	.set_msglevel		= ice_set_msglevel,
 	.self_test		= ice_self_test,
 	.get_link		= ethtool_op_get_link,
 	.get_eeprom_len		= ice_get_eeprom_len,
@@ -3831,8 +3831,8 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.get_channels		= ice_get_channels,
 	.set_channels		= ice_set_channels,
 	.get_ts_info		= ethtool_op_get_ts_info,
-	.get_per_queue_coalesce = ice_get_per_q_coalesce,
-	.set_per_queue_coalesce = ice_set_per_q_coalesce,
+	.get_per_queue_coalesce	= ice_get_per_q_coalesce,
+	.set_per_queue_coalesce	= ice_set_per_q_coalesce,
 	.get_fecparam		= ice_get_fecparam,
 	.set_fecparam		= ice_set_fecparam,
 	.get_module_info	= ice_get_module_info,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 4f5116554dcc..d974e2fa3e63 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1230,8 +1230,9 @@ static void ice_vsi_set_rss_flow_fld(struct ice_vsi *vsi)
  *
  * Returns 0 on success or ENOMEM on failure.
  */
-int ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
-			const u8 *macaddr)
+int
+ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
+		    const u8 *macaddr)
 {
 	struct ice_fltr_list_entry *tmp;
 	struct ice_pf *pf = vsi->back;
@@ -2824,8 +2825,8 @@ static void ice_vsi_update_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctx)
 int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
-	struct ice_vsi_ctx *ctx;
 	struct ice_pf *pf = vsi->back;
+	struct ice_vsi_ctx *ctx;
 	enum ice_status status;
 	struct device *dev;
 	int i, ret = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 49f4f5eb90d1..5ef28052c0f8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3153,7 +3153,9 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	struct ice_hw *hw;
 	int err;
 
-	/* this driver uses devres, see Documentation/driver-api/driver-model/devres.rst */
+	/* this driver uses devres, see
+	 * Documentation/driver-api/driver-model/devres.rst
+	 */
 	err = pcim_enable_device(pdev);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 1d4755acca3d..4de61dbedd36 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -644,7 +644,7 @@ static bool ice_page_is_reserved(struct page *page)
  * Update the offset within page so that Rx buf will be ready to be reused.
  * For systems with PAGE_SIZE < 8192 this function will flip the page offset
  * so the second half of page assigned to Rx buffer will be used, otherwise
- * the offset is moved by the @size bytes
+ * the offset is moved by "size" bytes
  */
 static void
 ice_rx_buf_adjust_pg_offset(struct ice_rx_buf *rx_buf, unsigned int size)
@@ -1619,11 +1619,11 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 {
 	u64 td_offset, td_tag, td_cmd;
 	u16 i = tx_ring->next_to_use;
-	skb_frag_t *frag;
 	unsigned int data_len, size;
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
 	struct sk_buff *skb;
+	skb_frag_t *frag;
 	dma_addr_t dma;
 
 	td_tag = off->td_l2tag1;
@@ -1736,9 +1736,8 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 	ice_maybe_stop_tx(tx_ring, DESC_NEEDED);
 
 	/* notify HW of packet */
-	if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more()) {
+	if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more())
 		writel(i, tx_ring->tail);
-	}
 
 	return;
 
@@ -2076,7 +2075,7 @@ static bool __ice_chk_linearize(struct sk_buff *skb)
 	frag = &skb_shinfo(skb)->frags[0];
 
 	/* Initialize size to the negative value of gso_size minus 1. We
-	 * use this as the worst case scenerio in which the frag ahead
+	 * use this as the worst case scenario in which the frag ahead
 	 * of us only provides one byte which is why we are limited to 6
 	 * descriptors for a single transmit as the header and previous
 	 * fragment are already consuming 2 descriptors.
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index a86270696df1..14a1bf445889 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -33,8 +33,8 @@
  * frame.
  *
  * Note: For cache line sizes 256 or larger this value is going to end
- *       up negative.  In these cases we should fall back to the legacy
- *       receive path.
+ *	 up negative.  In these cases we should fall back to the legacy
+ *	 receive path.
  */
 #if (PAGE_SIZE < 8192)
 #define ICE_2K_TOO_SMALL_WITH_PADDING \
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index b361ffabb0ca..db0ef6ba907f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -517,7 +517,7 @@ struct ice_hw {
 	struct ice_fw_log_cfg fw_log;
 
 /* Device max aggregate bandwidths corresponding to the GL_PWR_MODE_CTL
- * register. Used for determining the ITR/intrl granularity during
+ * register. Used for determining the ITR/INTRL granularity during
  * initialization.
  */
 #define ICE_MAX_AGG_BW_200G	0x0
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index eb60abd8394f..262714d5f54a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1093,7 +1093,6 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	 * finished resetting.
 	 */
 	for (i = 0, v = 0; i < 10 && v < pf->num_alloc_vfs; i++) {
-
 		/* Check each VF in sequence */
 		while (v < pf->num_alloc_vfs) {
 			u32 reg;
@@ -2637,8 +2636,8 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	struct ice_pf *pf = vf->pf;
 	u16 max_allowed_vf_queues;
 	u16 tx_rx_queue_left;
-	u16 cur_queues;
 	struct device *dev;
+	u16 cur_queues;
 
 	dev = ice_pf_to_dev(pf);
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
-- 
2.24.1

