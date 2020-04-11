Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE961A5B4A
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgDKXtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbgDKXE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25643214D8;
        Sat, 11 Apr 2020 23:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646269;
        bh=zyDu7THscQGIMNXG8JLjanNzlSD/bT1YdgGk65oZU9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tUlyzXPmnpSZt7di863bQg5TuuZh+MF0b5fYoHfwX7mxQVKTISUsMwqf32JiL6zE
         +WeaTwB7IkQowNhFiqpGigHPTznh8iBuO4xQJ4p89o7PGIHrIjVSHtwvCIcraLvKE9
         0dg9SEQOCpLpPFW+rdf324K2RclmN8UiQo+EqnJs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 034/149] net: phylink: Add missing Backplane speeds
Date:   Sat, 11 Apr 2020 19:01:51 -0400
Message-Id: <20200411230347.22371-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit c580165ffbf24fbda5c42de269021766911221f4 ]

USXGMII also supports these missing backplane speeds.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6e66b8e77ec7b..030206be10d8a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -308,11 +308,13 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 1000baseT_Half);
 			phylink_set(pl->supported, 1000baseT_Full);
 			phylink_set(pl->supported, 1000baseX_Full);
+			phylink_set(pl->supported, 1000baseKX_Full);
 			phylink_set(pl->supported, 2500baseT_Full);
 			phylink_set(pl->supported, 2500baseX_Full);
 			phylink_set(pl->supported, 5000baseT_Full);
 			phylink_set(pl->supported, 10000baseT_Full);
 			phylink_set(pl->supported, 10000baseKR_Full);
+			phylink_set(pl->supported, 10000baseKX4_Full);
 			phylink_set(pl->supported, 10000baseCR_Full);
 			phylink_set(pl->supported, 10000baseSR_Full);
 			phylink_set(pl->supported, 10000baseLR_Full);
-- 
2.20.1

