Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248672F3077
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405187AbhALM6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405142AbhALM6W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B76C23132;
        Tue, 12 Jan 2021 12:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456264;
        bh=RWPYeWz3kPOiRzfDjlhXVD3DzEPHKpRO/Y29GmVKYrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WF+wdVgOOlmtR0iwp3TsWVcTm6o6oxT/bneoqXOtxn8MG8+pBgSsTnjC7Gpw8PWVB
         DKARsGMoc830GryAHVyzcUnx3VxDFmM882T7uFmqyX7yiXNnAk/2poR3ekREbwhMim
         TVMfiqinVv4JYgnDSmpd13mlVHsOpJyx1cbv62pJsTZtwH7QxfKwFaN3NCJV+NRenE
         GmgBBVYZMRX8aRRDUOa1pTdTK5nkBTAqzmXUZvpF7OoFx5a9fQz4dyYON0HcmweuaS
         5sBEBN24wzODc3cOUNDofZjrxEpHNWDB7QL3Y+nEc5Ed7kz4oj7HOqK9TMHx0VVhpG
         6FXlMhIOszrAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/16] net: ethernet: fs_enet: Add missing MODULE_LICENSE
Date:   Tue, 12 Jan 2021 07:57:22 -0500
Message-Id: <20210112125725.71014-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125725.71014-1-sashal@kernel.org>
References: <20210112125725.71014-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 445c6198fe7be03b7d38e66fe8d4b3187bc251d4 ]

Since commit 1d6cd3929360 ("modpost: turn missing MODULE_LICENSE()
into error") the ppc32_allmodconfig build fails with:

  ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-fec.o
  ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-bitbang.o

Add the missing MODULE_LICENSEs to fix the build. Both files include a
copyright header indicating they are GPL v2.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c | 1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
index c8e5d889bd81f..21de56345503f 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
@@ -223,3 +223,4 @@ static struct platform_driver fs_enet_bb_mdio_driver = {
 };
 
 module_platform_driver(fs_enet_bb_mdio_driver);
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
index 1582d82483eca..4e6a9c5d8af55 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -224,3 +224,4 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
 };
 
 module_platform_driver(fs_enet_fec_mdio_driver);
+MODULE_LICENSE("GPL");
-- 
2.27.0

