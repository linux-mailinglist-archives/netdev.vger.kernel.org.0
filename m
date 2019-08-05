Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1706822CF
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfHEQp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:45:57 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:40092 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729302AbfHEQpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:45:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 67A76C015B;
        Mon,  5 Aug 2019 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565023530; bh=0LbPrLAJZPL+E0+EEkTDfdECwXLyTc0PWcn5jnubUI8=;
        h=From:To:Cc:Subject:Date:From;
        b=fwhulZuLa3ryglwiiwLjF4/2ithvclLv+FstYbrMDuZUUzbasLHK6bKffdBkzXJbw
         Bze7ohv14AR+/LgKzBrDhlrZ922jio5ql9f+PUa5FEcwYYyeAXs+QkqwOQr3/UQUBb
         hywH00ci3zmVycCrIu0L1pOeotaSjKBgV9l864aNVk2LgVEOzpRcrwGKi1EhLmzoUP
         qure26YhNg7npw16CSBy72d8V4vyNnmbY9G/beRv3rnFEipdd05UGN+VH2rafPGzT+
         WT9LOXYfKY/xU+TzcfDjPLJmNSAVOu/7dGib4K7dwl+sJoZTIaBIj94VkSxpryQzzU
         TG0wIbOb+vBpA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id CD08FA005D;
        Mon,  5 Aug 2019 16:45:25 +0000 (UTC)
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
Subject: [PATCH net-next 00/26] net: stmmac: Misc improvements for XGMAC
Date:   Mon,  5 Aug 2019 18:44:27 +0200
Message-Id: <cover.1565022597.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Jose Abreu (26):
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
  net: stmmac: Add Flexible RX Parser support in XGMAC
  net: stmmac: tc: Do not return a fragment entry
  net: stmmac: selftests: Add a selftest for Flexible RX Parser
  net: stmmac: Get correct timestamp values from XGMAC
  net: stmmac: Prepare to add Split Header support
  net: stmmac: xgmac: Correctly return that RX descriptor is not last
    one
  net: stmmac: Add Split Header support and enable it in XGMAC cores
  net: stmmac: dwxgmac: Add Flexible PPS support
  net: stmmac: Add ethtool register dump for XGMAC cores
  net: stmmac: Add a counter for Split Header packets
  net: stmmac: Add support for SA Insertion/Replacement in XGMAC cores
  net: stmmac: selftests: Add tests for SA Insertion/Replacement
  net: stmmac: xgmac: Add EEE support
  net: stmmac: Add support for VLAN Insertion Offload
  net: stmmac: selftests: Add selftest for VLAN TX Offload
  net: stmmac: selftests: Return proper error code to userspace

 drivers/net/ethernet/stmicro/stmmac/common.h       |  16 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   4 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 135 +++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 880 ++++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   | 118 ++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  41 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  47 ++
 drivers/net/ethernet/stmicro/stmmac/mmc.h          |   9 +
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     | 192 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  21 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   | 106 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 380 +++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 513 +++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   2 +-
 include/linux/stmmac.h                             |   1 +
 16 files changed, 2361 insertions(+), 108 deletions(-)

-- 
2.7.4

