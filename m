Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1197482475
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfHESBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:01:38 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:56184 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728701AbfHESBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:01:34 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D7318C0A63;
        Mon,  5 Aug 2019 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565028094; bh=nqhZWX5HPwhPCii0Zhd4dUGJjfCgRX6Yf5XeDcT+/o8=;
        h=From:To:Cc:Subject:Date:From;
        b=l4I75AHm/SJ9oBzK+gBfHPyw3YMHqHCWoULSaaidixeYuSY5SAXeU1KF5sEqjL4T/
         oh5TPtWhMaYJi3jonEjcTwxdfK+Xqso5oqtg9ePR3iYXyqWkEbbdIjEPYSkDyEQWUD
         rSpXEOImIVIghMKbiCx+uBwpcWjhzbtsRDfPLNx0HwEWaZCEN07JLpMjqgw3Dgtc5P
         af4Jiy9C33/2enfl3Hwdt6LmGg+SXrZUdRrftux8SfqTvFnmyDgep9MSglxW5O332V
         oFXKoGbNPTEsibJI3LKG5A1FLScDiFSf2h+6bTCMoixudmbmdjV0XKJYE7pab7mL9N
         5whjabwAfljeQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A600CA005D;
        Mon,  5 Aug 2019 18:01:31 +0000 (UTC)
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
Subject: [PATCH net-next 00/10] net: stmmac: Misc improvements for XGMAC (Part 1 of 3)
Date:   Mon,  5 Aug 2019 20:01:13 +0200
Message-Id: <cover.1565027782.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Breaking down the previous 26 patch series into 3 series ]

[ This series depend on 3caa61c20875 ("net: stmmac: Sync RX Buffer upon allocation")
which is already in -net but not -next ]

Misc improvements for -next which adds new features in XGMAC cores.

More info in commit logs.

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

Jose Abreu (10):
  net: stmmac: xgmac: Fix XGMAC selftests
  net: stmmac: xgmac: Implement MMC counters
  net: stmmac: Fix issues when number of Queues >= 4
  net: stmmac: xgmac: Implement set_mtl_tx_queue_weight()
  net: stmmac: xgmac: Implement tx_queue_prio()
  net: stmmac: Implement RSS and enable it in XGMAC core
  net: stmmac: selftests: Add RSS test
  net: stmmac: Implement VLAN Hash Filtering in XGMAC
  net: stmmac: selftests: Add test for VLAN and Double VLAN Filtering
  net: stmmac: Implement Safety Features in XGMAC core

 drivers/net/ethernet/stmicro/stmmac/common.h       |   6 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   4 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  66 ++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 502 ++++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |  29 ++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   7 +
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  17 +
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |   9 +
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     | 192 ++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  11 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  81 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 117 ++++-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 224 +++++++++
 include/linux/stmmac.h                             |   1 +
 15 files changed, 1252 insertions(+), 18 deletions(-)

-- 
2.7.4

