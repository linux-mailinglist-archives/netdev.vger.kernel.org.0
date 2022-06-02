Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C395053B461
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbiFBHf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiFBHf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:35:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4418B38DA1;
        Thu,  2 Jun 2022 00:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654155327; x=1685691327;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=guW2S9dJLzjEzn/tbSdMDgpb8Z56ie57XqS2+J+2Pe0=;
  b=Kfe75JAQUym80SFUmkfz10vlF2w8CPYNk2ZrmGEazHs4ys9Zz7K2dhii
   4AL5Qh+UhvdUDi6J/UanqpJM5p8JDMteVqX7nQ1phnW0FHNWJawChMflK
   eQCvhTdjZRGfoCpbO4BVaCf68SAFYgQOPCpEdygpYQ2WGTr3Ym4PEgWEn
   22rFtaISo1+H1t8QQV9vGskNYLnZnVCFdGzT8Zv9mwHfzy67HDl5pPGr+
   PMBw7z+X9B/p8XkTyq11Hz4H76gu0ivr0x23j7sHbFQbT5tVDvgsUKueS
   wxDhuGoX90dwyrOwU2dPwU0EFZpr2ilNrB2poS4X/thGFsUBST6Xb3NXP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10365"; a="263495536"
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="263495536"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 00:35:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,270,1647327600"; 
   d="scan'208";a="606706523"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga008.jf.intel.com with ESMTP; 02 Jun 2022 00:35:21 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: [net-next 1/1] stmmac: intel: Add RPL-P PCI ID
Date:   Thu,  2 Jun 2022 15:35:07 +0800
Message-Id: <20220602073507.3955721-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PCI ID for Ethernet TSN Controller on RPL-P.

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 0b0be0898ac5..f9f80933e0c9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1161,6 +1161,7 @@ static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
 #define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_0	0x7aac
 #define PCI_DEVICE_ID_INTEL_ADLS_SGMII1G_1	0x7aad
 #define PCI_DEVICE_ID_INTEL_ADLN_SGMII1G	0x54ac
+#define PCI_DEVICE_ID_INTEL_RPLP_SGMII1G	0x51ac
 
 static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, QUARK, &quark_info) },
@@ -1179,6 +1180,7 @@ static const struct pci_device_id intel_eth_pci_id_table[] = {
 	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_0, &adls_sgmii1g_phy0_info) },
 	{ PCI_DEVICE_DATA(INTEL, ADLS_SGMII1G_1, &adls_sgmii1g_phy1_info) },
 	{ PCI_DEVICE_DATA(INTEL, ADLN_SGMII1G, &tgl_sgmii1g_phy0_info) },
+	{ PCI_DEVICE_DATA(INTEL, RPLP_SGMII1G, &tgl_sgmii1g_phy0_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
-- 
2.25.1

