Return-Path: <netdev+bounces-5584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C77F7122FE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 067B828174D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCF41094E;
	Fri, 26 May 2023 09:05:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D3710786
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:05:10 +0000 (UTC)
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FB6119;
	Fri, 26 May 2023 02:05:07 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
	by fd01.gateway.ufhost.com (Postfix) with ESMTP id 84D7D8109;
	Fri, 26 May 2023 17:05:05 +0800 (CST)
Received: from EXMBX062.cuchost.com (172.16.6.62) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 26 May
 2023 17:05:05 +0800
Received: from starfive-sdk.starfivetech.com (171.223.208.138) by
 EXMBX062.cuchost.com (172.16.6.62) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Fri, 26 May 2023 17:05:04 +0800
From: Samin Guo <samin.guo@starfivetech.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>, Frank
	<Frank.Sae@motor-comm.com>
CC: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>, Andrew Lunn <andrew@lunn.ch>, "Heiner
 Kallweit" <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>,
	"Samin Guo" <samin.guo@starfivetech.com>, Yanhong Wang
	<yanhong.wang@starfivetech.com>
Subject: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver strength cfg
Date: Fri, 26 May 2023 17:05:01 +0800
Message-ID: <20230526090502.29835-2-samin.guo@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230526090502.29835-1-samin.guo@starfivetech.com>
References: <20230526090502.29835-1-samin.guo@starfivetech.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX062.cuchost.com
 (172.16.6.62)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The motorcomm phy (YT8531) supports the ability to adjust the drive
strength of the rx_clk/rx_data, the value range of pad driver
strength is 0 to 7.

Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
---
 .../devicetree/bindings/net/motorcomm,yt8xxx.yaml    | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
index 157e3bbcaf6f..29a1997a1577 100644
--- a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
+++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
@@ -52,6 +52,18 @@ properties:
       for a timer.
     type: boolean
 
+  motorcomm,rx-clk-driver-strength:
+    description: drive strength of rx_clk pad.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
+    default: 3
+
+  motorcomm,rx-data-driver-strength:
+    description: drive strength of rx_data/rx_ctl rgmii pad.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
+    default: 3
+
   motorcomm,tx-clk-adj-enabled:
     description: |
       This configuration is mainly to adapt to VF2 with JH7110 SoC.
-- 
2.17.1


