Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B102562553
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiF3VfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbiF3VfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:35:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED9251B3A
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624911; x=1688160911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dzv+zfbK0r3lPU4is9LyJJqhHkw4X0V7dM680gO+fps=;
  b=JGZcklPUyFr+cMuoF17I5/o+JCcko6mBx9rNyql5+mpA478bT8iIicXz
   p9XBBmZ/mbNWcKXm/GKJYcccFz4L0MlImvF49fVjPXoDpepfxdKqZDNqW
   4j0sEhLRX01XXc4LPTE7IcH5HaNHSp/7xEcCaH0AGqbgath/cz+90By5W
   sN1kA28Yrt4d4AVnDbe9fgO1Zzjmn3ZZYD/yoAzwo8IVDsxLZuLVtPsFp
   3keukiFn/1EvSenPrYsbg/izkOIG96QczcscUm5a0Ll5Bwo4AmsUyM7jR
   cJFUQhWh4Wl7LvSt+4BcMD+tbmfEUO1Fs9KeOxdIVKbS0J213eQrkSTTW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="282507738"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="282507738"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:35:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837771790"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:35:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 01/15] intel: remove unused macros
Date:   Thu, 30 Jun 2022 14:31:54 -0700
Message-Id: <20220630213208.3034968-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
References: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

As found by the compile option -Wunused-macros, remove these macros
that are never used by the code.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e100.c                | 1 -
 drivers/net/ethernet/intel/e1000/e1000_param.c   | 2 --
 drivers/net/ethernet/intel/e1000e/param.c        | 2 --
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c   | 2 --
 drivers/net/ethernet/intel/i40e/i40e_ptp.c       | 1 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c      | 1 -
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c  | 4 ----
 drivers/net/ethernet/intel/igc/igc_ptp.c         | 1 -
 drivers/net/ethernet/intel/ixgb/ixgb_main.c      | 1 -
 drivers/net/ethernet/intel/ixgb/ixgb_param.c     | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c  | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c     | 1 -
 drivers/net/ethernet/intel/ixgbevf/ethtool.c     | 4 ----
 14 files changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 36418b510dde..11a884aa5082 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1430,7 +1430,6 @@ static int e100_phy_check_without_mii(struct nic *nic)
 #define MII_NSC_CONG		MII_RESV1
 #define NSC_CONG_ENABLE		0x0100
 #define NSC_CONG_TXREADY	0x0400
