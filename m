Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5641D1DA610
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgETAE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:15444 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbgETAEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:55 -0400
IronPort-SDR: 2k/4i8h9xhSTA1/u2Xs5/Res7t1+IOlfsDzoOEdqDvf4AewRqVn/BM9+CFw74eMeXFlDwn2Gfw
 cjwT/OXo2SFA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:25 -0700
IronPort-SDR: HCmE3wN/bB9C+C3MHOa7OJe64RYDh3FLSPncZkOvglbqMrQu/iq5aoGpiRA1JgPBK+UVjYVKe+
 0A9LdemeJwTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324819"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/14] igc: Remove unused registers
Date:   Tue, 19 May 2020 17:04:19 -0700
Message-Id: <20200520000419.1595788-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Tx data FIFO Head/Tail, Saved and Packet Count registers
not applicable for i225 LAN controller.
This patch comes to clean up these registers.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_dump.c | 4 ----
 drivers/net/ethernet/intel/igc/igc_regs.h | 5 -----
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_dump.c b/drivers/net/ethernet/intel/igc/igc_dump.c
index 4ad32d98f77f..4b9ec7d0b727 100644
--- a/drivers/net/ethernet/intel/igc/igc_dump.c
+++ b/drivers/net/ethernet/intel/igc/igc_dump.c
@@ -35,10 +35,6 @@ static const struct igc_reg_info igc_reg_info_tbl[] = {
 	{IGC_TDH(0), "TDH"},
 	{IGC_TDT(0), "TDT"},
 	{IGC_TXDCTL(0), "TXDCTL"},
-	{IGC_TDFH, "TDFH"},
-	{IGC_TDFT, "TDFT"},
-	{IGC_TDFHS, "TDFHS"},
-	{IGC_TDFPC, "TDFPC"},
 
 	/* List Terminator */
 	{}
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 763a24d52865..61db951f0947 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -17,11 +17,6 @@
 /* Internal Packet Buffer Size Registers */
 #define IGC_RXPBS		0x02404  /* Rx Packet Buffer Size - RW */
 #define IGC_TXPBS		0x03404  /* Tx Packet Buffer Size - RW */
-#define IGC_TDFH		0x03410  /* Tx Data FIFO Head - RW */
-#define IGC_TDFT		0x03418  /* Tx Data FIFO Tail - RW */
-#define IGC_TDFHS		0x03420  /* Tx Data FIFO Head Saved - RW */
-#define IGC_TDFTS		0x03428  /* Tx Data FIFO Tail Saved - RW */
-#define IGC_TDFPC		0x03430  /* Tx Data FIFO Packet Count - RW */
 
 /* NVM  Register Descriptions */
 #define IGC_EERD		0x12014  /* EEprom mode read - RW */
-- 
2.26.2

