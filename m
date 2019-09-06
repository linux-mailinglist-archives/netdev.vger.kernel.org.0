Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F9FAB35E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404583AbfIFHlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:41:31 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:33342 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391079AbfIFHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:41:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 23988C0E35;
        Fri,  6 Sep 2019 07:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567755688; bh=4FNcbwGO762eeiYuWoydSpxazMahLxkBYcFUNjeJ3so=;
        h=From:To:Cc:Subject:Date:From;
        b=QV3sTkQjRq3+DWj4SAq7M3ARw0wOD88Y820JB4aK6VQ3BqbtO+ozEBJg5jkZxP6ba
         3K3PfEsnZAFP8beQSbvbq4rYsxCaqGuqw8h9pPqMiS6RCdbZ0eax/vPBjpPQJO3fpn
         4GOoFgI8P87xZ6bFcQt0szF2m6kys4oWjegPndcukIUo4cRGrBYIT79WQrcuzC9ip9
         4+AT6uXZ1T2NKq8mP+IAI4DwvUSgoSG5aniE63bpRkwW+wF/luxd0JWIyWzZQsXLIu
         EiPm2rX5BcbHPhAqfeLgzesocBttjgJAAkBystKy36O3f9cHmcsjU3truRAWoxfcIF
         40D7xgWd5/dhw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 001F5A005C;
        Fri,  6 Sep 2019 07:41:25 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: stmmac: Improvements and fixes for -next
Date:   Fri,  6 Sep 2019 09:41:12 +0200
Message-Id: <cover.1567755423.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improvements and fixes for recently introduced features. All for -next tree.
More info in commit logs.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---

Jose Abreu (5):
  net: stmmac: selftests: Add missing checks for support of SA
  net: stmmac: selftests: Set RX tail pointer in Flow Control test
  net: stmmac: dwmac4: Enable RX Jumbo frame support
  net: stmmac: selftests: Add Split Header test
  net: stmmac: Limit max speeds of XGMAC if asked to

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |  3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  6 ---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 25 +++++----
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 60 ++++++++++++++++++++++
 4 files changed, 78 insertions(+), 16 deletions(-)

-- 
2.7.4

