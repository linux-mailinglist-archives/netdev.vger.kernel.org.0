Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BED479D8B
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhLRVsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:48:22 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32565 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbhLRVsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:48:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639864099; x=1671400099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4dr5CJLFKWVQrkJhrfDVafsYeo5cW6GO/ds1HbLxWGk=;
  b=Jt9Bw615AV8hCcyL5qsxV4Zv4RoeXW0w4Z/a96IyJ+yHrCM6V4f68fip
   9yszGEd0sreSgkewRSaAvVoDkPQTz1bB/VMfrXumf4UNYmtToBJKy2jz/
   dcaef9MBubXSHN0ztACvx0SMB2gFB1G2BpFmCty1UVIGO+ctgGHNEI5sd
   kgTPjMPDN3Y/CKrzSwmPhSo8MPqHUwg0CAVRJz6iABSZ053RbUnLbatE6
   SFKabSJWI+gtgRBWBzeq4y5KJuYVm6BW5m8YljtVyttvk/STAWfHkRRfy
   uR3qQ6PhPHj/sp8FGa5vq+OCcQyhARNxBYCI5ZT3DuZw/MfX1Y6u/jy51
   Q==;
IronPort-SDR: w//HnoGQd403Vc6YC6QLsI9M0vBhQwpbrBcXaMkDKnDs33dIWrFfdUuxYQDIcLM4d/6WdP6Jh4
 KBUg6Gli0cBDkiCIzAzlWw0bK6FVDxx/b2XHTr8crvRMyhKNWyd4VjPgr23hEajCtp4IKlA5xo
 boOieUsVBmz18wyn5xLth8c3zu8t2wuKFX8iuVodjc4Iqx9qCQE+689BVYHW7Hn0ComG/OELf+
 NKmQlBOf/YUrnTK190xsvTeb7qMP/L9ROHviDmzV66IO1xmvut7eEr2FLjRypS1o7rsVymMrhh
 Nx55zBjmebxvJjBv/g6Nb2rr
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="147699434"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 14:48:19 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 14:48:14 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 18 Dec 2021 14:48:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v8 2/9] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Sat, 18 Dec 2021 22:49:39 +0100
Message-ID: <20211218214946.531940-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211218214946.531940-1-horatiu.vultur@microchip.com>
References: <20211218214946.531940-1-horatiu.vultur@microchip.com>
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

