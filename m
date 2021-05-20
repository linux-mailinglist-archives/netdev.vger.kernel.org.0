Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401CE38B0B8
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241862AbhETOBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243572AbhETOAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 10:00:14 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1F9C061763
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 06:58:50 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:9cc6:7165:bcc2:1e70])
        by andre.telenet-ops.be with bizsmtp
        id 71yi2500T31btb9011yizs; Thu, 20 May 2021 15:58:46 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCD-007Wn3-UB; Thu, 20 May 2021 15:58:41 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljjCD-008zrZ-I0; Thu, 20 May 2021 15:58:41 +0200
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
Subject: [PATCH 2/5] ARM: dts: imx53-ard: Correct Ethernet node name
Date:   Thu, 20 May 2021 15:58:36 +0200
Message-Id: <daf2394440a8e6aae015b561f560e443aaa246bf.1621518686.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1621518686.git.geert+renesas@glider.be>
References: <cover.1621518686.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make dtbs_check:

    lan9220@f4000000: $nodename:0: 'lan9220@f4000000' does not match '^ethernet(@.*)?$'

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/imx53-ard.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx53-ard.dts b/arch/arm/boot/dts/imx53-ard.dts
index 9a2e1fde712879ea..6208fbb2e74104fb 100644
--- a/arch/arm/boot/dts/imx53-ard.dts
+++ b/arch/arm/boot/dts/imx53-ard.dts
@@ -24,7 +24,7 @@ eim-cs1@f4000000 {
 		reg = <0xf4000000 0x3ff0000>;
 		ranges;
 
-		lan9220@f4000000 {
+		ethernet@f4000000 {
 			compatible = "smsc,lan9220", "smsc,lan9115";
 			reg = <0xf4000000 0x2000000>;
 			phy-mode = "mii";
-- 
2.25.1

