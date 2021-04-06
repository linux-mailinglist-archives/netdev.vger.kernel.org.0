Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F2B355EA0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344198AbhDFWMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344109AbhDFWMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD13F613D5;
        Tue,  6 Apr 2021 22:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747134;
        bh=ph8C8CczmaefOw2MWVIpV67Ei+uohFYTsjx7Q69PAXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqXENkP6VVY6Jj3aj65SRuS1CBOT0YvrKDOOHpMZs93d5B/mrKrafOcLqtHbkpUqz
         09ZNQjl5+V3lx4kiLzd8JqIM0i3TnRhqpdhj1hKu2MmZqHg/uYYQH6SNA/P/vqkxKy
         2N+khGtg02iHXAAlxlqjbVAYVwQ2hzhliRk3rJxnTM2kqMsquliirKeidiQ0+Q55Ob
         dDVuTckq/e7DXYDBBXzMoDmGvAvGNdFZSBKX42SJ4dOBZivRvC5qcrwffGsELlJdDT
         iqo1DPLJfjc1sahK4vMFUnw2Fi/ekBD5CBGNqJGUfXzSWFC5KBcmhT3y3/Nb1f/7u8
         fs1yyev1leZSw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 17/18] net: phy: marvell10g: change module description
Date:   Wed,  7 Apr 2021 00:11:06 +0200
Message-Id: <20210406221107.1004-18-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This module supports not not only Alaska X, but also Alaska M.

Change module description appropriately.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 6269b9041180..8c3ec67c83cc 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -1058,5 +1058,5 @@ static struct mdio_device_id __maybe_unused mv3310_tbl[] = {
 	{ },
 };
 MODULE_DEVICE_TABLE(mdio, mv3310_tbl);
-MODULE_DESCRIPTION("Marvell Alaska X 10Gigabit Ethernet PHY driver (MV88X3310)");
+MODULE_DESCRIPTION("Marvell Alaska X/M multi-gigabit Ethernet PHY driver");
 MODULE_LICENSE("GPL");
-- 
2.26.2

