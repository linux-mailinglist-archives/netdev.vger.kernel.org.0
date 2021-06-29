Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67003B6CD4
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhF2DNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:13:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:51165 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231925AbhF2DNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 23:13:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="187762082"
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="187762082"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 20:10:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="558597311"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2021 20:10:32 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, tee.min.tan@intel.com,
        michael.wei.hong.sit@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com
Subject: [PATCH net-next V2 2/3] stmmac: intel: Enable PHY WOL option in EHL
Date:   Tue, 29 Jun 2021 11:08:58 +0800
Message-Id: <20210629030859.1273157-3-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629030859.1273157-1-pei.lee.ling@intel.com>
References: <20210629030859.1273157-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable PHY Wake On LAN in Intel EHL Intel platform.
PHY Wake on LAN option is enabled due to
Intel EHL Intel platform is designed for
PHY Wake On LAN but not MAC Wake On LAN.

Signed-off-by: Ling Pei Lee <pei.lee.ling@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2ecf93c84b9d..73be34a10a4c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -567,6 +567,7 @@ static int ehl_common_data(struct pci_dev *pdev,
 	plat->rx_queues_to_use = 8;
 	plat->tx_queues_to_use = 8;
 	plat->clk_ptp_rate = 200000000;
+	plat->use_phy_wol = 1;
 
 	plat->safety_feat_cfg->tsoee = 1;
 	plat->safety_feat_cfg->mrxpee = 1;
-- 
2.25.1

