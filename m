Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8759529217
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348273AbiEPUwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348643AbiEPUvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75DE39163
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIh-0006E0-A2
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:43 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 312007FB77
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7FC8E7FB66;
        Mon, 16 May 2022 20:26:38 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 14c0b072;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Akira Yokosawa <akiyks@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 9/9] docs: ctucanfd: Use 'kernel-figure' directive instead of 'figure'
Date:   Mon, 16 May 2022 22:26:25 +0200
Message-Id: <20220516202625.1129281-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516202625.1129281-1-mkl@pengutronix.de>
References: <20220516202625.1129281-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>

Two issues were observed in the ReST doc added by commit c3a0addefbde
("docs: ctucanfd: CTU CAN FD open-source IP core documentation.")
with Sphinx versions 2.4.4 and 4.5.0.

The plain "figure" directive broke "make pdfdocs" due to a missing
PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
directive, which is an extension for kernel documentation, should
be used instead.

The directive of "code:: raw" causes a warning from both
"make htmldocs" and "make pdfdocs", which reads:

    [...]/can/ctu/ctucanfd-driver.rst:75: WARNING: Pygments lexer name
    'raw' is not known

A plain literal-block marker should suffice where no syntax
highlighting is intended.

Fix the issues by using suitable directive and marker.

Fixes: c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core documentation.")
Link: https://lore.kernel.org/all/5986752a-1c2a-5d64-f91d-58b1e6decd17@gmail.com
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Martin Jerabek <martin.jerabek01@gmail.com>
Cc: Ondrej Ille <ondrej.ille@gmail.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../networking/device_drivers/can/ctu/ctucanfd-driver.rst     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 2fde5551e756..40c92ea272af 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -72,7 +72,7 @@ it is reachable (on which bus it resides) and its configuration –
 registers address, interrupts and so on. An example of such a device
 tree is given in .
 
-.. code:: raw
+::
 
            / {
                /* ... */
@@ -451,7 +451,7 @@ the FIFO is maintained, together with priority rotation, is depicted in
 
 |
 
-.. figure:: fsm_txt_buffer_user.svg
+.. kernel-figure:: fsm_txt_buffer_user.svg
 
    TX Buffer states with possible transitions
 
-- 
2.35.1


