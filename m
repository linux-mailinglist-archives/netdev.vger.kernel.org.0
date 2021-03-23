Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680E134685A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhCWTBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:01:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:10825 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232679AbhCWTA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:26 -0400
IronPort-SDR: Ub9N12py1MvbI6ICaUTv6lIHXUTmU0XMHkIPlfAPfA9tSayQnwQMTIV3jDx82a2r6dfgTx87mN
 TcrLtihFhr5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545845"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545845"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:24 -0700
IronPort-SDR: c0Jjyb+WohqslIfpM/G2BwysM0JbzMTtf4RM5GC03lEzA2k1naTl3HKsgUZ5hNncmi9p0Q/MVA
 TrwnYIWuN77Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460648"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 03/10] e1000e: Fix prototype warning
Date:   Tue, 23 Mar 2021 12:01:42 -0700
Message-Id: <20210323190149.3160859-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
References: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Correct report warnings in ich8lan.c, netdev.c phy.c and ptp.c files

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c  | 6 +++---
 drivers/net/ethernet/intel/e1000e/phy.c     | 2 +-
 drivers/net/ethernet/intel/e1000e/ptp.c     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 0ac8d79a7987..590ad110d383 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -2745,7 +2745,7 @@ static s32 e1000_lv_phy_workarounds_ich8lan(struct e1000_hw *hw)
 }
 
 /**
- *  e1000_k1_gig_workaround_lv - K1 Si workaround
+ *  e1000_k1_workaround_lv - K1 Si workaround
  *  @hw:   pointer to the HW structure
  *
  *  Workaround to set the K1 beacon duration for 82579 parts in 10Mbps
@@ -5220,7 +5220,7 @@ void e1000e_set_kmrn_lock_loss_workaround_ich8lan(struct e1000_hw *hw,
 }
 
 /**
- *  e1000_ipg3_phy_powerdown_workaround_ich8lan - Power down workaround on D3
+ *  e1000e_igp3_phy_powerdown_workaround_ich8lan - Power down workaround on D3
  *  @hw: pointer to the HW structure
  *
  *  Workaround for 82566 power-down on D3 entry:
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 39ca02b7fdc5..31b8726fd69b 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5987,7 +5987,7 @@ static void e1000_reset_task(struct work_struct *work)
 }
 
 /**
- * e1000_get_stats64 - Get System Network Statistics
+ * e1000e_get_stats64 - Get System Network Statistics
  * @netdev: network interface device structure
  * @stats: rtnl_link_stats64 pointer
  *
@@ -6160,7 +6160,7 @@ static int e1000_mii_ioctl(struct net_device *netdev, struct ifreq *ifr,
 }
 
 /**
- * e1000e_hwtstamp_ioctl - control hardware time stamping
+ * e1000e_hwtstamp_set - control hardware time stamping
  * @netdev: network interface device structure
  * @ifr: interface request
  *
@@ -6818,7 +6818,7 @@ static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
 }
 
 /**
- * e1000e_disable_aspm_locked   Disable ASPM states.
+ * e1000e_disable_aspm_locked - Disable ASPM states.
  * @pdev: pointer to PCI device struct
  * @state: bit-mask of ASPM states to disable
  *
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index bdd9dc163f15..1db35b2c7750 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -371,7 +371,7 @@ s32 e1000e_read_phy_reg_igp_locked(struct e1000_hw *hw, u32 offset, u16 *data)
 }
 
 /**
- *  e1000e_write_phy_reg_igp - Write igp PHY register
+ *  __e1000e_write_phy_reg_igp - Write igp PHY register
  *  @hw: pointer to the HW structure
  *  @offset: register offset to write to
  *  @data: data to write at register offset
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index f3f671311855..9e79d672f4f1 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -142,7 +142,7 @@ static int e1000e_phc_get_syncdevicetime(ktime_t *device,
 }
 
 /**
- * e1000e_phc_getsynctime - Reads the current system/device cross timestamp
+ * e1000e_phc_getcrosststamp - Reads the current system/device cross timestamp
  * @ptp: ptp clock structure
  * @xtstamp: structure containing timestamp
  *
-- 
2.26.2

