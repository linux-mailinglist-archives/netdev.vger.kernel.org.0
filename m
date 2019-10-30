Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3F3E9EF7
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfJ3P3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:29:04 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:39120 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727039AbfJ3P3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:29:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 32231C0DE4;
        Wed, 30 Oct 2019 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572449343; bh=66e/bYyhcGrAFctAHp4076TE/JEaWIo4me4coBNTLE4=;
        h=From:To:Cc:Subject:Date:From;
        b=UisusYJw9jOvIsXZkfJxzPB8s+FfMXeBNTap3qWNDjaLtsNIAJo3ZDActVJ3vMkg/
         so418MsACo0KkbTR3ZntPXQF9s1g8LrZ+tWzFSWxmJqJ1qJ26AM5hqtgJR20LaQAKW
         dVekW/7G5jUlyAVeIi+xEGsty4fYBzi3Zs423KPVO4bugjqj45dSH8V5YhAI52lAN6
         EtN1OntgLkWJBn3zOop8FBT0QkGuYsNvoi1JwweQoBlp1p+F8ZWfKtfXK2NIXNVEgO
         sYJDAMgmfZ+QSEi15Iu9kV0C2woDau+Pt94hGEpdFPB3jxiUQLYSzL+TyL2YthpRN7
         ZOXfxvQLH8tOg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 51946A0057;
        Wed, 30 Oct 2019 15:28:56 +0000 (UTC)
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
Subject: [PATCH net-next 0/3] net: stmmac: Improvements for -next
Date:   Wed, 30 Oct 2019 16:28:47 +0100
Message-Id: <cover.1572449009.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc improvements for stmmac.

Patch 1/3, adds the support for Split Header feature in GMAC4+ cores. This
was already available for XGMAC and now with this change it is supported in
all relevant cores.

Patch 2/3, adds the support for C45 MDIO callbacks in XGMAC cores.

Patch 3/3, removes the speed dependency in TC CBS callbacks because XGMAC3
supports CBS feature at speeds up to 10Gbps

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

Jose Abreu (3):
  net: stmmac: gmac4+: Add Split Header support
  net: stmmac: xgmac: Add C45 PHY support in the MDIO callbacks
  net: stmmac: tc: Remove the speed dependency

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |  7 ++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c | 21 ++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   | 19 +++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  | 47 ++++++++++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  2 -
 7 files changed, 89 insertions(+), 9 deletions(-)

-- 
2.7.4

