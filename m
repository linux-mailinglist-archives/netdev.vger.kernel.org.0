Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23512137117
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgAJPX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:23:58 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:56084 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727866AbgAJPX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:23:58 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 54EBE4060D;
        Fri, 10 Jan 2020 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578669837; bh=YXcyxyil0lGkpQvMbPeFKs6Zw5fWZ1TPJ+83+aDSukc=;
        h=From:To:Cc:Subject:Date:From;
        b=LiDZcVgMNPYNpj8ZItMUc7By1O3X+Kf0pfyJ9pUPyJjxg662goHX4A8W8Epnwl0nh
         03GdcCOwwRaxbxeLNPTvtlpIN/WljR1OKmdetvow9Rk4cH3U2nN4lhXRJ+MTY13KE4
         vyjmTBgqaxRZrsGu79plinbaib6fudxjrLOMIoxGSp65+8aavDVISsYI2JLLNBN/lz
         H4XBubZejjwzaXw2q039iBCyyxuNSs8HEIfKR1foGfJtKeKCwi0oA6Z5lrZmkADNYG
         5I+WudyRal7y0sBBOssxKDZXqzerT+huCJc/cJZYVukn6XtRD0s4CHHWTFlRphaXYE
         rRCkdjsrdYzdA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 120B4A0061;
        Fri, 10 Jan 2020 15:23:56 +0000 (UTC)
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
Subject: [PATCH net 0/2] net: stmmac: Filtering fixes
Date:   Fri, 10 Jan 2020 16:23:51 +0100
Message-Id: <cover.1578669661.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two single fixes for the L3 and L4 filtering in stmmac.

1) Updates the internal status of RSS when disabling it in order to keep
internal driver status consistent.

2) Do not lets user add a filter if RSS is enabled because the filter will
not work correctly as RSS bypasses this mechanism.

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

Jose Abreu (2):
  net: stmmac: selftests: Update status when disabling RSS
  net: stmmac: tc: Do not setup flower filtering if RSS is enabled

 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c   | 20 ++++++++++++++------
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c      |  4 ++++
 2 files changed, 18 insertions(+), 6 deletions(-)

-- 
2.7.4

