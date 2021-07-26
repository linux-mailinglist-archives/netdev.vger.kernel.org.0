Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D843D5B65
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhGZNeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbhGZNde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:33:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5B2C0619EF
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81La-0002Qq-II
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5AB806582DE
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4C2B0658219;
        Mon, 26 Jul 2021 14:12:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cfe6ba4d;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 38/46] can: etas_es58x: fix three typos in author name and documentation
Date:   Mon, 26 Jul 2021 16:11:36 +0200
Message-Id: <20210726141144.862529-39-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Change the author name from "lastname firstname" to "firstname
lastname".

Fix a typo in a variable name in the documentation of struct
es58x_parameters::fifo_mask.

Fix a typo in the title of the datasheet (E701 -> E70) and re-indent
the comments.

Link: https://lore.kernel.org/r/20210628155420.1176217-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c |  2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h |  2 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c   | 16 ++++++++--------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 8e9102482c52..4758f793627a 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -19,7 +19,7 @@
 #include "es58x_core.h"
 
 #define DRV_VERSION "1.00"
-MODULE_AUTHOR("Mailhol Vincent <mailhol.vincent@wanadoo.fr>");
+MODULE_AUTHOR("Vincent Mailhol <mailhol.vincent@wanadoo.fr>");
 MODULE_AUTHOR("Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>");
 MODULE_DESCRIPTION("Socket CAN driver for ETAS ES58X USB adapters");
 MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index fcf219e727bf..826a15871573 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -287,7 +287,7 @@ struct es58x_priv {
  * @rx_urb_cmd_max_len: Maximum length of a RX URB command.
  * @fifo_mask: Bit mask to quickly convert the tx_tail and tx_head
  *	field of the struct es58x_priv into echo_skb
- *	indexes. Properties: @fifo_mask = echos_skb_max - 1 where
+ *	indexes. Properties: @fifo_mask = echo_skb_max - 1 where
  *	echo_skb_max must be a power of two. Also, echo_skb_max must
  *	not exceed the maximum size of the device internal TX FIFO
  *	length. This parameter is used to control the network queue
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index 1a2779d383a4..e8a77d136165 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -463,9 +463,9 @@ static int es58x_fd_get_timestamp(struct es58x_device *es58x_dev)
 }
 
 /* Nominal bittiming constants for ES582.1 and ES584.1 as specified in
- * the microcontroller datasheet: "SAM E701/S70/V70/V71 Family"
- * section 49.6.8 "MCAN Nominal Bit Timing and Prescaler Register"
- * from Microchip.
+ * the microcontroller datasheet: "SAM E70/S70/V70/V71 Family" section
+ * 49.6.8 "MCAN Nominal Bit Timing and Prescaler Register" from
+ * Microchip.
  *
  * The values from the specification are the hardware register
  * values. To convert them to the functional values, all ranges were
@@ -484,8 +484,8 @@ static const struct can_bittiming_const es58x_fd_nom_bittiming_const = {
 };
 
 /* Data bittiming constants for ES582.1 and ES584.1 as specified in
- * the microcontroller datasheet: "SAM E701/S70/V70/V71 Family"
- * section 49.6.4 "MCAN Data Bit Timing and Prescaler Register" from
+ * the microcontroller datasheet: "SAM E70/S70/V70/V71 Family" section
+ * 49.6.4 "MCAN Data Bit Timing and Prescaler Register" from
  * Microchip.
  */
 static const struct can_bittiming_const es58x_fd_data_bittiming_const = {
@@ -501,9 +501,9 @@ static const struct can_bittiming_const es58x_fd_data_bittiming_const = {
 };
 
 /* Transmission Delay Compensation constants for ES582.1 and ES584.1
- * as specified in the microcontroller datasheet: "SAM
- * E701/S70/V70/V71 Family" section 49.6.15 "MCAN Transmitter Delay
- * Compensation Register" from Microchip.
+ * as specified in the microcontroller datasheet: "SAM E70/S70/V70/V71
+ * Family" section 49.6.15 "MCAN Transmitter Delay Compensation
+ * Register" from Microchip.
  */
 static const struct can_tdc_const es58x_tdc_const = {
 	.tdcv_max = 0, /* Manual mode not supported. */
-- 
2.30.2


