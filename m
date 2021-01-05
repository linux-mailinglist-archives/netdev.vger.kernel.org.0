Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B99F2EA725
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbhAEJQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:16:04 -0500
Received: from ozlabs.org ([203.11.71.1]:35713 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbhAEJQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 04:16:04 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4D96KQ1KJ5z9sWM; Tue,  5 Jan 2021 20:15:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1609838122;
        bh=EADqwwn7oD0FlfCscvnQrpY01N4uznyjB3jWIAXQL/g=;
        h=From:To:Cc:Subject:Date:From;
        b=ZsDKHd/+RTNrcjY1Wafc4Wbrdfvb0IYrSYzS9/jnoGOPbuBdY7hDjDBDlOwF3k+g8
         3rXOroz4sy6l5V3dDAl0aq1d3HgU3v82JX2FkwLpkzRK/hJbqyabv1A7IvI1cCJgfY
         i70rNbIeE/VMSOpf2/bbepwEAh4Y7exxfTj53tFUyVMn1XWstgo0Q3mkCfWspqiodt
         onJxdeAGJ8qaYnwWroEUW+aOIxbjFxszlDSAL2u97JgVF7uq6Zq00jMfbKDomAkQRt
         EYZWw1AoIdXb/wcTAdjf2EnVQSSZb68nJieW5zVCdWfHMS+6rqyNj9sMveDOrGxEFL
         XqzNymymkW9lg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pantelis.antoniou@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        andrew@lunn.ch
Subject: [PATCH v2] net: ethernet: fs_enet: Add missing MODULE_LICENSE
Date:   Tue,  5 Jan 2021 20:15:15 +1100
Message-Id: <20210105091515.87509-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 1d6cd3929360 ("modpost: turn missing MODULE_LICENSE()
into error") the ppc32_allmodconfig build fails with:

  ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-fec.o
  ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-bitbang.o

Add the missing MODULE_LICENSEs to fix the build. Both files include a
copyright header indicating they are GPL v2.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c | 1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c     | 1 +
 2 files changed, 2 insertions(+)

v2: Use simply "GPL" as pointed out by Andrew:
    https://lore.kernel.org/lkml/X%2FPRX+RziaU3IJGi@lunn.ch/

diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
index c8e5d889bd81..21de56345503 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
@@ -223,3 +223,4 @@ static struct platform_driver fs_enet_bb_mdio_driver = {
 };
 
 module_platform_driver(fs_enet_bb_mdio_driver);
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
index 8b51ee142fa3..152f4d83765a 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -224,3 +224,4 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
 };
 
 module_platform_driver(fs_enet_fec_mdio_driver);
+MODULE_LICENSE("GPL");
-- 
2.25.1

