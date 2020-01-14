Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BB513AE85
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgANQJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:09:41 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40740 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728879AbgANQJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:09:39 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8D9B4C0623;
        Tue, 14 Jan 2020 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579018178; bh=SATy7ndJEIOBEqXRG+bt0KtbNZXEPfoL4GDzHGjf0uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=C8wENoLnQk0kfxeOxzbHVodoBqbIP2P0Gm53bCX8t5qxrIWoSloaUxjR6/I/faQ6O
         sLvH0mEREQo57rWGgh71HGdo1+VWns9oo9TsUlzuM3jIUy+smkOb8Fn+USgRq/CBOR
         reWDvENZ1mK1v/LA6ObAD1cn7+AdlwYnvLQVjjwXpYQNlRtNzM2Igc9S6OCHjGqyZU
         5Ftk2G+EpcTsMx4UvzCeyb1GeWsEjr/55B8wJWLtDFnClg558bSVPkT/nVDEjdODYx
         lruSdDM8zkrcyAF4ytaoJpJjD2v7T3QRiiiqAOe0GoCQxGHuZ8uFWCL+35+PVyDiEg
         pkwv2M5FzZClA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 28468A006C;
        Tue, 14 Jan 2020 16:09:35 +0000 (UTC)
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH net 2/4] net: stmmac: selftests: Mark as fail when received VLAN ID != expected
Date:   Tue, 14 Jan 2020 17:09:22 +0100
Message-Id: <2d9e75a94a3e4c120ff7e2135c6f0976ab9d0708.1579017787.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1579017787.git.Jose.Abreu@synopsys.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1579017787.git.Jose.Abreu@synopsys.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the VLAN ID does not match the expected one it means filter failed
in HW. Fix it.

Fixes: 94e18382003c ("net: stmmac: selftests: Add selftest for VLAN TX Offload")
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
Cc: Alexey Brodkin <abrodkin@synopsys.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-snps-arc@lists.infradead.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 6516d65e84b8..7edee3c87ac9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -853,8 +853,12 @@ static int stmmac_test_vlan_validate(struct sk_buff *skb,
 	if (tpriv->vlan_id) {
 		if (skb->vlan_proto != htons(proto))
 			goto out;
-		if (skb->vlan_tci != tpriv->vlan_id)
+		if (skb->vlan_tci != tpriv->vlan_id) {
+			/* Means filter did not work. */
+			tpriv->ok = false;
+			complete(&tpriv->comp);
 			goto out;
+		}
 	}
 
 	ehdr = (struct ethhdr *)skb_mac_header(skb);
-- 
2.7.4

