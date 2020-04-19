Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688471AFDC9
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDSTvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:45111 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDSTvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:33 -0400
IronPort-SDR: PcgGE3T7123WG0ZqQQBGjmMdQbvjcMLIQ9iMitF3iPSdwwLs7ZY3MgbGY2wMrhQNopIFloM39z
 n/ql9O++yryQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:33 -0700
IronPort-SDR: YmSvhhj+QLEGU09fbwLVZJbJgNuYW/5EbzPWDCiTefrxjRzH4KswhEMhoJ8zSbBIqzMYEmcCqC
 hI3ZHTYtYNcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034395"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:32 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/14] igc: Add new device IDs for i225 part
Date:   Sun, 19 Apr 2020 12:51:18 -0700
Message-Id: <20200419195131.1068144-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
References: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add new device IDs for the next step of i225

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 3 +++
 drivers/net/ethernet/intel/igc/igc_hw.h   | 3 +++
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 5a506440560a..f7fb18d8d8f5 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -212,6 +212,9 @@ static s32 igc_get_invariants_base(struct igc_hw *hw)
 	case IGC_DEV_ID_I225_I:
 	case IGC_DEV_ID_I220_V:
 	case IGC_DEV_ID_I225_K:
+	case IGC_DEV_ID_I225_K2:
+	case IGC_DEV_ID_I225_LMVP:
+	case IGC_DEV_ID_I225_IT:
 	case IGC_DEV_ID_I225_BLANK_NVM:
 		mac->type = igc_i225;
 		break;
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 90ac0e0144d8..af34ae310327 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -21,6 +21,9 @@
 #define IGC_DEV_ID_I225_I			0x15F8
 #define IGC_DEV_ID_I220_V			0x15F7
 #define IGC_DEV_ID_I225_K			0x3100
+#define IGC_DEV_ID_I225_K2			0x3101
+#define IGC_DEV_ID_I225_LMVP			0x5502
+#define IGC_DEV_ID_I225_IT			0x0D9F
 #define IGC_DEV_ID_I225_BLANK_NVM		0x15FD
 
 /* Function pointers for the MAC. */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9d1792e80e2e..6a7c1b081792 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -47,6 +47,9 @@ static const struct pci_device_id igc_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_I), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I220_V), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K2), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_LMVP), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_IT), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_BLANK_NVM), board_base },
 	/* required last entry */
 	{0, }
-- 
2.25.2

