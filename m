Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24241C88B3
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgEGLpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgEGLpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 07:45:15 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B7DC05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 04:45:14 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed60:6572:4a1f:d283:9ae8])
        by michel.telenet-ops.be with bizsmtp
        id bnlC2200M3ZRV0X06nlCSR; Thu, 07 May 2020 13:45:13 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jWexk-0007Qx-N2; Thu, 07 May 2020 13:45:12 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jWexk-0006TJ-L5; Thu, 07 May 2020 13:45:12 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        huangdaode <huangdaode@hisilicon.com>,
        Kenneth Lee <liguozhu@huawei.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: hisilicon: Make CONFIG_HNS invisible
Date:   Thu,  7 May 2020 13:45:11 +0200
Message-Id: <20200507114511.24835-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HNS config symbol enables the framework support for the Hisilicon
Network Subsystem.  It is already selected by all of its users, so there
is no reason to make it visible.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/hisilicon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index 3892a2062404eee6..2fff435090983395 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -64,7 +64,7 @@ config HNS_MDIO
 	  the PHY
 
 config HNS
-	tristate "Hisilicon Network Subsystem Support (Framework)"
+	tristate
 	---help---
 	  This selects the framework support for Hisilicon Network Subsystem. It
 	  is needed by any driver which provides HNS acceleration engine or make
-- 
2.17.1

