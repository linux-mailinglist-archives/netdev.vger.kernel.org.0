Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669DE160192
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgBPDo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:44:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:33370 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbgBPDo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916608"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:58 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: remove unnecessary fallthrough comments
Date:   Sat, 15 Feb 2020 19:44:48 -0800
Message-Id: <20200216034452.1251706-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Fallthrough comments are used to explicitly indicate the code is intended
to flow from one case statement to the next in a switch statement rather
than break out of the switch statement.  They are only needed when a case
has one or more statements to execute before falling through to the next
case, not when there is a list of cases for which the same statement(s)
should be executed.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c    | 1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 --
 drivers/net/ethernet/intel/ice/ice_lib.c     | 2 --
 drivers/net/ethernet/intel/ice/ice_main.c    | 2 --
 drivers/net/ethernet/intel/ice/ice_sriov.c   | 2 --
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 1 -
 6 files changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 1c41e7e6d548..75cc5a366b26 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -247,7 +247,6 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 	 */
 	switch (vsi->type) {
 	case ICE_VSI_LB:
-		/* fall through */
 	case ICE_VSI_PF:
 		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_PF;
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index c02af503764e..583e07fffd5f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1091,7 +1091,6 @@ ice_get_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
 		fecparam->active_fec = ETHTOOL_FEC_BASER;
 		break;
 	case ICE_AQ_LINK_25G_RS_528_FEC_EN:
-		/* fall through */
 	case ICE_AQ_LINK_25G_RS_544_FEC_EN:
 		fecparam->active_fec = ETHTOOL_FEC_RS;
 		break;
@@ -1781,7 +1780,6 @@ ice_get_settings_link_up(struct ethtool_link_ksettings *ks,
 						     Asym_Pause);
 		break;
 	case ICE_FC_PFC:
-		/* fall through */
 	default:
 		ethtool_link_ksettings_del_link_mode(ks, lp_advertising, Pause);
 		ethtool_link_ksettings_del_link_mode(ks, lp_advertising,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index fe7748518e41..ff72a6d1c978 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -121,7 +121,6 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 {
 	switch (vsi->type) {
 	case ICE_VSI_PF:
-		/* fall through */
 	case ICE_VSI_LB:
 		vsi->num_rx_desc = ICE_DFLT_NUM_RX_DESC;
 		vsi->num_tx_desc = ICE_DFLT_NUM_TX_DESC;
@@ -817,7 +816,6 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 	ctxt->info = vsi->info;
 	switch (vsi->type) {
 	case ICE_VSI_LB:
-		/* fall through */
 	case ICE_VSI_PF:
 		ctxt->flags = ICE_AQ_VSI_TYPE_PF;
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9bbe9d1fc9a8..ce5397d18219 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -706,7 +706,6 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	/* Get FEC mode based on negotiated link info */
 	switch (vsi->port_info->phy.link_info.fec_info) {
 	case ICE_AQ_LINK_25G_RS_528_FEC_EN:
-		/* fall through */
 	case ICE_AQ_LINK_25G_RS_544_FEC_EN:
 		fec = "RS-FEC";
 		break;
@@ -2955,7 +2954,6 @@ ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 		}
 		break;
 	case ICE_ERR_BUF_TOO_SHORT:
-		/* fall-through */
 	case ICE_ERR_CFG:
 		dev_err(dev, "The DDP package file is invalid. Entering Safe Mode.\n");
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index d2db0d04e117..554f567476f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -121,9 +121,7 @@ u32 ice_conv_link_speed_to_virtchnl(bool adv_link_support, u16 link_speed)
 			speed = (u32)VIRTCHNL_LINK_SPEED_25GB;
 			break;
 		case ICE_AQ_LINK_SPEED_40GB:
-			/* fall through */
 		case ICE_AQ_LINK_SPEED_50GB:
-			/* fall through */
 		case ICE_AQ_LINK_SPEED_100GB:
 			speed = (u32)VIRTCHNL_LINK_SPEED_40GB;
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 4de61dbedd36..0c08ab0462df 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1188,7 +1188,6 @@ ice_adjust_itr_by_size_and_speed(struct ice_port_info *port_info,
 				    avg_pkt_size + 640);
 		break;
 	case ICE_AQ_LINK_SPEED_10GB:
-		/* fall through */
 	default:
 		itr += DIV_ROUND_UP(170 * (avg_pkt_size + 24),
 				    avg_pkt_size + 640);
-- 
2.24.1

