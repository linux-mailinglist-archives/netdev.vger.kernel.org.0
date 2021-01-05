Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2222EA34D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 03:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbhAECXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 21:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbhAECXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 21:23:18 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D38C061574;
        Mon,  4 Jan 2021 18:22:38 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4D8x962qVnz9sSs; Tue,  5 Jan 2021 13:22:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1609813354;
        bh=+JHifb6rnjYZKQkkEfYeRWl4cRAvJxzjXbwxzFCiS8k=;
        h=From:To:Cc:Subject:Date:From;
        b=X0BQOYDYrvBC/e22mHXnwJ8D7EdkFfuUuVPN2Q2X7EGecqHv3u1SYMln7ySR16u6+
         /nTeb78HHtoBQGZ2Xm9pvMU/CgM3Q+XSZeH9mQssD+7sA5sTwbVXguuIm6wNOdSW0k
         soY5YgJ7j0MuDE8mBgJaqEhsBSkXJRvUpnMwGs58hg1S+lLfmJdRPFF/pv974i/mU1
         SA333qQQ6jXxWX+hmJ8MF9aveY6vyhFmaYxA9q61VzgtiJ31r4pTbO+8GUMqBwg+bq
         KVkGUwtmYX+bO+QGb6EfGPrewCoLFN5caMbXhLItTckJRTD7AliN10/8zm8/Rpu+CT
         13PlX1VX/hJtw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pantelis.antoniou@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] net: ethernet: fs_enet: Add missing MODULE_LICENSE
Date:   Tue,  5 Jan 2021 13:22:29 +1100
Message-Id: <20210105022229.54601-1-mpe@ellerman.id.au>
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

diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
index c8e5d889bd81..76ac1a9eab58 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
@@ -223,3 +223,4 @@ static struct platform_driver fs_enet_bb_mdio_driver = {
 };
 
 module_platform_driver(fs_enet_bb_mdio_driver);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
index 8b51ee142fa3..407c330b432f 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -224,3 +224,4 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
 };
 
 module_platform_driver(fs_enet_fec_mdio_driver);
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

