Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C8C7C359
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbfGaNWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:22:53 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:58520 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfGaNWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:21 -0400
Received: from ramsan ([84.194.98.4])
        by michel.telenet-ops.be with bizsmtp
        id jRNK2000D05gfCL06RNKmu; Wed, 31 Jul 2019 15:22:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-000181-7D; Wed, 31 Jul 2019 15:22:19 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-0004UP-6A; Wed, 31 Jul 2019 15:22:19 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/8] net: ixp4xx: Spelling s/XSacle/XScale/
Date:   Wed, 31 Jul 2019 15:22:13 +0200
Message-Id: <20190731132216.17194-6-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190731132216.17194-1-geert+renesas@glider.be>
References: <20190731132216.17194-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/xscale/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index 2f354ba029a61491..cd0a8f46e7c6c143 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -13,7 +13,7 @@ config NET_VENDOR_XSCALE
 
 	  Note that the answer to this question does not directly affect the
 	  kernel: saying N will just cause the configurator to skip all
-	  the questions about XSacle IXP devices. If you say Y, you will be
+	  the questions about XScale IXP devices. If you say Y, you will be
 	  asked for your specific card in the following questions.
 
 if NET_VENDOR_XSCALE
-- 
2.17.1

