Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A898D36539D
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhDTHz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230201AbhDTHz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:55:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A11B3613AE;
        Tue, 20 Apr 2021 07:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618905295;
        bh=GPfB7RB4S4QXXlDwMzCffHDNv6dwcUFtqmtBs7e4EV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdW0PGaaKIG8eWcdLLjdxMQo01SZlDP/hXnMCRek9veNirMA8s87qOUGPGkJHDg6/
         8uM4BEIuc+KxPV/lNQyjf01CJyXqzl61qkEHjdOvpG8uok6twd1HZprZNXeBVK0e9t
         3/3WEjylFWXBrATZ3hEdM8MuS2NZJkh0YiCQx01a9+AxqhDxyKHo7S9PMFi/mGbP8l
         sUYrXcs2f7Oo7+Qb9VlbjedDnfX1lFgn6DJfGnNunVHVk8dOgyZPNtHyxK4TLf6DUf
         rNN+gGLVuoy68RFxXDqbmEcig66klA4OjozoeirSiPvE5Zl0USgbJ8bXv9ZS4z+TN0
         dOAOV0/4HFVug==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 4/5] net: dsa: mv88e6xxx: simulate Amethyst PHY model number
Date:   Tue, 20 Apr 2021 09:54:02 +0200
Message-Id: <20210420075403.5845-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210420075403.5845-1-kabel@kernel.org>
References: <20210420075403.5845-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amethyst internal PHYs also report empty model number in MII_PHYSID2.

Fill in switch product number, as is done for Topaz and Peridot.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 860dca41cf4b..9c4f8517c34b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3165,6 +3165,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 static const u16 family_prod_id_table[] = {
 	[MV88E6XXX_FAMILY_6341] = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
 	[MV88E6XXX_FAMILY_6390] = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
+	[MV88E6XXX_FAMILY_6393] = MV88E6XXX_PORT_SWITCH_ID_PROD_6393X,
 };
 
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
-- 
2.26.3

