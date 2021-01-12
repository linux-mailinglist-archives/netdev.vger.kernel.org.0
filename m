Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C8B2F2FA3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 13:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403790AbhALM5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:57:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390236AbhALM5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F692313C;
        Tue, 12 Jan 2021 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456182;
        bh=AR00w8oAd+3YM+3Yohx10hcG4J7Jqsm4OVgaDygvR5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dD+UVgT0IdIEHIG6kIHO3gziaLD6jvEPvbRVDPuMjEo/A2oUUjwsPC4+j7qTOwa1X
         jYr418dfXkCv+RASnxfTvsi6vk8GAJZzEN8SIX3CLazbL4hm4Tcm3B9fXmbp+LJ5xA
         vAILyGZfgwBbNUGqzwh6qEKtEEm7UHp36JBsQaL3+XR+IM1zbA4woVS/kB++9yg5+1
         7c81BvuLITtmLH4mNhcQ+hV1pmbImLGIJr3AYxSnSc3Ic+RcP3a6O85D41S45ZYM0r
         pDOAouxEZmZh5oHuARrgUyrzJP6ACTZsw9378y2LKQ87khiD+WsfoZNZkHni8+SHzC
         x72TRhVZkT7bA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 36/51] net: ethernet: fs_enet: Add missing MODULE_LICENSE
Date:   Tue, 12 Jan 2021 07:55:18 -0500
Message-Id: <20210112125534.70280-36-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
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
index 8b51ee142fa3c..152f4d83765aa 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -224,3 +224,4 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
 };
 
 module_platform_driver(fs_enet_fec_mdio_driver);
+MODULE_LICENSE("GPL");
-- 
2.27.0

