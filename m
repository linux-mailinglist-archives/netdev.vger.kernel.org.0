Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977907C35A
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbfGaNWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:22:53 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:41766 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729468AbfGaNWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:21 -0400
Received: from ramsan ([84.194.98.4])
        by laurent.telenet-ops.be with bizsmtp
        id jRNK2000905gfCL01RNKlo; Wed, 31 Jul 2019 15:22:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-00017v-5U; Wed, 31 Jul 2019 15:22:19 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-0004UJ-4T; Wed, 31 Jul 2019 15:22:19 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/8] net: apple: Fix manufacturer name in Kconfig help text
Date:   Wed, 31 Jul 2019 15:22:11 +0200
Message-Id: <20190731132216.17194-4-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190731132216.17194-1-geert+renesas@glider.be>
References: <20190731132216.17194-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The help text refers to IBM instead of Apple, presumably because it was
copied from the former.

Fixes: 8fb6b0908176704a ("bmac/mace/macmace/mac89x0/cs89x0: Move the Macintosh (Apple) drivers")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/apple/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/apple/Kconfig b/drivers/net/ethernet/apple/Kconfig
index fde7ae33e302b6bc..f78b9c841296c94b 100644
--- a/drivers/net/ethernet/apple/Kconfig
+++ b/drivers/net/ethernet/apple/Kconfig
@@ -11,8 +11,8 @@ config NET_VENDOR_APPLE
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
 	  Note that the answer to this question doesn't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about IBM devices. If you say Y, you will be asked for
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about Apple devices. If you say Y, you will be asked for
 	  your specific card in the following questions.
 
 if NET_VENDOR_APPLE
-- 
2.17.1

