Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561C82A597C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgKCWGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731038AbgKCWGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B95BC061A04
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:41 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rr-0006Ui-7z; Tue, 03 Nov 2020 23:06:39 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        Rob Herring <robh@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 01/27] dt-bindings: can: add can-controller.yaml
Date:   Tue,  3 Nov 2020 23:06:10 +0100
Message-Id: <20201103220636.972106-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

For now we have only node name as common rule for all CAN controllers

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20201022075218.11880-2-o.rempel@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../bindings/net/can/can-controller.yaml       | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/can-controller.yaml

diff --git a/Documentation/devicetree/bindings/net/can/can-controller.yaml b/Documentation/devicetree/bindings/net/can/can-controller.yaml
new file mode 100644
index 000000000000..9cf2ae097156
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/can-controller.yaml
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/can-controller.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: CAN Controller Generic Binding
+
+maintainers:
+  - Marc Kleine-Budde <mkl@pengutronix.de>
+
+properties:
+  $nodename:
+    pattern: "^can(@.*)?$"
+
+additionalProperties: true
+
+...

base-commit: 9621618130bf7e83635367c13b9a6ee53935bb37
-- 
2.28.0

