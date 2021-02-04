Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FAB30FAA0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbhBDSEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238740AbhBDSDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:03:40 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05655C06121C
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:02:24 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id R62L2400H4C55Sk0662LEl; Thu, 04 Feb 2021 19:02:23 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l7im7-003Fgj-Dv; Thu, 04 Feb 2021 18:50:39 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l7eEU-006uI4-D1; Thu, 04 Feb 2021 13:59:38 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: can: rcar_canfd: Group tuples in pin control properties
Date:   Thu,  4 Feb 2021 13:59:37 +0100
Message-Id: <20210204125937.1646305-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve human readability and enable automatic validation, the tuples
in "pinctrl-*" properties should be grouped using angle brackets.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
index 22cf2a889b2c7d6b..248c4ed97a0a078e 100644
--- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
+++ b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
@@ -97,7 +97,7 @@ E.g. below enables Channel 0 alone in the board using External clock
 as fCAN clock.
 
 &canfd {
-	pinctrl-0 = <&canfd0_pins &can_clk_pins>;
+	pinctrl-0 = <&canfd0_pins>, <&can_clk_pins>;
 	pinctrl-names = "default";
 	status = "okay";
 
-- 
2.25.1

