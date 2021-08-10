Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3053E539E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhHJGhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbhHJGhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 02:37:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD92C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 23:37:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mDLNr-0005we-8y
        for netdev@vger.kernel.org; Tue, 10 Aug 2021 08:37:07 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 139A1663C8D
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:37:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 26ABA663C81;
        Tue, 10 Aug 2021 06:37:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ca086ce9;
        Tue, 10 Aug 2021 06:37:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Baruch Siach <baruch@tkos.co.il>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/2] MAINTAINERS: fix Microchip CAN BUS Analyzer Tool entry typo
Date:   Tue, 10 Aug 2021 08:37:01 +0200
Message-Id: <20210810063702.350109-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810063702.350109-1-mkl@pengutronix.de>
References: <20210810063702.350109-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

This patch fixes the abbreviated name of the Microchip CAN BUS
Analyzer Tool.

Fixes: 8a7b46fa7902 ("MAINTAINERS: add Yasushi SHOJI as reviewer for the Microchip CAN BUS Analyzer Tool driver")
Link: https://lore.kernel.org/r/cc4831cb1c8759c15fb32c21fd326e831183733d.1627876781.git.baruch@tkos.co.il
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c9467d2839f5..25dc566a67c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11327,7 +11327,7 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/radio/radio-maxiradio*
 
-MCAB MICROCHIP CAN BUS ANALYZER TOOL DRIVER
+MCBA MICROCHIP CAN BUS ANALYZER TOOL DRIVER
 R:	Yasushi SHOJI <yashi@spacecubics.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained

base-commit: 143a8526ab5fd4f8a0c4fe2a9cb28c181dc5a95f
-- 
2.30.2


