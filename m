Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55614D2793
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiCIDkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiCIDkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:40:02 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FE215F098;
        Tue,  8 Mar 2022 19:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646797144; x=1678333144;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MllVgczf0c1TNdA75U5Rm2oYU7fpnZ5DVIRsDr6nA24=;
  b=afi5f697LvRx9RyXCoHwm++1tcWhIA635AUwpP7pE6LgYP215GF2k5Dr
   aZjPgcENKRZIcNu8V5h6o6wNWiCNucgf4Olv/JxD3bMVDePK3x45oq/bE
   1aZ/Au2VZgb0G8tayRtH3ODw2GLLRAgwEKF8YBAaZWX+7qee70qe2zIzG
   J9EY3SHvM+0vGd5hYrXVIPI4IsraiEaz5MzmzR2ICXCZMj7KN65J+/Eah
   CNA+S+QYXdTWt3sKIIaqMOaGRTtRxwaQz4u4HAx2OJQDEnLEMUn3eE0Hb
   umuS1ZLqVEUItlgwKSVScNEN21a64ydMEMwFkXPSWHRzKzmkJ1LYWslCT
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="253706486"
X-IronPort-AV: E=Sophos;i="5.90,166,1643702400"; 
   d="scan'208";a="253706486"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 19:39:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,166,1643702400"; 
   d="scan'208";a="510345506"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga002.jf.intel.com with ESMTP; 08 Mar 2022 19:38:57 -0800
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH net-next 1/1] stmmac: intel: Add ADL-N PCI ID
Date:   Wed,  9 Mar 2022 11:34:15 +0800
Message-Id: <20220309033415.3370250-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PCI ID for Ethernet TSN Controller on ADL-N.

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 32ef3df4e266..63754a9c4ba7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1159,6 +1159,7 @@ static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
 #define PCI_DEVICE_ID_INTEL_TGL_SGMII1G		0xa0ac
 #define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_0	0x7aac
 #define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_1	0x7aad
+#define PCI_DEVICE_ID_INTEL_ADLN_SGMII1G	0x54ac
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, QUARK, &quark_info) },
@@ -1176,6 +1177,7 @@ static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, TGLH_SGMII1G_1, &tgl_sgmii1g_phy1_info) },
 	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_0, &adls_sgmii1g_phy0_info) },
 	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_1, &adls_sgmii1g_phy1_info) },
+	{ PCI_DEVICE_DATA(INTEL, ADLN_SGMII1G, &tgl_sgmii1g_phy0_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
-- 
2.25.1

