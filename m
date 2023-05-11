Return-Path: <netdev+bounces-1850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D69E76FF4AE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E8B62813B2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1997620;
	Thu, 11 May 2023 14:39:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D716E372
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:39:53 +0000 (UTC)
X-Greylist: delayed 1641 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 May 2023 07:39:49 PDT
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDD91156A;
	Thu, 11 May 2023 07:39:49 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1px71g-0000mM-2M;
	Thu, 11 May 2023 14:12:12 +0000
Date: Thu, 11 May 2023 16:10:20 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: devicetree@vger.kernel.org, netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Qingfang Deng <dqfext@gmail.com>,
	SkyLake Huang <SkyLake.Huang@mediatek.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v4 1/2] dt-bindings: arm: mediatek: add
 mediatek,boottrap binding
Message-ID: <f2d447d8b836cf9584762465a784185e8fcf651f.1683813687.git.daniel@makrotopia.org>
References: <cover.1683813687.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683813687.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The boottrap is used to read implementation details from the SoC, such
as the polarity of LED pins. Add bindings for it as we are going to use
it for the LEDs connected to MediaTek built-in 1GE PHYs.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../arm/mediatek/mediatek,boottrap.yaml       | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.yaml
new file mode 100644
index 000000000000..460e375320a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,boottrap.yaml
@@ -0,0 +1,37 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/arm/mediatek/mediatek,boottrap.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek boottrap
+
+maintainers:
+  - Daniel Golle <daniel@makrotopia.org>
+
+description:
+  The boottrap found in some MediaTek SoCs is used to read SoC implementation
+  details such as LED polarities.
+
+properties:
+  $nodename:
+    const: boottrap
+
+  compatible:
+    const: mediatek,boottrap
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    boottrap: boottrap@1001f6f0 {
+      compatible = "mediatek,boottrap";
+      reg = <0 0x1001f6f0 0 0x20>;
+    };
-- 
2.40.0


