Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77E2AED5F
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbfIJOld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:41:33 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:42888 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732145AbfIJOlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 10:41:32 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4F355C2B07;
        Tue, 10 Sep 2019 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568126491; bh=Tub4nxbeU4nreRv8Psll6baSDgasdHP9Jdi2H3FUuM0=;
        h=From:To:Cc:Subject:Date:From;
        b=C2o6PJo4/Gf/7lp2JOLM+WEG1MfCOq73flr31Z7C9+k5tPz3ahpk3X+Jdiw3i1fn9
         imLq+yTn/PJJlWrTdXHoTa/8aus7nXy5gjO+RrI80mGiwkgCCXASzT7qN2WCdjCmue
         OfxO8I9cv2dqEbJBlSWxOiLrHu6RW1A/4GkyB+sQraKB0raSVjXXKSPSvCrFaIga4B
         y9BuCLwa04cyaUqPgnY6ADYrMAWgEQzFctN1M50DadnTDXTeUkweuOTpiwzxUdd5pr
         rfMt62re75WqJhRakCtdR1TKDAOFu4McgBvPV74oFBSIxBzoQgSa7LdCuXxvsneLn/
         kptY6jHGqPW/g==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B7508A0057;
        Tue, 10 Sep 2019 14:41:28 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: stmmac: Improvements for -next
Date:   Tue, 10 Sep 2019 16:41:21 +0200
Message-Id: <cover.1568126224.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Misc patches for -next. It includes:
 - Two fixes for features in -next only
 - New features support for GMAC cores (which includes GMAC4 and GMAC5)

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

Jose Abreu (6):
  net: stmmac: Prevent divide-by-zero
  net: stmmac: Add VLAN HASH filtering support in GMAC4+
  net: stmmac: xgmac: Reinitialize correctly a variable
  net: stmmac: Add support for SA Insertion/Replacement in GMAC4+
  net: stmmac: Add support for VLAN Insertion Offload in GMAC4+
  net: stmmac: ARP Offload for GMAC4+ Cores

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       | 23 +++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  | 79 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c | 43 ++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.h |  9 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |  5 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  4 +-
 7 files changed, 162 insertions(+), 3 deletions(-)

-- 
2.7.4

