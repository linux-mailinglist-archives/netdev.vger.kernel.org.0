Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE0B3D513F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhGZBlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 21:41:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:37265 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhGZBlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 21:41:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10056"; a="192420752"
X-IronPort-AV: E=Sophos;i="5.84,269,1620716400"; 
   d="scan'208";a="192420752"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2021 19:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,269,1620716400"; 
   d="scan'208";a="515915887"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jul 2021 19:21:35 -0700
From:   mohammad.athari.ismail@intel.com
To:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mohammad.athari.ismail@intel.com,
        stable@vger.kernel.org
Subject: [PATCH net] net: stmmac: add est_irq_status callback function for GMAC 4.10 and 5.10
Date:   Mon, 26 Jul 2021 10:20:20 +0800
Message-Id: <20210726022020.5907-1-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

Assign dwmac5_est_irq_status to est_irq_status callback function for
GMAC 4.10 and 5.10. With this, EST related interrupts could be handled
properly.

Fixes: e49aa315cb01 ("net: stmmac: EST interrupts handling and error reporting")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 67ba083eb90c..b21745368983 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -1249,6 +1249,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
+	.est_irq_status = dwmac5_est_irq_status,
 	.fpe_configure = dwmac5_fpe_configure,
 	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
 	.fpe_irq_status = dwmac5_fpe_irq_status,
@@ -1300,6 +1301,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
 	.est_configure = dwmac5_est_configure,
+	.est_irq_status = dwmac5_est_irq_status,
 	.fpe_configure = dwmac5_fpe_configure,
 	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
 	.fpe_irq_status = dwmac5_fpe_irq_status,
-- 
2.17.1

