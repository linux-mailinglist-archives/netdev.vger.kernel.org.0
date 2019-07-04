Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E1F5FA92
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfGDPE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:04:27 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:47088 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbfGDPE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 11:04:26 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 12782C263A;
        Thu,  4 Jul 2019 15:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562252666; bh=PAo9PIfhNcKwwl9Dq4k5dVtLOG+3Xoxeinoz/2G+cRY=;
        h=From:To:Cc:Subject:Date:From;
        b=fjCN0tWGG04dUAErtw3+lTfyoSI1bCYZ1W+tfumt497tAJeXlHTCvXjXWLxORtmi4
         yXfh0hm7HNGGtcQ6o1SUPI+r/oAFWW/WhzoIb7CCcmkrO2Z31MBMLv9QXfr60L0iFL
         V85QfjjBvyr1H7MZ39Yv7It51sh1IWofgDC6HtR2wSZ4m0lV+Ds04F2+hDJI1zZ2g0
         Sh00PHuMlY2A7OU4rDGocObLlvHj90HK+AICMmIRfFasQNWaabU1kRoolcmjRCVt5S
         JbZG9TSrg7HTFzM2F+63jh53vle+CRvMxIBK38p9Pdxjp7eO972wJ1w8HjYwABzYSh
         VmrsJ2wO+zWTA==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 81926A005D;
        Thu,  4 Jul 2019 15:04:23 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 2984E3FC5D;
        Thu,  4 Jul 2019 17:04:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 0/3] net: stmmac: Some improvements and a fix
Date:   Thu,  4 Jul 2019 17:04:11 +0200
Message-Id: <cover.1562252534.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some performace improvements (01/03 and 03/03) and a fix (02/03), all for -next.

Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>

Jose Abreu (3):
  net: stmmac: Implement RX Coalesce Frames setting
  net: stmmac: Fix descriptors address being in > 32 bits address space
  net: stmmac: Introducing support for Page Pool

 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   2 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  10 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  12 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 215 +++++++--------------
 12 files changed, 112 insertions(+), 172 deletions(-)

-- 
2.7.4

