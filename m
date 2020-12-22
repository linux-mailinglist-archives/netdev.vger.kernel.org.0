Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5964F2E0D0D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgLVQF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:05:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:36057 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbgLVQF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 11:05:29 -0500
IronPort-SDR: eznndMjYX+qoacIH4nWjHWtysxO3iNvKdv7f1yMxP5WOIifUt1EPE2A5uahiwdA8BtKq3kn3xY
 pziG69doPzzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9842"; a="194326427"
X-IronPort-AV: E=Sophos;i="5.78,439,1599548400"; 
   d="scan'208";a="194326427"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 08:04:48 -0800
IronPort-SDR: Ub16STipXKVbct2Ux+UQzCGb8H8E0ZRhshgqs0PUyl0ilggYSReuBHn6mOzbH2JHcHSkyssSQE
 5kN9o289/c6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,439,1599548400"; 
   d="scan'208";a="492272029"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.114])
  by orsmga004.jf.intel.com with ESMTP; 22 Dec 2020 08:04:44 -0800
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     noor.azura.ahmad.tarmizi@intel.com, weifeng.voon@intel.com
Subject: [PATCH net-next v1] stmmac: intel: Add PCI IDs for TGL-H platform
Date:   Wed, 23 Dec 2020 00:03:37 +0800
Message-Id: <20201222160337.30870-1-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

Add TGL-H PCI info and PCI IDs for the new TSN Controller to the list
of supported devices.

Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 55dbb1a930da..d3608db576f7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -723,6 +723,8 @@ static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID		0x4bb0
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID		0x4bb1
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5_ID	0x4bb2
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0_ID		0x43ac
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1_ID		0x43a2
 #define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID		0xa0ac
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
@@ -737,6 +739,8 @@ static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G_ID, &ehl_pse1_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5_ID, &ehl_pse1_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0_ID, &tgl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1_ID, &tgl_sgmii1g_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
-- 
2.17.1

