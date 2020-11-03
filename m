Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8462A5979
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgKCWHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731164AbgKCWGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729B6C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:47 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rx-0006Ui-G0; Tue, 03 Nov 2020 23:06:45 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 13/27] can: isotp: Explain PDU in CAN_ISOTP help text
Date:   Tue,  3 Nov 2020 23:06:22 +0100
Message-Id: <20201103220636.972106-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

The help text for the CAN_ISOTP config symbol uses the acronym "PDU".  However,
this acronym is not explained here, nor in Documentation/networking/can.rst.

Expand the acronym to make it easier for users to decide if they need to enable
the CAN_ISOTP option or not.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20201013141341.28487-1-geert+renesas@glider.be
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/can/Kconfig b/net/can/Kconfig
index 224e5e0283a9..7c9958df91d3 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -62,8 +62,9 @@ config CAN_ISOTP
 	  communication between CAN nodes via two defined CAN Identifiers.
 	  As CAN frames can only transport a small amount of data bytes
 	  (max. 8 bytes for 'classic' CAN and max. 64 bytes for CAN FD) this
-	  segmentation is needed to transport longer PDUs as needed e.g. for
-	  vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
+	  segmentation is needed to transport longer Protocol Data Units (PDU)
+	  as needed e.g. for vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN
+	  traffic.
 	  This protocol driver implements data transfers according to
 	  ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
 	  If you want to perform automotive vehicle diagnostic services (UDS),
-- 
2.28.0

