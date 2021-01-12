Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02562F3157
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbhALNSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389432AbhALM5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EBBC23129;
        Tue, 12 Jan 2021 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456158;
        bh=JhHkmBHJ/vjgN/AAPK9wad5MKz+neIePH2m0tWb8bxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbpbhGSS226KUuKKru28wo2NziNtkH7aFR6M/xvWy+hZyu2edMlx64fSrLSaPF5Vi
         Al6l7jsl+ZISSKMpkobBf32eJVh7QMTM3Q6IOvF8ayVrj9oG0VMIuyLqfRBNEoYzx1
         IDIovzm+2j/o3u44+f1tNG+TULu/cQr/7KEEWca3zzJnxMSoRFDWboX67c+mTClB5o
         Cr49nmn1e+oIQmBs4cQ7FK9RmpbsrRaXgPPeT+zywBM/cv9IBVOjN6kr4rvVT5Uhyp
         /svSE3MbU07YVwa33VC9NsD4FpradypxVuIXzbPymGKVbyEDlBgVox/shr0B5KkUW9
         XbtbY2zlvQ5+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 17/51] stmmac: intel: Add PCI IDs for TGL-H platform
Date:   Tue, 12 Jan 2021 07:54:59 -0500
Message-Id: <20210112125534.70280-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

[ Upstream commit 8450e23f142f629e40bd67afc8375c86c7fbf8f1 ]

Add TGL-H PCI info and PCI IDs for the new TSN Controller to the list
of supported devices.

Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Link: https://lore.kernel.org/r/20201222160337.30870-1-muhammad.husaini.zulkifli@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 81ee0a071b4e9..e5234bb02dafd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -725,6 +725,8 @@ static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_RGMII1G_ID		0x4bb0
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII1G_ID		0x4bb1
 #define PCI_DEVICE_ID_INTEL_EHL_PSE1_SGMII2G5_ID	0x4bb2
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_0_ID		0x43ac
+#define PCI_DEVICE_ID_INTEL_TGLH_SGMII1G_1_ID		0x43a2
 #define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID		0xa0ac
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
@@ -739,6 +741,8 @@ static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII1G_ID, &ehl_pse1_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, EHL_PSE1_SGMII2G5_ID, &ehl_pse1_sgmii1g_info) },
 	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_0_ID, &tgl_sgmii1g_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1_ID, &tgl_sgmii1g_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
-- 
2.27.0

