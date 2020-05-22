Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD51DDBD9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbgEVALb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:41703 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgEVALN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:13 -0400
IronPort-SDR: 7Y2Vre0O7B0QEEQOoTBg6Cr5Lp2lYRGliL9+5+iXUvau9/RkjT3GwGD2+sXWlNtH+JCfjjK5vi
 R3tmyHtGCx+w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:10 -0700
IronPort-SDR: EfeYs+jKTpxnckI9egn/QNGorNP1Cn3dXOdP8O6v3txD3opBcdVMk+gCU/cTH9GcpPaPf1WCij
 BR0UrQWQU6qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133942"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/15] igc: Remove obsolete circuit breaker registers
Date:   Thu, 21 May 2020 17:10:59 -0700
Message-Id: <20200522001108.1675149-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
References: <20200522001108.1675149-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Part of circuit breaker registers is obsolete
and not applicable for i225 device.
This patch comes to clean up these registers.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 4 ----
 drivers/net/ethernet/intel/igc/igc_regs.h | 7 -------
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 12aa6b5fcb5d..89445ab02a98 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -307,12 +307,8 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_ICTXQMTC);
 	rd32(IGC_ICRXDMTC);
 
-	rd32(IGC_CBTMPC);
-	rd32(IGC_HTDPMC);
-	rd32(IGC_CBRMPC);
 	rd32(IGC_RPTHC);
 	rd32(IGC_HGPTC);
-	rd32(IGC_HTCBDPC);
 	rd32(IGC_HGORCL);
 	rd32(IGC_HGORCH);
 	rd32(IGC_HGOTCL);
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 61db951f0947..f2654f379d88 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -68,13 +68,6 @@
 #define IGC_ICRXDMTC		0x04120  /* Rx Descriptor Min Threshold Count */
 #define IGC_ICRXOC		0x04124  /* Receiver Overrun Count */
 
-#define IGC_CBTMPC		0x0402C  /* Circuit Breaker TX Packet Count */
-#define IGC_HTDPMC		0x0403C  /* Host Transmit Discarded Packets */
-#define IGC_CBRMPC		0x040FC  /* Circuit Breaker RX Packet Count */
-#define IGC_RPTHC		0x04104  /* Rx Packets To Host */
-#define IGC_HGPTC		0x04118  /* Host Good Packets TX Count */
-#define IGC_HTCBDPC		0x04124  /* Host TX Circ.Breaker Drop Count */
-
 /* MSI-X Table Register Descriptions */
 #define IGC_PBACL		0x05B68  /* MSIx PBA Clear - R/W 1 to clear */
 
-- 
2.26.2

