Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC7B1DA602
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgETAEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:15427 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgETAE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:29 -0400
IronPort-SDR: jvutKwNnQfG+u097eYTRTchsIUBrxtcrivSzJMErgK92A1GZQPnNV5sTXgfCxUlcS0lGO9N5uF
 Kkq67kYEKU0A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:21 -0700
IronPort-SDR: 5x4hsWqIuwtGRkrAgVqdYixmZRzRHg873Q5/z2uq8YvuEQxuJ1nxrjDS2XLHj1cI12a+thvYGr
 Ma6Nys/7TfUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324747"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:20 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/14] igc: Remove PCIe Control register
Date:   Tue, 19 May 2020 17:04:06 -0700
Message-Id: <20200520000419.1595788-2-jeffrey.t.kirsher@intel.com>
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

GCR (PCIe Control) register not in use and should be removed
This patch clean up this register

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_regs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 5a6110e211fd..0f94285ddc11 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -36,9 +36,6 @@
 #define IGC_FCRTH		0x02168  /* FC Receive Threshold High - RW */
 #define IGC_FCRTV		0x02460  /* FC Refresh Timer Value - RW */
 
-/* PCIe Register Description */
-#define IGC_GCR			0x05B00  /* PCIe control- RW */
-
 /* Semaphore registers */
 #define IGC_SW_FW_SYNC		0x05B5C  /* SW-FW Synchronization - RW */
 #define IGC_SWSM		0x05B50  /* SW Semaphore */
-- 
2.26.2

