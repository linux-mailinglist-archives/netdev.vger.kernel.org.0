Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B56355E91
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhDFWL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242471AbhDFWL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02732613D7;
        Tue,  6 Apr 2021 22:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747108;
        bh=lsPKnMie2e0T1Zwy/pWfYzquGPqebfg5m7AGMVjwbEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMynEwwWACF0lNW0EbZc9hLSorhsRwECsgtFe6aWFKfag4kYItcx73r5VyJop47p1
         1M6llbsd7Mk9dOpPdBpGWryEiM9/t35DfuH8PToyHJhG4iOwgj08N55JTYUjM+KqKM
         lcQY4IVBu1Wu25rzAoTU7axEZpY6rw+gtPNw2OzXEZKSXIsuItUTA2VNAbFXzxmatS
         E00OfYi4NfvoTYpWZS1EwH7Ke0jqrqcMH6G2neydWFvIaNxiZLvwb2KMJU2JX9S3WA
         Qz31vG5GYyiLzm6NkIc1ErcpjfRkCD5tyLValMVul5ZObRHTDnox6j7hur5cyd8beJ
         s80Xq2AMxCUCg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 02/18] net: phy: marvell10g: fix typo
Date:   Wed,  7 Apr 2021 00:10:51 +0200
Message-Id: <20210406221107.1004-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
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

