Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F00F740D1
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbfGXV00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:26:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:63563 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfGXV0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 17:26:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 14:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="scan'208";a="160700655"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 24 Jul 2019 14:26:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 1/5] igc: Remove the polarity field from a PHY information structure
Date:   Wed, 24 Jul 2019 14:26:09 -0700
Message-Id: <20190724212613.1580-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190724212613.1580-1-jeffrey.t.kirsher@intel.com>
References: <20190724212613.1580-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Polarity and cable length fields is not applicable for the i225 device.
This patch comes to clean up PHY information structure.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 1039a224ac80..f689f0a02b5d 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -151,16 +151,10 @@ struct igc_phy_info {
 
 	u16 autoneg_advertised;
 	u16 autoneg_mask;
-	u16 cable_length;
-	u16 max_cable_length;
-	u16 min_cable_length;
-	u16 pair_length[4];
 
 	u8 mdix;
 
-	bool disable_polarity_correction;
 	bool is_mdix;
-	bool polarity_correction;
 	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
-- 
2.21.0

