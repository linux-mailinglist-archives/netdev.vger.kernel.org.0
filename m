Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A00C2F08
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbfJAIlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:41:06 -0400
Received: from hermes.aosc.io ([199.195.250.187]:52090 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbfJAIlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 04:41:06 -0400
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: icenowy@aosc.io)
        by hermes.aosc.io (Postfix) with ESMTPSA id C4D1A82B04;
        Tue,  1 Oct 2019 08:30:57 +0000 (UTC)
From:   Icenowy Zheng <icenowy@aosc.io>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.xyz>
Subject: [PATCH 1/3] dt-bindings: add binding for RTL8211E Ethernet PHY
Date:   Tue,  1 Oct 2019 16:29:10 +0800
Message-Id: <20191001082912.12905-2-icenowy@aosc.io>
In-Reply-To: <20191001082912.12905-1-icenowy@aosc.io>
References: <20191001082912.12905-1-icenowy@aosc.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.xyz>

Some RTL8211E Ethernet PHY have an issue that needs a workaround, and a
way to indicate the need of the workaround should be added.

Add the binding for a DT property that indicates this workaround.

Signed-off-by: Icenowy Zheng <icenowy@aosc.xyz>
---
 .../bindings/net/realtek,rtl8211e.yaml        | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8211e.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8211e.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8211e.yaml
new file mode 100644
index 000000000000..264e93cafbec
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek,rtl8211e.yaml
@@ -0,0 +1,23 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/realtek,rtl8211e.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Realtek RTL8211E Ethernet PHY
+
+properties:
+  realtek,config-magic-for-pine64:
+    description:
+      Enabling specific hacks for some broken RTL8211E chips known to be
+      used by Pine64+ boards.
+
+examples:
+  - |
+    &mdio {
+        ext_phy: ethernet-phy@0 {
+            compatible = "ethernet-phy-ieee802.3-c22";
+            reg = <0>;
+            realtek,config-magic-for-pine64;
+        };
+    };
-- 
2.21.0

