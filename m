Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92F5649DCA
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiLLLcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiLLLbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DED9FE1
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:06 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1U-0000Wz-Ot
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:04 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5FAE513CC1C
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id ADF2C13CBD6;
        Mon, 12 Dec 2022 11:30:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9a7b07f3;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 24/39] can: ucan: remove unused ucan_priv::intf
Date:   Mon, 12 Dec 2022 12:30:30 +0100
Message-Id: <20221212113045.222493-25-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Field intf of struct ucan_priv is set but never used. Remove it.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221208081142.16936-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/ucan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 159e25ffa337..a0f7bcec719c 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -277,7 +277,6 @@ struct ucan_priv {
 
 	/* linux USB device structures */
 	struct usb_device *udev;
-	struct usb_interface *intf;
 	struct net_device *netdev;
 
 	/* lock for can->echo_skb (used around
@@ -1501,7 +1500,6 @@ static int ucan_probe(struct usb_interface *intf,
 
 	/* initialize data */
 	up->udev = udev;
-	up->intf = intf;
 	up->netdev = netdev;
 	up->intf_index = iface_desc->desc.bInterfaceNumber;
 	up->in_ep_addr = in_ep_addr;
-- 
2.35.1


