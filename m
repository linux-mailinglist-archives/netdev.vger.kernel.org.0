Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF2A3DB431
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbhG3HFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbhG3HFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 03:05:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2CCC061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 00:05:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m9MaM-00062X-Il
        for netdev@vger.kernel.org; Fri, 30 Jul 2021 09:05:34 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8D45B65B7AC
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:05:30 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D9E7665B790;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id af41d2ca;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Yasushi SHOJI <yashi@spacecubics.com>
Subject: [PATCH net 1/6] MAINTAINERS: add Yasushi SHOJI as reviewer for the Microchip CAN BUS Analyzer Tool driver
Date:   Fri, 30 Jul 2021 09:05:21 +0200
Message-Id: <20210730070526.1699867-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730070526.1699867-1-mkl@pengutronix.de>
References: <20210730070526.1699867-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds Yasushi SHOJI as a reviewer for the Microchip CAN BUS
Analyzer Tool driver.

Link: https://lore.kernel.org/r/20210726111619.1023991-1-mkl@pengutronix.de
Acked-by: Yasushi SHOJI <yashi@spacecubics.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 58afeb12d3b3..42ea3183e87c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11327,6 +11327,12 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/radio/radio-maxiradio*
 
+MCAB MICROCHIP CAN BUS ANALYZER TOOL DRIVER
+R:	Yasushi SHOJI <yashi@spacecubics.com>
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	drivers/net/can/usb/mcba_usb.c
+
 MCAN MMIO DEVICE DRIVER
 M:	Chandrasekar Ramakrishnan <rcsekar@samsung.com>
 L:	linux-can@vger.kernel.org

base-commit: fc16a5322ee6c30ea848818722eee5d352f8d127
-- 
2.30.2


