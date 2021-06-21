Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0953AE65A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFUJsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:48:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:3842 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhFUJsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 05:48:16 -0400
IronPort-SDR: 5B/JDXYYSf0o71+ZcnZvrXXxTs5Z0JaqJAYBajWUrzY751VqYPmj9Q82QVVxTEVwYQci2r1edX
 YsdROkAwwKnA==
X-IronPort-AV: E=McAfee;i="6200,9189,10021"; a="194122115"
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="194122115"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 02:46:03 -0700
IronPort-SDR: 7AHo2x31FLcRLJxwRpcdGXHrLqvIGSoW2va7D+rASj9Rttp5HskP+Eza6RuFt3k39MPzfUITba
 /yYtJMVgFBKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="638720283"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2021 02:45:58 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com
Subject: [PATCH net-next V1 2/4] stmmac: intel: Enable PHY WOL option in EHL
Date:   Mon, 21 Jun 2021 17:45:34 +0800
Message-Id: <20210621094536.387442-3-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621094536.387442-1-pei.lee.ling@intel.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
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

