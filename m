Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EC03575D7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356110AbhDGUYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356086AbhDGUXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C186120E;
        Wed,  7 Apr 2021 20:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827017;
        bh=hFLQmhj0ezwVUZzvrcnF7suIFqWuj3BoQv+SuX2CxlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPMjgPgcNbbr1Jysj3NodqD2A7wFrIFbfSoyfphTo491eaGcb/KQ9kdR4o8xtOdYA
         4uwD9Jc+RfRx76Vj6uSxkoHKkpADUQT06k/cXaMz+9sl93kfjvylbuE8T1WSanlaFV
         ZxYGd3XJP3fRvCytZVRhkr5tWWpSLWiF4tWsHtcp2RSq94glknlsdxbQpTcsAX/uCu
         8Ey5R8zopo+DrXJhxn0msa/YEguvFYvqNnPPo2LzBitXBeZJo6hNxLvYQInJ8wW/4R
         7y/1SaUYkAhbJbDKcChr4nOgllh7BDoIo952gYsRT8DnASmgPdZ5ILY94NRquzXci/
         yruVBQ1Apu1ww==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 02/16] net: phy: marvell10g: fix typo
Date:   Wed,  7 Apr 2021 22:22:40 +0200
Message-Id: <20210407202254.29417-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This space should be a tab instead.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

