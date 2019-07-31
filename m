Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6DA7C356
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbfGaNWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:22:51 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:56334 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729466AbfGaNWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:21 -0400
Received: from ramsan ([84.194.98.4])
        by xavier.telenet-ops.be with bizsmtp
        id jRNK2000605gfCL01RNKsy; Wed, 31 Jul 2019 15:22:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-00017s-4c; Wed, 31 Jul 2019 15:22:19 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-0004UG-3Q; Wed, 31 Jul 2019 15:22:19 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/8] net: amd: Spelling s/case/cause/
Date:   Wed, 31 Jul 2019 15:22:10 +0200
Message-Id: <20190731132216.17194-3-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190731132216.17194-1-geert+renesas@glider.be>
References: <20190731132216.17194-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/amd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index de4950d2022e0a6d..9f965cdfff5c99db 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -14,7 +14,7 @@ config NET_VENDOR_AMD
 	  say Y.
 
 	  Note that the answer to this question does not directly affect
-	  the kernel: saying N will just case the configurator to skip all
+	  the kernel: saying N will just cause the configurator to skip all
 	  the questions regarding AMD chipsets. If you say Y, you will be asked
 	  for your specific chipset/driver in the following questions.
 
-- 
2.17.1

