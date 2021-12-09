Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E9446E5D7
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhLIJt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:49:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49053 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhLIJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639043181; x=1670579181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SzVwhwLnt8ql7ii30Vxma29+2up071tdWQBl65HE5V4=;
  b=Jseh4z1CeF0ccP281dPPCdCtsZibc42mnuCUtYjOjgux4CkLn00CFND4
   xrK2/VQtvSfY8VPEBisw7GszQ+TSpxmSWwbQUjwN8M3Jvtia4mtLims80
   mWB+wd4bdxKbVAAk/oDfXZuYRyLX/n+Y/fmbj1XpxxJjO0ca2jIj0RN/L
   hfJwOj7DX3uphbC2nKQk0y1soSYKwV6GuzoKoEpfDp+OWsPesfLnuBL94
   b+chr+OxajEDYOKJ2hkuqXw8e9hXYq3ngCUAXzJuxtYIIaKqhChOVm+Uv
   Vb66fZvZLVK7SHs6W/1bRasj8IiiOj31vxgdYhYjiEZHHfUFvs3pURAPI
   w==;
IronPort-SDR: LV7qBGWwQSFDY/bFgnBK31h0Fd+LSZ38I4LD0n21Modn8uK9/xCbpjOKCrTrNi+D8uykI3FCqU
 YZ+2acyNWqbctpRevbAUO+vYs0XiL7naft/sMx14Q/dENg9Ir+K6uTdWRmWImaJ9qrFm+BlS+v
 44Blp+WcrsEIFL7VKAAxzkS8DzbkULYbaMBxc9JMcQmp1CH9625+veYnV+Z1VQH1CDjizTmAmQ
 QnIlZwDNGyCXligoSNaADEi//kYQTTQnxdUyk8Sd8Z36qZW+hnLa2ddeQm70iZCm3j2KkKdFF1
 bOTMk/QWur/2zR3oHyD5GjQv
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="146639265"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 02:46:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 9 Dec 2021 02:46:19 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 9 Dec 2021 02:46:16 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 2/6] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Thu, 9 Dec 2021 10:46:11 +0100
Message-ID: <20211209094615.329379-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211209094615.329379-1-horatiu.vultur@microchip.com>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
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

