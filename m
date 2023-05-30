Return-Path: <netdev+bounces-6598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD07F7170F6
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:49:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C39C1C20D7C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61AFC34CDB;
	Tue, 30 May 2023 22:48:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ABF34CCA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:48:50 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E92EC;
	Tue, 30 May 2023 15:48:47 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34UMmLwD002590;
	Tue, 30 May 2023 17:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1685486901;
	bh=lRjzC1PXGwTxRNrfRpHXIWdTM8CL+XACgMhEM8GBJrQ=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=tTURIePUlPnCFNySKF9H/lJizOlYT8OwW7ENuwmdLqw+W/PGlDzr0mQw9PcQPMiRO
	 pkJBoHmqwSEPn8TQk1g1E1t/5kYWs1fTkpEupQtq7CSPR5/3XQTh5oLUA4TKavvPVV
	 vl8AVeXjFrRMAeo6QIyiuFfnDWDMJRNIE+KTbax0=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34UMmL8B036335
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 30 May 2023 17:48:21 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 30
 May 2023 17:48:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 30 May 2023 17:48:20 -0500
Received: from uda0498204.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34UMmKxW112899;
	Tue, 30 May 2023 17:48:20 -0500
From: Judith Mendez <jm@ti.com>
To: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <linux-can@vger.kernel.org>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde
	<mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Schuyler Patton <spatton@ti.com>,
        Tero Kristo
	<kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        <devicetree@vger.kernel.org>,
        Oliver
 Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>,
        Conor Dooley <conor+dt@linaro.org>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH v8 1/2] dt-bindings: net: can: Remove interrupt properties for MCAN
Date: Tue, 30 May 2023 17:48:19 -0500
Message-ID: <20230530224820.303619-2-jm@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530224820.303619-1-jm@ti.com>
References: <20230530224820.303619-1-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
routed to A53 Linux, instead they will use software interrupt by
timer polling.

To enable timer polling method, interrupts should be
optional so remove interrupts property from required section and
add an example for MCAN node with timer polling enabled.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Judith Mendez <jm@ti.com>
---
Changelog:
v8:
   1. No changes
v7:
   1. No changes
v6:
   1. No changes
v5:
   1. Remove poll-interval
   2. Remove oneOf that selects interrupts/interrupt-names or poll-interval
v3:
   1. Update binding poll-interval description
   2. Add oneOf to select interrupts/interrupt-names or poll-interval
v2:
   1. Add poll-interval property to enable timer polling method
   2. Add example using poll-interval property
---
 .../bindings/net/can/bosch,m_can.yaml         | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 67879aab623b..bb518c831f7b 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -122,8 +122,6 @@ required:
   - compatible
   - reg
   - reg-names
-  - interrupts
-  - interrupt-names
   - clocks
   - clock-names
   - bosch,mram-cfg
@@ -132,6 +130,7 @@ additionalProperties: false
 
 examples:
   - |
+    // Example with interrupts
     #include <dt-bindings/clock/imx6sx-clock.h>
     can@20e8000 {
       compatible = "bosch,m_can";
@@ -149,4 +148,21 @@ examples:
       };
     };
 
+  - |
+    // Example with timer polling
+    #include <dt-bindings/clock/imx6sx-clock.h>
+    can@20e8000 {
+      compatible = "bosch,m_can";
+      reg = <0x020e8000 0x4000>, <0x02298000 0x4000>;
+      reg-names = "m_can", "message_ram";
+      clocks = <&clks IMX6SX_CLK_CANFD>,
+               <&clks IMX6SX_CLK_CANFD>;
+      clock-names = "hclk", "cclk";
+      bosch,mram-cfg = <0x0 0 0 32 0 0 0 1>;
+
+      can-transceiver {
+        max-bitrate = <5000000>;
+      };
+    };
+
 ...
-- 
2.34.1


