Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6EF3F71D2
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbhHYJgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbhHYJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:36:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0040BC06179A
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 02:35:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mIpJb-00048w-BF
        for netdev@vger.kernel.org; Wed, 25 Aug 2021 11:35:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CAED766F5B7
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:35:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2E8BE66F597;
        Wed, 25 Aug 2021 09:35:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 07e828ab;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Tang Bin <tangbin@cmss.chinamobile.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 4/4] can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): remove useless BUG_ON()
Date:   Wed, 25 Aug 2021 11:35:16 +0200
Message-Id: <20210825093516.448231-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210825093516.448231-1-mkl@pengutronix.de>
References: <20210825093516.448231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

In the function mpc5xxx_can_probe(), the variable 'data' has already
been determined in the above code, so the BUG_ON() in this place is
useless, remove it.

Link: https://lore.kernel.org/r/20210823141033.17876-1-tangbin@cmss.chinamobile.com
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/mscan/mpc5xxx_can.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 3b7465acd35c..35892c1efef0 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -317,7 +317,6 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 	clock_name = of_get_property(np, "fsl,mscan-clock-source", NULL);
 
-	BUG_ON(!data);
 	priv->type = data->type;
 	priv->can.clock.freq = data->get_clock(ofdev, clock_name,
 					       &mscan_clksrc);
-- 
2.32.0


