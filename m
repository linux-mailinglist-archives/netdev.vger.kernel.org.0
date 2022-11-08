Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4973B621821
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiKHPYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiKHPYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:24:21 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B21554CA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:24:19 -0800 (PST)
Received: from gmx.fr ([181.118.49.178]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N2E1G-1ozcFd2H78-013hMz; Tue, 08
 Nov 2022 16:24:08 +0100
Date:   Tue, 8 Nov 2022 11:24:03 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com
Subject: [PATCH 1/1] net-next: e1000e: Enable Link Partner Advertised Support
Message-ID: <Y2p0kxpSN20BfiCD@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:uL9miHRGNCaRUV0PzTzcInZFDkNbuSLTcxJYvzj74MYGpyn5lL+
 jYgAZxD1EjhEG9hsTclMSLStWqRCE3MWiX/NDyt0BnsK9aHaTCa2hc899Dpv0SpE1OHJxVT
 1pdvjHYSE9V17syWpoObc9q9gWKhje7duEh4O9wFQCM6JwKh3jgjZOZuGtS6g1TckyE2H8Q
 VyLG4xMAGWtXdeRtKI/2Q==
UI-OutboundReport: notjunk:1;M01:P0:zjCb6tPmwr8=;AOKXQGANlq85vrKYdWObaPi4vlt
 dYkH9n71Yc0NF0v3fPkx7sl9IRx5cUTyAQV4CRgjeYOHvv8Lf6oSndeCyeKPMiRNL3MNxEjGr
 afugCeNdAlSfdW/i7YC94TZ2lyYDx+5I9MhfmuT1lLwFj7s71hJ/EFWXNkUW9YyqDlrR4qU5d
 J2tq4rqc0Gr8SZHqdN0hQVyyFBZFqaE+Dwa0VmImo4aHWT63Yv8uPak/jte7sp+RO24uBuHkw
 +6yTdfgBj507ONBNBpHk2/5cu5jqYjkqZcRwFDkU22s/8g+T0sNFaOFTwOAQtTLKYkYeARTv0
 2kc8MyEwhCzccyhoTi6jxgCtCE7LhSx6ZlB01P8nAsEIjk+EeCOwDaoV7L6dPARZPjXCqBxZz
 8DvMUegiB3ljLRZKrBzkPwkSnjjLPsrQA+kKeKOuVThTkwkgXOUPg3QiNgS0i3I50xdvtHE2m
 paxWibMmVa5llsNa5cT9l80Rj2J0uxpJ+Dp8ZeYbVHYctrZtge43w07LoxQKqRcb/XhEO+oSj
 bXaxpJMnCM45CdyP6nPtH1d1fmv1u71B9K7l2ctv3hwh3s86kMnqs756DjiAHIqE4Nk40R4UM
 3mUnKDYRONqtZGiHK5csSbcW2Y/QUFBe7SQPTMUNsmO5iszOmOqP+HnOaHWkQDuYca/17Uoc6
 Jeev8RTEvbb8mx/AiTnYLRXgbC77Xk/vnHb8vij61zSlzH9UkJlWGSBoojNzyKboPOHZc4/HJ
 HYBsMxVQSqLLA213SEn+N0Lz6aFIA5XDBGVAL6uW811/G8VKrkTt6IyuxCLnkpns4rU5/Acj+
 xfy5NM4gQR+80KWR9Ep9WFLCQmrCSNE1Z4OShKfYYX+AJzx8yOC9x9n3nmzL0FzEjU5xu8iiN
 Yi4/fXpzXHfuALPuZVG5Nr4aA0QF7NtXzHPfT7dQ93sPk0PInYgNC3sJPMrf56l5c7UkRm2qc
 pQF3tsS1dWsK9ZocSCYIxA1H/yc=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables link partner advertised support to show link modes and
pause frame use.

Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 10 +++++++++-
 drivers/net/ethernet/intel/e1000e/phy.c     |  9 +++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 51a5afe9df2f..743462adccd0 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -110,9 +110,9 @@ static const char e1000_gstrings_test[][ETH_GSTRING_LEN] = {
 static int e1000_get_link_ksettings(struct net_device *netdev,
 				    struct ethtool_link_ksettings *cmd)
 {
+	u32 speed, supported, advertising, lp_advertising, lpa_t;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
-	u32 speed, supported, advertising;
 
 	if (hw->phy.media_type == e1000_media_type_copper) {
 		supported = (SUPPORTED_10baseT_Half |
@@ -120,7 +120,9 @@ static int e1000_get_link_ksettings(struct net_device *netdev,
 			     SUPPORTED_100baseT_Half |
 			     SUPPORTED_100baseT_Full |
 			     SUPPORTED_1000baseT_Full |
+			     SUPPORTED_Asym_Pause |
 			     SUPPORTED_Autoneg |
+			     SUPPORTED_Pause |
 			     SUPPORTED_TP);
 		if (hw->phy.type == e1000_phy_ife)
 			supported &= ~SUPPORTED_1000baseT_Full;
@@ -192,10 +194,16 @@ static int e1000_get_link_ksettings(struct net_device *netdev,
 	if (hw->phy.media_type != e1000_media_type_copper)
 		cmd->base.eth_tp_mdix_ctrl = ETH_TP_MDI_INVALID;
 
+	lpa_t = mii_stat1000_to_ethtool_lpa_t(adapter->phy_regs.stat1000);
+	lp_advertising = lpa_t |
+	mii_lpa_to_ethtool_lpa_t(adapter->phy_regs.lpa);
+
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
 						supported);
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
 						advertising);
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.lp_advertising,
+						lp_advertising);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index 060b263348ce..08c3d477dd6f 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 1999 - 2018 Intel Corporation. */
 
 #include "e1000.h"
+#include <linux/ethtool.h>
 
 static s32 e1000_wait_autoneg(struct e1000_hw *hw);
 static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
@@ -1011,6 +1012,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg &=
 		    ~(ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
+		phy->autoneg_advertised &=
+		    ~(ADVERTISED_Pause | ADVERTISED_Asym_Pause);
 		break;
 	case e1000_fc_rx_pause:
 		/* Rx Flow control is enabled, and Tx Flow control is
@@ -1024,6 +1027,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg |=
 		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
+		phy->autoneg_advertised |=
+		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
 		break;
 	case e1000_fc_tx_pause:
 		/* Tx Flow control is enabled, and Rx Flow control is
@@ -1031,6 +1036,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg |= ADVERTISE_PAUSE_ASYM;
 		mii_autoneg_adv_reg &= ~ADVERTISE_PAUSE_CAP;
+		phy->autoneg_advertised |= ADVERTISED_Asym_Pause;
+		phy->autoneg_advertised &= ~ADVERTISED_Pause;
 		break;
 	case e1000_fc_full:
 		/* Flow control (both Rx and Tx) is enabled by a software
@@ -1038,6 +1045,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg |=
 		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
+		phy->autoneg_advertised |=
+		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
 		break;
 	default:
 		e_dbg("Flow control param set incorrectly\n");
-- 
2.28.0

