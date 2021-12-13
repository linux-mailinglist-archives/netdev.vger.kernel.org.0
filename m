Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB9547293E
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245077AbhLMKTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:19:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:3463 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243987AbhLMKPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639390501; x=1670926501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V+Jv9MaMFqvcBDNSlIjW3tUS0kwQ8RDWb5PfDQGs6NU=;
  b=SPFas1cbqyiU3lLweIksQTDvc1n6i5kABhORH1VbHBj4uYRRSAserCEb
   lKj0xIzoOihlyFQFmJ5z6VTaqe0luX+rPfy4qqs/1t1/gEPJRAWxxBjAK
   3RrBpWFK/AzE77idTwozXpmimyYt3sgaeYfya/QaoazpkAiCrbZQLGut0
   EccsP+0pvvGDGXh0EwWIHicKugxdBCSqtIogEQpgODerlkqIWJwcyMbgF
   TZPPlQ3imLs2unCovWCxGlaGnAfqlQ2IoOzPl7wZDBIKJDSSWMEcWU1M4
   fXl7qvhs8/P2Wr3zuo92X37BV16an65FGXifuqw3CSY0oCHluP1hgDBa1
   Q==;
IronPort-SDR: yOpSMrsFf9gV7hKYwW+bqXe0385gEc88EBCZap+PqjJyzDibmssJZnFmNldL5YB1GqXJ1vKlYr
 Pigf0I23KGFytgHrth51Gb/UkErqxQ7plPZC4NQwtwZ6RsDhTOs+byn5ZJ4rlcDgqyY8FG/29Q
 C0rF0qNuvF1WMM5RPBy8Lt9XfNCEykGo+m88SpqvVKzSlBNCxDKvat1vjzUafNJVKwCSBO4UcD
 o2429y60LW50rw/nqboJFOPbVLw86vpDGp3H/AYSs1Yfo+IkprZZGrD4lpDkEu8AXGzC2zHqJu
 XK+vCFmD5omsOoEixiQ0ITg5
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="147013397"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:15:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:15:00 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Dec 2021 03:14:57 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 02/10] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Mon, 13 Dec 2021 11:14:24 +0100
Message-ID: <20211213101432.2668820-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
References: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for lan966x with analyzer interrupt.
This interrupt can be generated for example when the HW learn/forgets
an entry in the MAC table.

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

