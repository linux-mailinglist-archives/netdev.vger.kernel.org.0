Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C9C1E7511
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgE2Ekj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:40323 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2EkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:17 -0400
IronPort-SDR: TjcTV6UgcGSNeFArc9RRQbT7UXPtpVxke3rQMfdNe42fNB19IdqmGQRfaV7LyJ3RU64I5AgVP/
 YP/Oc1x5QmXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:05 -0700
IronPort-SDR: di7aaWZv+DROtT96YdctVoeQktafLIrOsuaNHQl8PZr0aRFpAxHNP8kbJDAQXjms2NKe0KRFo1
 YR4h7NJ0lhPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850915"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/17] igc: Remove unused flags
Date:   Thu, 28 May 2020 21:39:55 -0700
Message-Id: <20200529044004.3725307-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Transmit underrun, late and excess collision flags not in use.
This patch comes to clean up these flags.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 3d8d40d6fa3f..186deb1d9375 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -269,13 +269,9 @@
 #define IGC_TXD_CMD_DEXT	0x20000000 /* Desc extension (0 = legacy) */
 #define IGC_TXD_CMD_VLE		0x40000000 /* Add VLAN tag */
 #define IGC_TXD_STAT_DD		0x00000001 /* Descriptor Done */
-#define IGC_TXD_STAT_EC		0x00000002 /* Excess Collisions */
-#define IGC_TXD_STAT_LC		0x00000004 /* Late Collisions */
-#define IGC_TXD_STAT_TU		0x00000008 /* Transmit underrun */
 #define IGC_TXD_CMD_TCP		0x01000000 /* TCP packet */
 #define IGC_TXD_CMD_IP		0x02000000 /* IP packet */
 #define IGC_TXD_CMD_TSE		0x04000000 /* TCP Seg enable */
-#define IGC_TXD_STAT_TC		0x00000004 /* Tx Underrun */
 #define IGC_TXD_EXTCMD_TSTAMP	0x00000010 /* IEEE1588 Timestamp packet */
 
 /* IPSec Encrypt Enable */
-- 
2.26.2

