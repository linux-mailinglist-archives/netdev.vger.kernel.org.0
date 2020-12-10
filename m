Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8D12D6603
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393314AbgLJTJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:09:52 -0500
Received: from mga07.intel.com ([134.134.136.100]:4500 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393251AbgLJTJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 14:09:34 -0500
IronPort-SDR: nAYRmCPhbd7FYaGOz5haJQ4vnBMtWy7z0rv+GMtnXuAf/TcMJy/OIMMFj7Ku/V4yPgQq2AzleR
 VyrzFYwRmgnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9831"; a="238419584"
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="238419584"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2020 11:08:51 -0800
IronPort-SDR: Ga57zK1Dx1Mn4Zwk+rn0qShFMK6KIa9visBS+GskF+wjus/KNq0JKhlk61XrrrzqqGw5sADBgf
 SxZwdhQW0ixg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="364877698"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 10 Dec 2020 11:08:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [PATCH net-next] igc: Add new device ID
Date:   Thu, 10 Dec 2020 11:08:12 -0800
Message-Id: <20201210190812.413143-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add new device ID for the next step of the silicon and
reflect the I226_K part.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 1 +
 drivers/net/ethernet/intel/igc/igc_hw.h   | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index fd37d2c203af..d0700d48ecf9 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -213,6 +213,7 @@ static s32 igc_get_invariants_base(struct igc_hw *hw)
 	case IGC_DEV_ID_I220_V:
 	case IGC_DEV_ID_I225_K:
 	case IGC_DEV_ID_I225_K2:
+	case IGC_DEV_ID_I226_K:
 	case IGC_DEV_ID_I225_LMVP:
 	case IGC_DEV_ID_I225_IT:
 	case IGC_DEV_ID_I226_LM:
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 55dae7c4703f..9da5f83ce456 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -23,6 +23,7 @@
 #define IGC_DEV_ID_I225_K			0x3100
 #define IGC_DEV_ID_I225_K2			0x3101
 #define IGC_DEV_ID_I225_LMVP			0x5502
+#define IGC_DEV_ID_I226_K			0x5504
 #define IGC_DEV_ID_I225_IT			0x0D9F
 #define IGC_DEV_ID_I226_LM			0x125B
 #define IGC_DEV_ID_I226_V			0x125C
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b673ac1199bb..afd6a62da29d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -45,6 +45,7 @@ static const struct pci_device_id igc_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I220_V), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K2), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_K), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_LMVP), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_IT), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_LM), board_base },
-- 
2.26.2

