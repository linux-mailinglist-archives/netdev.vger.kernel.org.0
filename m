Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161B991275
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfHQSzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:55:01 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:53942 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726082AbfHQSzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:55:00 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B5101C0051;
        Sat, 17 Aug 2019 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1566068100; bh=R7aF5EjeHRaz3V0jYhX81XQ4Vx/vUvia+WkrllGMdp8=;
        h=From:To:Cc:Subject:Date:From;
        b=klHGs7Wt4qpN//vshsoyUFv7c/QKb7AgVf1s6U8uNN+Lii5AyjIsgob+26b5x3FtC
         WqL969hl0Bgb694G7TZQRHfkG4EH9C5tSVLfCncajH2KwUWZjbgSTmuLrKI/IeGXTx
         MrS/DcUZWFe4QlakUt/vrfrdIh6JclcuaChfJs9Jc+hCIRVX9m5s9iJ0rQd+DvZFCc
         Zn3tyRG4Vt0zA0/3kK0E/x4R3tarPoxpkwtQzW2Yw2ayFH0/mvR7tjb5P87vN3fAo4
         jzZAlNjZkuctooeqV1aFaIMRxMo7V41PBXqgJBNqphUbI/MQseI6oDyxhEDb0r4LAV
         C3xuQ+WlPUfGQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 60C4CA0057;
        Sat, 17 Aug 2019 18:54:53 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 00/12] net: stmmac: Improvements for -next
Date:   Sat, 17 Aug 2019 20:54:39 +0200
Message-Id: <cover.1566067802.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple of improvements for -next tree. More info in commit logs.

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

Jose Abreu (12):
  net: stmmac: Get correct timestamp values from XGMAC
  net: stmmac: Prepare to add Split Header support
  net: stmmac: xgmac: Correctly return that RX descriptor is not last
    one
  net: stmmac: Add Split Header support and enable it in XGMAC cores
  net: stmmac: Add a counter for Split Header packets
  net: stmmac: dwxgmac: Add Flexible PPS support
  net: stmmac: Add ethtool register dump for XGMAC cores
  net: stmmac: Add support for SA Insertion/Replacement in XGMAC cores
  net: stmmac: selftests: Add tests for SA Insertion/Replacement
  net: stmmac: xgmac: Add EEE support
  net: stmmac: Add support for VLAN Insertion Offload
  net: stmmac: selftests: Add selftest for VLAN TX Offload

 drivers/net/ethernet/stmicro/stmmac/common.h       |  10 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  56 ++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 182 ++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |  85 +++++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  31 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  30 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  10 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  24 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 286 ++++++++++++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 194 +++++++++++++-
 10 files changed, 817 insertions(+), 91 deletions(-)

-- 
2.7.4

