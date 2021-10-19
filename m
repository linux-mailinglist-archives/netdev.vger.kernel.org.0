Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574E443363C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhJSMpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbhJSMpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:45:35 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50C1C06176D
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:43:22 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:b4c3:ba80:54db:46f])
        by michel.telenet-ops.be with bizsmtp
        id 7ojF2600c12AN0U06ojFzA; Tue, 19 Oct 2021 14:43:20 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoSZ-0069O4-Bi; Tue, 19 Oct 2021 14:43:15 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoSY-00EESf-GI; Tue, 19 Oct 2021 14:43:14 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        David Lechner <david@lechnology.com>,
        Sebastian Reichel <sre@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/3] ARM: dts: motorola-mapphone: Drop second ti,wlcore compatible value
Date:   Tue, 19 Oct 2021 14:43:11 +0200
Message-Id: <84f8e477015d73ce7fca7b8abdd1099f505ad972.1634646975.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634646975.git.geert+renesas@glider.be>
References: <cover.1634646975.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TI wlcore DT bindings specify using a single compatible value for
each variant, and the Linux kernel driver matches against the first
compatible value since commit 078b30da3f074f2e ("wlcore: add wl1285
compatible") in v4.13.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/motorola-mapphone-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
index a4423ff0df39264b..c7a1f3ffc48ca58e 100644
--- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
+++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
@@ -310,7 +310,7 @@ &mmc3 {
 	#address-cells = <1>;
 	#size-cells = <0>;
 	wlcore: wlcore@2 {
-		compatible = "ti,wl1285", "ti,wl1283";
+		compatible = "ti,wl1285";
 		reg = <2>;
 		/* gpio_100 with gpmc_wait2 pad as wakeirq */
 		interrupts-extended = <&gpio4 4 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.25.1

