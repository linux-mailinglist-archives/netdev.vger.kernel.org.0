Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A965C1B1A42
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgDTXnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:43:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:14655 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgDTXn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:43:26 -0400
IronPort-SDR: xRQ2BiEPMmXVB7aaUhQXkFQ6MblQ2k3DTBRt62aAxMXkNYURD/3mDtOZ9teT5q5ZROVnILVe60
 LTLKu0g1pKyQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:43:17 -0700
IronPort-SDR: CMMMnWgTCrWm3uGeckS7rykMTnq0MvlLD8901f0RI//EcxkaBD/yPsiZ8vTd9grMHXb3+k8LsM
 UQclUB/GcUEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300428878"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:43:17 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/13] igc: Remove '\n' from log strings in igc_phy.c
Date:   Mon, 20 Apr 2020 16:43:11 -0700
Message-Id: <20200420234313.2184282-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

To keep log strings in igc_phy.c consistent with the rest of the driver
code, this patch removes the '\n' character at the end. The newline
character is automatically added by netdev_dbg() so there is no changes
in the output.

Note: hw_dbg() is a macro that expands to netdev_dbg().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_phy.c | 52 ++++++++++++------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 8e1799508edc..a11c2e45d894 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -207,7 +207,7 @@ s32 igc_phy_hw_reset(struct igc_hw *hw)
 	} while (!(phpm & IGC_PHY_RST_COMP) && timeout);
 
 	if (!timeout)
-		hw_dbg("Timeout is expired after a phy reset\n");
+		hw_dbg("Timeout is expired after a phy reset");
 
 	usleep_range(100, 150);
 
@@ -278,49 +278,49 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 				 NWAY_AR_10T_HD_CAPS);
 	mii_1000t_ctrl_reg &= ~(CR_1000T_HD_CAPS | CR_1000T_FD_CAPS);
 
-	hw_dbg("autoneg_advertised %x\n", phy->autoneg_advertised);
+	hw_dbg("autoneg_advertised %x", phy->autoneg_advertised);
 
 	/* Do we want to advertise 10 Mb Half Duplex? */
 	if (phy->autoneg_advertised & ADVERTISE_10_HALF) {
-		hw_dbg("Advertise 10mb Half duplex\n");
+		hw_dbg("Advertise 10mb Half duplex");
 		mii_autoneg_adv_reg |= NWAY_AR_10T_HD_CAPS;
 	}
 
 	/* Do we want to advertise 10 Mb Full Duplex? */
 	if (phy->autoneg_advertised & ADVERTISE_10_FULL) {
-		hw_dbg("Advertise 10mb Full duplex\n");
+		hw_dbg("Advertise 10mb Full duplex");
 		mii_autoneg_adv_reg |= NWAY_AR_10T_FD_CAPS;
 	}
 
 	/* Do we want to advertise 100 Mb Half Duplex? */
 	if (phy->autoneg_advertised & ADVERTISE_100_HALF) {
-		hw_dbg("Advertise 100mb Half duplex\n");
+		hw_dbg("Advertise 100mb Half duplex");
 		mii_autoneg_adv_reg |= NWAY_AR_100TX_HD_CAPS;
 	}
 
 	/* Do we want to advertise 100 Mb Full Duplex? */
 	if (phy->autoneg_advertised & ADVERTISE_100_FULL) {
-		hw_dbg("Advertise 100mb Full duplex\n");
+		hw_dbg("Advertise 100mb Full duplex");
 		mii_autoneg_adv_reg |= NWAY_AR_100TX_FD_CAPS;
 	}
 
 	/* We do not allow the Phy to advertise 1000 Mb Half Duplex */
 	if (phy->autoneg_advertised & ADVERTISE_1000_HALF)
-		hw_dbg("Advertise 1000mb Half duplex request denied!\n");
+		hw_dbg("Advertise 1000mb Half duplex request denied");
 
 	/* Do we want to advertise 1000 Mb Full Duplex? */
 	if (phy->autoneg_advertised & ADVERTISE_1000_FULL) {
-		hw_dbg("Advertise 1000mb Full duplex\n");
+		hw_dbg("Advertise 1000mb Full duplex");
 		mii_1000t_ctrl_reg |= CR_1000T_FD_CAPS;
 	}
 
 	/* We do not allow the Phy to advertise 2500 Mb Half Duplex */
 	if (phy->autoneg_advertised & ADVERTISE_2500_HALF)
-		hw_dbg("Advertise 2500mb Half duplex request denied!\n");
+		hw_dbg("Advertise 2500mb Half duplex request denied");
 
 	/* Do we want to advertise 2500 Mb Full Duplex? */
 	if (phy->autoneg_advertised & ADVERTISE_2500_FULL) {
-		hw_dbg("Advertise 2500mb Full duplex\n");
+		hw_dbg("Advertise 2500mb Full duplex");
 		aneg_multigbt_an_ctrl |= CR_2500T_FD_CAPS;
 	} else {
 		aneg_multigbt_an_ctrl &= ~CR_2500T_FD_CAPS;
@@ -376,7 +376,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 		mii_autoneg_adv_reg |= (NWAY_AR_ASM_DIR | NWAY_AR_PAUSE);
 		break;
 	default:
-		hw_dbg("Flow control param set incorrectly\n");
+		hw_dbg("Flow control param set incorrectly");
 		return -IGC_ERR_CONFIG;
 	}
 