-#define ADVERTISE_FC_SUPPORTED	0x0400
 static int e100_phy_init(struct nic *nic)
 {
 	struct net_device *netdev = nic->netdev;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_param.c b/drivers/net/ethernet/intel/e1000/e1000_param.c
index 4d4f5bf1e516..f4154ca7fcb4 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_param.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_param.c
@@ -82,7 +82,6 @@ E1000_PARAM(Duplex, "Duplex setting");
  */
 E1000_PARAM(AutoNeg, "Advertised auto-negotiation setting");
 #define AUTONEG_ADV_DEFAULT  0x2F
-#define AUTONEG_ADV_MASK     0x2F
 
 /* User Specified Flow Control Override
  *
@@ -95,7 +94,6 @@ E1000_PARAM(AutoNeg, "Advertised auto-negotiation setting");
  * Default Value: Read flow control settings from the EEPROM
  */
 E1000_PARAM(FlowControl, "Flow Control setting");
-#define FLOW_CONTROL_DEFAULT FLOW_CONTROL_FULL
 
 /* XsumRX - Receive Checksum Offload Enable/Disable
  *
diff --git a/drivers/net/ethernet/intel/e1000e/param.c b/drivers/net/ethernet/intel/e1000e/param.c
index ebe121db4307..3132d8f2f207 100644
--- a/drivers/net/ethernet/intel/e1000e/param.c
+++ b/drivers/net/ethernet/intel/e1000e/param.c
@@ -101,8 +101,6 @@ E1000_PARAM(InterruptThrottleRate, "Interrupt Throttling Rate");
  * demoted to the most advanced interrupt mode available.
  */
 E1000_PARAM(IntMode, "Interrupt Mode");
-#define MAX_INTMODE	2
-#define MIN_INTMODE	0
 
 /* Enable Smart Power Down of the PHY
  *
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 55841816272b..d9a934ca3eba 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -236,8 +236,6 @@ static void __i40e_add_stat_strings(u8 **p, const struct i40e_stats stats[],
 	I40E_STAT(struct i40e_cp_veb_tc_stats, _name, _stat)
 #define I40E_PFC_STAT(_name, _stat) \
 	I40E_STAT(struct i40e_pfc_stats, _name, _stat)
-#define I40E_QUEUE_STAT(_name, _stat) \
-	I40E_STAT(struct i40e_ring, _name, _stat)
 
 static const struct i40e_stats i40e_gstrings_net_stats[] = {
 	I40E_NETDEV_STAT(rx_packets),
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
index 61e5789d78db..57a71fa17ed5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -27,7 +27,6 @@
 #define I40E_PRTTSYN_CTL1_TSYNTYPE_V2  (2 << \
 					I40E_PRTTSYN_CTL1_TSYNTYPE_SHIFT)
 #define I40E_SUBDEV_ID_25G_PTP_PIN	0xB
-#define to_dev(obj) container_of(obj, struct device, kobj)
 
 enum i40e_ptp_pin {
 	SDP3_2 = 0,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index a327189deda0..f6ba97a0166e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -372,7 +372,6 @@ static void i40e_change_filter_num(bool ipv4, bool add, u16 *ipv4_filter_num,
 	}
 }
 
-#define IP_HEADER_OFFSET		14
 #define I40E_UDPIP_DUMMY_PACKET_LEN	42
 #define I40E_UDPIP6_DUMMY_PACKET_LEN	62
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index e2b4ba98f71e..0d22bba6a5f2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -5,10 +5,6 @@
 #include "iavf_prototype.h"
 #include "iavf_client.h"
 
-/* busy wait delay in msec */
-#define IAVF_BUSY_WAIT_DELAY 10
-#define IAVF_BUSY_WAIT_COUNT 50
-
 /**
  * iavf_send_pf_msg
  * @adapter: adapter structure
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 653e9f1e35b5..8dbb9f903ca7 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -15,7 +15,6 @@
 #define INCVALUE_MASK		0x7fffffff
 #define ISGN			0x80000000
 
-#define IGC_SYSTIM_OVERFLOW_PERIOD	(HZ * 60 * 9)
 #define IGC_PTP_TX_TIMEOUT		(HZ * 15)
 
 #define IGC_PTM_STAT_SLEEP		2
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index affdefcca7e3..bca53625da33 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -1704,7 +1704,6 @@ ixgb_update_stats(struct ixgb_adapter *adapter)
 	netdev->stats.tx_window_errors = 0;
 }
 
-#define IXGB_MAX_INTR 10
 /**
  * ixgb_intr - Interrupt Handler
  * @irq: interrupt number
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_param.c b/drivers/net/ethernet/intel/ixgb/ixgb_param.c
index f0cadd532c53..d40f96250691 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_param.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_param.c
@@ -141,8 +141,6 @@ IXGB_PARAM(IntDelayEnable, "Transmit Interrupt Delay Enable");
 #define MAX_RDTR			 0xFFFF
 #define MIN_RDTR			      0
 
-#define XSUMRX_DEFAULT		 OPTION_ENABLED
-
 #define DEFAULT_FCRTL	  		0x28000
 #define DEFAULT_FCRTH			0x30000
 #define MIN_FCRTL			      0
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
index 72e6ebffea33..e85f7d2e8810 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
@@ -8,12 +8,10 @@
 #include "ixgbe_sriov.h"
 
 /* Callbacks for DCB netlink in the kernel */
-#define BIT_DCB_MODE	0x01
 #define BIT_PFC		0x02
 #define BIT_PG_RX	0x04
 #define BIT_PG_TX	0x08
 #define BIT_APP_UPCHG	0x10
-#define BIT_LINKSPEED   0x80
 
 /* Responses for the DCB_C_SET_ALL command */
 #define DCB_HW_CHG_RST  0  /* DCB configuration changed with reset */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 628d0eb0599f..04f453eabef6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -18,8 +18,6 @@
 #include "ixgbe_phy.h"
 
 
-#define IXGBE_ALL_RAR_ENTRIES 16
-
 enum {NETDEV_STATS, IXGBE_STATS};
 
 struct ixgbe_stats {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 336426a67ac1..27a71fa26d3c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -138,7 +138,6 @@
 #define IXGBE_X550_BASE_PERIOD 0xC80000000ULL
 #define INCVALUE_MASK	0x7FFFFFFF
 #define ISGN		0x80000000
-#define MAX_TIMADJ	0x7FFFFFFF
 
 /**
  * ixgbe_ptp_setup_sdp_X540
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 3b41f83c8dff..fed46872af2b 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -17,8 +17,6 @@
 
 #include "ixgbevf.h"
 
-#define IXGBE_ALL_RAR_ENTRIES 16
-
 enum {NETDEV_STATS, IXGBEVF_STATS};
 
 struct ixgbe_stats {
@@ -130,8 +128,6 @@ static void ixgbevf_set_msglevel(struct net_device *netdev, u32 data)
 	adapter->msg_enable = data;
 }
 
-#define IXGBE_GET_STAT(_A_, _R_) (_A_->stats._R_)
-
 static int ixgbevf_get_regs_len(struct net_device *netdev)
 {
 #define IXGBE_REGS_LEN 45
-- 
2.35.1

