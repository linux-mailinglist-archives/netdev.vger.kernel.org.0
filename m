Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7B85071B7
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 17:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353870AbiDSP2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 11:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353841AbiDSP2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 11:28:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E5F13F80
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:26:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ngpjw-0001Ps-QQ
        for netdev@vger.kernel.org; Tue, 19 Apr 2022 17:26:04 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C7AF666B07
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 15:25:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3B24D66ABD;
        Tue, 19 Apr 2022 15:25:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 41dc2c5c;
        Tue, 19 Apr 2022 15:25:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/17] MAINTAINERS: rectify entry for XILINX CAN DRIVER
Date:   Tue, 19 Apr 2022 17:25:43 +0200
Message-Id: <20220419152554.2925353-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419152554.2925353-1-mkl@pengutronix.de>
References: <20220419152554.2925353-1-mkl@pengutronix.de>
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

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Commit 7843d3c8e5e6 ("dt-bindings: can: xilinx_can: Convert Xilinx CAN
binding to YAML") converts xilinx_can.txt to xilinx,can.yaml, but
missed to adjust its reference in MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains
about a broken reference.

Repair this file reference in XILINX CAN DRIVER.

Fixes: 7843d3c8e5e6 ("dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML")
Link: https://lore.kernel.org/all/20220321122840.17841-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 84158e08e6e9..eaa1a074bf16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21632,7 +21632,7 @@ M:	Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
 R:	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/can/xilinx_can.txt
+F:	Documentation/devicetree/bindings/net/can/xilinx,can.yaml
 F:	drivers/net/can/xilinx_can.c
 
 XILINX GPIO DRIVER
-- 
2.35.1


