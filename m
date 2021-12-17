Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F37478AFF
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhLQMJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 07:09:10 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:21941 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbhLQMJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 07:09:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639742949; x=1671278949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4dr5CJLFKWVQrkJhrfDVafsYeo5cW6GO/ds1HbLxWGk=;
  b=1jlS6Kp+p3aBFu1eUuqXjnbQUDpyn711Ez6zixm7d3X+NaMTA7UDx/19
   L6azvIKbvDlfCcaOUopDx0f4h2RsqzXrhmTetTF8Y8G5qH0LoN4fpWiGH
   PB3V05ww1EXHBUyGdTxkDyDECawgjw/V6DDMbCU7uA9LW0X+jsWMviyok
   UC+dOI+txHz2aAC2185R+hkgjyFpjfgptwQFycZ3PqGTcGk4kq8chItYh
   I7mu6VS1p/I1EfSw76rMcOW6Yp9PlakDcPyE4CtEG+s2LyfEpkIl9pa2+
   oedHK5mlExsLSM+vkDJnUMwh/7GGcGpgdopKQ+t69ewO8UrBSE2nV5uHS
   A==;
IronPort-SDR: 6IPEaHMn3IfnuuWkMLgeQrK1Abon3obL2IkWTkgTyXPqO71UspT+bPEgRZvi3YVeSymYLrfy1q
 f7ELNWS0tYElfwZtZGDdA+27zeRj3tfrQwX2Jk8M/EEqfBRUtEfe3vsNmVEjXLpH5gadVaH1d6
 KQtUHyeK5ECGF9eqbq1h13pSbQ2nD4z1ntMG8I7+47gzAtqGaaaQLYDbzBM/DgFrv4lvfpAczp
 VCY/4Fc0Ju6hUyOlWaw0Mm2Yi9QvdqK3zX+ZUxS0zbFxSBut5/df1HV/rvtBs4hUIwYxMFXlZI
 kUcdtgLbkz3IjkbA28+gjQCK
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="147012726"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 05:09:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 05:09:07 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Dec 2021 05:09:05 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v6 2/9] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Fri, 17 Dec 2021 13:10:10 +0100
Message-ID: <20211217121017.282481-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217121017.282481-1-horatiu.vultur@microchip.com>
References: <20211217121017.282481-1-horatiu.vultur@microchip.com>
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

