Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F582479068
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbhLQPxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:53:05 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62791 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238316AbhLQPxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 10:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639756381; x=1671292381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4dr5CJLFKWVQrkJhrfDVafsYeo5cW6GO/ds1HbLxWGk=;
  b=cUnb31Y/B6+exZzS/sZ6WDjRMlaGv8n72nMIIMYTeFJOBhhOCOZ/kFCB
   YHTYcMPhHDx3vmSrOw6kdoDlxatxvkLy8bA58dRC6Afr6mRPNNkGEKi9Q
   gQdSZOUrvSvy/n1i2GG70jg7odS5RuUhjMdXICrWPxu5MbO/O6/FE1jHL
   arNbg5pYx9ihCqrh46LdWJDgS0exZSQdm1eCWyc9pCip2MamZ/EcxJuuq
   1MRFIuxx9hKqkb/OIYfei/940LWy2tjK7ot5KwJAfzErYBfC77z75vEcP
   FMYiFErnYUScY5c7vs9ISoU/Vjbg96/pfaucBFOt8YHV6iTc8tFfSNXWa
   A==;
IronPort-SDR: NtUdIkoVtxupRt/gzEL2oEQ9QYi9V0gsTQTsST4Xpph0sXjtYFwckXbRfE5Pi1uqMi7wFLEazL
 WpiJsUjFV727pAqfedFD8HGiSFacPX7ULrcLbrXYpXz/L4f2BOJm1HCfnntMW7f7I/KudR8VQG
 2E3zA3xGkRd+qfP9/XNncV4BLM73OdfSxpvxgVkrkl4StlvCRAZz7qWfP+q/Xnb42swYCahnZp
 dcVYhq5SUnRSexGD6ATHsRQYSMPL2/7YUdJp0s022j2lEuRl4XxEdCOqsb5VR08EcxRJSMF165
 WavyraPrJHZ0RvnIwz+RDHdY
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="147607537"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 08:53:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 08:53:00 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Dec 2021 08:52:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v7 2/9] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Fri, 17 Dec 2021 16:53:46 +0100
Message-ID: <20211217155353.460594-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217155353.460594-1-horatiu.vultur@microchip.com>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for lan966x with analyzer interrupt.
This interrupt can be generated for example when the HW learn/forgets
an entry in the MAC table.

Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index 5bee665d5fcf..e79e4e166ad8 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -37,12 +37,14 @@ properties:
     items:
       - description: register based extraction
       - description: frame dma based extraction
+      - description: analyzer interrupt
 
   interrupt-names:
     minItems: 1
     items:
       - const: xtr
       - const: fdma
+      - const: ana
 
   resets:
     items:
-- 
2.33.0

