Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C31475881
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbhLOMM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:12:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:58871 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242346AbhLOMM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:12:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639570346; x=1671106346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4dr5CJLFKWVQrkJhrfDVafsYeo5cW6GO/ds1HbLxWGk=;
  b=p55PmhbDSPc+IEcv6ZktKw5oNlfeTStY0uXaAG6TrjlgZdALVGioQMna
   PIXzaIvUPGSdzrZ6qJIqrxXaxjDHcP+gE7FSGOtPmnCXTUy2CMUJzqdGb
   nhWyqOaTlFedEcbSu6NEhnGr8KzllgEGcvGqsFbWTexBHHg8CUgyMK2Hz
   cz9bKdDlyiP9DoJGaEEp1wK7Es1B6y7IYYMGbpAlNHRBHEGGu/Zo4AX6k
   EEdYWnEonvZoDKdT1NwrGSTR+ikQzOFdrUdPp4fYQilbGAO6+TirKbToL
   P20/e5Iv8IPhPEPP094RKvD9kXnw021L0VNAs0EkDuWNC5aguiZ7sTGO0
   g==;
IronPort-SDR: EvBGzQdK6JOf1+iswiKNPp5CGe2GftZSlkUS8Dx79OCA9zadVRXx/pMkyIk3DsEhFyXfhl/kSm
 digAtgeOof0Yri2grEQOwI+FNsTUNA8kmcH249XCXJwzzhKXCeEENBlgOpxVELi259paAkfE30
 RMUmN4qo9OfTxff/MqNUHp+tdb8rrvxakaG9azMYMhjd19494qzKutL5Yi1shXdohoQvufMQj8
 BuISBCLgB1Mtbq9bUTvg3iIqkySIy/R3Dv1aREchmq178EK+SHqpqOiW7SOH54XvPiHmJ5pn34
 AqwuAZszBB92ivf6EsJegTL8
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="139847907"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2021 05:12:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Dec 2021 05:12:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Dec 2021 05:12:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v5 2/9] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Wed, 15 Dec 2021 13:13:02 +0100
Message-ID: <20211215121309.3669119-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
References: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
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

