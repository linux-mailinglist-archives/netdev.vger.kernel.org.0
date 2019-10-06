Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46211CD1A5
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 13:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfJFLR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 07:17:29 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:50002 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbfJFLR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 07:17:28 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 82F25C0374;
        Sun,  6 Oct 2019 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570360648; bh=tnWdGo9LoSdCZ4UfDy75YwxsYXeRpsko+ph8h48XVjw=;
        h=From:To:Cc:Subject:Date:From;
        b=FQMSCljtVSk3DUGXIYL5Y/rZoAhum7g7BKll/VBVchW6bd4uyIiPqizHt5Tz/H0Ox
         gkpXLUo9yOl4ZJlVsKbO+O0+n8C/XtkvBvzSE8HtymuTGVAp1C1FuaTmtDq+wi5cHG
         vDrovkxteOrYGKCOsRVEl0ruoRp7k4Zy+Uhqk3qerYbcOsu0ibRLniLQd128jBzi4Q
         ZIhze5AsgYQDM34Omxb6g8KKyFBRKzOI8xIZX1fRLPAQtTeQVrRYVILsKAN04NNwui
         fqdWgJGVi6CJBbDeTdmPI5gEa44mT/VPKiim9ybgfazEZmTkg13y+a87ypFVWTdqoO
         oiKNxSpv2IMAA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DF023A005D;
        Sun,  6 Oct 2019 11:17:19 +0000 (UTC)
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
Date:   Sun,  6 Oct 2019 13:17:11 +0200
Message-Id: <cover.1570360411.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improvements for -next. More info in commit logs.

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
  net: stmmac: Fallback to VLAN Perfect filtering if HASH is not
    available
  net: stmmac: selftests: Add tests for VLAN Perfect Filtering
  net: stmmac: Implement L3/L4 Filters in GMAC4+

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |  21 ++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  | 118 ++++++++++++++++++++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   1 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  17 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  18 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 114 +++++++++++++-------
 7 files changed, 245 insertions(+), 46 deletions(-)

-- 
2.7.4

