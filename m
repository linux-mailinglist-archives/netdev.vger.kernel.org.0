Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9C610B28A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 16:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfK0Pjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 10:39:48 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45908 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfK0Pjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 10:39:47 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xARFdcwh078476;
        Wed, 27 Nov 2019 09:39:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574869178;
        bh=Psyf7mTJ+jSTqnRUbqkBC0f+Z6J0CTi9u7TTpexnusY=;
        h=From:To:CC:Subject:Date;
        b=Gug+HMXCOXvtL1j7EJtwWaS8jwkdvec7geM0AvaUwFLqrLUuGx9gicfbPxB9UUv2C
         YePqdFMeqqV9essK/IrTH0jORl2uyfDrOlRds98hSg7/MSrO93Xe5DSSLaFnIOXQFz
         Uj92QTISNPu1RS5Z79c++emq3v5N2GcMUeb/TNCQ=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xARFdc06062892
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 Nov 2019 09:39:38 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 27
 Nov 2019 09:39:38 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 27 Nov 2019 09:39:38 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xARFdbOP083678;
        Wed, 27 Nov 2019 09:39:38 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>
CC:     Simon Horman <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] dt-bindings: net: mdio: use non vendor specific compatible string in example
Date:   Wed, 27 Nov 2019 17:39:28 +0200
Message-ID: <20191127153928.22408-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use non vendor specific compatible string in example, otherwise DT YAML
schemas validation may trigger warnings specific to TI ti,davinci_mdio
and not to the generic MDIO example.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index 5d08d2ffd4eb..524f062c6973 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -56,7 +56,7 @@ patternProperties:
 examples:
   - |
     davinci_mdio: mdio@5c030000 {
-        compatible = "ti,davinci_mdio";
+        compatible = "vendor,mdio";
         reg = <0x5c030000 0x1000>;
         #address-cells = <1>;
         #size-cells = <0>;
-- 
2.17.1

