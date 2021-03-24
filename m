Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A90347E31
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbhCXQvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236628AbhCXQvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 12:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4476E61A0E;
        Wed, 24 Mar 2021 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616604660;
        bh=Bacl9JJMzatk4KzdOmXEDzAyI95dA+SMwbfhEruxhew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEDSLapH3cUR365tktMnbXDhzLbI2zQ80dwILu1/b4Q50ZrlWfmMpYESN+jlESSKt
         OAE5iZQnePar1fBBDnQQX0MF28KPcqxqUVe0AYkC1wQ9+bI49xkznzgKpjc6fTer9E
         5Cc5gRBlG9qzZG440glgbVCq13vPqzyqZh5EXY8VAAfTjSQDKLsIuDfEgle6Q1CGHd
         NGdey2otW0OHuoxZl03KkE3SeSXrTlJHy7pDyK7wX6rY2F1REXw8IkwKNXU7vNL5ml
         iy+Ti2suo+FZ68NLRGcEiAJu39r0l8XoDevE1tQMzEihtxHWQoilgE6o3Ul2gBD463
         jbVVJXZR2kowg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/7] net: phy: marvell10g: fix typo
Date:   Wed, 24 Mar 2021 17:50:18 +0100
Message-Id: <20210324165023.32352-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324165023.32352-1-kabel@kernel.org>
References: <20210324165023.32352-1-kabel@kernel.org>
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
index 96c081a7ec54..567e7900e5b8 100644
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

