Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C91E3575E1
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356157AbhDGUZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356131AbhDGUYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2258611CC;
        Wed,  7 Apr 2021 20:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827038;
        bh=sbAz3qdE24QZw4jx1wPXMrKBFACJuPMLORHWu39dkY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkIPzfSWZXpx7N4yYOLPNWbBoO1NsYY3UZvbPGsv/jhXYCvRs4ALCqXpICiO460Ic
         sfyHV54WlwedsU991MA3EjJN/yAyNZCXSDsUNQxUdleX+XU8UL6PFf2/BogszVTgYL
         tZXwPuBI5pbYgLvectStQYiXo/QhA8qu9t6WZKlUU9Y181kgxoGscEN7u4v/XBQ/3m
         ttTGALFMB0rx5y9XoR7fiEmobQPRWggGX/CRkO48nNtb+wHcnQyWiCTn9NooUKb9Sa
         hZCa9EUZDGFiDAa6Ngwmx2hC4DXz2lKH851rQTLCuxl7bKMQzKwn1KohBbvZJMJF6D
         ezhw7e6XADuPg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 15/16] net: phy: marvell10g: change module description
Date:   Wed,  7 Apr 2021 22:22:53 +0200
Message-Id: <20210407202254.29417-16-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This module supports not only Alaska X, but also Alaska M.

Change module description appropriately.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index fcf4db4e5665..bbbc6ac8fa82 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -1075,5 +1075,5 @@ static struct mdio_device_id __maybe_unused mv3310_tbl[] = {
 	{ },
 };
 MODULE_DEVICE_TABLE(mdio, mv3310_tbl);
-MODULE_DESCRIPTION("Marvell Alaska X 10Gigabit Ethernet PHY driver (MV88X3310)");
+MODULE_DESCRIPTION("Marvell Alaska X/M multi-gigabit Ethernet PHY driver");
 MODULE_LICENSE("GPL");
-- 
2.26.2

