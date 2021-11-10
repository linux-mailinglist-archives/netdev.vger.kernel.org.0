Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA6344C88A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhKJTKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhKJTKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:10:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FE5E6117A;
        Wed, 10 Nov 2021 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636571243;
        bh=w8cQj8Xef1Oh87M1Z22c1qsxYss2IbmH3JBYGxMtkMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fT6ZrsEuT/Gb9BXYCKoHiW8SLLpPZ7SF6lcM1EimDRIJhIV7ZHCkg1gyXOZMsL5s0
         dKVnVshiz0gGsZpEtCAycclZHGqzIRaVkZkfeEIlRORjP1C49qtUtx4CkvyNwRQ4as
         nj2RDU50xxSkge/iT0uH7EFTtsNp/WGWPj3p5D+DwsuFT6B7iZstLqIUQeFwqKiYAp
         hT4MtBbV/vj1mW0f+QskwKwgJ+hegXn3iGGkbZcNTKPZh5ED3OU6wsp5giUNRKY2Qb
         Uk3mXpDWNV6ZVcTFxpEUYFTgyyueXkvCsYQCIH5k0vyU2TOfusil/SdeQCHl7G5vEm
         7/XU74ZUaixBw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 6/8] net: phy: marvell10g: Use generic macro for supported interfaces
Date:   Wed, 10 Nov 2021 20:07:07 +0100
Message-Id: <20211110190709.16505-7-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110190709.16505-1-kabel@kernel.org>
References: <20211110190709.16505-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that phy.h defines macro DECLARE_PHY_INTERFACE_MASK(), use it
instead of DECLARE_BITMAP().

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index b6fea119fe13..d289641190db 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -148,7 +148,7 @@ struct mv3310_chip {
 };
 
 struct mv3310_priv {
-	DECLARE_BITMAP(supported_interfaces, PHY_INTERFACE_MODE_MAX);
+	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
 
 	u32 firmware_ver;
 	bool has_downshift;
-- 
2.32.0

