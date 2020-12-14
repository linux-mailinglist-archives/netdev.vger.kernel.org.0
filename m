Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4622D98DB
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439629AbgLNNcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439514AbgLNNce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:32:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB68C0613D6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:31:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1konxA-0003Mu-GU
        for netdev@vger.kernel.org; Mon, 14 Dec 2020 14:31:52 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CF8385AD2A5
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:31:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 33D725AD28C;
        Mon, 14 Dec 2020 13:31:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5da25f90;
        Mon, 14 Dec 2020 13:31:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sean Nyekjaer <sean@geanix.com>, Dan Murphy <dmurphy@ti.com>
Subject: [net-next 1/7] can: m_can: update link to M_CAN user manual
Date:   Mon, 14 Dec 2020 14:31:39 +0100
Message-Id: <20201214133145.442472-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214133145.442472-1-mkl@pengutronix.de>
References: <20201214133145.442472-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Old versions of the user manual are regularly depublished, so change link to
the linux-can github page, which has a mirror off all published datasheets.

Link: https://lore.kernel.org/r/20201212175518.139651-2-mkl@pengutronix.de
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 06c136961c7c..ec209326c3d8 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -5,8 +5,7 @@
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
 /* Bosch M_CAN user manual can be obtained from:
- * http://www.bosch-semiconductors.de/media/pdf_1/ipmodules_1/m_can/
- * mcan_users_manual_v302.pdf
+ * https://github.com/linux-can/can-doc/tree/master/m_can
  */
 
 #include <linux/interrupt.h>

base-commit: 13458ffe0a953e17587f172a8e5059c243e6850a
-- 
2.29.2


