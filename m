Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839DB211618
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgGAWe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:25457 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbgGAWeY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:24 -0400
IronPort-SDR: CI5/bO9Rs1D1nu3BnhV0nVTLn9SPSDm7oWYSxojhOIjGe4SPCy7QervRD1uVGXdbOrSRwekIcA
 Oi77SwNM8pyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178599"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178599"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: PFiih8dvwEFISPGN20JJavsAjCDC3CcSMLnaqC3pE3MGJXTJY165M+TYvUzm5yOXvf8Rd9dwMA
 W8DZ9cNDdKCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276100"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, anthony.nguyen@intel.com,
        Joe Perches <joe@perches.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 01/12] ethernet/intel: Convert fallthrough code comments
Date:   Wed,  1 Jul 2020 15:34:01 -0700
Message-Id: <20200701223412.2675606-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Convert all the remaining 'fall through' code comments to the newer
'fallthrough;' keyword.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c   |  4 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c |  3 +-
 .../net/ethernet/intel/e1000/e1000_param.c    |  2 +-
 drivers/net/ethernet/intel/e1000e/82571.c     |  4 +--
 drivers/net/ethernet/intel/e1000e/ethtool.c   | 11 ++++---
 drivers/net/ethernet/intel/e1000e/ich8lan.c   | 14 ++++-----
 drivers/net/ethernet/intel/e1000e/netdev.c    | 30 +++++++++----------
 drivers/net/ethernet/intel/e1000e/param.c     |  2 +-
 drivers/net/ethernet/intel/e1000e/phy.c       |  2 +-
 drivers/net/ethernet/intel/e1000e/ptp.c       |  3 +-
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |  4 +--
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  4 +--
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c  |  6 ++--
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c   |  8 ++---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  2 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  6 ++--
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  6 ++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  4 +--
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c  |  4 +--
 drivers/net/ethernet/intel/igb/e1000_nvm.c    |  2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c    |  4 +--
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  8 ++---
 drivers/net/ethernet/intel/igb/igb_main.c     | 26 ++++++++--------
 drivers/net/ethernet/intel/igb/igb_ptp.c      |  2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  4 +--
 drivers/net/ethernet/intel/igc/igc_ethtool.c  | 16 +++-------
 drivers/net/ethernet/intel/igc/igc_main.c     |  5 ++--
 .../net/ethernet/intel/ixgbe/ixgbe_82598.c    |  2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_82599.c    |  6 ++--
 .../net/ethernet/intel/ixgbe/ixgbe_common.c   |  4 +--
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 10 +++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 30 +++++++++----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |  4 +--
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 10 +++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  4 +--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 +++----
 drivers/net/ethernet/intel/ixgbevf/vf.c       |  6 ++--
 43 files changed, 135 insertions(+), 151 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 623e516a9630..4e7a0810eaeb 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -4526,7 +4526,7 @@ s32 e1000_setup_led(struct e1000_hw *hw)
 						     ~IGP01E1000_GMII_SPD));
 		if (ret_val)
 			return ret_val;
-		/* Fall Through */
+		fallthrough;
 	default:
 		if (hw->media_type == e1000_media_type_fiber) {
 			ledctl = er32(LEDCTL);
@@ -4571,7 +4571,7 @@ s32 e1000_cleanup_led(struct e1000_hw *hw)
 					      hw->phy_spd_default);
 		if (ret_val)
 			return ret_val;
-		/* Fall Through */
+		fallthrough;
 	default:
 		/* Restore LEDCTL settings */
 		ew32(LEDCTL, hw->ledctl_default);
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 266899c0c933..1e6ec081fd9d 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1138,7 +1138,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				EEPROM_INIT_CONTROL3_PORT_B, 1, &eeprom_data);
 			break;
 		}
-		/* Fall Through */
+		fallthrough;
 	default:
 		e1000_read_eeprom(hw,
 			EEPROM_INIT_CONTROL3_PORT_A, 1, &eeprom_data);
@@ -3154,7 +3154,6 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 				if ((unsigned long)(skb_tail_pointer(skb) - 1)
 				    & 4)
 					break;
