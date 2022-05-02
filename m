Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5B6516B96
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383661AbiEBIC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383634AbiEBICv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:02:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFBD2C675
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 00:59:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlQxm-0002TM-62
        for netdev@vger.kernel.org; Mon, 02 May 2022 09:59:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1B8F472E3A
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:59:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A724372E08;
        Mon,  2 May 2022 07:59:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4611b67a;
        Mon, 2 May 2022 07:59:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Odrej Ille <ondrej.ille@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 4/9] docs: networking: device drivers: can: ctucanfd: update author e-mail
Date:   Mon,  2 May 2022 09:59:09 +0200
Message-Id: <20220502075914.1905039-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502075914.1905039-1-mkl@pengutronix.de>
References: <20220502075914.1905039-1-mkl@pengutronix.de>
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

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

This patch updates the author's email address.

Link: https://lore.kernel.org/all/e4396244da6b008c671def9f50bb983a10389863.1650816929.git.pisa@cmp.felk.cvut.cz
Cc: Odrej Ille <ondrej.ille@gmail.com>
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
[mkl: split into separate patches]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../networking/device_drivers/can/ctu/ctucanfd-driver.rst       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 797fb45be187..2fde5551e756 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -536,7 +536,7 @@ CTU CAN FD Driver Sources Reference
 CTU CAN FD IP Core and Driver Development Acknowledgment
 ---------------------------------------------------------
 
-* Odrej Ille <illeondr@fel.cvut.cz>
+* Odrej Ille <ondrej.ille@gmail.com>
 
   * started the project as student at Department of Measurement, FEE, CTU
   * invested great amount of personal time and enthusiasm to the project over years
-- 
2.35.1


