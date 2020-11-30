Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166982C8665
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgK3OQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgK3OQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:16:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5227FC08E863
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjx2-0007l6-Tk
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EAF4C59FB36
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4E86259FAE0;
        Mon, 30 Nov 2020 14:14:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e6da690c;
        Mon, 30 Nov 2020 14:14:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>
Subject: [net-next 13/14] can: m_can: m_can_plat_remove(): remove unneeded platform_set_drvdata()
Date:   Mon, 30 Nov 2020 15:14:31 +0100
Message-Id: <20201130141432.278219-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need to unset the drvdata on remove, so remove the unneeded call to
platform_set_drvdata() in m_can_plat_remove().

Link: https://lore.kernel.org/r/20201130133713.269256-6-mkl@pengutronix.de
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 161cb9be018c..c45a889a1afd 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -141,8 +141,6 @@ static int m_can_plat_remove(struct platform_device *pdev)
 
 	m_can_class_free_dev(mcan_class->net);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
2.29.2


