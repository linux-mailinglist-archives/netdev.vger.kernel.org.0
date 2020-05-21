Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3C1DC796
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgEUH2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 03:28:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:36207 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728378AbgEUH2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 03:28:03 -0400
IronPort-SDR: PXZbZ1YyHMV7VldgwgThXP/zDfRJDvJKFl+JYNhJKz2VGR6JSqHFOdTKnIzSIEo5nnIAhUiiFh
 EGaThQF+n3qg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 00:28:02 -0700
IronPort-SDR: NbJDpIcXtaViA4CPPNqLOqVbWjDkV+SfeniYjzYq3URRgu4NUBa815DnvQElDy3COi2xQfyUfJ
 qh8htl/wgV5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,417,1583222400"; 
   d="scan'208";a="343758705"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga001.jf.intel.com with ESMTP; 21 May 2020 00:28:00 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] igc: Remove per queue good transmited counter register
Date:   Thu, 21 May 2020 00:27:51 -0700
Message-Id: <20200521072758.440264-9-jeffrey.t.kirsher@intel.com>
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

Per queue good transmitted packet counter not applicable for i225 device.
This patch comes to clean up this register.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_regs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 79bd104363ed..7f999cfc9b39 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -124,9 +124,6 @@
 #define IGC_MMDAC		13 /* MMD Access Control */
 #define IGC_MMDAAD		14 /* MMD Access Address/Data */
 
-/* Good transmitted packets counter registers */
-#define IGC_PQGPTC(_n)		(0x010014 + (0x100 * (_n)))
-
 /* Statistics Register Descriptions */
 #define IGC_CRCERRS	0x04000  /* CRC Error Count - R/clr */
 #define IGC_ALGNERRC	0x04004  /* Alignment Error Count - R/clr */
-- 
2.26.2

