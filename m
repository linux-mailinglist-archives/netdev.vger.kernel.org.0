Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257961DA609
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgETAEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:15429 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgETAEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:34 -0400
IronPort-SDR: Of1eJ+SDNg/nRLI5ji/ux94iKd6eoeLD4VuuY1G/A4M/yX0s9DjHKuMVeQv6cKrZfNQhc+O4sO
 cuvETEWopPVg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:25 -0700
IronPort-SDR: 5AkJb7NMpaE0na8VYd29M2il3+7WtONsQ6ZZ01WTOellM8CR2UViz78igFNWhJTmSNpRQLSkre
 pHcqWSPiFkww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324813"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/14] igc: Remove unused IGC_ICS_DRSTA define
Date:   Tue, 19 May 2020 17:04:18 -0700
Message-Id: <20200520000419.1595788-14-jeffrey.t.kirsher@intel.com>
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

Device reset assert for interrupt cause register not in
use for i225 device.
This patch comes to clean up this define.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 6909826bc747..51d8a15e239c 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -244,7 +244,6 @@
 /* Interrupt Cause Set */
 #define IGC_ICS_LSC		IGC_ICR_LSC       /* Link Status Change */
 #define IGC_ICS_RXDMT0		IGC_ICR_RXDMT0    /* rx desc min. threshold */
-#define IGC_ICS_DRSTA		IGC_ICR_DRSTA     /* Device Reset Aserted */
 
 #define IGC_ICR_DOUTSYNC	0x10000000 /* NIC DMA out of sync */
 #define IGC_EITR_CNT_IGNR	0x80000000 /* Don't reset counters on write */
-- 
2.26.2

