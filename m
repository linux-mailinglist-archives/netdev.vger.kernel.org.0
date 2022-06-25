Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2F55A9BD
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiFYMHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbiFYMGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E4D2CC85
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YW-0002lB-BI
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:28 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DC37F9F206
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:04:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CE8E29F1D7;
        Sat, 25 Jun 2022 12:04:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e585ddcd;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Max Staudt <max@enpas.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 12/22] can: Break loopback loop on loopback documentation
Date:   Sat, 25 Jun 2022 14:03:25 +0200
Message-Id: <20220625120335.324697-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Staudt <max@enpas.org>

There are two sections called "Local Loopback of Sent Frames". One was
meant to link to the other, but pointed at itself instead.

Link: https://lore.kernel.org/all/20220611171155.9090-1-max@enpas.org
Fixes: 7d5977394515 ("can: migrate documentation to restructured text")
Signed-off-by: Max Staudt <max@enpas.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/can.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index f34cb0e4460e..ebc822e605f5 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -168,7 +168,7 @@ reflect the correct [#f1]_ traffic on the node the loopback of the sent
 data has to be performed right after a successful transmission. If
 the CAN network interface is not capable of performing the loopback for
 some reason the SocketCAN core can do this task as a fallback solution.
-See :ref:`socketcan-local-loopback1` for details (recommended).
+See :ref:`socketcan-local-loopback2` for details (recommended).
 
 The loopback functionality is enabled by default to reflect standard
 networking behaviour for CAN applications. Due to some requests from
-- 
2.35.1


