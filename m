Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE761981E0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgC3RF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:05:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:10809 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbgC3RFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 13:05:25 -0400
IronPort-SDR: bJrNy6Qh5lK3fUyAXzW9Ik2OE4bwCiAtwgRutojwLFltrbBpymf3cNSxmMa+5xCp142vABh2aN
 ZUjyeddv1n3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 10:05:25 -0700
IronPort-SDR: KML/ZVXpYdd0mp/sFUfG2OKlEDEegtiHVV2ziozQKms9EB1QVlXKPek04CFc7p/XZZfeRLhb/Y
 rjiakd21Epsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="294667253"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Mar 2020 10:05:22 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [net-next,v2, 3/3] net: stmmac: add EHL 2.5Gbps PCI info and PCI ID
Date:   Tue, 31 Mar 2020 01:05:12 +0800
Message-Id: <20200330170512.22240-4-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330170512.22240-1-weifeng.voon@intel.com>
References: <20200330170512.22240-1-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add EHL SGMII 2.5Gbps PCI info and PCI ID

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 12927571cee4..5419d4e478c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -537,30 +537,38 @@ static int __maybe_unused intel_eth_pci_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
 			 intel_eth_pci_resume);
 
-#define PCI_DEVICE_ID_INTEL_QUARK_ID		0x0937
-#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID	0x4b30
-#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID	0x4b31
+#define PCI_DEVICE_ID_INTEL_QUARK_ID			0x0937
+#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID		0x4b30
+#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID		0x4b31
+#define PCI_DEVICE_ID_INTEL_EHL_SGMII2G5_ID		0x4b32
 /* Intel(R) Programmable Services Engine (Intel(R) PSE) consist of 2 MAC
  * which are named PSE0 and PSE1
  */
-#define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G_ID	0x4ba0
-#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G_ID	0x4ba1
-#define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID	0x4bb0
-#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID	0x4bb1
-#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID	0xa0ac
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G_ID		0x4ba0
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G_ID		0x4ba1
+#define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII2G5_ID	0x4ba2
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID		0x4bb0
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID		0x4bb1
+#define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5_ID	0x4bb2
+#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID		0xa0ac
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII2G5_ID, &ehl_sgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_RGMII1G_ID,
 			  &ehl_pse0_rgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII1G_ID,
 			  &ehl_pse0_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII2G5_ID,
+			  &ehl_pse0_sgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_RGMII1G_ID,
 			  &ehl_pse1_rgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G_ID,
 			  &ehl_pse1_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5_ID,
+			  &ehl_pse1_sgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_pci_info) },
 	{}
 };
-- 
2.17.1

