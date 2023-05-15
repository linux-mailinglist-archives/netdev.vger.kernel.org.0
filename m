Return-Path: <netdev+bounces-2774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 219A2703ED1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 212F31C20C8F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA08619E4B;
	Mon, 15 May 2023 20:47:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE0719E48
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:47:34 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C27893C7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:47:32 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyf6Q-0004p1-Pl
	for netdev@vger.kernel.org; Mon, 15 May 2023 22:47:30 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id 0F5221C5C4B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:47:28 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 5FD611C5C0B;
	Mon, 15 May 2023 20:47:25 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4473973c;
	Mon, 15 May 2023 20:47:24 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Rob Herring <robh@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 5/9] dt-bindings: net: can: add "st,can-secondary" property
Date: Mon, 15 May 2023 22:47:18 +0200
Message-Id: <20230515204722.1000957-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230515204722.1000957-1-mkl@pengutronix.de>
References: <20230515204722.1000957-1-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

On the stm32f7 Socs the can peripheral can be in single or dual
configuration. In the dual configuration, in turn, it can be in primary
or secondary mode. The addition of the 'st,can-secondary' property allows
you to specify this mode in the dual configuration.

CAN peripheral nodes in single configuration contain neither
"st,can-primary" nor "st,can-secondary".

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/all/20230427204540.3126234-2-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/st,stm32-bxcan.yaml      | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
index 769fa5c27b76..de1d4298893b 100644
--- a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
@@ -21,11 +21,22 @@ properties:
 
   st,can-primary:
     description:
-      Primary and secondary mode of the bxCAN peripheral is only relevant
-      if the chip has two CAN peripherals. In that case they share some
-      of the required logic.
+      Primary mode of the bxCAN peripheral is only relevant if the chip has
+      two CAN peripherals in dual CAN configuration. In that case they share
+      some of the required logic.
+      Not to be used if the peripheral is in single CAN configuration.
       To avoid misunderstandings, it should be noted that ST documentation
-      uses the terms master/slave instead of primary/secondary.
+      uses the terms master instead of primary.
+    type: boolean
+
+  st,can-secondary:
+    description:
+      Secondary mode of the bxCAN peripheral is only relevant if the chip
+      has two CAN peripherals in dual CAN configuration. In that case they
+      share some of the required logic.
+      Not to be used if the peripheral is in single CAN configuration.
+      To avoid misunderstandings, it should be noted that ST documentation
+      uses the terms slave instead of secondary.
     type: boolean
 
   reg:
-- 
2.39.2



