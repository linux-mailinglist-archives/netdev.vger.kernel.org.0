Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB7E1DDBD8
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgEVALc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:11:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:41697 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbgEVALN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:11:13 -0400
IronPort-SDR: oysTjoW56V9U6gj7ZLBukj7eX6rQ8JouGB1J2t92R6ScFAdJk8k0JFQXc0FBQF98VTnestIk2o
 6bnoc3WM7GDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:11:10 -0700
IronPort-SDR: pMu3A+lI9Bq9idfa4H5OBsInSalfsROn7ZT4ZV0JRU7XsXItfxqoC/nciaiaC7siMGcTiBLVvl
 HJipAEPR362w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254133945"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 May 2020 17:11:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 07/15] igc: Remove header redirection register
Date:   Thu, 21 May 2020 17:11:00 -0700
Message-Id: <20200522001108.1675149-8-jeffrey.t.kirsher@intel.com>
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

Header redirection missed packet counter not applicable for i225 device.
This patch comes to clean up this register.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_regs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index f2654f379d88..79bd104363ed 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -199,7 +199,6 @@
 #define IGC_HGOTCL	0x04130  /* Host Good Octets Transmit Count Low */
 #define IGC_HGOTCH	0x04134  /* Host Good Octets Transmit Count High */
 #define IGC_LENERRS	0x04138  /* Length Errors Count */
-#define IGC_HRMPC	0x0A018  /* Header Redirection Missed Packet Count */
 
 /* Time sync registers */
 #define IGC_TSICR	0x0B66C  /* Time Sync Interrupt Cause */
-- 
2.26.2

