Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA93272601
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgIUNqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgIUNqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE632C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:05 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8q-0003ED-38; Mon, 21 Sep 2020 15:46:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 07/38] can: slcan: update dead link
Date:   Mon, 21 Sep 2020 15:45:26 +0200
Message-Id: <20200921134557.2251383-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diego Elio Pettenò <flameeyes@flameeyes.com>

BerliOS has not been operating for more than five years. linux-can moved to
GitHub.

Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.com>
Link: https://lore.kernel.org/r/20200413170241.13207-1-flameeyes@flameeyes.com
[mkl: split into two patches - handle slcan part here]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index f07012a76c0c..424970939fd4 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -41,8 +41,8 @@ config CAN_SLCAN
 	  www.canusb.com / www.can232.com / www.mictronics.de / www.canhack.de
 
 	  Userspace tools to attach the SLCAN line discipline (slcan_attach,
-	  slcand) can be found in the can-utils at the SocketCAN SVN, see
-	  http://developer.berlios.de/projects/socketcan for details.
+	  slcand) can be found in the can-utils at the linux-can project, see
+	  https://github.com/linux-can/can-utils for details.
 
 	  The slcan driver supports up to 10 CAN netdevices by default which
 	  can be changed by the 'maxdev=xx' module option. This driver can
-- 
2.28.0

