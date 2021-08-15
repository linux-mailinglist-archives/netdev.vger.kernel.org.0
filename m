Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F63EC6F9
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 05:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbhHODe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 23:34:58 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:48869 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbhHODet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 23:34:49 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d21 with ME
        id hfZ7250050zjR6y03faHyr; Sun, 15 Aug 2021 05:34:19 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 15 Aug 2021 05:34:19 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 7/7] can: etas_es58x: clean-up documentation of struct es58x_fd_tx_conf_msg
Date:   Sun, 15 Aug 2021 12:32:48 +0900
Message-Id: <20210815033248.98111-8-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation of struct es58x_fd_tx_conf_msg explains in details
the different TDC parameters. However, those description are redundant
with the documentation of struct can_tdc.

Remove most of the description.

Also, fixes a typo in the reference to the datasheet (E701 -> E70).

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_fd.h | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
index ee18a87e40c0..a191891b8777 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
@@ -96,23 +96,14 @@ struct es58x_fd_bittiming {
  * @ctrlmode: type enum es58x_fd_ctrlmode.
  * @canfd_enabled: boolean (0: Classical CAN, 1: CAN and/or CANFD).
  * @data_bittiming: Bittiming for flexible data-rate transmission.
- * @tdc_enabled: Transmitter Delay Compensation switch (0: disabled,
- *	1: enabled). On very high bitrates, the delay between when the
- *	bit is sent and received on the CANTX and CANRX pins of the
- *	transceiver start to be significant enough for errors to occur
- *	and thus need to be compensated.
- * @tdco: Transmitter Delay Compensation Offset. Offset value, in time
- *	quanta, defining the delay between the start of the bit
- *	reception on the CANRX pin of the transceiver and the SSP
- *	(Secondary Sample Point). Valid values: 0 to 127.
- * @tdcf: Transmitter Delay Compensation Filter window. Defines the
- *	minimum value for the SSP position, in time quanta. The
- *	feature is enabled when TDCF is configured to a value greater
- *	than TDCO. Valid values: 0 to 127.
+ * @tdc_enabled: Transmitter Delay Compensation switch (0: TDC is
+ *	disabled, 1: TDC is enabled).
+ * @tdco: Transmitter Delay Compensation Offset.
+ * @tdcf: Transmitter Delay Compensation Filter window.
  *
- * Please refer to the microcontroller datasheet: "SAM
- * E701/S70/V70/V71 Family" section 49 "Controller Area Network
- * (MCAN)" for additional information.
+ * Please refer to the microcontroller datasheet: "SAM E70/S70/V70/V71
+ * Family" section 49 "Controller Area Network (MCAN)" for additional
+ * information.
  */
 struct es58x_fd_tx_conf_msg {
 	struct es58x_fd_bittiming nominal_bittiming;
-- 
2.31.1

