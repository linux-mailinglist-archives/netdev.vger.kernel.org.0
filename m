Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF71DF43C
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbgEWCvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:37985 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387577AbgEWCvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:17 -0400
IronPort-SDR: pf/T/t935OHOcnKeViYQMflZu9BLXzUwluVO1nQ0ntzVpn2ecdGgZq0c2UhfHi5woI/LkAurba
 wEFP+galNJVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:13 -0700
IronPort-SDR: b96CrD4rBNnbi0SjW9f36BIQPviqlV4DfuaOYsWa3FX56k9zbt5JD+8IWrYBCKTJedFPZmrqfv
 S14/ZUUL75bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291126"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/17] igc: Remove unused descriptor's flags
Date:   Fri, 22 May 2020 19:51:05 -0700
Message-Id: <20200523025109.3313635-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Enable Tidv register, Report Packet Sent, Report Status and
Ethernet CRC flags not in use.
This patch comes to clean up these flags.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 45b567587ca9..3d8d40d6fa3f 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -265,13 +265,9 @@
 #define IGC_TXD_POPTS_IXSM	0x01       /* Insert IP checksum */
 #define IGC_TXD_POPTS_TXSM	0x02       /* Insert TCP/UDP checksum */
 #define IGC_TXD_CMD_EOP		0x01000000 /* End of Packet */
-#define IGC_TXD_CMD_IFCS	0x02000000 /* Insert FCS (Ethernet CRC) */
 #define IGC_TXD_CMD_IC		0x04000000 /* Insert Checksum */
-#define IGC_TXD_CMD_RS		0x08000000 /* Report Status */
-#define IGC_TXD_CMD_RPS		0x10000000 /* Report Packet Sent */
 #define IGC_TXD_CMD_DEXT	0x20000000 /* Desc extension (0 = legacy) */
 #define IGC_TXD_CMD_VLE		0x40000000 /* Add VLAN tag */
-#define IGC_TXD_CMD_IDE		0x80000000 /* Enable Tidv register */
 #define IGC_TXD_STAT_DD		0x00000001 /* Descriptor Done */
 #define IGC_TXD_STAT_EC		0x00000002 /* Excess Collisions */
 #define IGC_TXD_STAT_LC		0x00000004 /* Late Collisions */
-- 
2.26.2

