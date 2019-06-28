Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE947594E4
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfF1H3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:29:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:48020 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbfF1H3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 50DA7C0BF4;
        Fri, 28 Jun 2019 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706965; bh=7+tT87aSu+blEqvLvV7U9GKQj6WhSqKHVNxkfVuOqns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=CAD71Sci7+fmBoozvKGyAZ1hh8sViFlOZ5KDH3T7tV2LnsE18wTnRjyLH32lRh57S
         uzV9aBNyIEI/bP8ohaUuO+mNjG0s8pt2EutCCRBJqLw5NjXcZwCabNjibK2njgPhhC
         DMZZvCxu+a5WXeub7sUltNI/bx3KyKaSrHZ7OcgjTQNZVdU2Oa6ubvkqwN14q9GZo2
         eXkqVUy3Gh7lOlkd6Frm5U2RJMNa9s4J6gemcW+Iww3qxMn/HUUqR8cZZmu65++4oG
         Vu//UM0LP/euilEN7FrRYukRTrqHEcdvIRZfoG7tB0YMZPtderZ99hNbXTMOisX21p
         wiVQkODweBuMw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 14577A0242;
        Fri, 28 Jun 2019 07:29:24 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 054F83E96D;
        Fri, 28 Jun 2019 09:29:24 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 10/10] net: stmmac: Update Kconfig entry
Date:   Fri, 28 Jun 2019 09:29:21 +0200
Message-Id: <68d80ab64c72f881d25cbb2691f10b1933292da6.1561706801.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We support more speeds now. Update the Kconfig entry.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index c43e2da4e7e3..2acb999b7f63 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config STMMAC_ETH
-	tristate "STMicroelectronics 10/100/1000/EQOS Ethernet driver"
+	tristate "STMicroelectronics 10/100/1000/EQOS/2500/5000/10000 Ethernet driver"
 	depends on HAS_IOMEM && HAS_DMA
 	select MII
 	select PHYLINK
-- 
2.7.4

