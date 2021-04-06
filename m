Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F157D35509B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245009AbhDFKNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:13:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:34228 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhDFKNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 06:13:10 -0400
IronPort-SDR: nCyTWj2Ehr8rwnLIfxCZ2yKZkrDVjzjkYOfPvCvklPPq7RZNozTvpxGsD30UmTuMdLSx6Lz1GH
 PENne2YBV6Ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="193074139"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="193074139"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 03:12:55 -0700
IronPort-SDR: R+yYM16m9/NbCWKhvHzUaI9MU3w8pkApAg5iD1qfMiu0txZNazdqeCxogiUvOl/GuF952M6Yz+
 mBCmAm9KB9tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="380863979"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 06 Apr 2021 03:12:52 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C1FE4202; Tue,  6 Apr 2021 13:13:07 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH net-next v1 1/1] stmmac: intel: Drop duplicate ID in the list of PCI device IDs
Date:   Tue,  6 Apr 2021 13:13:06 +0300
Message-Id: <20210406101306.59162-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PCI device IDs are defined with a prefix PCI_DEVICE_ID.
There is no need to repeat the ID part at the end of each definition.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 60 +++++++++----------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 3d9a57043af2..7f0ce373a63d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1053,41 +1053,41 @@ static int __maybe_unused intel_eth_pci_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
 			 intel_eth_pci_resume);
 
-#define PCI_DEVICE_ID_INTEL_QUARK_ID			0x0937
-#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID		0x4b30
-#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID		0x4b31
-#define PCI_DEVICE_ID_INTEL_EHL_SGMII2G5_ID		0x4b32
+#define PCI_DEVICE_ID_INTEL_QUARK		0x0937
+#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G		0x4b30
+#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G		0x4b31
+#define PCI_DEVICE_ID_INTEL_EHL_SGMII2G5	0x4b32
 /* Intel(R) Programmable Services Engine (Intel(R) PSE) consist of 2 MAC
  * which are named PSE0 and PSE1
  */
-#define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G_ID		0x4ba0
-#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G_ID		0x4ba1
-#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII2G5_ID	0x4ba2
-#define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID		0x4bb0
-#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID		0x4bb1
-#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5_ID	0x4bb2
-#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0_ID		0x43ac
-#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1_ID		0x43a2
-#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID		0xa0ac
-#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_0_ID		0x7aac
-#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_1_ID		0x7aad
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G	0x4ba0
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G	0x4ba1
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII2G5	0x4ba2
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G	0x4bb0
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G	0x4bb1
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5	0x4bb2
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0	0x43ac
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1	0x43a2
+#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G		0xa0ac
+#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_0	0x7aac
+#define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_1	0x7aad
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
-	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII2G5_ID, &ehl_sgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_RGMII1G_ID, &ehl_pse0_rgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII1G_ID, &ehl_pse0_sgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII2G5_ID, &ehl_pse0_sgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_RGMII1G_ID, &ehl_pse1_rgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G_ID, &ehl_pse1_sgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5_ID, &ehl_pse1_sgmii1g_info) },
-	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_phy0_info) },
-	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0_ID, &tgl_sgmii1g_phy0_info) },
-	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1_ID, &tgl_sgmii1g_phy1_info) },
-	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_0_ID, &adls_sgmii1g_phy0_info) },
-	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_1_ID, &adls_sgmii1g_phy1_info) },
+	{ PCI_DEVICE_DATA(INTEL, QUARK, &quark_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G, &ehl_rgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G, &ehl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII2G5, &ehl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_RGMII1G, &ehl_pse0_rgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII1G, &ehl_pse0_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII2G5, &ehl_pse0_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_RGMII1G, &ehl_pse1_rgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G, &ehl_pse1_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5, &ehl_pse1_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G, &tgl_sgmii1g_phy0_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0, &tgl_sgmii1g_phy0_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1, &tgl_sgmii1g_phy1_info) },
+	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_0, &adls_sgmii1g_phy0_info) },
+	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_1, &adls_sgmii1g_phy1_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
-- 
2.30.2

