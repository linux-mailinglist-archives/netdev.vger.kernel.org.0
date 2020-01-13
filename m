Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEEE1395C7
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgAMQYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:24:23 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:37152 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728838AbgAMQYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:24:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D730AC05E0;
        Mon, 13 Jan 2020 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578932661; bh=KfUuj7FkYk8P0Zny6DjZbC4vjoy9xayAvDkveS1KNOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=FOT706iIpRhlE72P2lXrfvKsHj0TCPxOaLl0XvoqfuZC8M6rM7QgWwhjl7rZ1gIiR
         39CBhuOCRCeQ+P7jDvHT1krqSxRo33bxC60r+qmHOocAHcwX5urv/H2K2KAQjPVPcq
         3gVzfDRQCkNgklbWpJCz7WXuyrBneYNS2y+XngbDWy4arR1/g/oOywloXh4G7o09n6
         x7iQyVfOeRBpqi15w5Q9/d/1UlQNiZlGgg9cegMKoLUDhEw6G4swp/e9nbqyqYRPWy
         lgP/Ucg1yzP794xrcWSFyoeh5+GqOfaFOQelL+KhIvlg2/mnmy9/ZxrJaMREg97DKT
         jyFdrL2pRGqbQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9A9BAA0073;
        Mon, 13 Jan 2020 16:24:19 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 6/8] net: stmmac: Add missing information in DebugFS capabilities file
Date:   Mon, 13 Jan 2020 17:24:14 +0100
Message-Id: <091120c35e058e48868dc81ef80ea0f3b0fac99c.1578932287.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578932287.git.Jose.Abreu@synopsys.com>
References: <cover.1578932287.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds more information regarding HW Capabilities in the corresponding
DebugFS file.

Changes from v2:
- Remove the TX/RX queues in use (Jakub)

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 43af4fc5ab8f..2738d97495e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4365,6 +4365,12 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
 		   priv->dma_cap.l3l4fnum);
 	seq_printf(seq, "\tARP Offloading: %s\n",
 		   priv->dma_cap.arpoffsel ? "Y" : "N");
+	seq_printf(seq, "\tEnhancements to Scheduled Traffic (EST): %s\n",
+		   priv->dma_cap.estsel ? "Y" : "N");
+	seq_printf(seq, "\tFrame Preemption (FPE): %s\n",
+		   priv->dma_cap.fpesel ? "Y" : "N");
+	seq_printf(seq, "\tTime-Based Scheduling (TBS): %s\n",
+		   priv->dma_cap.tbssel ? "Y" : "N");
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
-- 
2.7.4

