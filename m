Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3E34E6C5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhC3Lr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhC3Lqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78477C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpZ-0006YY-Ut
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 55199603ED9
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E5833603E40;
        Tue, 30 Mar 2021 11:46:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0060f3d9;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 29/39] can: c_can: remove unnecessary blank lines and add suggested ones
Date:   Tue, 30 Mar 2021 13:45:49 +0200
Message-Id: <20210330114559.1114855-30-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes unnecessary blank lines and add suggested ones, so
that checkpatch doesn't complain anymore.

Link: https://lore.kernel.org/r/20210304154240.2747987-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c     | 2 --
 drivers/net/can/c_can/c_can_pci.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 6629951e4935..cb0707a899d5 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -132,7 +132,6 @@
 /* For the high buffers we clear the interrupt bit and newdat */
 #define IF_COMM_RCV_HIGH	(IF_COMM_RCV_LOW | IF_COMM_CLR_NEWDAT)
 
-
 /* Receive setup of message objects */
 #define IF_COMM_RCV_SETUP	(IF_COMM_MASK | IF_COMM_ARB | IF_COMM_CONTROL)
 
@@ -250,7 +249,6 @@ static void c_can_obj_update(struct net_device *dev, int iface, u32 cmd, u32 obj
 		udelay(1);
 	}
 	netdev_err(dev, "Updating object timed out\n");
-
 }
 
 static inline void c_can_object_get(struct net_device *dev, int iface,
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 9d7a4a335249..35a914e70cc9 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -278,6 +278,7 @@ static const struct pci_device_id c_can_pci_tbl[] = {
 		 c_can_pch),
 	{},
 };
+
 static struct pci_driver c_can_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = c_can_pci_tbl,
-- 
2.30.2


