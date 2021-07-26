Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0543D5B73
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhGZNe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbhGZNeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:34:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BC4C061384
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Lf-0002XQ-BL
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:51 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6F30265830E
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6A514658239;
        Mon, 26 Jul 2021 14:12:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2906ae59;
        Mon, 26 Jul 2021 14:11:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Angelo Dureghello <angelo@kernel-space.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 46/46] can: flexcan: update Kconfig to enable coldfire
Date:   Mon, 26 Jul 2021 16:11:44 +0200
Message-Id: <20210726141144.862529-47-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Angelo Dureghello <angelo@kernel-space.org>

Update flexcan to support coldfire architecture.

Any new platform should use OF, but coldfire architecture is
actually not supporting devicetrees.

Link: https://lore.kernel.org/r/20210702094841.327679-4-angelo@kernel-space.org
Signed-off-by: Angelo Dureghello <angelo@kernel-space.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index e355d3974977..fff259247d52 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -97,7 +97,8 @@ config CAN_AT91
 
 config CAN_FLEXCAN
 	tristate "Support for Freescale FLEXCAN based chips"
-	depends on OF && HAS_IOMEM
+	depends on OF || COLDFIRE || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Say Y here if you want to support for Freescale FlexCAN.
 
-- 
2.30.2


