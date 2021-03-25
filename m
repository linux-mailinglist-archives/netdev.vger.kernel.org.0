Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACFE3492DF
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhCYNNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhCYNN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4925661A11;
        Thu, 25 Mar 2021 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678007;
        bh=lsPKnMie2e0T1Zwy/pWfYzquGPqebfg5m7AGMVjwbEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4/h/Kgg+49X55wDJo3Gvvryx8j+lsy4+bcKIFfvXx0hO4RarZfEDxXZiyIuCy2CV
         rkR+SJfbvELtQO9/JBFPj8lF9InqBUEfSuVICG9T3ODdJ4J9KgJrA5dbvFC0BAOXoq
         agkUr+foacQNdWtdojxroHoFcIsEhm0W+Ka2+YkGPe8lUVsEqimM/n0BLSoL4ZnHhu
         l4WLrjJEepeFyRQUh/3BHcJlgFlw/5D5iOeVrkOAZSSALlBG/4PNJRHER1+1E2AQdK
         1676B4gTPzVsRKhh/AL42rK4tMuFPBgEfufU7+yp9/PJwen1qVypJNbR3gvwAe7bV1
         zHEZyBPyFf8kw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 02/12] net: phy: marvell10g: fix typo
Date:   Thu, 25 Mar 2021 14:12:40 +0100
Message-Id: <20210325131250.15901-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This space should be a tab instead.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 9b514124af0d..f2f0da9717be 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -79,7 +79,7 @@ enum {
 	/* Vendor2 MMD registers */
 	MV_V2_PORT_CTRL		= 0xf001,
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
-	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
+	MV_V2_PORT_CTRL_PWRDOWN	= BIT(11),
 	MV_V2_PORT_CTRL_MACTYPE_MASK = 0x7,
 	MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH = 0x6,
 	/* Temperature control/read registers (88X3310 only) */
-- 
2.26.2

