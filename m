Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A888327D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfHFNQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:16:26 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:58054 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfHFNQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:16:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0CC85C21B9;
        Tue,  6 Aug 2019 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565097385; bh=Ab5jp3GsMXQWmVrZFrMXWKrOoJ32+iutiBB3NdSCy7U=;
        h=From:To:Cc:Subject:Date:From;
        b=PV/WBimuik8cDyALtkSnshvQukdpJgHBFPGuylY9CPMMZYPNIPKYj/PrY6y3KdbIn
         7+zJqksQXOsuQCb7qd30AAFIjyPTOK8A2wFol/Qb0prJBfKAeSfuaJ6agtDlyP7Qaf
         4H4k4GCqDRJf+Bw56ms3NoSOZ5TG/s8zTSwFxrEy9GBfeKJxXFk8z5U0nNa5SR+S7d
         jy8Rq/Ceum+0OgckWOgGJySMNMQ6CV1YcgE7gMdcS92NuHsg+JGzB3Jsejny0LyDYc
         /q8Zg4poIBGoFrKAzfLZxEP/nj87pFzhQ0wkzQLTIiJQVaBIjm9GTunXvv17P0l6d6
         b875KXfyAsAFQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DE4CBA0057;
        Tue,  6 Aug 2019 13:16:22 +0000 (UTC)
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
Subject: [PATCH net 0/3] net: stmmac: Fixes for -net
Date:   Tue,  6 Aug 2019 15:16:15 +0200
Message-Id: <cover.1565097294.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple of fixes for -net. More info in commit log.

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
  net: stmmac: xgmac: Fix XGMAC selftests
  net: stmmac: Fix issues when number of Queues >= 4
  net: stmmac: tc: Do not return a fragment entry

 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  4 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  7 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 87 +++++++++++++++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  2 +-
 4 files changed, 88 insertions(+), 12 deletions(-)

-- 
2.7.4

