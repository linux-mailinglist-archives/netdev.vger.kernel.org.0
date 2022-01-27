Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB4E49DF22
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbiA0KVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:21:44 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:4337 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239195AbiA0KVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:21:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643278903; x=1674814903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OQUhJF642/uvleoXNczRpNNaCVc1PX0AmlgliIsw8hM=;
  b=rMqmOo/tQSEj+Ws59kKr6ASnz2Mm+KrFFfuyFFJPieb1vFDcikojnFxT
   Yq95qML/ZO9u5aampKt9GsQhj/i6dt+abBeXODfFlh/c2qo/vGa3n57Gd
   UL4ecaVIoeJwXv8x6VIKI8oRAaG/pMN/MRQT/wcSPKXv54uyJsnZ3bIJj
   1H8e7oSbJDn7rzTSmU1VMda7BrZgPzx+wYOqenK+leKh98BAmt3Awdt6+
   XH8bR+64oT8jvXmjFeFfDfO+nPPi529bgMNbqwQ40ecn2iNPsgP2IAcsn
   eh7hJtrXmMxUmDE7w8O65sOtM194/s4C8oFv7rtzVumuVvohQhxhI87cQ
   A==;
IronPort-SDR: 95pRJlrJ2o0GYvdgVheAO8R8Q8aWFP/t3mMq2vExA5pd5Y+143zVjZMSSkraa6AdB/FZkJDUho
 +QPBYl9IBBFP9XuDF5Qfjt/M4oK1yL078MOUBYyWZ3lpNQqbMg6fT7zajfXzLORMx7sWETGzPt
 JIASxpnFBf49jD94l+eczMudtXkKTI7o99VzwJiZJ7Ih84dOOYyjmTn0v6L4ypzgvssovoR5dA
 yHueANm9psAtm2RMpQNnFGWbNdJOOhB82BimdMMbYkVIt2F2Pj3uzK1F5GN1U1HiW39KOrrq46
 FkdJ3joQpK/4BKMbZa4/ATt/
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="151079215"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 03:21:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 03:21:40 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 03:21:37 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/7] dt-bindings: net: lan966x: Extend with the ptp interrupt
Date:   Thu, 27 Jan 2022 11:23:27 +0100
Message-ID: <20220127102333.987195-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220127102333.987195-1-horatiu.vultur@microchip.com>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
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

