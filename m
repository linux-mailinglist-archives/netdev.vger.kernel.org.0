Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F641B73FF
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgDXMXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgDXMXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8CCD2168B;
        Fri, 24 Apr 2020 12:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731024;
        bh=gQAWuW39xI8mn+xgNei4VJx/ZoOFJOfZegmSKlqk98g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWcsE9bpBBMu7ZCYyxSxBgRR4pPz9cMqUROZnobD9xyFDvj9F4S58NMrn/QOrHE54
         DTFAg4+Q3G9APLRr43h609sQXtSb3JyCbgKp/SNXxFS4hCNevrCD6X9CHWOr3ffmrE
         eP4aBN4fUNlT+6nnLpi4omQyEngyuzVwgWwFOsdU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atsushi Nemoto <atsushi.nemoto@sord.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 18/26] net: stmmac: socfpga: Allow all RGMII modes
Date:   Fri, 24 Apr 2020 08:23:15 -0400
Message-Id: <20200424122323.10194-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>

[ Upstream commit a7a0d6269652846671312b29992143f56e2866b8 ]

Allow all the RGMII modes to be used.  (Not only "rgmii", "rgmii-id"
but "rgmii-txid", "rgmii-rxid")

Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index e0212d2fc2a12..fa32cd5b418ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -241,6 +241,8 @@ static int socfpga_set_phy_mode_common(int phymode, u32 *val)
 	switch (phymode) {
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		*val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII;
 		break;
 	case PHY_INTERFACE_MODE_MII:
-- 
2.20.1

