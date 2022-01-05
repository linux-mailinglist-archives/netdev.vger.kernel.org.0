Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2A04854D7
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbiAEOoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbiAEOoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:13 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848FEC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WN-00040T-Vb
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4F9DB6D1AE3
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BE5996D1ABB;
        Wed,  5 Jan 2022 14:44:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c429241a;
        Wed, 5 Jan 2022 14:44:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/15] can: usb_8dev: remove unused member echo_skb from struct usb_8dev_priv
Date:   Wed,  5 Jan 2022 15:43:48 +0100
Message-Id: <20220105144402.1174191-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the unused memberecho_skb from the struct
usb_8dev_priv.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Link: https://lore.kernel.org/all/20220104230753.956520-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/usb_8dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index d1b83bd1b3cb..1fa02905e7ec 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -121,8 +121,6 @@ struct usb_8dev_tx_urb_context {
 struct usb_8dev_priv {
 	struct can_priv can; /* must be the first member */
 
-	struct sk_buff *echo_skb[MAX_TX_URBS];
-
 	struct usb_device *udev;
 	struct net_device *netdev;
 

base-commit: ffd32ea6b13c97904cae59bdb13a843d52756578
-- 
2.34.1


