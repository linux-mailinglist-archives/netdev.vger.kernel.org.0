Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE681BE1BC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgD2Owo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:52:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:4275 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgD2Owm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:52:42 -0400
IronPort-SDR: WOm5g4Guf51RCwqJSCvFNh/D1WGqh6xc2PpByFcKbrKtzbHvBgQZLnEIx5e+z0pVYtaLVs0A0n
 i0Cvag95IBGQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:52:42 -0700
IronPort-SDR: x34GlmmegmbkgVWguM6jaXWpqQDIMIgHWm0mV6dvu0CUnZxEIyUY6rVnZ76sH3uBEhDVLdnMVH
 lXtIKFAI4g3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="294195609"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 29 Apr 2020 07:52:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id A5FD5425; Wed, 29 Apr 2020 17:52:34 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 6/6] stmmac: intel: Place object in the Makefile according to the order
Date:   Wed, 29 Apr 2020 17:52:33 +0300
Message-Id: <20200429145233.81943-6-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429145233.81943-1-andriy.shevchenko@linux.intel.com>
References: <20200429145233.81943-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the order for the platform drivers, i.e. generic object are going first.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: new patch
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

