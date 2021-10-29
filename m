Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A393844015F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJ2Rpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:45:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:63747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhJ2Rph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:45:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="210767102"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="210767102"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 10:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="574760203"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2021 10:42:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 2/3] igc: Add new device ID
Date:   Fri, 29 Oct 2021 10:41:00 -0700
Message-Id: <20211029174101.2970935-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
References: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add new device ID for the next step of the silicon and
reflect the I226_LMVP part.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 1 +
 drivers/net/ethernet/intel/igc/igc_hw.h   | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 30b1f02cef15..2612a58fc52a 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -202,6 +202,7 @@ static s32 igc_get_invariants_base(struct igc_hw *hw)
 	case IGC_DEV_ID_I225_K2:
 	case IGC_DEV_ID_I226_K:
 	case IGC_DEV_ID_I225_LMVP:
+	case IGC_DEV_ID_I226_LMVP:
 	case IGC_DEV_ID_I225_IT:
 	case IGC_DEV_ID_I226_LM:
 	case IGC_DEV_ID_I226_V:
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 4e0203336c6b..587db7483f25 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -24,6 +24,7 @@
 #define IGC_DEV_ID_I225_K2			0x3101
 #define IGC_DEV_ID_I226_K			0x3102
 #define IGC_DEV_ID_I225_LMVP			0x5502
+#define IGC_DEV_ID_I226_LMVP			0x5503
 #define IGC_DEV_ID_I225_IT			0x0D9F
 #define IGC_DEV_ID_I226_LM			0x125B
 #define IGC_DEV_ID_I226_V			0x125C
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7ffb1045f00c..8e448288ee26 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -56,6 +56,7 @@ static const struct pci_device_id igc_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K2), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_K), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_LMVP), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_LMVP), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_IT), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_LM), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_V), board_base },
-- 
2.31.1

