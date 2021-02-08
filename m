Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D843134C3
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhBHOOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:14:34 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57514 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhBHOHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:07:20 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/20] net: stmmac: Discard dwmac1000_dma_ops declaration from dwmac100.h
Date:   Mon, 8 Feb 2021 17:03:33 +0300
Message-ID: <20210208140341.9271-13-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed it's redundant to have that variable declaration in the dwmac1000.h
header file since it's used in the hwif.c module only and declared in its
header together with the rest of the ops descriptors.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index b70d44ac0990..494e1d2f2971 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -329,5 +329,4 @@ enum rtc_control {
 #define GMAC_MMC_RX_CSUM_OFFLOAD   0x208
 #define GMAC_EXTHASH_BASE  0x500
 
-extern const struct stmmac_dma_ops dwmac1000_dma_ops;
 #endif /* __DWMAC1000_H__ */
-- 
2.29.2

