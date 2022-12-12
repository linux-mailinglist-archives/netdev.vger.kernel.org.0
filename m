Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F716649D9C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiLLLbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbiLLLay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:30:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3C2616D
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:30:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1H-0008R2-LG
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:30:51 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3ED4A13CB57
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:50 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 140CE13CB31;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d1f2a2f7;
        Mon, 12 Dec 2022 11:30:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Subject: [PATCH net-next 02/39] can: kvaser_usb: kvaser_usb_set_{,data}bittiming(): remove empty lines in variable declaration
Date:   Mon, 12 Dec 2022 12:30:08 +0100
Message-Id: <20221212113045.222493-3-mkl@pengutronix.de>
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

Fix coding style by removing empty lines in variable declaration.

Fixes: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
Cc: Jimmy Assarsson <extja@kvaser.com>
Cc: Anssi Hannula <anssi.hannula@bitwise.fi>
Link: https://lore.kernel.org/all/20221031114513.81214-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index b17c4d8c6cf9..d4c5356d5884 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -536,7 +536,6 @@ static int kvaser_usb_set_bittiming(struct net_device *netdev)
 	struct kvaser_usb *dev = priv->dev;
 	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	struct can_bittiming *bt = &priv->can.bittiming;
-
 	struct kvaser_usb_busparams busparams;
 	int tseg1 = bt->prop_seg + bt->phase_seg1;
 	int tseg2 = bt->phase_seg2;
@@ -581,7 +580,6 @@ static int kvaser_usb_set_data_bittiming(struct net_device *netdev)
 	struct kvaser_usb *dev = priv->dev;
 	const struct kvaser_usb_dev_ops *ops = dev->driver_info->ops;
 	struct can_bittiming *dbt = &priv->can.data_bittiming;
-
 	struct kvaser_usb_busparams busparams;
 	int tseg1 = dbt->prop_seg + dbt->phase_seg1;
 	int tseg2 = dbt->phase_seg2;
-- 
2.35.1


