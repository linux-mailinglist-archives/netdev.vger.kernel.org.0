Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EA6467582
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352174AbhLCKtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:49:22 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32101 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352031AbhLCKtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638528356; x=1670064356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SzVwhwLnt8ql7ii30Vxma29+2up071tdWQBl65HE5V4=;
  b=bfQq2CvaQgXuDIZf35oCcSsRnLktl40nendzrDwOtmPyEfaogLWlm5jc
   68QSLvXs29XdCWHynmTmtcquRxnKIHL9lf+jdHUMNJowwNUjWFK90Ak+v
   Z2c4Y5nEVhehbyfozHPF6j735DRIR1HNySTC3bd3/kt6Unnruah5fXuaE
   +AhM0a25MGzmO5KtdrDejW/ft0ECOteu4HVFVI076ziFGGegDfP1sqp2a
   t1cID7MrMOMNw/ehr5DOACbdp41D3vbsing4EpfKa4cmPVDZTSmGUNQSL
   V6K9g+oJlvmtrjKQlw2UEOPP9roCl0VFsp55uFwTTQdVx2geCwIseaxy8
   A==;
IronPort-SDR: M1mZpKSZ5fpFndsaT4nhGawCbRaXPDlPVoO9razX0SAd4mS8QYE3wR0oMbyXVWZPHPUMU/Iu/B
 0V2tWgOSO3Z/IHwXe6wUWHw2V8erGLEW/dW4W94fO7R6uZ7lllhlhtnLjI5fLdd1bdmb3+d3Ee
 u2JAEu98qnb3p4D0yIm++S+/hqwsv2b6ok0pLeVh2AMLTsxKFYkpvLIIvLP2d5i94zWVDqOng/
 GM+CX40MQJNDAmE9sXusWQZpMRCXicHON0nOmqrC//6akRAhoSqhNAvXFTqt/JNGhLCDLWGesg
 OehxoMVcTUuH9BEH+ImRk4Wz
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="145985155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2021 03:45:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Dec 2021 03:45:56 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 3 Dec 2021 03:45:54 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/6] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Fri, 3 Dec 2021 11:46:41 +0100
Message-ID: <20211203104645.1476704-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
References: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for lan966x with analyzer interrupt.
This interrupt can be generated for example when the HW learn/forgets
an entry in the MAC table.

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

