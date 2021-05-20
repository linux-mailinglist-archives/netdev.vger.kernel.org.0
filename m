Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BC038B0C9
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242398AbhETOBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243569AbhETOAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 10:00:19 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91288C06138A
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 06:58:50 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:9cc6:7165:bcc2:1e70])
        by baptiste.telenet-ops.be with bizsmtp
        id 71yi2500931btb9011yiMK; Thu, 20 May 2021 15:58:46 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCD-007Wn2-Um; Thu, 20 May 2021 15:58:41 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCD-008zrT-HD; Thu, 20 May 2021 15:58:41 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/5] ARM: dts: i.MX51: digi-connectcore-som: Correct Ethernet node name
Date:   Thu, 20 May 2021 15:58:35 +0200
Message-Id: <44eec3e8f638f3ac0a2b58ea52f3442a8f52a9a0.1621518686.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1621518686.git.geert+renesas@glider.be>
References: <cover.1621518686.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make dtbs_check:

    lan9221@5,0: $nodename:0: 'lan9221@5,0' does not match '^ethernet(@.*)?$'

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi b/arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi
index 16addb3a2a1b4ee6..7d4970417dce8fd7 100644
--- a/arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi
+++ b/arch/arm/boot/dts/imx51-digi-connectcore-som.dtsi
@@ -206,7 +206,7 @@ &weim {
 	pinctrl-0 = <&pinctrl_weim>;
 	status = "okay";
 
-	lan9221: lan9221@5,0 {
+	lan9221: ethernet@5,0 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_lan9221>;
 		compatible = "smsc,lan9221", "smsc,lan9115";
-- 
2.25.1

