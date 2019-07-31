Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3394E7C355
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388326AbfGaNWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:22:47 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:32770 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387713AbfGaNWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:22 -0400
Received: from ramsan ([84.194.98.4])
        by baptiste.telenet-ops.be with bizsmtp
        id jRNL2000i05gfCL01RNLBg; Wed, 31 Jul 2019 15:22:21 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-00017y-6L; Wed, 31 Jul 2019 15:22:19 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-0004UM-5K; Wed, 31 Jul 2019 15:22:19 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4/8] net: broadcom: Fix manufacturer name in Kconfig help text
Date:   Wed, 31 Jul 2019 15:22:12 +0200
Message-Id: <20190731132216.17194-5-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190731132216.17194-1-geert+renesas@glider.be>
References: <20190731132216.17194-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The help text refers to AMD instead of Broadcom, presumably because it
was copied from the former.

Fixes: adfc5217e9db68d3 ("broadcom: Move the Broadcom drivers")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/broadcom/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index e9017caf024dcf33..e24f5d2b6afe3547 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -14,9 +14,9 @@ config NET_VENDOR_BROADCOM
 	  say Y.
 
 	  Note that the answer to this question does not directly affect
-	  the kernel: saying N will just case the configurator to skip all
-	  the questions regarding AMD chipsets. If you say Y, you will be asked
-	  for your specific chipset/driver in the following questions.
+	  the kernel: saying N will just cause the configurator to skip all
+	  the questions regarding Broadcom chipsets. If you say Y, you will
+	  be asked for your specific chipset/driver in the following questions.
 
 if NET_VENDOR_BROADCOM
 
-- 
2.17.1

