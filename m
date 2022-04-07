Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF2B4F785B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbiDGH6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242652AbiDGH6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:58:25 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB7F3389F
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:56:25 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 2377iePu045435;
        Thu, 7 Apr 2022 15:44:40 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from DylanHung-PC.aspeed.com (192.168.2.216) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Apr
 2022 15:56:01 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <BMC-SW@aspeedtech.com>
Subject: [PATCH RESEND v3 3/3] ARM: dts: aspeed: add reset properties into MDIO nodes
Date:   Thu, 7 Apr 2022 15:57:34 +0800
Message-ID: <20220407075734.19644-4-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407075734.19644-1-dylan_hung@aspeedtech.com>
References: <20220407075734.19644-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.216]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 2377iePu045435
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reset control properties into MDIO nodes.  The 4 MDIO controllers in
AST2600 SOC share one reset control bit SCU50[3].

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
---
 arch/arm/boot/dts/aspeed-g6.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed-g6.dtsi b/arch/arm/boot/dts/aspeed-g6.dtsi
index c32e87fad4dc..ab20ea8d829d 100644
--- a/arch/arm/boot/dts/aspeed-g6.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6.dtsi
@@ -181,6 +181,7 @@ mdio0: mdio@1e650000 {
 			status = "disabled";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_mdio1_default>;
+			resets = <&syscon ASPEED_RESET_MII>;
 		};
 
 		mdio1: mdio@1e650008 {
@@ -191,6 +192,7 @@ mdio1: mdio@1e650008 {
 			status = "disabled";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_mdio2_default>;
+			resets = <&syscon ASPEED_RESET_MII>;
 		};
 
 		mdio2: mdio@1e650010 {
@@ -201,6 +203,7 @@ mdio2: mdio@1e650010 {
 			status = "disabled";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_mdio3_default>;
+			resets = <&syscon ASPEED_RESET_MII>;
 		};
 
 		mdio3: mdio@1e650018 {
@@ -211,6 +214,7 @@ mdio3: mdio@1e650018 {
 			status = "disabled";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_mdio4_default>;
+			resets = <&syscon ASPEED_RESET_MII>;
 		};
 
 		mac0: ftgmac@1e660000 {
-- 
2.25.1

