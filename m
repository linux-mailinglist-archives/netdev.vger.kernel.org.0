Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3DC71DD6
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391144AbfGWRhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:37:07 -0400
Received: from mga17.intel.com ([192.55.52.151]:49104 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391139AbfGWRhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 13:37:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 10:37:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,299,1559545200"; 
   d="scan'208";a="197203629"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jul 2019 10:37:01 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 4/6] igc: Add more SKUs for i225 device
Date:   Tue, 23 Jul 2019 10:36:48 -0700
Message-Id: <20190723173650.23276-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
References: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add support for more SKUs.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 3 +++
 drivers/net/ethernet/intel/igc/igc_hw.h   | 3 +++
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 46206b3dabfb..db289bcce21d 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -209,6 +209,9 @@ static s32 igc_get_invariants_base(struct igc_hw *hw)
 	switch (hw->device_id) {
 	case IGC_DEV_ID_I225_LM:
 	case IGC_DEV_ID_I225_V:
+	case IGC_DEV_ID_I225_I:
+	case IGC_DEV_ID_I220_V:
+	case IGC_DEV_ID_I225_K:
 		mac->type = igc_i225;
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 9a338fbf671c..abb2d72911ff 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -18,6 +18,9 @@
 
 #define IGC_DEV_ID_I225_LM			0x15F2
 #define IGC_DEV_ID_I225_V			0x15F3
+#define IGC_DEV_ID_I225_I			0x15F8
+#define IGC_DEV_ID_I220_V			0x15F7
+#define IGC_DEV_ID_I225_K			0x3100
 
 #define IGC_FUNC_0				0
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9ffe71424ece..e5114bebd30b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -36,6 +36,9 @@ static const struct igc_info *igc_info_tbl[] = {
 static const struct pci_device_id igc_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_LM), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_V), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_I), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I220_V), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K), board_base },
 	/* required last entry */
 	{0, }
 };
-- 
2.21.0

