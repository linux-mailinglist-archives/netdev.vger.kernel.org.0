Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F412C27B3C5
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1R7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:32952 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgI1R7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:23 -0400
IronPort-SDR: ZajFdlszykNtoweGuwo18vUeXw1UAcL4du37FGVNRZ9eRcB+1m29k6meS5ZqnfrL5h4OBhAYVw
 ErjqLyAc7VLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810264"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810264"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: E3BSi0G/nHU31d/Iadu1yCfmSjcD48wXrVcEDa0auVOlh/jM0maKYNS2agjKnTbozePFKmWyzG
 +kZJ33bMK4vA==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505376"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 03/15] igc: Add new device ID's
Date:   Mon, 28 Sep 2020 10:58:56 -0700
Message-Id: <20200928175908.318502-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add new device ID's for the next step of the silicon and
reflect i221 and i226 parts

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 5 +++++
 drivers/net/ethernet/intel/igc/igc_hw.h   | 5 +++++
 drivers/net/ethernet/intel/igc/igc_main.c | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index cc5a6cf531c7..fd37d2c203af 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -215,6 +215,11 @@ static s32 igc_get_invariants_base(struct igc_hw *hw)
 	case IGC_DEV_ID_I225_K2:
 	case IGC_DEV_ID_I225_LMVP:
 	case IGC_DEV_ID_I225_IT:
+	case IGC_DEV_ID_I226_LM:
+	case IGC_DEV_ID_I226_V:
+	case IGC_DEV_ID_I226_IT:
+	case IGC_DEV_ID_I221_V:
+	case IGC_DEV_ID_I226_BLANK_NVM:
 	case IGC_DEV_ID_I225_BLANK_NVM:
 		mac->type = igc_i225;
 		break;
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index b9fe51b91c47..6defdb8a31fe 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -24,6 +24,11 @@
 #define IGC_DEV_ID_I225_K2			0x3101
 #define IGC_DEV_ID_I225_LMVP			0x5502
 #define IGC_DEV_ID_I225_IT			0x0D9F
+#define IGC_DEV_ID_I226_LM			0x125B
+#define IGC_DEV_ID_I226_V			0x125C
+#define IGC_DEV_ID_I226_IT			0x125D
+#define IGC_DEV_ID_I221_V			0x125E
+#define IGC_DEV_ID_I226_BLANK_NVM		0x125F
 #define IGC_DEV_ID_I225_BLANK_NVM		0x15FD
 
 /* Function pointers for the MAC. */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3183150c7995..b46bc8ded836 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -47,6 +47,11 @@ static const struct pci_device_id igc_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_K2), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_LMVP), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_IT), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_LM), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_V), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_IT), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I221_V), board_base },
+	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I226_BLANK_NVM), board_base },
 	{ PCI_VDEVICE(INTEL, IGC_DEV_ID_I225_BLANK_NVM), board_base },
 	/* required last entry */
 	{0, }
-- 
2.26.2

