Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0322FB35B
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfKMPMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:12:22 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:51218 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726957AbfKMPMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:12:21 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 23FA0C0E95;
        Wed, 13 Nov 2019 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573657941; bh=BDukAyowAZk0E3mYeClr0pY7CNQPO/82dQMmXYYRMf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gGfeRKLy5OnSABPHpsoRpQ1oNQLxPjzk8yLPClR94JuQq7ZtODaNwFGxiGZrPST1Z
         bMDToDxnKjNzOlQXS+gAl0yW2nKZsibHY/mw7Bs+6JWXmNO4WT4nNnmucmBrR06ins
         AFufK4AZwNTmIrjsoA/ErdvDLVQrQi/RsNfMMCHiNLD/g1E5+KCyhzXHPzia2cTvpv
         u5Vs5zY/mB+9HOnrqiQ2HQXh41NpvtinEV1f5fEe/+O2PutWpUyLnDAOeTUJodw34o
         dGkwuIfVmrm1TTFdi3ERQ+3UKCSx0E5H9xZJhuBFXmsPSRLP9pmlS8UbmCycGaJZXe
         93tdULeu7rNpw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id CE630A0094;
        Wed, 13 Nov 2019 15:12:19 +0000 (UTC)
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
Subject: [PATCH net-next 6/7] net: stmmac: Tune-up default coalesce settings
Date:   Wed, 13 Nov 2019 16:12:07 +0100
Message-Id: <19636d3f37d1a202712e38c85f5a2d9bbbf8781c.1573657592.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tune-up the defalt coalesce settings for optimal values. This gives the
best performance in most of the use-cases.

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
 drivers/net/ethernet/stmicro/stmmac/common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 309ea12ea61f..b210e987a1db 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -253,8 +253,8 @@ struct stmmac_safety_stats {
 #define STMMAC_COAL_TX_TIMER	1000
 #define STMMAC_MAX_COAL_TX_TICK	100000
 #define STMMAC_TX_MAX_FRAMES	256
-#define STMMAC_TX_FRAMES	1
-#define STMMAC_RX_FRAMES	25
+#define STMMAC_TX_FRAMES	25
+#define STMMAC_RX_FRAMES	0
 
 /* Packets types */
 enum packets_types {
-- 
2.7.4

