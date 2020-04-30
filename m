Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831A21BFF85
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgD3PDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:03:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:13786 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgD3PDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:03:01 -0400
IronPort-SDR: 6PrbYjDEVJqhtFwyqs6TQ22CV4Ciqn5rigzunq7oEagOO2u17hzcIvABiw3IiYVrGDahxZ+tkW
 hzx4A3rouDMg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 08:03:01 -0700
IronPort-SDR: dqG4KRPQFU9Qc9a2WzmSQZ45J+T/1G5zQYgjc7ufSPkmE65T/sQeTCoW55esxvCVgc/TgUQbd8
 V5raOPFoEAPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,336,1583222400"; 
   d="scan'208";a="293592056"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 30 Apr 2020 08:02:59 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 9A91F4B8; Thu, 30 Apr 2020 18:02:55 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 7/7] stmmac: intel: Place object in the Makefile according to the order
Date:   Thu, 30 Apr 2020 18:02:54 +0300
Message-Id: <20200430150254.34565-8-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
References: <20200430150254.34565-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the order for the platform drivers, i.e. generic object are going first.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 5a6f265bc540fb..f9d024d6b69b58 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -30,6 +30,6 @@ obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
 
-obj-$(CONFIG_DWMAC_INTEL) += dwmac-intel.o
-obj-$(CONFIG_STMMAC_PCI) += stmmac-pci.o
+obj-$(CONFIG_STMMAC_PCI)	+= stmmac-pci.o
+obj-$(CONFIG_DWMAC_INTEL)	+= dwmac-intel.o
 stmmac-pci-objs:= stmmac_pci.o
-- 
2.26.2

