Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA232ECD2E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbhAGJvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbhAGJvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:13 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC07C061282
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:49:54 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvV-00015s-8b
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:53 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3A5035BBA54
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D34645BBA14;
        Thu,  7 Jan 2021 09:49:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5f62d16e;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: [net-next 01/19] can: tcan4x5x: replace DEVICE_NAME by KBUILD_MODNAME
Date:   Thu,  7 Jan 2021 10:48:42 +0100
Message-Id: <20210107094900.173046-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the DEVICE_NAME macro by KBUILD_MODNAME and removed the
superfluous DEVICE_NAME.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 24c737c4fc44..1b5f706674af 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -10,7 +10,6 @@
 
 #include "m_can.h"
 
-#define DEVICE_NAME "tcan4x5x"
 #define TCAN4X5X_EXT_CLK_DEF 40000000
 
 #define TCAN4X5X_DEV_ID0 0x00
@@ -132,7 +131,7 @@ static inline struct tcan4x5x_priv *cdev_to_priv(struct m_can_classdev *cdev)
 }
 
 static struct can_bittiming_const tcan4x5x_bittiming_const = {
-	.name = DEVICE_NAME,
+	.name = KBUILD_MODNAME,
 	.tseg1_min = 2,
 	.tseg1_max = 31,
 	.tseg2_min = 2,
@@ -144,7 +143,7 @@ static struct can_bittiming_const tcan4x5x_bittiming_const = {
 };
 
 static struct can_bittiming_const tcan4x5x_data_bittiming_const = {
-	.name = DEVICE_NAME,
+	.name = KBUILD_MODNAME,
 	.tseg1_min = 1,
 	.tseg1_max = 32,
 	.tseg2_min = 1,
@@ -544,7 +543,7 @@ MODULE_DEVICE_TABLE(spi, tcan4x5x_id_table);
 
 static struct spi_driver tcan4x5x_can_driver = {
 	.driver = {
-		.name = DEVICE_NAME,
+		.name = KBUILD_MODNAME,
 		.of_match_table = tcan4x5x_of_match,
 		.pm = NULL,
 	},

base-commit: ede71cae72855f8d6f6268510895210adc317666
-- 
2.29.2


