Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91ECC35FEE5
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhDOA3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:27420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhDOA2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:53 -0400
IronPort-SDR: yS4hpBDIq7PciHTTw8gZ5LU1WuIG7Kn2VYXh2ZFmgE1+k9bKoDczmRCmLjmrP9OY+bwRctx8Zb
 y6lwHeG9Ovsg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262250"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262250"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:27 -0700
IronPort-SDR: ApKRrvCiTx839weIKy/Fz6ETBMTdYD/hTtNsz+UY1wwNrKKrpwybopB0btxOHl/hnse16g3aVL
 aJt//+iErAQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379498"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 02/15] ice: Drop leading underscores in enum ice_pf_state
Date:   Wed, 14 Apr 2021 17:30:00 -0700
Message-Id: <20210415003013.19717-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove the leading underscores in enum ice_pf_state. This is not really
communicating anything and is unnecessary. No functional change.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  68 ++---
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  18 +-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  18 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 234 +++++++++---------
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |   6 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  22 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   6 +-
 8 files changed, 187 insertions(+), 187 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index dd2e75d15558..2cb09af3148c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -197,45 +197,45 @@ struct ice_sw {
 };
 
 enum ice_pf_state {
-	__ICE_TESTING,
-	__ICE_DOWN,
-	__ICE_NEEDS_RESTART,
-	__ICE_PREPARED_FOR_RESET,	/* set by driver when prepared */
-	__ICE_RESET_OICR_RECV,		/* set by driver after rcv reset OICR */
-	__ICE_PFR_REQ,			/* set by driver and peers */
-	__ICE_CORER_REQ,		/* set by driver and peers */
-	__ICE_GLOBR_REQ,		/* set by driver and peers */
-	__ICE_CORER_RECV,		/* set by OICR handler */
-	__ICE_GLOBR_RECV,		/* set by OICR handler */
-	__ICE_EMPR_RECV,		/* set by OICR handler */
-	__ICE_SUSPENDED,		/* set on module remove path */
-	__ICE_RESET_FAILED,		/* set by reset/rebuild */
+	ICE_TESTING,
+	ICE_DOWN,
+	ICE_NEEDS_RESTART,
+	ICE_PREPARED_FOR_RESET,	/* set by driver when prepared */
+	ICE_RESET_OICR_RECV,		/* set by driver after rcv reset OICR */
+	ICE_PFR_REQ,			/* set by driver and peers */
+	ICE_CORER_REQ,		/* set by driver and peers */
+	ICE_GLOBR_REQ,		/* set by driver and peers */
+	ICE_CORER_RECV,		/* set by OICR handler */
+	ICE_GLOBR_RECV,		/* set by OICR handler */
+	ICE_EMPR_RECV,		/* set by OICR handler */
+	ICE_SUSPENDED,		/* set on module remove path */
+	ICE_RESET_FAILED,		/* set by reset/rebuild */
 	/* When checking for the PF to be in a nominal operating state, the
 	 * bits that are grouped at the beginning of the list need to be
-	 * checked. Bits occurring before __ICE_STATE_NOMINAL_CHECK_BITS will
+	 * checked. Bits occurring before ICE_STATE_NOMINAL_CHECK_BITS will
 	 * be checked. If you need to add a bit into consideration for nominal
 	 * operating state, it must be added before
-	 * __ICE_STATE_NOMINAL_CHECK_BITS. Do not move this entry's position
+	 * ICE_STATE_NOMINAL_CHECK_BITS. Do not move this entry's position
 	 * without appropriate consideration.
 	 */
-	__ICE_STATE_NOMINAL_CHECK_BITS,
-	__ICE_ADMINQ_EVENT_PENDING,
-	__ICE_MAILBOXQ_EVENT_PENDING,
-	__ICE_MDD_EVENT_PENDING,
-	__ICE_VFLR_EVENT_PENDING,
-	__ICE_FLTR_OVERFLOW_PROMISC,
-	__ICE_VF_DIS,
-	__ICE_CFG_BUSY,
-	__ICE_SERVICE_SCHED,
-	__ICE_SERVICE_DIS,
-	__ICE_FD_FLUSH_REQ,
-	__ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
-	__ICE_MDD_VF_PRINT_PENDING,	/* set when MDD event handle */
-	__ICE_VF_RESETS_DISABLED,	/* disable resets during ice_remove */
-	__ICE_LINK_DEFAULT_OVERRIDE_PENDING,
-	__ICE_PHY_INIT_COMPLETE,
-	__ICE_FD_VF_FLUSH_CTX,		/* set at FD Rx IRQ or timeout */
-	__ICE_STATE_NBITS		/* must be last */
+	ICE_STATE_NOMINAL_CHECK_BITS,
+	ICE_ADMINQ_EVENT_PENDING,
+	ICE_MAILBOXQ_EVENT_PENDING,
+	ICE_MDD_EVENT_PENDING,
+	ICE_VFLR_EVENT_PENDING,
+	ICE_FLTR_OVERFLOW_PROMISC,
+	ICE_VF_DIS,
+	ICE_CFG_BUSY,
+	ICE_SERVICE_SCHED,
+	ICE_SERVICE_DIS,
+	ICE_FD_FLUSH_REQ,
+	ICE_OICR_INTR_DIS,		/* Global OICR interrupt disabled */
+	ICE_MDD_VF_PRINT_PENDING,	/* set when MDD event handle */
+	ICE_VF_RESETS_DISABLED,	/* disable resets during ice_remove */
+	ICE_LINK_DEFAULT_OVERRIDE_PENDING,
+	ICE_PHY_INIT_COMPLETE,
+	ICE_FD_VF_FLUSH_CTX,		/* set at FD Rx IRQ or timeout */
+	ICE_STATE_NBITS		/* must be last */
 };
 
 enum ice_vsi_state {
@@ -421,7 +421,7 @@ struct ice_pf {
 	u16 num_msix_per_vf;
 	/* used to ratelimit the MDD event logging */
 	unsigned long last_printed_mdd_jiffies;
-	DECLARE_BITMAP(state, __ICE_STATE_NBITS);
+	DECLARE_BITMAP(state, ICE_STATE_NBITS);
 	DECLARE_BITMAP(flags, ICE_PF_FLAGS_NBITS);
 	unsigned long *avail_txqs;	/* bitmap to track PF Tx queue usage */
 	unsigned long *avail_rxqs;	/* bitmap to track PF Rx queue usage */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a39e890100d9..f2bc8f1e86cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -806,7 +806,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
 		netdev_info(netdev, "offline testing starting\n");
 
-		set_bit(__ICE_TESTING, pf->state);
+		set_bit(ICE_TESTING, pf->state);
 
 		if (ice_active_vfs(pf)) {
 			dev_warn(dev, "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
@@ -816,7 +816,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 			data[ICE_ETH_TEST_LOOP] = 1;
 			data[ICE_ETH_TEST_LINK] = 1;
 			eth_test->flags |= ETH_TEST_FL_FAILED;
-			clear_bit(__ICE_TESTING, pf->state);
+			clear_bit(ICE_TESTING, pf->state);
 			goto skip_ol_tests;
 		}
 		/* If the device is online then take it offline */
@@ -837,7 +837,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 		    data[ICE_ETH_TEST_REG])
 			eth_test->flags |= ETH_TEST_FL_FAILED;
 
-		clear_bit(__ICE_TESTING, pf->state);
+		clear_bit(ICE_TESTING, pf->state);
 
 		if (if_running) {
 			int status = ice_open(netdev);
@@ -1097,7 +1097,7 @@ static int ice_nway_reset(struct net_device *netdev)
 	int err;
 
 	/* If VSI state is up, then restart autoneg with link up */
-	if (!test_bit(__ICE_DOWN, vsi->back->state))
+	if (!test_bit(ICE_DOWN, vsi->back->state))
 		err = ice_set_link(vsi, true);
 	else
 		err = ice_set_link(vsi, false);
@@ -2282,7 +2282,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 		goto done;
 	}
 
-	while (test_and_set_bit(__ICE_CFG_BUSY, pf->state)) {
+	while (test_and_set_bit(ICE_CFG_BUSY, pf->state)) {
 		timeout--;
 		if (!timeout) {
 			err = -EBUSY;
@@ -2392,7 +2392,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 	pi->phy.curr_user_speed_req = adv_link_speed;
 done:
 	kfree(phy_caps);
-	clear_bit(__ICE_CFG_BUSY, pf->state);
+	clear_bit(ICE_CFG_BUSY, pf->state);
 
 	return err;
 }
@@ -2748,7 +2748,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	if (ice_xsk_any_rx_ring_ena(vsi))
 		return -EBUSY;
 
-	while (test_and_set_bit(__ICE_CFG_BUSY, pf->state)) {
+	while (test_and_set_bit(ICE_CFG_BUSY, pf->state)) {
 		timeout--;
 		if (!timeout)
 			return -EBUSY;
@@ -2927,7 +2927,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	}
 
 done:
-	clear_bit(__ICE_CFG_BUSY, pf->state);
+	clear_bit(ICE_CFG_BUSY, pf->state);
 	return err;
 }
 
@@ -3046,7 +3046,7 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	}
 
 	/* If we have link and don't have autoneg */
-	if (!test_bit(__ICE_DOWN, pf->state) &&
+	if (!test_bit(ICE_DOWN, pf->state) &&
 	    !(hw_link_info->an_info & ICE_AQ_AN_COMPLETED)) {
 		/* Send message that it might not necessarily work*/
 		netdev_info(netdev, "Autoneg did not complete so changing settings may not result in an actual change.\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 440964defa4a..16de603b280c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1452,7 +1452,7 @@ int ice_del_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 		return -EBUSY;
 	}
 
-	if (test_bit(__ICE_FD_FLUSH_REQ, pf->state))
+	if (test_bit(ICE_FD_FLUSH_REQ, pf->state))
 		return -EBUSY;
 
 	mutex_lock(&hw->fdir_fltr_lock);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 16d0ee5b48a5..162f01b42147 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1502,13 +1502,13 @@ static void ice_vsi_set_rss_flow_fld(struct ice_vsi *vsi)
  */
 bool ice_pf_state_is_nominal(struct ice_pf *pf)
 {
-	DECLARE_BITMAP(check_bits, __ICE_STATE_NBITS) = { 0 };
+	DECLARE_BITMAP(check_bits, ICE_STATE_NBITS) = { 0 };
 
 	if (!pf)
 		return false;
 
-	bitmap_set(check_bits, 0, __ICE_STATE_NOMINAL_CHECK_BITS);
-	if (bitmap_intersects(pf->state, check_bits, __ICE_STATE_NBITS))
+	bitmap_set(check_bits, 0, ICE_STATE_NOMINAL_CHECK_BITS);
+	if (bitmap_intersects(pf->state, check_bits, ICE_STATE_NBITS))
 		return false;
 
 	return true;
@@ -2811,7 +2811,7 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	ice_vsi_delete(vsi);
 	ice_vsi_free_q_vectors(vsi);
 
-	/* make sure unregister_netdev() was called by checking __ICE_DOWN */
+	/* make sure unregister_netdev() was called by checking ICE_DOWN */
 	if (vsi->netdev && test_bit(ICE_VSI_DOWN, vsi->state)) {
 		free_netdev(vsi->netdev);
 		vsi->netdev = NULL;
@@ -3140,7 +3140,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 	}
 err_vsi:
 	ice_vsi_clear(vsi);
-	set_bit(__ICE_RESET_FAILED, pf->state);
+	set_bit(ICE_RESET_FAILED, pf->state);
 	kfree(coalesce);
 	return ret;
 }
@@ -3151,10 +3151,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
  */
 bool ice_is_reset_in_progress(unsigned long *state)
 {
-	return test_bit(__ICE_RESET_OICR_RECV, state) ||
-	       test_bit(__ICE_PFR_REQ, state) ||
-	       test_bit(__ICE_CORER_REQ, state) ||
-	       test_bit(__ICE_GLOBR_REQ, state);
+	return test_bit(ICE_RESET_OICR_RECV, state) ||
+	       test_bit(ICE_PFR_REQ, state) ||
+	       test_bit(ICE_CORER_REQ, state) ||
+	       test_bit(ICE_GLOBR_REQ, state);
 }
 
 #ifdef CONFIG_DCB
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1b2f1e258e5c..032101680e09 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -257,7 +257,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	if (!vsi->netdev)
 		return -EINVAL;
 
-	while (test_and_set_bit(__ICE_CFG_BUSY, vsi->state))
+	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
 		usleep_range(1000, 2000);
 
 	changed_flags = vsi->current_netdev_flags ^ vsi->netdev->flags;
@@ -307,7 +307,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 		 * space reserved for promiscuous filters.
 		 */
 		if (hw->adminq.sq_last_status == ICE_AQ_RC_ENOSPC &&
-		    !test_and_set_bit(__ICE_FLTR_OVERFLOW_PROMISC,
+		    !test_and_set_bit(ICE_FLTR_OVERFLOW_PROMISC,
 				      vsi->state)) {
 			promisc_forced_on = true;
 			netdev_warn(netdev, "Reached MAC filter limit, forcing promisc mode on VSI %d\n",
@@ -391,7 +391,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	set_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state);
 	set_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
 exit:
-	clear_bit(__ICE_CFG_BUSY, vsi->state);
+	clear_bit(ICE_CFG_BUSY, vsi->state);
 	return err;
 }
 
@@ -451,7 +451,7 @@ ice_prepare_for_reset(struct ice_pf *pf)
 	unsigned int i;
 
 	/* already prepared for reset */
-	if (test_bit(__ICE_PREPARED_FOR_RESET, pf->state))
+	if (test_bit(ICE_PREPARED_FOR_RESET, pf->state))
 		return;
 
 	/* Notify VFs of impending reset */
@@ -472,7 +472,7 @@ ice_prepare_for_reset(struct ice_pf *pf)
 
 	ice_shutdown_all_ctrlq(hw);
 
-	set_bit(__ICE_PREPARED_FOR_RESET, pf->state);
+	set_bit(ICE_PREPARED_FOR_RESET, pf->state);
 }
 
 /**
@@ -493,12 +493,12 @@ static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	/* trigger the reset */
 	if (ice_reset(hw, reset_type)) {
 		dev_err(dev, "reset %d failed\n", reset_type);
-		set_bit(__ICE_RESET_FAILED, pf->state);
-		clear_bit(__ICE_RESET_OICR_RECV, pf->state);
-		clear_bit(__ICE_PREPARED_FOR_RESET, pf->state);
-		clear_bit(__ICE_PFR_REQ, pf->state);
-		clear_bit(__ICE_CORER_REQ, pf->state);
-		clear_bit(__ICE_GLOBR_REQ, pf->state);
+		set_bit(ICE_RESET_FAILED, pf->state);
+		clear_bit(ICE_RESET_OICR_RECV, pf->state);
+		clear_bit(ICE_PREPARED_FOR_RESET, pf->state);
+		clear_bit(ICE_PFR_REQ, pf->state);
+		clear_bit(ICE_CORER_REQ, pf->state);
+		clear_bit(ICE_GLOBR_REQ, pf->state);
 		return;
 	}
 
@@ -509,8 +509,8 @@ static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	if (reset_type == ICE_RESET_PFR) {
 		pf->pfr_count++;
 		ice_rebuild(pf, reset_type);
-		clear_bit(__ICE_PREPARED_FOR_RESET, pf->state);
-		clear_bit(__ICE_PFR_REQ, pf->state);
+		clear_bit(ICE_PREPARED_FOR_RESET, pf->state);
+		clear_bit(ICE_PFR_REQ, pf->state);
 		ice_reset_all_vfs(pf, true);
 	}
 }
@@ -526,20 +526,20 @@ static void ice_reset_subtask(struct ice_pf *pf)
 	/* When a CORER/GLOBR/EMPR is about to happen, the hardware triggers an
 	 * OICR interrupt. The OICR handler (ice_misc_intr) determines what type
 	 * of reset is pending and sets bits in pf->state indicating the reset
-	 * type and __ICE_RESET_OICR_RECV. So, if the latter bit is set
+	 * type and ICE_RESET_OICR_RECV. So, if the latter bit is set
 	 * prepare for pending reset if not already (for PF software-initiated
 	 * global resets the software should already be prepared for it as
-	 * indicated by __ICE_PREPARED_FOR_RESET; for global resets initiated
+	 * indicated by ICE_PREPARED_FOR_RESET; for global resets initiated
 	 * by firmware or software on other PFs, that bit is not set so prepare
 	 * for the reset now), poll for reset done, rebuild and return.
 	 */
-	if (test_bit(__ICE_RESET_OICR_RECV, pf->state)) {
+	if (test_bit(ICE_RESET_OICR_RECV, pf->state)) {
 		/* Perform the largest reset requested */
-		if (test_and_clear_bit(__ICE_CORER_RECV, pf->state))
+		if (test_and_clear_bit(ICE_CORER_RECV, pf->state))
 			reset_type = ICE_RESET_CORER;
-		if (test_and_clear_bit(__ICE_GLOBR_RECV, pf->state))
+		if (test_and_clear_bit(ICE_GLOBR_RECV, pf->state))
 			reset_type = ICE_RESET_GLOBR;
-		if (test_and_clear_bit(__ICE_EMPR_RECV, pf->state))
+		if (test_and_clear_bit(ICE_EMPR_RECV, pf->state))
 			reset_type = ICE_RESET_EMPR;
 		/* return if no valid reset type requested */
 		if (reset_type == ICE_RESET_INVAL)
@@ -548,7 +548,7 @@ static void ice_reset_subtask(struct ice_pf *pf)
 
 		/* make sure we are ready to rebuild */
 		if (ice_check_reset(&pf->hw)) {
-			set_bit(__ICE_RESET_FAILED, pf->state);
+			set_bit(ICE_RESET_FAILED, pf->state);
 		} else {
 			/* done with reset. start rebuild */
 			pf->hw.reset_ongoing = false;
@@ -556,11 +556,11 @@ static void ice_reset_subtask(struct ice_pf *pf)
 			/* clear bit to resume normal operations, but
 			 * ICE_NEEDS_RESTART bit is set in case rebuild failed
 			 */
-			clear_bit(__ICE_RESET_OICR_RECV, pf->state);
-			clear_bit(__ICE_PREPARED_FOR_RESET, pf->state);
-			clear_bit(__ICE_PFR_REQ, pf->state);
-			clear_bit(__ICE_CORER_REQ, pf->state);
-			clear_bit(__ICE_GLOBR_REQ, pf->state);
+			clear_bit(ICE_RESET_OICR_RECV, pf->state);
+			clear_bit(ICE_PREPARED_FOR_RESET, pf->state);
+			clear_bit(ICE_PFR_REQ, pf->state);
+			clear_bit(ICE_CORER_REQ, pf->state);
+			clear_bit(ICE_GLOBR_REQ, pf->state);
 			ice_reset_all_vfs(pf, true);
 		}
 
@@ -568,19 +568,19 @@ static void ice_reset_subtask(struct ice_pf *pf)
 	}
 
 	/* No pending resets to finish processing. Check for new resets */
-	if (test_bit(__ICE_PFR_REQ, pf->state))
+	if (test_bit(ICE_PFR_REQ, pf->state))
 		reset_type = ICE_RESET_PFR;
-	if (test_bit(__ICE_CORER_REQ, pf->state))
+	if (test_bit(ICE_CORER_REQ, pf->state))
 		reset_type = ICE_RESET_CORER;
-	if (test_bit(__ICE_GLOBR_REQ, pf->state))
+	if (test_bit(ICE_GLOBR_REQ, pf->state))
 		reset_type = ICE_RESET_GLOBR;
 	/* If no valid reset type requested just return */
 	if (reset_type == ICE_RESET_INVAL)
 		return;
 
 	/* reset if not already down or busy */
-	if (!test_bit(__ICE_DOWN, pf->state) &&
-	    !test_bit(__ICE_CFG_BUSY, pf->state)) {
+	if (!test_bit(ICE_DOWN, pf->state) &&
+	    !test_bit(ICE_CFG_BUSY, pf->state)) {
 		ice_do_reset(pf, reset_type);
 	}
 }
@@ -937,8 +937,8 @@ static void ice_watchdog_subtask(struct ice_pf *pf)
 	int i;
 
 	/* if interface is down do nothing */
-	if (test_bit(__ICE_DOWN, pf->state) ||
-	    test_bit(__ICE_CFG_BUSY, pf->state))
+	if (test_bit(ICE_DOWN, pf->state) ||
+	    test_bit(ICE_CFG_BUSY, pf->state))
 		return;
 
 	/* make sure we don't do these things too often */
@@ -1182,7 +1182,7 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 	u32 oldval, val;
 
 	/* Do not clean control queue if/when PF reset fails */
-	if (test_bit(__ICE_RESET_FAILED, pf->state))
+	if (test_bit(ICE_RESET_FAILED, pf->state))
 		return 0;
 
 	switch (q_type) {
@@ -1317,13 +1317,13 @@ static void ice_clean_adminq_subtask(struct ice_pf *pf)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	if (!test_bit(__ICE_ADMINQ_EVENT_PENDING, pf->state))
+	if (!test_bit(ICE_ADMINQ_EVENT_PENDING, pf->state))
 		return;
 
 	if (__ice_clean_ctrlq(pf, ICE_CTL_Q_ADMIN))
 		return;
 
-	clear_bit(__ICE_ADMINQ_EVENT_PENDING, pf->state);
+	clear_bit(ICE_ADMINQ_EVENT_PENDING, pf->state);
 
 	/* There might be a situation where new messages arrive to a control
 	 * queue between processing the last message and clearing the
@@ -1344,13 +1344,13 @@ static void ice_clean_mailboxq_subtask(struct ice_pf *pf)
 {
 	struct ice_hw *hw = &pf->hw;
 
-	if (!test_bit(__ICE_MAILBOXQ_EVENT_PENDING, pf->state))
+	if (!test_bit(ICE_MAILBOXQ_EVENT_PENDING, pf->state))
 		return;
 
 	if (__ice_clean_ctrlq(pf, ICE_CTL_Q_MAILBOX))
 		return;
 
-	clear_bit(__ICE_MAILBOXQ_EVENT_PENDING, pf->state);
+	clear_bit(ICE_MAILBOXQ_EVENT_PENDING, pf->state);
 
 	if (ice_ctrlq_pending(hw, &hw->mailboxq))
 		__ice_clean_ctrlq(pf, ICE_CTL_Q_MAILBOX);
@@ -1366,9 +1366,9 @@ static void ice_clean_mailboxq_subtask(struct ice_pf *pf)
  */
 void ice_service_task_schedule(struct ice_pf *pf)
 {
-	if (!test_bit(__ICE_SERVICE_DIS, pf->state) &&
-	    !test_and_set_bit(__ICE_SERVICE_SCHED, pf->state) &&
-	    !test_bit(__ICE_NEEDS_RESTART, pf->state))
+	if (!test_bit(ICE_SERVICE_DIS, pf->state) &&
+	    !test_and_set_bit(ICE_SERVICE_SCHED, pf->state) &&
+	    !test_bit(ICE_NEEDS_RESTART, pf->state))
 		queue_work(ice_wq, &pf->serv_task);
 }
 
@@ -1378,32 +1378,32 @@ void ice_service_task_schedule(struct ice_pf *pf)
  */
 static void ice_service_task_complete(struct ice_pf *pf)
 {
-	WARN_ON(!test_bit(__ICE_SERVICE_SCHED, pf->state));
+	WARN_ON(!test_bit(ICE_SERVICE_SCHED, pf->state));
 
 	/* force memory (pf->state) to sync before next service task */
 	smp_mb__before_atomic();
-	clear_bit(__ICE_SERVICE_SCHED, pf->state);
+	clear_bit(ICE_SERVICE_SCHED, pf->state);
 }
 
 /**
  * ice_service_task_stop - stop service task and cancel works
  * @pf: board private structure
  *
- * Return 0 if the __ICE_SERVICE_DIS bit was not already set,
+ * Return 0 if the ICE_SERVICE_DIS bit was not already set,
  * 1 otherwise.
  */
 static int ice_service_task_stop(struct ice_pf *pf)
 {
 	int ret;
 
-	ret = test_and_set_bit(__ICE_SERVICE_DIS, pf->state);
+	ret = test_and_set_bit(ICE_SERVICE_DIS, pf->state);
 
 	if (pf->serv_tmr.function)
 		del_timer_sync(&pf->serv_tmr);
 	if (pf->serv_task.func)
 		cancel_work_sync(&pf->serv_task);
 
-	clear_bit(__ICE_SERVICE_SCHED, pf->state);
+	clear_bit(ICE_SERVICE_SCHED, pf->state);
 	return ret;
 }
 
@@ -1415,7 +1415,7 @@ static int ice_service_task_stop(struct ice_pf *pf)
  */
 static void ice_service_task_restart(struct ice_pf *pf)
 {
-	clear_bit(__ICE_SERVICE_DIS, pf->state);
+	clear_bit(ICE_SERVICE_DIS, pf->state);
 	ice_service_task_schedule(pf);
 }
 
@@ -1448,7 +1448,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 	unsigned int i;
 	u32 reg;
 
-	if (!test_and_clear_bit(__ICE_MDD_EVENT_PENDING, pf->state)) {
+	if (!test_and_clear_bit(ICE_MDD_EVENT_PENDING, pf->state)) {
 		/* Since the VF MDD event logging is rate limited, check if
 		 * there are pending MDD events.
 		 */
@@ -1540,7 +1540,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_TX_PQM_VALID_M) {
 			wr32(hw, VP_MDET_TX_PQM(i), 0xFFFF);
 			vf->mdd_tx_events.count++;
-			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			set_bit(ICE_MDD_VF_PRINT_PENDING, pf->state);
 			if (netif_msg_tx_err(pf))
 				dev_info(dev, "Malicious Driver Detection event TX_PQM detected on VF %d\n",
 					 i);
@@ -1550,7 +1550,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_TX_TCLAN_VALID_M) {
 			wr32(hw, VP_MDET_TX_TCLAN(i), 0xFFFF);
 			vf->mdd_tx_events.count++;
-			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			set_bit(ICE_MDD_VF_PRINT_PENDING, pf->state);
 			if (netif_msg_tx_err(pf))
 				dev_info(dev, "Malicious Driver Detection event TX_TCLAN detected on VF %d\n",
 					 i);
@@ -1560,7 +1560,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_TX_TDPU_VALID_M) {
 			wr32(hw, VP_MDET_TX_TDPU(i), 0xFFFF);
 			vf->mdd_tx_events.count++;
-			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			set_bit(ICE_MDD_VF_PRINT_PENDING, pf->state);
 			if (netif_msg_tx_err(pf))
 				dev_info(dev, "Malicious Driver Detection event TX_TDPU detected on VF %d\n",
 					 i);
@@ -1570,7 +1570,7 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
 		if (reg & VP_MDET_RX_VALID_M) {
 			wr32(hw, VP_MDET_RX(i), 0xFFFF);
 			vf->mdd_rx_events.count++;
-			set_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state);
+			set_bit(ICE_MDD_VF_PRINT_PENDING, pf->state);
 			if (netif_msg_rx_err(pf))
 				dev_info(dev, "Malicious Driver Detection event RX detected on VF %d\n",
 					 i);
@@ -1735,7 +1735,7 @@ static void ice_init_link_dflt_override(struct ice_port_info *pi)
  * settings using the default override mask from the NVM.
  *
  * The PHY should only be configured with the default override settings the
- * first time media is available. The __ICE_LINK_DEFAULT_OVERRIDE_PENDING state
+ * first time media is available. The ICE_LINK_DEFAULT_OVERRIDE_PENDING state
  * is used to indicate that the user PHY cfg default override is initialized
  * and the PHY has not been configured with the default override settings. The
  * state is set here, and cleared in ice_configure_phy the first time the PHY is
@@ -1767,7 +1767,7 @@ static void ice_init_phy_cfg_dflt_override(struct ice_port_info *pi)
 	cfg->link_fec_opt = ldo->fec_options;
 	phy->curr_user_fec_req = ICE_FEC_AUTO;
 
-	set_bit(__ICE_LINK_DEFAULT_OVERRIDE_PENDING, pf->state);
+	set_bit(ICE_LINK_DEFAULT_OVERRIDE_PENDING, pf->state);
 }
 
 /**
@@ -1839,7 +1839,7 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 
 out:
 	phy->curr_user_speed_req = ICE_AQ_LINK_SPEED_M;
-	set_bit(__ICE_PHY_INIT_COMPLETE, pf->state);
+	set_bit(ICE_PHY_INIT_COMPLETE, pf->state);
 err_out:
 	kfree(pcaps);
 	return err;
@@ -1923,7 +1923,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 	/* Speed - If default override pending, use curr_user_phy_cfg set in
 	 * ice_init_phy_user_cfg_ldo.
 	 */
-	if (test_and_clear_bit(__ICE_LINK_DEFAULT_OVERRIDE_PENDING,
+	if (test_and_clear_bit(ICE_LINK_DEFAULT_OVERRIDE_PENDING,
 			       vsi->back->state)) {
 		cfg->phy_type_low = phy->curr_user_phy_cfg.phy_type_low;
 		cfg->phy_type_high = phy->curr_user_phy_cfg.phy_type_high;
@@ -2002,7 +2002,7 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 		return;
 
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
-		if (!test_bit(__ICE_PHY_INIT_COMPLETE, pf->state))
+		if (!test_bit(ICE_PHY_INIT_COMPLETE, pf->state))
 			ice_init_phy_user_cfg(pi);
 
 		/* PHY settings are reset on media insertion, reconfigure
@@ -2038,8 +2038,8 @@ static void ice_service_task(struct work_struct *work)
 
 	/* bail if a reset/recovery cycle is pending or rebuild failed */
 	if (ice_is_reset_in_progress(pf->state) ||
-	    test_bit(__ICE_SUSPENDED, pf->state) ||
-	    test_bit(__ICE_NEEDS_RESTART, pf->state)) {
+	    test_bit(ICE_SUSPENDED, pf->state) ||
+	    test_bit(ICE_NEEDS_RESTART, pf->state)) {
 		ice_service_task_complete(pf);
 		return;
 	}
@@ -2060,7 +2060,8 @@ static void ice_service_task(struct work_struct *work)
 	ice_clean_mailboxq_subtask(pf);
 	ice_sync_arfs_fltrs(pf);
 	ice_flush_fdir_ctx(pf);
-	/* Clear __ICE_SERVICE_SCHED flag to allow scheduling next event */
+
+	/* Clear ICE_SERVICE_SCHED flag to allow scheduling next event */
 	ice_service_task_complete(pf);
 
 	/* If the tasks have taken longer than one service timer period
@@ -2068,11 +2069,11 @@ static void ice_service_task(struct work_struct *work)
 	 * schedule the service task now.
 	 */
 	if (time_after(jiffies, (start_time + pf->serv_tmr_period)) ||
-	    test_bit(__ICE_MDD_EVENT_PENDING, pf->state) ||
-	    test_bit(__ICE_VFLR_EVENT_PENDING, pf->state) ||
-	    test_bit(__ICE_MAILBOXQ_EVENT_PENDING, pf->state) ||
-	    test_bit(__ICE_FD_VF_FLUSH_CTX, pf->state) ||
-	    test_bit(__ICE_ADMINQ_EVENT_PENDING, pf->state))
+	    test_bit(ICE_MDD_EVENT_PENDING, pf->state) ||
+	    test_bit(ICE_VFLR_EVENT_PENDING, pf->state) ||
+	    test_bit(ICE_MAILBOXQ_EVENT_PENDING, pf->state) ||
+	    test_bit(ICE_FD_VF_FLUSH_CTX, pf->state) ||
+	    test_bit(ICE_ADMINQ_EVENT_PENDING, pf->state))
 		mod_timer(&pf->serv_tmr, jiffies);
 }
 
@@ -2102,7 +2103,7 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
 	struct device *dev = ice_pf_to_dev(pf);
 
 	/* bail out if earlier reset has failed */
-	if (test_bit(__ICE_RESET_FAILED, pf->state)) {
+	if (test_bit(ICE_RESET_FAILED, pf->state)) {
 		dev_dbg(dev, "earlier reset has failed\n");
 		return -EIO;
 	}
@@ -2114,13 +2115,13 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset)
 
 	switch (reset) {
 	case ICE_RESET_PFR:
-		set_bit(__ICE_PFR_REQ, pf->state);
+		set_bit(ICE_PFR_REQ, pf->state);
 		break;
 	case ICE_RESET_CORER:
-		set_bit(__ICE_CORER_REQ, pf->state);
+		set_bit(ICE_CORER_REQ, pf->state);
 		break;
 	case ICE_RESET_GLOBR:
-		set_bit(__ICE_GLOBR_REQ, pf->state);
+		set_bit(ICE_GLOBR_REQ, pf->state);
 		break;
 	default:
 		return -EINVAL;
@@ -2625,8 +2626,8 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 	u32 oicr, ena_mask;
 
 	dev = ice_pf_to_dev(pf);
-	set_bit(__ICE_ADMINQ_EVENT_PENDING, pf->state);
-	set_bit(__ICE_MAILBOXQ_EVENT_PENDING, pf->state);
+	set_bit(ICE_ADMINQ_EVENT_PENDING, pf->state);
+	set_bit(ICE_MAILBOXQ_EVENT_PENDING, pf->state);
 
 	oicr = rd32(hw, PFINT_OICR);
 	ena_mask = rd32(hw, PFINT_OICR_ENA);
@@ -2638,18 +2639,18 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 	if (oicr & PFINT_OICR_MAL_DETECT_M) {
 		ena_mask &= ~PFINT_OICR_MAL_DETECT_M;
-		set_bit(__ICE_MDD_EVENT_PENDING, pf->state);
+		set_bit(ICE_MDD_EVENT_PENDING, pf->state);
 	}
 	if (oicr & PFINT_OICR_VFLR_M) {
 		/* disable any further VFLR event notifications */
-		if (test_bit(__ICE_VF_RESETS_DISABLED, pf->state)) {
+		if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
 			u32 reg = rd32(hw, PFINT_OICR_ENA);
 
 			reg &= ~PFINT_OICR_VFLR_M;
 			wr32(hw, PFINT_OICR_ENA, reg);
 		} else {
 			ena_mask &= ~PFINT_OICR_VFLR_M;
-			set_bit(__ICE_VFLR_EVENT_PENDING, pf->state);
+			set_bit(ICE_VFLR_EVENT_PENDING, pf->state);
 		}
 	}
 
@@ -2675,13 +2676,13 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		 * We also make note of which reset happened so that peer
 		 * devices/drivers can be informed.
 		 */
-		if (!test_and_set_bit(__ICE_RESET_OICR_RECV, pf->state)) {
+		if (!test_and_set_bit(ICE_RESET_OICR_RECV, pf->state)) {
 			if (reset == ICE_RESET_CORER)
-				set_bit(__ICE_CORER_RECV, pf->state);
+				set_bit(ICE_CORER_RECV, pf->state);
 			else if (reset == ICE_RESET_GLOBR)
-				set_bit(__ICE_GLOBR_RECV, pf->state);
+				set_bit(ICE_GLOBR_RECV, pf->state);
 			else
-				set_bit(__ICE_EMPR_RECV, pf->state);
+				set_bit(ICE_EMPR_RECV, pf->state);
 
 			/* There are couple of different bits at play here.
 			 * hw->reset_ongoing indicates whether the hardware is
@@ -2689,7 +2690,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 			 * is received and set back to false after the driver
 			 * has determined that the hardware is out of reset.
 			 *
-			 * __ICE_RESET_OICR_RECV in pf->state indicates
+			 * ICE_RESET_OICR_RECV in pf->state indicates
 			 * that a post reset rebuild is required before the
 			 * driver is operational again. This is set above.
 			 *
@@ -2717,7 +2718,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		if (oicr & (PFINT_OICR_PE_CRITERR_M |
 			    PFINT_OICR_PCI_EXCEPTION_M |
 			    PFINT_OICR_ECC_ERR_M)) {
-			set_bit(__ICE_PFR_REQ, pf->state);
+			set_bit(ICE_PFR_REQ, pf->state);
 			ice_service_task_schedule(pf);
 		}
 	}
@@ -3321,7 +3322,7 @@ static int ice_init_pf(struct ice_pf *pf)
 	timer_setup(&pf->serv_tmr, ice_service_timer, 0);
 	pf->serv_tmr_period = HZ;
 	INIT_WORK(&pf->serv_task, ice_service_task);
-	clear_bit(__ICE_SERVICE_SCHED, pf->state);
+	clear_bit(ICE_SERVICE_SCHED, pf->state);
 
 	mutex_init(&pf->avail_q_mutex);
 	pf->avail_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
@@ -3530,7 +3531,7 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 	if (!new_rx && !new_tx)
 		return -EINVAL;
 
-	while (test_and_set_bit(__ICE_CFG_BUSY, pf->state)) {
+	while (test_and_set_bit(ICE_CFG_BUSY, pf->state)) {
 		timeout--;
 		if (!timeout)
 			return -EBUSY;
@@ -3554,7 +3555,7 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 	ice_pf_dcb_recfg(pf);
 	ice_vsi_open(vsi);
 done:
-	clear_bit(__ICE_CFG_BUSY, pf->state);
+	clear_bit(ICE_CFG_BUSY, pf->state);
 	return err;
 }
 
@@ -4020,9 +4021,9 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	pf->pdev = pdev;
 	pci_set_drvdata(pdev, pf);
-	set_bit(__ICE_DOWN, pf->state);
+	set_bit(ICE_DOWN, pf->state);
 	/* Disable service task until DOWN bit is cleared */
-	set_bit(__ICE_SERVICE_DIS, pf->state);
+	set_bit(ICE_SERVICE_DIS, pf->state);
 
 	hw = &pf->hw;
 	hw->hw_addr = pcim_iomap_table(pdev)[ICE_BAR0];
@@ -4162,7 +4163,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_alloc_sw_unroll;
 	}
 
-	clear_bit(__ICE_SERVICE_DIS, pf->state);
+	clear_bit(ICE_SERVICE_DIS, pf->state);
 
 	/* tell the firmware we are up */
 	err = ice_send_version(pf);
@@ -4256,16 +4257,15 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_netdev_reg;
 
 	/* ready to go, so clear down state bit */
-	clear_bit(__ICE_DOWN, pf->state);
-
+	clear_bit(ICE_DOWN, pf->state);
 	return 0;
 
 err_netdev_reg:
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
 err_alloc_sw_unroll:
-	set_bit(__ICE_SERVICE_DIS, pf->state);
-	set_bit(__ICE_DOWN, pf->state);
+	set_bit(ICE_SERVICE_DIS, pf->state);
+	set_bit(ICE_DOWN, pf->state);
 	devm_kfree(dev, pf->first_sw);
 err_msix_misc_unroll:
 	ice_free_irq_msix_misc(pf);
@@ -4365,11 +4365,11 @@ static void ice_remove(struct pci_dev *pdev)
 	}
 
 	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags)) {
-		set_bit(__ICE_VF_RESETS_DISABLED, pf->state);
+		set_bit(ICE_VF_RESETS_DISABLED, pf->state);
 		ice_free_vfs(pf);
 	}
 
-	set_bit(__ICE_DOWN, pf->state);
+	set_bit(ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
@@ -4529,13 +4529,13 @@ static int __maybe_unused ice_suspend(struct device *dev)
 	disabled = ice_service_task_stop(pf);
 
 	/* Already suspended?, then there is nothing to do */
-	if (test_and_set_bit(__ICE_SUSPENDED, pf->state)) {
+	if (test_and_set_bit(ICE_SUSPENDED, pf->state)) {
 		if (!disabled)
 			ice_service_task_restart(pf);
 		return 0;
 	}
 
-	if (test_bit(__ICE_DOWN, pf->state) ||
+	if (test_bit(ICE_DOWN, pf->state) ||
 	    ice_is_reset_in_progress(pf->state)) {
 		dev_err(dev, "can't suspend device in reset or already down\n");
 		if (!disabled)
@@ -4607,16 +4607,16 @@ static int __maybe_unused ice_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "Cannot restore interrupt scheme: %d\n", ret);
 
-	clear_bit(__ICE_DOWN, pf->state);
+	clear_bit(ICE_DOWN, pf->state);
 	/* Now perform PF reset and rebuild */
 	reset_type = ICE_RESET_PFR;
 	/* re-enable service task for reset, but allow reset to schedule it */
-	clear_bit(__ICE_SERVICE_DIS, pf->state);
+	clear_bit(ICE_SERVICE_DIS, pf->state);
 
 	if (ice_schedule_reset(pf, reset_type))
 		dev_err(dev, "Reset during resume failed.\n");
 
-	clear_bit(__ICE_SUSPENDED, pf->state);
+	clear_bit(ICE_SUSPENDED, pf->state);
 	ice_service_task_restart(pf);
 
 	/* Restart the service task */
@@ -4645,11 +4645,11 @@ ice_pci_err_detected(struct pci_dev *pdev, pci_channel_state_t err)
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	if (!test_bit(__ICE_SUSPENDED, pf->state)) {
+	if (!test_bit(ICE_SUSPENDED, pf->state)) {
 		ice_service_task_stop(pf);
 
-		if (!test_bit(__ICE_PREPARED_FOR_RESET, pf->state)) {
-			set_bit(__ICE_PFR_REQ, pf->state);
+		if (!test_bit(ICE_PREPARED_FOR_RESET, pf->state)) {
+			set_bit(ICE_PFR_REQ, pf->state);
 			ice_prepare_for_reset(pf);
 		}
 	}
@@ -4716,7 +4716,7 @@ static void ice_pci_err_resume(struct pci_dev *pdev)
 		return;
 	}
 
-	if (test_bit(__ICE_SUSPENDED, pf->state)) {
+	if (test_bit(ICE_SUSPENDED, pf->state)) {
 		dev_dbg(&pdev->dev, "%s failed to resume normal operations!\n",
 			__func__);
 		return;
@@ -4737,11 +4737,11 @@ static void ice_pci_err_reset_prepare(struct pci_dev *pdev)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 
-	if (!test_bit(__ICE_SUSPENDED, pf->state)) {
+	if (!test_bit(ICE_SUSPENDED, pf->state)) {
 		ice_service_task_stop(pf);
 
-		if (!test_bit(__ICE_PREPARED_FOR_RESET, pf->state)) {
-			set_bit(__ICE_PFR_REQ, pf->state);
+		if (!test_bit(ICE_PREPARED_FOR_RESET, pf->state)) {
+			set_bit(ICE_PFR_REQ, pf->state);
 			ice_prepare_for_reset(pf);
 		}
 	}
@@ -4888,7 +4888,7 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 		return 0;
 	}
 
-	if (test_bit(__ICE_DOWN, pf->state) ||
+	if (test_bit(ICE_DOWN, pf->state) ||
 	    ice_is_reset_in_progress(pf->state)) {
 		netdev_err(netdev, "can't set mac %pM. device not ready\n",
 			   mac);
@@ -5373,7 +5373,7 @@ void ice_update_vsi_stats(struct ice_vsi *vsi)
 	struct ice_pf *pf = vsi->back;
 
 	if (test_bit(ICE_VSI_DOWN, vsi->state) ||
-	    test_bit(__ICE_CFG_BUSY, pf->state))
+	    test_bit(ICE_CFG_BUSY, pf->state))
 		return;
 
 	/* get stats as recorded by Tx/Rx rings */
@@ -5625,7 +5625,7 @@ int ice_down(struct ice_vsi *vsi)
 	int i, tx_err, rx_err, link_err = 0;
 
 	/* Caller of this function is expected to set the
-	 * vsi->state __ICE_DOWN bit
+	 * vsi->state ICE_DOWN bit
 	 */
 	if (vsi->netdev) {
 		netif_carrier_off(vsi->netdev);
@@ -5973,7 +5973,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	enum ice_status ret;
 	int err;
 
-	if (test_bit(__ICE_DOWN, pf->state))
+	if (test_bit(ICE_DOWN, pf->state))
 		goto clear_recovery;
 
 	dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
@@ -6089,7 +6089,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	ice_replay_post(hw);
 
 	/* if we get here, reset flow is successful */
-	clear_bit(__ICE_RESET_FAILED, pf->state);
+	clear_bit(ICE_RESET_FAILED, pf->state);
 	return;
 
 err_vsi_rebuild:
@@ -6097,10 +6097,10 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	ice_sched_cleanup_all(hw);
 err_init_ctrlq:
 	ice_shutdown_all_ctrlq(hw);
-	set_bit(__ICE_RESET_FAILED, pf->state);
+	set_bit(ICE_RESET_FAILED, pf->state);
 clear_recovery:
 	/* set this bit in PF state to control service task scheduling */
-	set_bit(__ICE_NEEDS_RESTART, pf->state);
+	set_bit(ICE_NEEDS_RESTART, pf->state);
 	dev_err(dev, "Rebuild failed, unload and reload driver\n");
 }
 
@@ -6622,19 +6622,19 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 
 	switch (pf->tx_timeout_recovery_level) {
 	case 1:
-		set_bit(__ICE_PFR_REQ, pf->state);
+		set_bit(ICE_PFR_REQ, pf->state);
 		break;
 	case 2:
-		set_bit(__ICE_CORER_REQ, pf->state);
+		set_bit(ICE_CORER_REQ, pf->state);
 		break;
 	case 3:
-		set_bit(__ICE_GLOBR_REQ, pf->state);
+		set_bit(ICE_GLOBR_REQ, pf->state);
 		break;
 	default:
 		netdev_err(netdev, "tx_timeout recovery unsuccessful, device is in unrecoverable state.\n");
-		set_bit(__ICE_DOWN, pf->state);
+		set_bit(ICE_DOWN, pf->state);
 		set_bit(ICE_VSI_NEEDS_RESTART, vsi->state);
-		set_bit(__ICE_SERVICE_DIS, pf->state);
+		set_bit(ICE_SERVICE_DIS, pf->state);
 		break;
 	}
 
@@ -6685,7 +6685,7 @@ int ice_open_internal(struct net_device *netdev)
 	enum ice_status status;
 	int err;
 
-	if (test_bit(__ICE_NEEDS_RESTART, pf->state)) {
+	if (test_bit(ICE_NEEDS_RESTART, pf->state)) {
 		netdev_err(netdev, "driver needs to be unloaded and reloaded\n");
 		return -EIO;
 	}
@@ -6703,7 +6703,7 @@ int ice_open_internal(struct net_device *netdev)
 	/* Set PHY if there is media, otherwise, turn off PHY */
 	if (pi->phy.link_info.link_info & ICE_AQ_MEDIA_AVAILABLE) {
 		clear_bit(ICE_FLAG_NO_MEDIA, pf->flags);
-		if (!test_bit(__ICE_PHY_INIT_COMPLETE, pf->state)) {
+		if (!test_bit(ICE_PHY_INIT_COMPLETE, pf->state)) {
 			err = ice_init_phy_user_cfg(pi);
 			if (err) {
 				netdev_err(netdev, "Failed to initialize PHY settings, error %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 1f4ba38b1599..eee180d8c024 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -1548,7 +1548,7 @@ static void ice_vf_fdir_timer(struct timer_list *t)
 	ctx_done->v_opcode = ctx_irq->v_opcode;
 	spin_unlock_irqrestore(&fdir->ctx_lock, flags);
 
-	set_bit(__ICE_FD_VF_FLUSH_CTX, pf->state);
+	set_bit(ICE_FD_VF_FLUSH_CTX, pf->state);
 	ice_service_task_schedule(pf);
 }
 
@@ -1596,7 +1596,7 @@ ice_vc_fdir_irq_handler(struct ice_vsi *ctrl_vsi,
 	if (!ret)
 		dev_err(dev, "VF %d: Unexpected inactive timer!\n", vf->vf_id);
 
-	set_bit(__ICE_FD_VF_FLUSH_CTX, pf->state);
+	set_bit(ICE_FD_VF_FLUSH_CTX, pf->state);
 	ice_service_task_schedule(pf);
 }
 
@@ -1847,7 +1847,7 @@ void ice_flush_fdir_ctx(struct ice_pf *pf)
 {
 	int i;
 
-	if (!test_and_clear_bit(__ICE_FD_VF_FLUSH_CTX, pf->state))
+	if (!test_and_clear_bit(ICE_FD_VF_FLUSH_CTX, pf->state))
 		return;
 
 	ice_for_each_vf(pf, i) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index e68d52a6b11d..a3d8d06b1e3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -371,7 +371,7 @@ void ice_free_vfs(struct ice_pf *pf)
 	if (!pf->vf)
 		return;
 
-	while (test_and_set_bit(__ICE_VF_DIS, pf->state))
+	while (test_and_set_bit(ICE_VF_DIS, pf->state))
 		usleep_range(1000, 2000);
 
 	/* Disable IOV before freeing resources. This lets any VF drivers
@@ -424,7 +424,7 @@ void ice_free_vfs(struct ice_pf *pf)
 			wr32(hw, GLGEN_VFLRSTAT(reg_idx), BIT(bit_idx));
 		}
 	}
-	clear_bit(__ICE_VF_DIS, pf->state);
+	clear_bit(ICE_VF_DIS, pf->state);
 	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
 }
 
@@ -1258,7 +1258,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		return false;
 
 	/* If VFs have been disabled, there is no need to reset */
-	if (test_and_set_bit(__ICE_VF_DIS, pf->state))
+	if (test_and_set_bit(ICE_VF_DIS, pf->state))
 		return false;
 
 	/* Begin reset on all VFs at once */
@@ -1314,7 +1314,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	}
 
 	ice_flush(hw);
-	clear_bit(__ICE_VF_DIS, pf->state);
+	clear_bit(ICE_VF_DIS, pf->state);
 
 	return true;
 }
@@ -1334,7 +1334,7 @@ static bool ice_is_vf_disabled(struct ice_vf *vf)
 	 * means something else is resetting the VF, so we shouldn't continue.
 	 * Otherwise, set disable VF state bit for actual reset, and continue.
 	 */
-	return (test_bit(__ICE_VF_DIS, pf->state) ||
+	return (test_bit(ICE_VF_DIS, pf->state) ||
 		test_bit(ICE_VF_STATE_DIS, vf->vf_states));
 }
 
@@ -1359,7 +1359,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	dev = ice_pf_to_dev(pf);
 
-	if (test_bit(__ICE_VF_RESETS_DISABLED, pf->state)) {
+	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
 		dev_dbg(dev, "Trying to reset VF %d, but all VF resets are disabled\n",
 			vf->vf_id);
 		return true;
@@ -1651,7 +1651,7 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 	/* Disable global interrupt 0 so we don't try to handle the VFLR. */
 	wr32(hw, GLINT_DYN_CTL(pf->oicr_idx),
 	     ICE_ITR_NONE << GLINT_DYN_CTL_ITR_INDX_S);
-	set_bit(__ICE_OICR_INTR_DIS, pf->state);
+	set_bit(ICE_OICR_INTR_DIS, pf->state);
 	ice_flush(hw);
 
 	ret = pci_enable_sriov(pf->pdev, num_vfs);
@@ -1679,7 +1679,7 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 		goto err_unroll_sriov;
 	}
 
-	clear_bit(__ICE_VF_DIS, pf->state);
+	clear_bit(ICE_VF_DIS, pf->state);
 	return 0;
 
 err_unroll_sriov:
@@ -1691,7 +1691,7 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 err_unroll_intr:
 	/* rearm interrupts here */
 	ice_irq_dynamic_ena(hw, NULL, NULL);
-	clear_bit(__ICE_OICR_INTR_DIS, pf->state);
+	clear_bit(ICE_OICR_INTR_DIS, pf->state);
 	return ret;
 }
 
@@ -1809,7 +1809,7 @@ void ice_process_vflr_event(struct ice_pf *pf)
 	unsigned int vf_id;
 	u32 reg;
 
-	if (!test_and_clear_bit(__ICE_VFLR_EVENT_PENDING, pf->state) ||
+	if (!test_and_clear_bit(ICE_VFLR_EVENT_PENDING, pf->state) ||
 	    !pf->num_alloc_vfs)
 		return;
 
@@ -4194,7 +4194,7 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf)
 	int i;
 
 	/* check that there are pending MDD events to print */
-	if (!test_and_clear_bit(__ICE_MDD_VF_PRINT_PENDING, pf->state))
+	if (!test_and_clear_bit(ICE_MDD_VF_PRINT_PENDING, pf->state))
 		return;
 
 	/* VF MDD event logs are rate limited to one second intervals */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 17ab8ef024ad..b881b650af98 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -159,7 +159,7 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	rx_ring = vsi->rx_rings[q_idx];
 	q_vector = rx_ring->q_vector;
 
-	while (test_and_set_bit(__ICE_CFG_BUSY, vsi->state)) {
+	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state)) {
 		timeout--;
 		if (!timeout)
 			return -EBUSY;
@@ -249,7 +249,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 	if (err)
 		goto free_buf;
 
-	clear_bit(__ICE_CFG_BUSY, vsi->state);
+	clear_bit(ICE_CFG_BUSY, vsi->state);
 	ice_qvec_toggle_napi(vsi, q_vector, true);
 	ice_qvec_ena_irq(vsi, q_vector);
 
@@ -758,7 +758,7 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_ring *ring;
 
-	if (test_bit(__ICE_DOWN, vsi->state))
+	if (test_bit(ICE_DOWN, vsi->state))
 		return -ENETDOWN;
 
 	if (!ice_is_xdp_ena_vsi(vsi))
-- 
2.26.2

