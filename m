Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A8D141137
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgAQS4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:56:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:5303 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgAQS4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:56:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 10:56:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="220819563"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2020 10:56:19 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 3/9] igc: Add SKU for i225 device
Date:   Fri, 17 Jan 2020 10:56:11 -0800
Message-Id: <20200117185617.1585693-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
References: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add support for blank NVM SKU

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 1 +
 drivers/net/ethernet/intel/igc/igc_hw.h   | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index db289bcce21d..5a506440560a 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -212,6 +212,7 @@ static s32 igc_get_invariants_base(struct igc_hw *hw)
 	case IGC_DEV_ID_I225_I:
 	case IGC_DEV_ID_I220_V:
 	case IGC_DEV_ID_I225_K:
+	case IGC_DEV_ID_I225_BLANK_NVM:
 		mac->type = igc_i225;
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index be7273c4b53f..90ac0e0144d8 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -21,6 +21,7 @@
 #define IGC_DEV_ID_I225_I			0x15F8
 #define IGC_DEV_ID_I220_V			0x15F7
 #define IGC_DEV_ID_I225_K			0x3100
+#define IGC_DEV_ID_I225_BLANK_NVM		0x15FD
 
 /* Function pointers for the MAC. */
 struct igc_mac_operations {
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1e27389bbda8..a8f8d279f3b1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -45,6 +45,7 @@ static const struct pci_device_id igc_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_I), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I220_V), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_BLANK_NVM), board_base },
 	/* required last entry */
 	{0, }
 };
-- 
2.24.1

