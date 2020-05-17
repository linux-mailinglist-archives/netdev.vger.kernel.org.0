Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5191D64F9
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 02:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgEQAfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 20:35:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50861 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgEQAfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 20:35:03 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49PjpR3ryQz1rsMq;
        Sun, 17 May 2020 02:34:55 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49PjpR3f4wz1shfq;
        Sun, 17 May 2020 02:34:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 5gdkxSRTfqux; Sun, 17 May 2020 02:34:54 +0200 (CEST)
X-Auth-Info: 1OJrtTE3bCJ2+1DGpPaSrWKdFtKkssfD9+1i38LYr34=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 02:34:54 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V6 20/20] net: ks8851: Drop define debug and pr_fmt()
Date:   Sun, 17 May 2020 02:33:54 +0200
Message-Id: <20200517003354.233373-21-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200517003354.233373-1-marex@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop those debug statements from both drivers. They were there since
at least 2011 and enabled by default, but that's likely wrong.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V6: New patch
---
 drivers/net/ethernet/micrel/ks8851_par.c | 4 ----
 drivers/net/ethernet/micrel/ks8851_spi.c | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 949c7a876f9a..ae9943f37408 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -6,10 +6,6 @@
  *	Ben Dooks <ben@simtec.co.uk>
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG
-
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 4ec7f1615977..f7ceebba7db0 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -6,10 +6,6 @@
  *	Ben Dooks <ben@simtec.co.uk>
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#define DEBUG
-
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-- 
2.25.1

