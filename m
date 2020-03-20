Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F3D18D4D9
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgCTQso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:48:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:37380 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbgCTQsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 12:48:38 -0400
IronPort-SDR: YDeGa1cCyB/lgY9cbeiSO8QvE8Reya8vlTUxsP2WDjNUY1DpJrBbIFRT4SYR6Z41GgifEGAaPd
 guXwiNyRcWGQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 09:48:38 -0700
IronPort-SDR: m54e9tNE1nB1U8yyrGtg2WQ6hRjGv7+m6ndblkqxR83bfKTKJL/0S1X3+fSKWTNthWtDMc31vA
 wo+RtIK1NxzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="239275204"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga008.jf.intel.com with ESMTP; 20 Mar 2020 09:48:35 -0700
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
Subject: [net-next,v1, 3/3] net: stmmac: add EHL SGMII 2.5Gbps PCI info and PCI ID
Date:   Sat, 21 Mar 2020 00:48:25 +0800
Message-Id: <20200320164825.14200-4-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320164825.14200-1-weifeng.voon@intel.com>
References: <20200320164825.14200-1-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add EHL SGMII 2.5Gbps PCI info and PCI ID

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 3f0f7cc7342f..b4a18075e372 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -645,6 +645,7 @@ static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_pci_suspend, stmmac_pci_resume);
 #define PCI_DEVICE_ID_INTEL_QUARK_ID			0x0937
 #define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID		0x4b30
 #define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID		0x4b31
+#define PCI_DEVICE_ID_INTEL_EHL_SGMII2G5_ID		0x4b32
 #define PCI_DEVICE_ID_INTEL_EHL_PSE0_RGMII1G_ID		0x4ba0
 #define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII1G_ID		0x4ba1
 #define PCI_DEVICE_ID_INTEL_EHL_PSE0_SGMII2G5_ID	0x4ba2
@@ -660,6 +661,7 @@ static const struct pci_device_id stmmac_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII2G5_ID, &ehl_sgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_RGMII1G_ID,
 			  &ehl_pse0_rgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE0_SGMII1G_ID,
-- 
2.17.1

