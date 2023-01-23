Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4977467856B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjAWS40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAWS4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:56:25 -0500
Received: from riemann.telenet-ops.be (riemann.telenet-ops.be [IPv6:2a02:1800:110:4::f00:10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E944583EB
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:56:23 -0800 (PST)
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by riemann.telenet-ops.be (Postfix) with ESMTPS id 4P0zpY4Py2z4x1Nt
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 19:56:21 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:6083:1fd7:ba05:ea8d])
        by baptiste.telenet-ops.be with bizsmtp
        id CJwJ2900C4604Ck01JwJ2y; Mon, 23 Jan 2023 19:56:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zG-0076KH-Hi;
        Mon, 23 Jan 2023 19:56:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zO-00EkhB-Eg;
        Mon, 23 Jan 2023 19:56:18 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 03/12] dt-bindings: can: renesas,rcar-canfd: Add transceiver support
Date:   Mon, 23 Jan 2023 19:56:05 +0100
Message-Id: <1bd328b5c9c6cfa633b42af87550f4c7358a05c1.1674499048.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674499048.git.geert+renesas@glider.be>
References: <cover.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for describing CAN transceivers as PHYs.

While simple CAN transceivers can do without, this is needed for CAN
transceivers like NXP TJR1443 that need a configuration step (like
pulling standby or enable lines), and/or impose a bitrate limit.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml       | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 04b7f0afdce1e3c6..d3f45d29fa0a550a 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -84,6 +84,10 @@ patternProperties:
       The controller supports multiple channels and each is represented as a
       child node.  Each channel can be enabled/disabled individually.
 
+    properties:
+      phys:
+        maxItems: 1
+
     additionalProperties: false
 
 required:
-- 
2.34.1