@@ -384,7 +384,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 	if (ret_val)
 		return ret_val;
 
-	hw_dbg("Auto-Neg Advertising %x\n", mii_autoneg_adv_reg);
+	hw_dbg("Auto-Neg Advertising %x", mii_autoneg_adv_reg);
 
 	if (phy->autoneg_mask & ADVERTISE_1000_FULL)
 		ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
@@ -458,13 +458,13 @@ static s32 igc_copper_link_autoneg(struct igc_hw *hw)
 	if (phy->autoneg_advertised == 0)
 		phy->autoneg_advertised = phy->autoneg_mask;
 
-	hw_dbg("Reconfiguring auto-neg advertisement params\n");
+	hw_dbg("Reconfiguring auto-neg advertisement params");
 	ret_val = igc_phy_setup_autoneg(hw);
 	if (ret_val) {
-		hw_dbg("Error Setting up Auto-Negotiation\n");
+		hw_dbg("Error Setting up Auto-Negotiation");
 		goto out;
 	}
-	hw_dbg("Restarting Auto-Neg\n");
+	hw_dbg("Restarting Auto-Neg");
 
 	/* Restart auto-negotiation by setting the Auto Neg Enable bit and
 	 * the Auto Neg Restart bit in the PHY control register.
@@ -484,7 +484,7 @@ static s32 igc_copper_link_autoneg(struct igc_hw *hw)
 	if (phy->autoneg_wait_to_complete) {
 		ret_val = igc_wait_autoneg(hw);
 		if (ret_val) {
-			hw_dbg("Error while waiting for autoneg to complete\n");
+			hw_dbg("Error while waiting for autoneg to complete");
 			goto out;
 		}
 	}
@@ -520,10 +520,10 @@ s32 igc_setup_copper_link(struct igc_hw *hw)
 		/* PHY will be set to 10H, 10F, 100H or 100F
 		 * depending on user settings.
 		 */
-		hw_dbg("Forcing Speed and Duplex\n");
+		hw_dbg("Forcing Speed and Duplex");
 		ret_val = hw->phy.ops.force_speed_duplex(hw);
 		if (ret_val) {
-			hw_dbg("Error Forcing Speed and Duplex\n");
+			hw_dbg("Error Forcing Speed and Duplex");
 			goto out;
 		}
 	}
@@ -536,11 +536,11 @@ s32 igc_setup_copper_link(struct igc_hw *hw)
 		goto out;
 
 	if (link) {
-		hw_dbg("Valid link established!!!\n");
+		hw_dbg("Valid link established");
 		igc_config_collision_dist(hw);
 		ret_val = igc_config_fc_after_link_up(hw);
 	} else {
-		hw_dbg("Unable to establish link!!!\n");
+		hw_dbg("Unable to establish link");
 	}
 
 out:
@@ -563,7 +563,7 @@ static s32 igc_read_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 *data)
 	s32 ret_val = 0;
 
 	if (offset > MAX_PHY_REG_ADDRESS) {
-		hw_dbg("PHY Address %d is out of range\n", offset);
+		hw_dbg("PHY Address %d is out of range", offset);
 		ret_val = -IGC_ERR_PARAM;
 		goto out;
 	}
@@ -589,12 +589,12 @@ static s32 igc_read_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 *data)
 			break;
 	}
 	if (!(mdic & IGC_MDIC_READY)) {
-		hw_dbg("MDI Read did not complete\n");
+		hw_dbg("MDI Read did not complete");
 		ret_val = -IGC_ERR_PHY;
 		goto out;
 	}
 	if (mdic & IGC_MDIC_ERROR) {
-		hw_dbg("MDI Error\n");
+		hw_dbg("MDI Error");
 		ret_val = -IGC_ERR_PHY;
 		goto out;
 	}
@@ -619,7 +619,7 @@ static s32 igc_write_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 data)
 	s32 ret_val = 0;
 
 	if (offset > MAX_PHY_REG_ADDRESS) {
-		hw_dbg("PHY Address %d is out of range\n", offset);
+		hw_dbg("PHY Address %d is out of range", offset);
 		ret_val = -IGC_ERR_PARAM;
 		goto out;
 	}
@@ -646,12 +646,12 @@ static s32 igc_write_phy_reg_mdic(struct igc_hw *hw, u32 offset, u16 data)
 			break;
 	}
 	if (!(mdic & IGC_MDIC_READY)) {
-		hw_dbg("MDI Write did not complete\n");
+		hw_dbg("MDI Write did not complete");
 		ret_val = -IGC_ERR_PHY;
 		goto out;
 	}
 	if (mdic & IGC_MDIC_ERROR) {
-		hw_dbg("MDI Error\n");
+		hw_dbg("MDI Error");
 		ret_val = -IGC_ERR_PHY;
 		goto out;
 	}
-- 
2.25.3

