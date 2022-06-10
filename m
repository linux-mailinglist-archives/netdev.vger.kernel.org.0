Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E6A545E69
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347319AbiFJIRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347310AbiFJIRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:17:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DED21F98E
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 01:16:40 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nzZof-0004Tv-FI; Fri, 10 Jun 2022 10:16:25 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nzZof-007Xi9-8S; Fri, 10 Jun 2022 10:16:23 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nzZoc-002SEu-JU; Fri, 10 Jun 2022 10:16:22 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1] ARM: dts: at91: ksz9477_evb: fix port/phy validation
Date:   Fri, 10 Jun 2022 10:16:21 +0200
Message-Id: <20220610081621.584393-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
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

Latest drivers version requires phy-mode to be set. Otherwise we will
use "NA" mode and the switch driver will invalidate this port mode.

Fixes: 65ac79e18120 ("net: dsa: microchip: add the phylink get_caps")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts b/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
index 443e8b022897..14af1fd6d247 100644
--- a/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
+++ b/arch/arm/boot/dts/at91-sama5d3_ksz9477_evb.dts
@@ -120,26 +120,31 @@ ports {
 			port@0 {
 				reg = <0>;
 				label = "lan1";
+				phy-mode = "internal";
 			};
 
 			port@1 {
 				reg = <1>;
 				label = "lan2";
+				phy-mode = "internal";
 			};
 
 			port@2 {
 				reg = <2>;
 				label = "lan3";
+				phy-mode = "internal";
 			};
 
 			port@3 {
 				reg = <3>;
 				label = "lan4";
+				phy-mode = "internal";
 			};
 
 			port@4 {
 				reg = <4>;
 				label = "lan5";
+				phy-mode = "internal";
 			};
 
 			port@5 {
-- 
2.30.2

