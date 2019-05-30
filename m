Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215B130241
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfE3Suw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:30429 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfE3Suk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Trivial cosmetic changes
Date:   Thu, 30 May 2019 11:50:45 -0700
Message-Id: <20190530185045.3886-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

This patch mostly capitalizes abbreviations in code comments. Fixed some
typos and removed some unnecessary newlines as well.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  6 +--
 drivers/net/ethernet/intel/ice/ice_controlq.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      | 14 +++----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 12 +++---
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 42 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  8 ++--
 drivers/net/ethernet/intel/ice/ice_type.h     |  2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  9 ++--
 12 files changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 7a9da5320e96..765e3c2ed045 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1273,7 +1273,7 @@ struct ice_aqc_get_cee_dcb_cfg_resp {
 };
 
 /* Set Local LLDP MIB (indirect 0x0A08)
- * Used to replace the local MIB of a given LLDP agent. e.g. DCBx
+ * Used to replace the local MIB of a given LLDP agent. e.g. DCBX
  */
 struct ice_aqc_lldp_set_local_mib {
 	u8 type;
@@ -1290,7 +1290,7 @@ struct ice_aqc_lldp_set_local_mib {
 };
 
 /* Stop/Start LLDP Agent (direct 0x0A09)
- * Used for stopping/starting specific LLDP agent. e.g. DCBx.
+ * Used for stopping/starting specific LLDP agent. e.g. DCBX.
  * The same structure is used for the response, with the command field
  * being used as the status field.
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 724f2975f3da..2e0731c1e1a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -499,7 +499,7 @@ static enum ice_status ice_get_fw_log_cfg(struct ice_hw *hw)
 	if (!status) {
 		u16 i;
 
-		/* Save fw logging information into the hw structure */
+		/* Save FW logging information into the HW structure */
 		for (i = 0; i < ICE_AQC_FW_LOG_ID_MAX; i++) {
 			u16 v, m, flgs;
 
@@ -691,7 +691,7 @@ void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf)
  * ice_get_itr_intrl_gran - determine int/intrl granularity
  * @hw: pointer to the HW struct
  *
- * Determines the itr/intrl granularities based on the maximum aggregate
+ * Determines the ITR/intrl granularities based on the maximum aggregate
  * bandwidth according to the device's configuration during power-on.
  */
 static void ice_get_itr_intrl_gran(struct ice_hw *hw)
@@ -2699,7 +2699,7 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 			ice_debug(hw, ICE_DBG_SCHED, "VM%d disable failed %d\n",
 				  vmvf_num, hw->adminq.sq_last_status);
 		else
-			ice_debug(hw, ICE_DBG_SCHED, "disable Q %d failed %d\n",
+			ice_debug(hw, ICE_DBG_SCHED, "disable queue %d failed %d\n",
 				  le16_to_cpu(qg_list[0].q_id[0]),
 				  hw->adminq.sq_last_status);
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index cc8cb5fdcdc1..e91ac4df0242 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -439,7 +439,7 @@ do {									\
 	/* free the buffer info list */					\
 	if ((qi)->ring.cmd_buf)						\
 		devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);	\
-	/* free dma head */						\
+	/* free DMA head */						\
 	devm_kfree(ice_hw_to_dev(hw), (qi)->ring.dma_head);		\
 } while (0)
 
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index e0585394d984..44945c2165d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -35,7 +35,7 @@ enum ice_ctl_q {
 #define ICE_CTL_Q_SQ_CMD_TIMEOUT	250  /* msecs */
 
 struct ice_ctl_q_ring {
-	void *dma_head;			/* Virtual address to dma head */
+	void *dma_head;			/* Virtual address to DMA head */
 	struct ice_dma_mem desc_buf;	/* descriptor ring memory */
 	void *cmd_buf;			/* command buffer memory */
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 49fbfe7c1ad7..c2002ded65f6 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -669,7 +669,7 @@ ice_lldp_to_dcb_cfg(u8 *lldpmib, struct ice_dcbx_cfg *dcbcfg)
 /**
  * ice_aq_get_dcb_cfg
  * @hw: pointer to the HW struct
- * @mib_type: mib type for the query
+ * @mib_type: MIB type for the query
  * @bridgetype: bridge type for the query (remote)
  * @dcbcfg: store for LLDPDU data
  *
@@ -700,13 +700,13 @@ ice_aq_get_dcb_cfg(struct ice_hw *hw, u8 mib_type, u8 bridgetype,
 }
 
 /**
- * ice_aq_start_stop_dcbx - Start/Stop DCBx service in FW
+ * ice_aq_start_stop_dcbx - Start/Stop DCBX service in FW
  * @hw: pointer to the HW struct
- * @start_dcbx_agent: True if DCBx Agent needs to be started
- *		      False if DCBx Agent needs to be stopped
- * @dcbx_agent_status: FW indicates back the DCBx agent status
- *		       True if DCBx Agent is active
- *		       False if DCBx Agent is stopped
+ * @start_dcbx_agent: True if DCBX Agent needs to be started
+ *		      False if DCBX Agent needs to be stopped
+ * @dcbx_agent_status: FW indicates back the DCBX agent status
+ *		       True if DCBX Agent is active
+ *		       False if DCBX Agent is stopped
  * @cd: pointer to command details structure or NULL
  *
  * Start/Stop the embedded dcbx Agent. In case that this wrapper function
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index e4174a14aa44..fe88b127ca42 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -283,7 +283,7 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 
 /**
  * ice_dcb_init_cfg - set the initial DCB config in SW
- * @pf: pf to apply config to
+ * @pf: PF to apply config to
  * @locked: Is the RTNL held
  */
 static int ice_dcb_init_cfg(struct ice_pf *pf, bool locked)
@@ -311,7 +311,7 @@ static int ice_dcb_init_cfg(struct ice_pf *pf, bool locked)
 
 /**
  * ice_dcb_sw_default_config - Apply a default DCB config
- * @pf: pf to apply config to
+ * @pf: PF to apply config to
  * @locked: was this function called with RTNL held
  */
 static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
@@ -356,7 +356,7 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool locked)
 
 /**
  * ice_init_pf_dcb - initialize DCB for a PF
- * @pf: pf to initiialize DCB for
+ * @pf: PF to initialize DCB for
  * @locked: Was function called with RTNL held
  */
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
@@ -371,7 +371,7 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 
 	err = ice_init_dcb(hw);
 	if (err) {
-		/* FW LLDP is not active, default to SW DCBx/LLDP */
+		/* FW LLDP is not active, default to SW DCBX/LLDP */
 		dev_info(&pf->pdev->dev, "FW LLDP is not active\n");
 		hw->port_info->dcbx_status = ICE_DCBX_STATUS_NOT_STARTED;
 		hw->port_info->is_sw_lldp = true;
@@ -604,10 +604,10 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	/* store the old configuration */
 	tmp_dcbx_cfg = pf->hw.port_info->local_dcbx_cfg;
 
-	/* Reset the old DCBx configuration data */
+	/* Reset the old DCBX configuration data */
 	memset(&pi->local_dcbx_cfg, 0, sizeof(pi->local_dcbx_cfg));
 
-	/* Get updated DCBx data from firmware */
+	/* Get updated DCBX data from firmware */
 	ret = ice_get_dcb_cfg(pf->hw.port_info);
 	if (ret) {
 		dev_err(&pf->pdev->dev, "Failed to get DCB config\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 6beb918f625f..52083a63dee6 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1247,7 +1247,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 				dev_warn(&pf->pdev->dev,
 					 "Fail to start LLDP Agent\n");
 
-			/* AQ command to start FW DCBx agent will fail if
+			/* AQ command to start FW DCBX agent will fail if
 			 * the agent is already started
 			 */
 			status = ice_aq_start_stop_dcbx(&pf->hw, true,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7625a4c0532d..35c5ff910afa 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2539,7 +2539,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	 * recipe, since VSI/VSI list is ignored with drop action...
 	 * Also add rules to handle LLDP Tx and Rx packets.  Tx LLDP packets
 	 * need to be dropped so that VFs cannot send LLDP packets to reconfig
-	 * DCB settings in the HW.  Also, if the FW DCBx engine is not running
+	 * DCB settings in the HW.  Also, if the FW DCBX engine is not running
 	 * then Rx LLDP packets need to be redirected up the stack.
 	 */
 	if (vsi->type == ICE_VSI_PF) {
@@ -3059,7 +3059,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 
 /**
  * ice_is_reset_in_progress - check for a reset in progress
- * @state: pf state field
+ * @state: PF state field
  */
 bool ice_is_reset_in_progress(unsigned long *state)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d34e2d529165..28ec0d57941d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -112,7 +112,7 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
  * ice_init_mac_fltr - Set initial MAC filters
  * @pf: board private structure
  *
- * Set initial set of mac filters for PF VSI; configure filters for permanent
+ * Set initial set of MAC filters for PF VSI; configure filters for permanent
  * address and broadcast address. If an error is encountered, netdevice will be
  * unregistered.
  */
@@ -682,13 +682,13 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 
 	switch (vsi->port_info->fc.current_mode) {
 	case ICE_FC_FULL:
-		fc = "RX/TX";
+		fc = "Rx/Tx";
 		break;
 	case ICE_FC_TX_PAUSE:
-		fc = "TX";
+		fc = "Tx";
 		break;
 	case ICE_FC_RX_PAUSE:
-		fc = "RX";
+		fc = "Rx";
 		break;
 	case ICE_FC_NONE:
 		fc = "None";
@@ -770,7 +770,7 @@ static void ice_vsi_link_event(struct ice_vsi *vsi, bool link_up)
 
 /**
  * ice_link_event - process the link event
- * @pf: pf that the link event is associated with
+ * @pf: PF that the link event is associated with
  * @pi: port_info for the port that the link event is associated with
  * @link_up: true if the physical link is up and false if it is down
  * @link_speed: current link speed received from the link event
@@ -880,7 +880,7 @@ static int ice_init_link_events(struct ice_port_info *pi)
 
 /**
  * ice_handle_link_event - handle link event via ARQ
- * @pf: pf that the link event is associated with
+ * @pf: PF that the link event is associated with
  * @event: event structure containing link status info
  */
 static int
@@ -2301,7 +2301,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	if (!pf)
 		return -ENOMEM;
 
-	/* set up for high or low dma */
+	/* set up for high or low DMA */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (err)
 		err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
@@ -2417,7 +2417,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	err = ice_setup_pf_sw(pf);
 	if (err) {
-		dev_err(dev, "probe failed due to setup pf switch:%d\n", err);
+		dev_err(dev, "probe failed due to setup PF switch:%d\n", err);
 		goto err_alloc_sw_unroll;
 	}
 
@@ -2674,7 +2674,7 @@ static int __init ice_module_init(void)
 
 	status = pci_register_driver(&ice_driver);
 	if (status) {
-		pr_err("failed to register pci driver, err %d\n", status);
+		pr_err("failed to register PCI driver, err %d\n", status);
 		destroy_workqueue(ice_wq);
 	}
 
@@ -2774,21 +2774,21 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 	ice_free_fltr_list(&pf->pdev->dev, &a_mac_list);
 
 	if (err) {
-		netdev_err(netdev, "can't set mac %pM. filter update failed\n",
+		netdev_err(netdev, "can't set MAC %pM. filter update failed\n",
 			   mac);
 		return err;
 	}
 
 	/* change the netdev's MAC address */
 	memcpy(netdev->dev_addr, mac, netdev->addr_len);
-	netdev_dbg(vsi->netdev, "updated mac address to %pM\n",
+	netdev_dbg(vsi->netdev, "updated MAC address to %pM\n",
 		   netdev->dev_addr);
 
 	/* write new MAC address to the firmware */
 	flags = ICE_AQC_MAN_MAC_UPDATE_LAA_WOL;
 	status = ice_aq_manage_mac_write(hw, mac, flags, NULL);
 	if (status) {
-		netdev_err(netdev, "can't set mac %pM. write to firmware failed.\n",
+		netdev_err(netdev, "can't set MAC %pM. write to firmware failed.\n",
 			   mac);
 	}
 	return 0;
@@ -3714,7 +3714,7 @@ static int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked)
 }
 
 /**
- * ice_vsi_rebuild_all - rebuild all VSIs in pf
+ * ice_vsi_rebuild_all - rebuild all VSIs in PF
  * @pf: the PF
  */
 static int ice_vsi_rebuild_all(struct ice_pf *pf)
@@ -3784,7 +3784,7 @@ static int ice_vsi_replay_all(struct ice_pf *pf)
 
 /**
  * ice_rebuild - rebuild after reset
- * @pf: pf to rebuild
+ * @pf: PF to rebuild
  */
 static void ice_rebuild(struct ice_pf *pf)
 {
@@ -3796,7 +3796,7 @@ static void ice_rebuild(struct ice_pf *pf)
 	if (test_bit(__ICE_DOWN, pf->state))
 		goto clear_recovery;
 
-	dev_dbg(dev, "rebuilding pf\n");
+	dev_dbg(dev, "rebuilding PF\n");
 
 	ret = ice_init_all_ctrlq(hw);
 	if (ret) {
@@ -3907,16 +3907,16 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	u8 count = 0;
 
 	if (new_mtu == netdev->mtu) {
-		netdev_warn(netdev, "mtu is already %u\n", netdev->mtu);
+		netdev_warn(netdev, "MTU is already %u\n", netdev->mtu);
 		return 0;
 	}
 
 	if (new_mtu < netdev->min_mtu) {
-		netdev_err(netdev, "new mtu invalid. min_mtu is %d\n",
+		netdev_err(netdev, "new MTU invalid. min_mtu is %d\n",
 			   netdev->min_mtu);
 		return -EINVAL;
 	} else if (new_mtu > netdev->max_mtu) {
-		netdev_err(netdev, "new mtu invalid. max_mtu is %d\n",
+		netdev_err(netdev, "new MTU invalid. max_mtu is %d\n",
 			   netdev->min_mtu);
 		return -EINVAL;
 	}
@@ -3932,7 +3932,7 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	} while (count < 100);
 
 	if (count == 100) {
-		netdev_err(netdev, "can't change mtu. Device is busy\n");
+		netdev_err(netdev, "can't change MTU. Device is busy\n");
 		return -EBUSY;
 	}
 
@@ -3944,13 +3944,13 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 
 		err = ice_down(vsi);
 		if (err) {
-			netdev_err(netdev, "change mtu if_up err %d\n", err);
+			netdev_err(netdev, "change MTU if_up err %d\n", err);
 			return err;
 		}
 
 		err = ice_up(vsi);
 		if (err) {
-			netdev_err(netdev, "change mtu if_up err %d\n", err);
+			netdev_err(netdev, "change MTU if_up err %d\n", err);
 			return err;
 		}
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 8e552a43681a..3c83230434b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -55,7 +55,7 @@ void ice_clean_tx_ring(struct ice_ring *tx_ring)
 	if (!tx_ring->tx_buf)
 		return;
 
-	/* Free all the Tx ring sk_bufss */
+	/* Free all the Tx ring sk_buffs */
 	for (i = 0; i < tx_ring->count; i++)
 		ice_unmap_and_free_tx_buf(tx_ring, &tx_ring->tx_buf[i]);
 
@@ -1101,7 +1101,7 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
  * ice_adjust_itr_by_size_and_speed - Adjust ITR based on current traffic
  * @port_info: port_info structure containing the current link speed
  * @avg_pkt_size: average size of Tx or Rx packets based on clean routine
- * @itr: itr value to update
+ * @itr: ITR value to update
  *
  * Calculate how big of an increment should be applied to the ITR value passed
  * in based on wmem_default, SKB overhead, Ethernet overhead, and the current
@@ -1316,7 +1316,7 @@ ice_update_itr(struct ice_q_vector *q_vector, struct ice_ring_container *rc)
  */
 static u32 ice_buildreg_itr(u16 itr_idx, u16 itr)
 {
-	/* The itr value is reported in microseconds, and the register value is
+	/* The ITR value is reported in microseconds, and the register value is
 	 * recorded in 2 microsecond units. For this reason we only need to
 	 * shift by the GLINT_DYN_CTL_INTERVAL_S - ICE_ITR_GRAN_S to apply this
 	 * granularity as a shift instead of division. The mask makes sure the
@@ -1645,7 +1645,7 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 	return;
 
 dma_error:
-	/* clear dma mappings for failed tx_buf map */
+	/* clear DMA mappings for failed tx_buf map */
 	for (;;) {
 		tx_buf = &tx_ring->tx_buf[i];
 		ice_unmap_and_free_tx_buf(tx_ring, tx_buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 3474bccbab6d..24bbef8bbe69 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -434,7 +434,7 @@ struct ice_hw {
 	struct ice_fw_log_cfg fw_log;
 
 /* Device max aggregate bandwidths corresponding to the GL_PWR_MODE_CTL
- * register. Used for determining the itr/intrl granularity during
+ * register. Used for determining the ITR/intrl granularity during
  * initialization.
  */
 #define ICE_MAX_AGG_BW_200G	0x0
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index fff59ebf07ca..5d24b539648f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -154,7 +154,7 @@ static void ice_free_vf_res(struct ice_vf *vf)
 	 */
 	clear_bit(ICE_VF_STATE_INIT, vf->vf_states);
 
-	/* free vsi & disconnect it from the parent uplink */
+	/* free VSI and disconnect it from the parent uplink */
 	if (vf->lan_vsi_idx) {
 		ice_vsi_release(pf->vsi[vf->lan_vsi_idx]);
 		vf->lan_vsi_idx = 0;
@@ -514,7 +514,6 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	vf->first_vector_idx = ice_calc_vf_first_vector_idx(pf, vf);
 
 	vsi = ice_vf_vsi_setup(pf, pf->hw.port_info, vf->vf_id);
-
 	if (!vsi) {
 		dev_err(&pf->pdev->dev, "Failed to create VF VSI\n");
 		return -ENOMEM;
@@ -1312,8 +1311,8 @@ static int ice_alloc_vfs(struct ice_pf *pf, u16 num_alloc_vfs)
 }
 
 /**
- * ice_pf_state_is_nominal - checks the pf for nominal state
- * @pf: pointer to pf to check
+ * ice_pf_state_is_nominal - checks the PF for nominal state
+ * @pf: pointer to PF to check
  *
  * Check the PF's state for a collection of bits that would indicate
  * the PF is in a state that would inhibit normal operation for
@@ -1640,7 +1639,7 @@ static void ice_vc_reset_vf_msg(struct ice_vf *vf)
 
 /**
  * ice_find_vsi_from_id
- * @pf: the pf structure to search for the VSI
+ * @pf: the PF structure to search for the VSI
  * @id: ID of the VSI it is searching for
  *
  * searches for the VSI with the given ID
-- 
2.21.0

