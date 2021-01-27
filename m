Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952813056EB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbhA0J2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbhA0JZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:25:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4E7C06178B
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 01:22:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l4h2B-0008GU-Kb
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 10:22:43 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9B51C5CF124
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:22:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 381FA5CF0D7;
        Wed, 27 Jan 2021 09:22:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 842192eb;
        Wed, 27 Jan 2021 09:22:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Tom Rix <trix@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 05/12] can: mcba_usb: remove h from printk format specifier
Date:   Wed, 27 Jan 2021 10:22:20 +0100
Message-Id: <20210127092227.2775573-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210127092227.2775573-1-mkl@pengutronix.de>
References: <20210127092227.2775573-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit commit
cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary
%h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless so do
not encourage the use of %hh[xudi] or %h[xudi].

Link: https://lore.kernel.org/r/20210124150916.1920434-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/mcba_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 4232a7126c1b..1f649d178010 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -466,7 +466,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 				    struct mcba_usb_msg_ka_usb *msg)
 {
 	if (unlikely(priv->usb_ka_first_pass)) {
-		netdev_info(priv->netdev, "PIC USB version %hhu.%hhu\n",
+		netdev_info(priv->netdev, "PIC USB version %u.%u\n",
 			    msg->soft_ver_major, msg->soft_ver_minor);
 
 		priv->usb_ka_first_pass = false;
@@ -492,7 +492,7 @@ static void mcba_usb_process_ka_can(struct mcba_priv *priv,
 				    struct mcba_usb_msg_ka_can *msg)
 {
 	if (unlikely(priv->can_ka_first_pass)) {
-		netdev_info(priv->netdev, "PIC CAN version %hhu.%hhu\n",
+		netdev_info(priv->netdev, "PIC CAN version %u.%u\n",
 			    msg->soft_ver_major, msg->soft_ver_minor);
 
 		priv->can_ka_first_pass = false;
@@ -554,7 +554,7 @@ static void mcba_usb_process_rx(struct mcba_priv *priv,
 		break;
 
 	default:
-		netdev_warn(priv->netdev, "Unsupported msg (0x%hhX)",
+		netdev_warn(priv->netdev, "Unsupported msg (0x%X)",
 			    msg->cmd_id);
 		break;
 	}
-- 
2.29.2


