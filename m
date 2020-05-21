Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E864A1DC797
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgEUH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:28:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:36202 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgEUH2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:28:03 -0400
IronPort-SDR: MmfTjYy/14+E1nSn3qwAPYU+N3JX0ev67QKlNKEb2eTb6g7/1f0iLQGVdKlERIa+SVPeZgTtx4
 IC5Yth3y36rA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:28:02 -0700
IronPort-SDR: acReh3Qj60f9r4Fe4/LEHFMeOxcKfuPWdkP0Buw8TqvJ3SEc7pfL6s4u3+n96te1SxHt1pnRf/
 L91tCyIdaV/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="343758699"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2020 00:28:00 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] igc: Remove header redirection register
Date:   Thu, 21 May 2020 00:27:50 -0700
Message-Id: <20200521072758.440264-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
References: <20200521072758.440264-1-jeffrey.t.kirsher@intel.com>
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

