Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BCA7C34E
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388303AbfGaNWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:22:37 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:32768 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387696AbfGaNWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:23 -0400
Received: from ramsan ([84.194.98.4])
        by baptiste.telenet-ops.be with bizsmtp
        id jRNL2000s05gfCL01RNLBk; Wed, 31 Jul 2019 15:22:21 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-000184-86; Wed, 31 Jul 2019 15:22:19 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-0004US-75; Wed, 31 Jul 2019 15:22:19 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6/8] net: nixge: Spelling s/Instrument/Instruments/
Date:   Wed, 31 Jul 2019 15:22:14 +0200
Message-Id: <20190731132216.17194-7-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190731132216.17194-1-geert+renesas@glider.be>
References: <20190731132216.17194-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/ni/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ni/Kconfig b/drivers/net/ethernet/ni/Kconfig
index 70b1a03c0953e696..01229190132d484f 100644
--- a/drivers/net/ethernet/ni/Kconfig
+++ b/drivers/net/ethernet/ni/Kconfig
@@ -11,7 +11,7 @@ config NET_VENDOR_NI
 
 	  Note that the answer to this question doesn't directly affect the
 	  kernel: saying N will just cause the configurator to skip all
-	  the questions about National Instrument devices.
+	  the questions about National Instruments devices.
 	  If you say Y, you will be asked for your specific device in the
 	  following questions.
 
-- 
2.17.1