-				/* fall through */
 				pull_size = min((unsigned int)4, skb->data_len);
 				if (!__pskb_pull_tail(skb, pull_size)) {
 					e_err(drv, "__pskb_pull_tail "
diff --git a/drivers/net/ethernet/intel/e1000/e1000_param.c b/drivers/net/ethernet/intel/e1000/e1000_param.c
index d3f29ffe1e47..4d4f5bf1e516 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_param.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_param.c
@@ -708,7 +708,7 @@ static void e1000_check_copper_options(struct e1000_adapter *adapter)
 		goto full_duplex_only;
 	case SPEED_1000 + HALF_DUPLEX:
 		e_dev_info("Half Duplex is not supported at 1000 Mbps\n");
-		/* fall through */
+		fallthrough;
 	case SPEED_1000 + FULL_DUPLEX:
 full_duplex_only:
 		e_dev_info("Using Autonegotiation at 1000 Mbps Full Duplex "
diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
index 2c1bab377b2a..88faf05e23ba 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -154,7 +154,7 @@ static s32 e1000_init_nvm_params_82571(struct e1000_hw *hw)
 			ew32(EECD, eecd);
 			break;
 		}
-		/* Fall Through */
+		fallthrough;
 	default:
 		nvm->type = e1000_nvm_eeprom_spi;
 		size = (u16)((eecd & E1000_EECD_SIZE_EX_MASK) >>
@@ -1107,7 +1107,7 @@ static s32 e1000_init_hw_82571(struct e1000_hw *hw)
 	switch (mac->type) {
 	case e1000_82573:
 		e1000e_enable_tx_pkt_filtering(hw);
-		/* fall through */
+		fallthrough;
 	case e1000_82574:
 	case e1000_82583:
 		reg_data = er32(GCR);
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 11de79e49661..64f684dc6c7a 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -893,7 +893,6 @@ static int e1000_reg_test(struct e1000_adapter *adapter, u64 *data)
 	case e1000_pch_lpt:
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
-		/* fall through */
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 		mask |= BIT(18);
@@ -1569,7 +1568,7 @@ static void e1000_loopback_cleanup(struct e1000_adapter *adapter)
 		/* set bit 29 (value of MULR requests is now 0) */
 		tarc0 &= 0xcfffffff;
 		ew32(TARC(0), tarc0);
-		/* fall through */
+		fallthrough;
 	case e1000_80003es2lan:
 		if (hw->phy.media_type == e1000_media_type_fiber ||
 		    hw->phy.media_type == e1000_media_type_internal_serdes) {
@@ -1577,7 +1576,7 @@ static void e1000_loopback_cleanup(struct e1000_adapter *adapter)
 			ew32(CTRL_EXT, adapter->tx_fifo_head);
 			adapter->tx_fifo_head = 0;
 		}
-		/* fall through */
+		fallthrough;
 	case e1000_82571:
 	case e1000_82572:
 		if (hw->phy.media_type == e1000_media_type_fiber ||
@@ -1587,7 +1586,7 @@ static void e1000_loopback_cleanup(struct e1000_adapter *adapter)
 			usleep_range(10000, 11000);
 			break;
 		}
-		/* Fall Through */
+		fallthrough;
 	default:
 		hw->mac.autoneg = 1;
 		if (hw->phy.type == e1000_phy_gg82563)
@@ -2122,7 +2121,7 @@ static int e1000_get_rxnfc(struct net_device *netdev,
 		case TCP_V4_FLOW:
 			if (mrqc & E1000_MRQC_RSS_FIELD_IPV4_TCP)
 				info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-			/* fall through */
+			fallthrough;
 		case UDP_V4_FLOW:
 		case SCTP_V4_FLOW:
 		case AH_ESP_V4_FLOW:
@@ -2133,7 +2132,7 @@ static int e1000_get_rxnfc(struct net_device *netdev,
 		case TCP_V6_FLOW:
 			if (mrqc & E1000_MRQC_RSS_FIELD_IPV6_TCP)
 				info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-			/* fall through */
+			fallthrough;
 		case UDP_V6_FLOW:
 		case SCTP_V6_FLOW:
 		case AH_ESP_V6_FLOW:
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index f999cca37a8a..ae0a6332fd30 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -338,12 +338,12 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 		 */
 		msleep(50);
 
-		/* fall-through */
+		fallthrough;
 	case e1000_pch2lan:
 		if (e1000_phy_is_accessible_pchlan(hw))
 			break;
 
-		/* fall-through */
+		fallthrough;
 	case e1000_pchlan:
 		if ((hw->mac.type == e1000_pchlan) &&
 		    (fwsm & E1000_ICH_FWSM_FW_VALID))
@@ -459,7 +459,7 @@ static s32 e1000_init_phy_params_pchlan(struct e1000_hw *hw)
 				return ret_val;
 			if ((phy->id != 0) && (phy->id != PHY_REVISION_MASK))
 				break;
-			/* fall-through */
+			fallthrough;
 		case e1000_pch2lan:
 		case e1000_pch_lpt:
 		case e1000_pch_spt:
@@ -704,7 +704,7 @@ static s32 e1000_init_mac_params_ich8lan(struct e1000_hw *hw)
 	case e1000_pch2lan:
 		mac->rar_entry_count = E1000_PCH2_RAR_ENTRIES;
 		mac->ops.rar_set = e1000_rar_set_pch2lan;
-		/* fall-through */
+		fallthrough;
 	case e1000_pch_lpt:
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
@@ -1559,7 +1559,7 @@ static s32 e1000_check_for_copper_link_ich8lan(struct e1000_hw *hw)
 		ret_val = e1000_k1_workaround_lv(hw);
 		if (ret_val)
 			return ret_val;
-		/* fall-thru */
+		fallthrough;
 	case e1000_pchlan:
 		if (hw->phy.type == e1000_phy_82578) {
 			ret_val = e1000_link_stall_workaround_hv(hw);
@@ -2096,7 +2096,7 @@ static s32 e1000_sw_lcd_config_ich8lan(struct e1000_hw *hw)
 			sw_cfg_mask = E1000_FEXTNVM_SW_CONFIG;
 			break;
 		}
-		/* Fall-thru */
+		fallthrough;
 	case e1000_pchlan:
 	case e1000_pch2lan:
 	case e1000_pch_lpt:
@@ -3189,7 +3189,7 @@ static s32 e1000_valid_nvm_bank_detect_ich8lan(struct e1000_hw *hw, u32 *bank)
 			return 0;
 		}
 		e_dbg("Unable to determine valid NVM bank via EEC - reading flash signature\n");
-		/* fall-thru */
+		fallthrough;
 	default:
 		/* set bank to 0 in case flash read fails */
 		*bank = 0;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 75937a48d517..63dde3bcf5bc 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -2107,7 +2107,7 @@ void e1000e_set_interrupt_capability(struct e1000_adapter *adapter)
 			e1000e_reset_interrupt_capability(adapter);
 		}
 		adapter->int_mode = E1000E_INT_MODE_MSI;
-		/* Fall through */
+		fallthrough;
 	case E1000E_INT_MODE_MSI:
 		if (!pci_enable_msi(adapter->pdev)) {
 			adapter->flags |= FLAG_MSI_ENABLED;
@@ -2115,7 +2115,7 @@ void e1000e_set_interrupt_capability(struct e1000_adapter *adapter)
 			adapter->int_mode = E1000E_INT_MODE_LEGACY;
 			e_err("Failed to initialize MSI interrupts.  Falling back to legacy interrupts.\n");
 		}
-		/* Fall through */
+		fallthrough;
 	case E1000E_INT_MODE_LEGACY:
 		/* Don't do anything; this is the system default */
 		break;
@@ -3173,10 +3173,10 @@ static void e1000_setup_rctl(struct e1000_adapter *adapter)
 		switch (adapter->rx_ps_pages) {
 		case 3:
 			psrctl |= PAGE_SIZE << E1000_PSRCTL_BSIZE3_SHIFT;
-			/* fall-through */
+			fallthrough;
 		case 2:
 			psrctl |= PAGE_SIZE << E1000_PSRCTL_BSIZE2_SHIFT;
-			/* fall-through */
+			fallthrough;
 		case 1:
 			psrctl |= PAGE_SIZE >> E1000_PSRCTL_BSIZE1_SHIFT;
 			break;
@@ -3673,9 +3673,8 @@ static int e1000e_config_hwtstamp(struct e1000_adapter *adapter,
 		is_l2 = true;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
-		/* Hardware cannot filter just V2 L4 Sync messages;
-		 * fall-through to V2 (both L2 and L4) Sync.
-		 */
+		/* Hardware cannot filter just V2 L4 Sync messages */
+		fallthrough;
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 		/* Also time stamps V2 Path Delay Request/Response. */
 		tsync_rx_ctl |= E1000_TSYNCRXCTL_TYPE_L2_L4_V2;
@@ -3684,9 +3683,8 @@ static int e1000e_config_hwtstamp(struct e1000_adapter *adapter,
 		is_l4 = true;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
-		/* Hardware cannot filter just V2 L4 Delay Request messages;
-		 * fall-through to V2 (both L2 and L4) Delay Request.
-		 */
+		/* Hardware cannot filter just V2 L4 Delay Request messages */
+		fallthrough;
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 		/* Also time stamps V2 Path Delay Request/Response. */
 		tsync_rx_ctl |= E1000_TSYNCRXCTL_TYPE_L2_L4_V2;
@@ -3696,9 +3694,8 @@ static int e1000e_config_hwtstamp(struct e1000_adapter *adapter,
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
-		/* Hardware cannot filter just V2 L4 or L2 Event messages;
-		 * fall-through to all V2 (both L2 and L4) Events.
-		 */
+		/* Hardware cannot filter just V2 L4 or L2 Event messages */
+		fallthrough;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 		tsync_rx_ctl |= E1000_TSYNCRXCTL_TYPE_EVENT_V2;
 		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
@@ -3710,6 +3707,7 @@ static int e1000e_config_hwtstamp(struct e1000_adapter *adapter,
 		 * Delay Request messages but not both so fall-through to
 		 * time stamp all packets.
 		 */
+		fallthrough;
 	case HWTSTAMP_FILTER_NTP_ALL:
 	case HWTSTAMP_FILTER_ALL:
 		is_l2 = true;
@@ -4056,7 +4054,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 			fc->low_water = fc->high_water - 8;
 			break;
 		}
-		/* fall-through */
+		fallthrough;
 	default:
 		hwm = min(((pba << 10) * 9 / 10),
 			  ((pba << 10) - adapter->max_frame_size));
@@ -4081,7 +4079,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 	case e1000_pch_lpt:
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
-		/* fall-through */
+		fallthrough;
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 		fc->refresh_time = 0xFFFF;
@@ -6764,7 +6762,7 @@ static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state, int locked)
 	case PCIE_LINK_STATE_L0S:
 	case PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1:
 		aspm_dis_mask |= PCI_EXP_LNKCTL_ASPM_L0S;
-		/* fall-through - can't have L1 without L0s */
+		fallthrough; /* can't have L1 without L0s */
 	case PCIE_LINK_STATE_L1:
 		aspm_dis_mask |= PCI_EXP_LNKCTL_ASPM_L1;
 		break;
diff --git a/drivers/net/ethernet/intel/e1000e/param.c b/drivers/net/ethernet/intel/e1000e/param.c
index 098369fd3e65..ebe121db4307 100644
--- a/drivers/net/ethernet/intel/e1000e/param.c
+++ b/drivers/net/ethernet/intel/e1000e/param.c
@@ -375,7 +375,7 @@ void e1000e_check_options(struct e1000_adapter *adapter)
 				 "%s Invalid mode - setting default\n",
 				 opt.name);
 			adapter->itr_setting = opt.def;
-			/* fall-through */
+			fallthrough;
 		case 3:
 			dev_info(&adapter->pdev->dev,
 				 "%s set to dynamic conservative mode\n",
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index 42233019255a..e11c877595fb 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -607,7 +607,7 @@ static s32 e1000_set_master_slave_mode(struct e1000_hw *hw)
 		break;
 	case e1000_ms_auto:
 		phy_data &= ~CTL1000_ENABLE_MASTER;
-		/* fall-through */
+		fallthrough;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 439fda2f5368..34b988d70488 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -295,7 +295,6 @@ void e1000e_ptp_init(struct e1000_adapter *adapter)
 	case e1000_pch_lpt:
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
-		/* fall-through */
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 		if ((hw->mac.type < e1000_pch_lpt) ||
@@ -303,7 +302,7 @@ void e1000e_ptp_init(struct e1000_adapter *adapter)
 			adapter->ptp_clock_info.max_adj = 24000000 - 1;
 			break;
 		}
-		/* fall-through */
+		fallthrough;
 	case e1000_82574:
 	case e1000_82583:
 		adapter->ptp_clock_info.max_adj = 600000000 - 1;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 30ea2b422678..908fefaa6b85 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -692,12 +692,12 @@ static int fm10k_get_rss_hash_opts(struct fm10k_intfc *interface,
 	case TCP_V4_FLOW:
 	case TCP_V6_FLOW:
 		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fall through */
+		fallthrough;
 	case UDP_V4_FLOW:
 		if (test_bit(FM10K_FLAG_RSS_FIELD_IPV4_UDP,
 			     interface->flags))
 			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fall through */
+		fallthrough;
 	case SCTP_V4_FLOW:
 	case SCTP_V6_FLOW:
 	case AH_ESP_V4_FLOW:
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 05e9bdb5f4aa..34f1f5350f68 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -856,7 +856,7 @@ static void fm10k_tx_csum(struct fm10k_ring *tx_ring,
 	case IPPROTO_GRE:
 		if (skb->encapsulation)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		if (unlikely(net_ratelimit())) {
 			dev_warn(tx_ring->dev,
@@ -1554,7 +1554,7 @@ static bool fm10k_set_rss_queues(struct fm10k_intfc *interface)
  * important, starting with the "most" number of features turned on at once,
  * and ending with the smallest set of features.  This way large combinations
  * can be allocated if they're turned on, and smaller combinations are the
- * fallthrough conditions.
+ * fall through conditions.
  *
  **/
 static void fm10k_set_num_queues(struct fm10k_intfc *interface)
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
index 75e51f91036c..8e2e92bf3cd4 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
@@ -967,7 +967,7 @@ static s32 fm10k_mbx_validate_msg_hdr(struct fm10k_mbx_info *mbx)
 		if (tail != mbx->head)
 			return FM10K_MBX_ERR_TAIL;
 
-		/* fall through */
+		fallthrough;
 	case FM10K_MSG_DATA:
 		/* validate that head is moving correctly */
 		if (!head || (head == FM10K_MSG_HDR_MASK(HEAD)))
@@ -987,7 +987,7 @@ static s32 fm10k_mbx_validate_msg_hdr(struct fm10k_mbx_info *mbx)
 		if ((size < FM10K_VFMBX_MSG_MTU) || (size & (size + 1)))
 			return FM10K_MBX_ERR_SIZE;
 
-		/* fall through */
+		fallthrough;
 	case FM10K_MSG_ERROR:
 		if (!head || (head == FM10K_MSG_HDR_MASK(HEAD)))
 			return FM10K_MBX_ERR_HEAD;
@@ -1570,7 +1570,7 @@ s32 fm10k_pfvf_mbx_init(struct fm10k_hw *hw, struct fm10k_mbx_info *mbx,
 			mbx->mbmem_reg = FM10K_MBMEM_VF(id, 0);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		return FM10K_MBX_ERR_NO_MBX;
 	}
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 0637ccadee79..1450a9f98c5a 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -853,7 +853,7 @@ void fm10k_clear_macvlan_queue(struct fm10k_intfc *interface,
 			/* Don't free requests for other interfaces */
 			if (r->mac.glort != glort)
 				break;
-			/* fall through */
+			fallthrough;
 		case FM10K_VLAN_REQUEST:
 			if (vlans) {
 				list_del(&r->list);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
index be07bfdb0bb4..c0780c3624c8 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -1317,19 +1317,19 @@ static u8 fm10k_iov_supported_xcast_mode_pf(struct fm10k_vf_info *vf_info,
 	case FM10K_XCAST_MODE_PROMISC:
 		if (vf_flags & FM10K_VF_FLAG_PROMISC_CAPABLE)
 			return FM10K_XCAST_MODE_PROMISC;
-		/* fall through */
+		fallthrough;
 	case FM10K_XCAST_MODE_ALLMULTI:
 		if (vf_flags & FM10K_VF_FLAG_ALLMULTI_CAPABLE)
 			return FM10K_XCAST_MODE_ALLMULTI;
-		/* fall through */
+		fallthrough;
 	case FM10K_XCAST_MODE_MULTI:
 		if (vf_flags & FM10K_VF_FLAG_MULTI_CAPABLE)
 			return FM10K_XCAST_MODE_MULTI;
-		/* fall through */
+		fallthrough;
 	case FM10K_XCAST_MODE_NONE:
 		if (vf_flags & FM10K_VF_FLAG_NONE_CAPABLE)
 			return FM10K_XCAST_MODE_NONE;
-		/* fall through */
+		fallthrough;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 6a089848c857..c897a2863e4f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -541,7 +541,7 @@ static void i40e_set_hw_flags(struct i40e_hw *hw)
 		    (aq->api_maj_ver == 1 &&
 		     aq->api_min_ver >= I40E_MINOR_VER_GET_LINK_INFO_X722))
 			hw->flags |= I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE;
-		/* fall through */
+		fallthrough;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index cbba22a2e449..d09c12795c65 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4102,7 +4102,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 	switch (fsp->flow_type & ~FLOW_EXT) {
 	case SCTP_V4_FLOW:
 		new_mask &= ~I40E_VERIFY_TAG_MASK;
-		/* Fall through */
+		fallthrough;
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
 		tcp_ip4_spec = &fsp->m_u.tcp_ip4_spec;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b749b0e1a7d5..37e3bc072b0e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1817,7 +1817,7 @@ static void i40e_vsi_setup_queue_map(struct i40e_vsi *vsi,
 						       num_tc_qps);
 					break;
 				}
-				/* fall through */
+				fallthrough;
 			case I40E_VSI_FDIR:
 			case I40E_VSI_SRIOV:
 			case I40E_VSI_VMDQ2:
@@ -13686,8 +13686,7 @@ struct i40e_vsi *i40e_vsi_setup(struct i40e_pf *pf, u8 type,
 		/* Setup DCB netlink interface */
 		i40e_dcbnl_setup(vsi);
 #endif /* CONFIG_I40E_DCB */
-		/* fall through */
-
+		fallthrough;
 	case I40E_VSI_FDIR:
 		/* set up vectors and rings if needed */
 		ret = i40e_vsi_setup_vectors(vsi);
@@ -13703,7 +13702,6 @@ struct i40e_vsi *i40e_vsi_setup(struct i40e_pf *pf, u8 type,
 
 		i40e_vsi_reset_stats(vsi);
 		break;
-
 	default:
 		/* no netdev or rings for the other VSI types */
 		break;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 9bf1ad4319f5..ff7b19c6bc73 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -586,7 +586,7 @@ static int i40e_ptp_set_timestamp_mode(struct i40e_pf *pf,
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
 		if (!(pf->hw_features & I40E_HW_PTP_L4_CAPABLE))
 			return -ERANGE;
-		/* fall through */
+		fallthrough;
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f9555c847f73..7e22a4ef582b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1690,7 +1690,7 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 	case I40E_RX_PTYPE_INNER_PROT_UDP:
 	case I40E_RX_PTYPE_INNER_PROT_SCTP:
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		/* fall though */
+		fallthrough;
 	default:
 		break;
 	}
@@ -2210,10 +2210,10 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fall through */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		/* fall through -- handle aborts by dropping packet */
+		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
 		result = I40E_XDP_CONSUMED;
 		break;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 7276580cbe64..8e489ed54138 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -168,10 +168,10 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fall through */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		/* fallthrough -- handle aborts by dropping packet */
+		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
 		result = I40E_XDP_CONSUMED;
 		break;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index e091bab7e770..ca041b39ffda 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1007,7 +1007,7 @@ static inline void iavf_rx_checksum(struct iavf_vsi *vsi,
 	case IAVF_RX_PTYPE_INNER_PROT_UDP:
 	case IAVF_RX_PTYPE_INNER_PROT_SCTP:
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		/* fall though */
+		fallthrough;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 438b42ce2cd9..a32391e82762 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -638,7 +638,7 @@ static s32 igb_get_invariants_82575(struct e1000_hw *hw)
 			dev_spec->sgmii_active = true;
 			break;
 		}
-		/* fall through - for I2C based SGMII */
+		fallthrough; /* for I2C based SGMII */
 	case E1000_CTRL_EXT_LINK_MODE_PCIE_SERDES:
 		/* read media type from SFP EEPROM */
 		ret_val = igb_set_sfp_media_type_82575(hw);
@@ -1704,7 +1704,7 @@ static s32 igb_setup_serdes_link_82575(struct e1000_hw *hw)
 	case E1000_CTRL_EXT_LINK_MODE_1000BASE_KX:
 		/* disable PCS autoneg and support parallel detect only */
 		pcs_autoneg = false;
-		/* fall through */
+		fallthrough;
 	default:
 		if (hw->mac.type == e1000_82575 ||
 		    hw->mac.type == e1000_82576) {
diff --git a/drivers/net/ethernet/intel/igb/e1000_nvm.c b/drivers/net/ethernet/intel/igb/e1000_nvm.c
index 09f4dcb09632..fa136e6e9328 100644
--- a/drivers/net/ethernet/intel/igb/e1000_nvm.c
+++ b/drivers/net/ethernet/intel/igb/e1000_nvm.c
@@ -721,7 +721,7 @@ void igb_get_fw_version(struct e1000_hw *hw, struct e1000_fw_version *fw_vers)
 			igb_read_invm_version(hw, fw_vers);
 			return;
 		}
-		/* fall through */
+		fallthrough;
 	case e1000_i350:
 		/* find combo image version */
 		hw->nvm.ops.read(hw, NVM_COMB_VER_PTR, 1, &comb_offset);
diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index ad2125e5a7f7..8c8eb82e6272 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -659,7 +659,7 @@ s32 igb_copper_link_setup_m88_gen2(struct e1000_hw *hw)
 			phy_data |= M88E1000_PSCR_AUTO_X_1000T;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case 0:
 	default:
 		phy_data |= M88E1000_PSCR_AUTO_X_MODE;
@@ -2621,7 +2621,7 @@ static s32 igb_set_master_slave_mode(struct e1000_hw *hw)
 		break;
 	case e1000_ms_auto:
 		phy_data &= ~CR_1000T_MS_ENABLE;
-		/* fall-through */
+		fallthrough;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index da60e8d2128f..c2cf414d126b 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2517,11 +2517,11 @@ static int igb_get_rss_hash_opts(struct igb_adapter *adapter,
 	switch (cmd->flow_type) {
 	case TCP_V4_FLOW:
 		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case UDP_V4_FLOW:
 		if (adapter->flags & IGB_FLAG_RSS_FIELD_IPV4_UDP)
 			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case SCTP_V4_FLOW:
 	case AH_ESP_V4_FLOW:
 	case AH_V4_FLOW:
@@ -2531,11 +2531,11 @@ static int igb_get_rss_hash_opts(struct igb_adapter *adapter,
 		break;
 	case TCP_V6_FLOW:
 		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case UDP_V6_FLOW:
 		if (adapter->flags & IGB_FLAG_RSS_FIELD_IPV6_UDP)
 			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case SCTP_V6_FLOW:
 	case AH_ESP_V6_FLOW:
 	case AH_V6_FLOW:
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ce611cb02c0a..ae8d64324619 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -711,14 +711,14 @@ static void igb_cache_ring_register(struct igb_adapter *adapter)
 				adapter->rx_ring[i]->reg_idx = rbase_offset +
 							       Q_IDX_82576(i);
 		}
-		/* Fall through */
+		fallthrough;
 	case e1000_82575:
 	case e1000_82580:
 	case e1000_i350:
 	case e1000_i354:
 	case e1000_i210:
 	case e1000_i211:
-		/* Fall through */
+		fallthrough;
 	default:
 		for (; i < adapter->num_rx_queues; i++)
 			adapter->rx_ring[i]->reg_idx = rbase_offset + i;
@@ -2873,7 +2873,7 @@ void igb_set_fw_version(struct igb_adapter *adapter)
 				 fw.invm_img_type);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		/* if option is rom valid, display its version too */
 		if (fw.or_valid) {
@@ -3724,13 +3724,13 @@ unsigned int igb_get_max_rss_queues(struct igb_adapter *adapter)
 			max_rss_queues = 1;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case e1000_82576:
 		if (!!adapter->vfs_allocated_count) {
 			max_rss_queues = 2;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case e1000_82580:
 	case e1000_i354:
 	default:
@@ -4869,14 +4869,14 @@ static int igb_vlan_promisc_enable(struct igb_adapter *adapter)
 		/* VLAN filtering needed for VLAN prio filter */
 		if (adapter->netdev->features & NETIF_F_NTUPLE)
 			break;
-		/* fall through */
+		fallthrough;
 	case e1000_82576:
 	case e1000_82580:
 	case e1000_i354:
 		/* VLAN filtering needed for pool filtering */
 		if (adapter->vfs_allocated_count)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return 1;
 	}
@@ -5156,7 +5156,7 @@ bool igb_has_link(struct igb_adapter *adapter)
 	case e1000_media_type_copper:
 		if (!hw->mac.get_link_status)
 			return true;
-		/* fall through */
+		fallthrough;
 	case e1000_media_type_internal_serdes:
 		hw->mac.ops.check_for_link(hw);
 		link_active = !hw->mac.get_link_status;
@@ -5816,7 +5816,7 @@ static void igb_tx_csum(struct igb_ring *tx_ring, struct igb_tx_buffer *first)
 	switch (skb->csum_offset) {
 	case offsetof(struct tcphdr, check):
 		type_tucmd = E1000_ADVTXD_TUCMD_L4T_TCP;
-		/* fall through */
+		fallthrough;
 	case offsetof(struct udphdr, check):
 		break;
 	case offsetof(struct sctphdr, checksum):
@@ -5828,7 +5828,7 @@ static void igb_tx_csum(struct igb_ring *tx_ring, struct igb_tx_buffer *first)
 			type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		skb_checksum_help(skb);
 		goto csum_failed;
@@ -6706,7 +6706,7 @@ static int __igb_notify_dca(struct device *dev, void *data)
 			igb_setup_dca(adapter);
 			break;
 		}
-		/* Fall Through - since DCA is disabled. */
+		fallthrough; /* since DCA is disabled. */
 	case DCA_PROVIDER_REMOVE:
 		if (adapter->flags & IGB_FLAG_DCA_ENABLED) {
 			/* without this a class_device is left
@@ -9375,13 +9375,13 @@ static void igb_vmm_control(struct igb_adapter *adapter)
 		reg = rd32(E1000_DTXCTL);
 		reg |= E1000_DTXCTL_VLAN_ADDED;
 		wr32(E1000_DTXCTL, reg);
-		/* Fall through */
+		fallthrough;
 	case e1000_82580:
 		/* enable replication vlan tag stripping */
 		reg = rd32(E1000_RPLOLR);
 		reg |= E1000_RPLOLR_STRVLAN;
 		wr32(E1000_RPLOLR, reg);
-		/* Fall through */
+		fallthrough;
 	case e1000_i350:
 		/* none of the above registers are supported by i350 */
 		break;
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index c39e921757ba..490368d3d03c 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -1053,7 +1053,7 @@ static int igb_ptp_set_timestamp_mode(struct igb_adapter *adapter,
 			config->rx_filter = HWTSTAMP_FILTER_ALL;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		config->rx_filter = HWTSTAMP_FILTER_NONE;
 		return -ERANGE;
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 07740654df5c..97a065928976 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2091,7 +2091,7 @@ static bool igbvf_tx_csum(struct igbvf_ring *tx_ring, struct sk_buff *skb,
 	switch (skb->csum_offset) {
 	case offsetof(struct tcphdr, check):
 		type_tucmd = E1000_ADVTXD_TUCMD_L4T_TCP;
-		/* fall through */
+		fallthrough;
 	case offsetof(struct udphdr, check):
 		break;
 	case offsetof(struct sctphdr, checksum):
@@ -2103,7 +2103,7 @@ static bool igbvf_tx_csum(struct igbvf_ring *tx_ring, struct sk_buff *skb,
 			type_tucmd = E1000_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		skb_checksum_help(skb);
 		goto csum_failed;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index ac331116ea08..44410c2265d6 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1015,37 +1015,29 @@ static int igc_ethtool_get_rss_hash_opts(struct igc_adapter *adapter,
 	switch (cmd->flow_type) {
 	case TCP_V4_FLOW:
 		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case UDP_V4_FLOW:
 		if (adapter->flags & IGC_FLAG_RSS_FIELD_IPV4_UDP)
 			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case SCTP_V4_FLOW:
-		/* Fall through */
 	case AH_ESP_V4_FLOW:
-		/* Fall through */
 	case AH_V4_FLOW:
-		/* Fall through */
 	case ESP_V4_FLOW:
-		/* Fall through */
 	case IPV4_FLOW:
 		cmd->data |= RXH_IP_SRC | RXH_IP_DST;
 		break;
 	case TCP_V6_FLOW:
 		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case UDP_V6_FLOW:
 		if (adapter->flags & IGC_FLAG_RSS_FIELD_IPV6_UDP)
 			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* Fall through */
+		fallthrough;
 	case SCTP_V6_FLOW:
-		/* Fall through */
 	case AH_ESP_V6_FLOW:
-		/* Fall through */
 	case AH_V6_FLOW:
-		/* Fall through */
 	case ESP_V6_FLOW:
-		/* Fall through */
 	case IPV6_FLOW:
 		cmd->data |= RXH_IP_SRC | RXH_IP_DST;
 		break;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e544f0599dcf..8d5869dcf798 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -969,7 +969,7 @@ static void igc_tx_csum(struct igc_ring *tx_ring, struct igc_tx_buffer *first)
 	switch (skb->csum_offset) {
 	case offsetof(struct tcphdr, check):
 		type_tucmd = IGC_ADVTXD_TUCMD_L4T_TCP;
-		/* fall through */
+		fallthrough;
 	case offsetof(struct udphdr, check):
 		break;
 	case offsetof(struct sctphdr, checksum):
@@ -981,7 +981,7 @@ static void igc_tx_csum(struct igc_ring *tx_ring, struct igc_tx_buffer *first)
 			type_tucmd = IGC_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		skb_checksum_help(skb);
 		goto csum_failed;
@@ -3269,7 +3269,6 @@ static void igc_cache_ring_register(struct igc_adapter *adapter)
 
 	switch (adapter->hw.mac.type) {
 	case igc_i225:
-	/* Fall through */
 	default:
 		for (; i < adapter->num_rx_queues; i++)
 			adapter->rx_ring[i]->reg_idx = i;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
index eee277c1bedf..95c92fe890a1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c
@@ -1098,7 +1098,7 @@ static void ixgbe_set_rxpba_82598(struct ixgbe_hw *hw, int num_pb,
 			IXGBE_WRITE_REG(hw, IXGBE_RXPBSIZE(i), rxpktsize);
 		/* Setup the last four at 48KB...don't re-init i */
 		rxpktsize = IXGBE_RXPBSIZE_48KB;
-		/* Fall Through */
+		fallthrough;
 	case PBA_STRATEGY_EQUAL:
 	default:
 		/* Divide the remaining Rx packet buffer evenly among the TCs */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
index 109f8de5a1c2..8d3798a32f0e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -1568,7 +1568,7 @@ s32 ixgbe_fdir_set_input_mask_82599(struct ixgbe_hw *hw,
 	case 0x0000:
 		/* mask VLAN ID */
 		fdirm |= IXGBE_FDIRM_VLANID;
-		/* fall through */
+		fallthrough;
 	case 0x0FFF:
 		/* mask VLAN priority */
 		fdirm |= IXGBE_FDIRM_VLANP;
@@ -1576,7 +1576,7 @@ s32 ixgbe_fdir_set_input_mask_82599(struct ixgbe_hw *hw,
 	case 0xE000:
 		/* mask VLAN ID only */
 		fdirm |= IXGBE_FDIRM_VLANID;
-		/* fall through */
+		fallthrough;
 	case 0xEFFF:
 		/* no VLAN fields masked */
 		break;
@@ -1589,7 +1589,7 @@ s32 ixgbe_fdir_set_input_mask_82599(struct ixgbe_hw *hw,
 	case 0x0000:
 		/* Mask Flex Bytes */
 		fdirm |= IXGBE_FDIRM_FLEX;
-		/* fall through */
+		fallthrough;
 	case 0xFFFF:
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 17357a12cbdc..62ddb452f862 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -145,7 +145,7 @@ s32 ixgbe_setup_fc_generic(struct ixgbe_hw *hw)
 		if (ret_val)
 			return ret_val;
 
-		/* fall through - only backplane uses autoc */
+		fallthrough; /* only backplane uses autoc */
 	case ixgbe_media_type_fiber:
 		reg = IXGBE_READ_REG(hw, IXGBE_PCS1GANA);
 
@@ -3533,7 +3533,7 @@ void ixgbe_set_rxpba_generic(struct ixgbe_hw *hw,
 		rxpktsize <<= IXGBE_RXPBSIZE_SHIFT;
 		for (; i < (num_pb / 2); i++)
 			IXGBE_WRITE_REG(hw, IXGBE_RXPBSIZE(i), rxpktsize);
-		/* fall through - configure remaining packet buffers */
+		fallthrough; /* configure remaining packet buffers */
 	case (PBA_STRATEGY_EQUAL):
 		/* Divide the remaining Rx packet buffer evenly among the TCs */
 		rxpktsize = (pbsize / (num_pb - i)) << IXGBE_RXPBSIZE_SHIFT;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 5da367cb5c93..8ae2c8c2f6a1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2507,11 +2507,11 @@ static int ixgbe_get_rss_hash_opts(struct ixgbe_adapter *adapter,
 	switch (cmd->flow_type) {
 	case TCP_V4_FLOW:
 		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fallthrough */
+		fallthrough;
 	case UDP_V4_FLOW:
 		if (adapter->flags2 & IXGBE_FLAG2_RSS_FIELD_IPV4_UDP)
 			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fallthrough */
+		fallthrough;
 	case SCTP_V4_FLOW:
 	case AH_ESP_V4_FLOW:
 	case AH_V4_FLOW:
@@ -2521,11 +2521,11 @@ static int ixgbe_get_rss_hash_opts(struct ixgbe_adapter *adapter,
 		break;
 	case TCP_V6_FLOW:
 		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fallthrough */
+		fallthrough;
 	case UDP_V6_FLOW:
 		if (adapter->flags2 & IXGBE_FLAG2_RSS_FIELD_IPV6_UDP)
 			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
-		/* fallthrough */
+		fallthrough;
 	case SCTP_V6_FLOW:
 	case AH_ESP_V6_FLOW:
 	case AH_V6_FLOW:
@@ -2657,7 +2657,7 @@ static int ixgbe_flowspec_to_flow_type(struct ethtool_rx_flow_spec *fsp,
 				*flow_type = IXGBE_ATR_FLOW_TYPE_IPV4;
 				break;
 			}
-			/* fall through */
+			fallthrough;
 		default:
 			return 0;
 		}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 6c5703cdf062..e67b1a59ecb7 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -444,7 +444,7 @@ int ixgbe_fcoe_ddp(struct ixgbe_adapter *adapter,
 		ddp->err = (__force u32)ddp_err;
 		ddp->sgl = NULL;
 		ddp->sgc = 0;
-		/* fall through */
+		fallthrough;
 	/* if DDP length is present pass it through to ULD */
 	case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_NODDP):
 		/* update length of DDPed data */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index fabdca9aadae..4601118f88c9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1395,7 +1395,7 @@ static int __ixgbe_notify_dca(struct device *dev, void *data)
 					IXGBE_DCA_CTRL_DCA_MODE_CB2);
 			break;
 		}
-		/* fall through - DCA is disabled. */
+		fallthrough; /* DCA is disabled. */
 	case DCA_PROVIDER_REMOVE:
 		if (adapter->flags & IXGBE_FLAG_DCA_ENABLED) {
 			dca_remove_requester(dev);
@@ -2229,10 +2229,10 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fallthrough */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		/* fallthrough -- handle aborts by dropping packet */
+		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
 		result = IXGBE_XDP_CONSUMED;
 		break;
@@ -3007,7 +3007,7 @@ static inline void ixgbe_irq_enable(struct ixgbe_adapter *adapter, bool queues,
 	case ixgbe_mac_82599EB:
 		mask |= IXGBE_EIMS_GPI_SDP1(hw);
 		mask |= IXGBE_EIMS_GPI_SDP2(hw);
-		/* fall through */
+		fallthrough;
 	case ixgbe_mac_X540:
 	case ixgbe_mac_X550:
 	case ixgbe_mac_X550EM_x:
@@ -3313,7 +3313,7 @@ static irqreturn_t ixgbe_intr(int irq, void *data)
 	switch (hw->mac.type) {
 	case ixgbe_mac_82599EB:
 		ixgbe_check_sfp_event(adapter, eicr);
-		/* Fall through */
+		fallthrough;
 	case ixgbe_mac_X540:
 	case ixgbe_mac_X550:
 	case ixgbe_mac_X550EM_x:
@@ -4335,7 +4335,7 @@ static void ixgbe_setup_rdrxctl(struct ixgbe_adapter *adapter)
 	case ixgbe_mac_x550em_a:
 		if (adapter->num_vfs)
 			rdrxctl |= IXGBE_RDRXCTL_PSP;
-		/* fall through */
+		fallthrough;
 	case ixgbe_mac_82599EB:
 	case ixgbe_mac_X540:
 		/* Disable RSC for ACK packets */
@@ -5885,7 +5885,7 @@ void ixgbe_disable_tx(struct ixgbe_adapter *adapter)
 		IXGBE_WRITE_REG(hw, IXGBE_DMATXCTL,
 				(IXGBE_READ_REG(hw, IXGBE_DMATXCTL) &
 				 ~IXGBE_DMATXCTL_TE));
-		/* fall through */
+		fallthrough;
 	default:
 		break;
 	}
@@ -6337,7 +6337,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 		default:
 			break;
 		}
-	/* fall through */
+		fallthrough;
 	case ixgbe_mac_X550EM_x:
 #ifdef CONFIG_IXGBE_DCB
 		adapter->flags &= ~IXGBE_FLAG_DCB_CAPABLE;
@@ -6348,7 +6348,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 		adapter->fcoe.up = 0;
 #endif /* IXGBE_DCB */
 #endif /* IXGBE_FCOE */
-	/* Fall Through */
+		fallthrough;
 	case ixgbe_mac_X550:
 		if (hw->mac.type == ixgbe_mac_X550)
 			adapter->flags2 |= IXGBE_FLAG2_TEMP_SENSOR_CAPABLE;
@@ -7168,7 +7168,7 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
 		hwstats->o2bspc += IXGBE_READ_REG(hw, IXGBE_O2BSPC);
 		hwstats->b2ospc += IXGBE_READ_REG(hw, IXGBE_B2OSPC);
 		hwstats->b2ogprc += IXGBE_READ_REG(hw, IXGBE_B2OGPRC);
-		/* fall through */
+		fallthrough;
 	case ixgbe_mac_82599EB:
 		for (i = 0; i < 16; i++)
 			adapter->hw_rx_no_dma_resources +=
@@ -8077,7 +8077,7 @@ static void ixgbe_tx_csum(struct ixgbe_ring *tx_ring,
 	switch (skb->csum_offset) {
 	case offsetof(struct tcphdr, check):
 		type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_TCP;
-		/* fall through */
+		fallthrough;
 	case offsetof(struct udphdr, check):
 		break;
 	case offsetof(struct sctphdr, checksum):
@@ -8089,7 +8089,7 @@ static void ixgbe_tx_csum(struct ixgbe_ring *tx_ring,
 			type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		skb_checksum_help(skb);
 		goto csum_failed;
@@ -8532,7 +8532,7 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
 
 		if (!sb_dev && (adapter->flags & IXGBE_FLAG_FCOE_ENABLED))
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return netdev_pick_tx(dev, skb, sb_dev);
 	}
@@ -8866,7 +8866,7 @@ static int ixgbe_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
 	case SIOCGMIIPHY:
 		if (!adapter->hw.phy.ops.read_reg)
 			return -EOPNOTSUPP;
-		/* fall through */
+		fallthrough;
 	default:
 		return mdio_mii_ioctl(&adapter->hw.phy.mdio, if_mii(req), cmd);
 	}
@@ -10656,7 +10656,7 @@ bool ixgbe_wol_supported(struct ixgbe_adapter *adapter, u16 device_id,
 			/* only support first port */
 			if (hw->bus.func != 0)
 				break;
-			/* fall through */
+			fallthrough;
 		case IXGBE_SUBDEV_ID_82599_SP_560FLR:
 		case IXGBE_SUBDEV_ID_82599_SFP:
 		case IXGBE_SUBDEV_ID_82599_RNDC:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 0be13a90ff79..22a874eee2e8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -1051,7 +1051,7 @@ static int ixgbe_ptp_set_timestamp_mode(struct ixgbe_adapter *adapter,
 			adapter->flags |= IXGBE_FLAG_RX_HWTSTAMP_ENABLED;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		/*
 		 * register RXMTRL must be set in order to do V1 packets,
@@ -1242,7 +1242,7 @@ void ixgbe_ptp_start_cyclecounter(struct ixgbe_adapter *adapter)
 			cc.mult = 3;
 			cc.shift = 2;
 		}
-		/* fallthrough */
+		fallthrough;
 	case ixgbe_mac_x550em_a:
 	case ixgbe_mac_X550:
 		cc.read = ixgbe_ptp_read_X550;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index d05a5690e66b..23a92656821d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -503,7 +503,7 @@ static s32 ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 			 */
 			if (pf_max_frame > ETH_FRAME_LEN)
 				break;
-			/* fall through */
+			fallthrough;
 		default:
 			/* If the PF or VF are running w/ jumbo frames enabled
 			 * we need to shut down the VF Rx path as we cannot
@@ -1141,7 +1141,7 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 		/* promisc introduced in 1.3 version */
 		if (xcast_mode == IXGBEVF_XCAST_MODE_PROMISC)
 			return -EOPNOTSUPP;
-		/* Fall through */
+		fallthrough;
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 9c42f741ed5e..5e339afa682a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -306,7 +306,7 @@ static s32 ixgbe_identify_phy_x550em(struct ixgbe_hw *hw)
 		hw->phy.phy_semaphore_mask = IXGBE_GSSR_SHARED_I2C_SM;
 		ixgbe_setup_mux_ctl(hw);
 		ixgbe_check_cs4227(hw);
-		/* Fallthrough */
+		fallthrough;
 	case IXGBE_DEV_ID_X550EM_A_SFP_N:
 		return ixgbe_identify_module_generic(hw);
 	case IXGBE_DEV_ID_X550EM_X_KX4:
@@ -325,7 +325,7 @@ static s32 ixgbe_identify_phy_x550em(struct ixgbe_hw *hw)
 			hw->phy.phy_semaphore_mask = IXGBE_GSSR_PHY1_SM;
 		else
 			hw->phy.phy_semaphore_mask = IXGBE_GSSR_PHY0_SM;
-		/* Fallthrough */
+		fallthrough;
 	case IXGBE_DEV_ID_X550EM_X_10G_T:
 		return ixgbe_identify_phy_generic(hw);
 	case IXGBE_DEV_ID_X550EM_X_1G_T:
@@ -2303,7 +2303,7 @@ static s32 ixgbe_get_link_capabilities_X550em(struct ixgbe_hw *hw,
 					break;
 				}
 			}
-			/* fall through */
+			fallthrough;
 		default:
 			*speed = IXGBE_LINK_SPEED_10GB_FULL |
 				 IXGBE_LINK_SPEED_1GB_FULL;
@@ -2885,7 +2885,7 @@ static s32 ixgbe_setup_fc_x550em(struct ixgbe_hw *hw)
 		 * through to the fc_full statement.  Later, we will
 		 * disable the adapter's ability to send PAUSE frames.
 		 */
-		/* Fallthrough */
+		fallthrough;
 	case ixgbe_fc_full:
 		pause = true;
 		asm_dir = true;
@@ -3284,7 +3284,7 @@ static enum ixgbe_media_type ixgbe_get_media_type_X550em(struct ixgbe_hw *hw)
 	case IXGBE_DEV_ID_X550EM_A_SGMII:
 	case IXGBE_DEV_ID_X550EM_A_SGMII_L:
 		hw->phy.type = ixgbe_phy_sgmii;
-		/* Fallthrough */
+		fallthrough;
 	case IXGBE_DEV_ID_X550EM_X_KR:
 	case IXGBE_DEV_ID_X550EM_X_KX4:
 	case IXGBE_DEV_ID_X550EM_X_XFI:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index be9d2a8da515..ec7121f352e2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -120,10 +120,10 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fallthrough */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		/* fallthrough -- handle aborts by dropping packet */
+		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
 		result = IXGBE_XDP_CONSUMED;
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 635cbc25e2f2..6e9a397db583 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1079,10 +1079,10 @@ static struct sk_buff *ixgbevf_run_xdp(struct ixgbevf_adapter *adapter,
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fallthrough */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		/* fallthrough -- handle aborts by dropping packet */
+		fallthrough; /* handle aborts by dropping packet */
 	case XDP_DROP:
 		result = IXGBEVF_XDP_CONSUMED;
 		break;
@@ -2602,7 +2602,7 @@ static int ixgbevf_acquire_msix_vectors(struct ixgbevf_adapter *adapter,
  * important, starting with the "most" number of features turned on at once,
  * and ending with the smallest set of features.  This way large combinations
  * can be allocated if they're turned on, and smaller combinations are the
- * fallthrough conditions.
+ * fall through conditions.
  *
  **/
 static void ixgbevf_set_num_queues(struct ixgbevf_adapter *adapter)
@@ -3874,7 +3874,7 @@ static void ixgbevf_tx_csum(struct ixgbevf_ring *tx_ring,
 	switch (skb->csum_offset) {
 	case offsetof(struct tcphdr, check):
 		type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_TCP;
-		/* fall through */
+		fallthrough;
 	case offsetof(struct udphdr, check):
 		break;
 	case offsetof(struct sctphdr, checksum):
@@ -3886,7 +3886,7 @@ static void ixgbevf_tx_csum(struct ixgbevf_ring *tx_ring,
 			type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_SCTP;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		skb_checksum_help(skb);
 		goto no_csum;
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index d5ce49636548..bfe6dfcec4ab 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -314,7 +314,7 @@ int ixgbevf_get_reta_locked(struct ixgbe_hw *hw, u32 *reta, int num_rx_queues)
 	case ixgbe_mbox_api_12:
 		if (hw->mac.type < ixgbe_mac_X550_vf)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -382,7 +382,7 @@ int ixgbevf_get_rss_key_locked(struct ixgbe_hw *hw, u8 *rss_key)
 	case ixgbe_mbox_api_12:
 		if (hw->mac.type < ixgbe_mac_X550_vf)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -540,7 +540,7 @@ static s32 ixgbevf_update_xcast_mode(struct ixgbe_hw *hw, int xcast_mode)
 		/* promisc introduced in 1.3 version */
 		if (xcast_mode == IXGBEVF_XCAST_MODE_PROMISC)
 			return -EOPNOTSUPP;
-		/* Fall threw */
+		fallthrough;
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
 		break;
-- 
2.26.2

