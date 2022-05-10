Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E2A52261D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiEJVKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiEJVKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:10:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60862293B68
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652217001; x=1683753001;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BKsvdGDYKo/HRUsu5RA+eTWAQ8rgNMaBNAJrs9/rXoY=;
  b=D4owYHNAyZurR4G94UlSHlh0CWMEVdivj2AcLNL2ggeU5UtqiU9iPugP
   kFUsP7PR+uz1qHB0xZ6Mr5xbS29iOjYNEG2dcwY1nb6BGDVdOWMCOMao1
   rq7DKt3p/qO+QqCiLj1jwmfdqYD/Rs7U4rlYcoj35qN8anYZxXuuHzXYv
   tiNt/pQmgFubgt+LCxexYt7OA9OSo5HvPlySU4ot09xdO1I9YLOm9LRTL
   aFru/qGw+A9PNCHRXzxZl9lH55zdvQPZ5a6MXSFyru8As6xTQeivfmG8V
   AosfwgcljBg18zABG42ZKyiUXdIn8ig9uAdJH+s16Z8XOn9c12uxhwdYS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="267096320"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="267096320"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 14:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="623648425"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2022 14:10:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 1/3] igc: Remove igc_set_spd_dplx method
Date:   Tue, 10 May 2022 14:06:54 -0700
Message-Id: <20220510210656.2168393-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510210656.2168393-1-anthony.l.nguyen@intel.com>
References: <20220510210656.2168393-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

igc_set_spd_dplx method is not used. This patch comes to tidy up
the driver code.

Reported-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  1 -
 drivers/net/ethernet/intel/igc/igc_main.c | 50 -----------------------
 2 files changed, 51 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 3e386c38d016..1e7e7071f64d 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -264,7 +264,6 @@ int igc_reinit_queues(struct igc_adapter *adapter);
 void igc_write_rss_indir_tbl(struct igc_adapter *adapter);
 bool igc_has_link(struct igc_adapter *adapter);
 void igc_reset(struct igc_adapter *adapter);
-int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx);
 void igc_update_stats(struct igc_adapter *adapter);
 void igc_disable_rx_ring(struct igc_ring *ring);
 void igc_enable_rx_ring(struct igc_ring *ring);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 74b2c590ed5d..ae17af44fe02 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6187,56 +6187,6 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	return value;
 }
 
-int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
-{
-	struct igc_mac_info *mac = &adapter->hw.mac;
-
-	mac->autoneg = false;
-
-	/* Make sure dplx is at most 1 bit and lsb of speed is not set
-	 * for the switch() below to work
-	 */
-	if ((spd & 1) || (dplx & ~1))
-		goto err_inval;
-
-	switch (spd + dplx) {
-	case SPEED_10 + DUPLEX_HALF:
-		mac->forced_speed_duplex = ADVERTISE_10_HALF;
-		break;
-	case SPEED_10 + DUPLEX_FULL:
-		mac->forced_speed_duplex = ADVERTISE_10_FULL;
-		break;
-	case SPEED_100 + DUPLEX_HALF:
-		mac->forced_speed_duplex = ADVERTISE_100_HALF;
-		break;
-	case SPEED_100 + DUPLEX_FULL:
-		mac->forced_speed_duplex = ADVERTISE_100_FULL;
-		break;
-	case SPEED_1000 + DUPLEX_FULL:
-		mac->autoneg = true;
-		adapter->hw.phy.autoneg_advertised = ADVERTISE_1000_FULL;
-		break;
-	case SPEED_1000 + DUPLEX_HALF: /* not supported */
-		goto err_inval;
-	case SPEED_2500 + DUPLEX_FULL:
-		mac->autoneg = true;
-		adapter->hw.phy.autoneg_advertised = ADVERTISE_2500_FULL;
-		break;
-	case SPEED_2500 + DUPLEX_HALF: /* not supported */
-	default:
-		goto err_inval;
-	}
-
-	/* clear MDI, MDI(-X) override is only allowed when autoneg enabled */
-	adapter->hw.phy.mdix = AUTO_ALL_MODES;
-
-	return 0;
-
-err_inval:
-	netdev_err(adapter->netdev, "Unsupported Speed/Duplex configuration\n");
-	return -EINVAL;
-}
-
 /**
  * igc_probe - Device Initialization Routine
  * @pdev: PCI device information struct
-- 
2.35.1

