Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78F64A3F9F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348104AbiAaJ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:59:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62625 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244621AbiAaJ7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643623149; x=1675159149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OQUhJF642/uvleoXNczRpNNaCVc1PX0AmlgliIsw8hM=;
  b=bHXvUm90S1B/1XCVpS7k6MeA7Fkj6WxkpmDGqe9EKvCl8s1FgrS0zkXY
   mt+uRzg3cuxZs7YlXqIpagkX/L0+4M0rxr2NGMGiug4Pq7ZrW7c4a9qHX
   KtBgKLDGzXUrPxp/ud6P8TMz1YMShv84M0vjXqjS6zaknMh/VTYrPx78b
   vY37c/7SPVmOOc+etPiNDOJpzCBQTN4IE8guA2YgFPkP07H9AWNXDH9nQ
   iMjvTt3VphSKy13WDSLEWBijmGDcwhZzuF+Fh2YLOsRDUvacUY4mgwT/L
   iqNcrx/e99D8z3JHbVp9zyfBIZmZuC8VTuVeuTfjxguC19PzATWz84tZ5
   g==;
IronPort-SDR: NLRWq9HBDpqiAAO/v/K1sxahvflbtE9E938WcLR/gz34nIWRa1h2SfWeBiJA7MT3le7Y/Jf+Mf
 MiFKlXJS+a34DoBlpinDefmAgMPuCr0OhJmAefvUCqtDeDhMnN1jOkQfHPx4TmS0PhAmouEHMd
 bkGQhdwCTHN+0D8zQdYe7v+rhQp4MlWpS6X10lbTiBF4YPT0qJW2nufwIH7hccXiHortYNM+QN
 vVrPHQr5kjNleoPnDm3nykJvqWNGuMte/FbSq9rYkzR9Rvi8Zi2eax+XdUwRVXWkiZYCIJGzLP
 jrHpNpxApNTRn0qhV75M2Cu8
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="151958753"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2022 02:59:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 02:59:07 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 31 Jan 2022 02:59:05 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/7] dt-bindings: net: lan966x: Extend with the ptp interrupt
Date:   Mon, 31 Jan 2022 11:01:16 +0100
Message-ID: <20220131100122.423164-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131100122.423164-1-horatiu.vultur@microchip.com>
References: <20220131100122.423164-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for lan966x with ptp interrupt. This is generated
when doing 2-step timestamping and the timestamp can be read from the
FIFO.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index e79e4e166ad8..13812768b923 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -38,6 +38,7 @@ properties:
       - description: register based extraction
       - description: frame dma based extraction
       - description: analyzer interrupt
+      - description: ptp interrupt
 
   interrupt-names:
     minItems: 1
@@ -45,6 +46,7 @@ properties:
       - const: xtr
       - const: fdma
       - const: ana
+      - const: ptp
 
   resets:
     items:
-- 
2.33.0

