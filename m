Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0752D1057
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgLGMR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:17:28 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:28226 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgLGMR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343447; x=1638879447;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DUxcKkP9tne2ZEad42EnpND5G9jdrOj1iXVeTt57jG8=;
  b=icckfXpBx/XU9nWVTk481FnECP3ZH6pJ0AMbS/wrJi4JF4dWHoz1OPVG
   dmbMg6O69EDDpaGJCdYHHSQS686wIzuSgIaxZq8U1ENd+W72JBHSn/8OM
   4Qnm/CmomgL5uhd7qdsjERoa5+Nn5vBRkqVd2q0WgiplMI80ORNBuW6Xg
   44fbAZ5lPNpxNeTz180V/BgCkJWTjmcUjCuJmdruoYEC3he68XPGt6h/g
   5FHE4UOVWOeZGIF4BXtaDyoDrHVO0lwu2BnwQQfGb+mmZTZ+e4wTLV25C
   /KMRDUTuG1sIxTDUWxINFxV0TmGpzSSVLTllc2PQ2HBiiGvudBnHg64OT
   A==;
IronPort-SDR: 7NBQCNTqGwOIfkmqgNYQkDZLfGGyFDD+TjnnaGsPa3QWsUk8C8FCdpp+PLQBX7//R9MW7N1dD0
 W+mMQyRPpn39Utv2/7RK81YAGY9f1CR6QMlX/6lC8BaULd1Hq5da3eejitf39Gn4+AkQ9MzbhD
 jT0Tz7KaB2UkZhA5IhbZgi6EsGADKRSvE7myeNDJspoxq6CqZocjBB7ucYKTqBiacPKBgsyXKv
 qxUqEv+aM48ugJ3C4/p9xNUxEoKeQvvW3QggYpMnrGkQOIS6u3AQY4BFA4dZtm8jgBP5/cjuOc
 zpI=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="36409538"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:16:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:16:21 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:16:15 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 5/8] dt-bindings: add documentation for sama7g5 ethernet interface
Date:   Mon, 7 Dec 2020 14:15:30 +0200
Message-ID: <1607343333-26552-6-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for SAMA7G5 ethernet interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/devicetree/bindings/net/macb.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 0b61a90f1592..26543a4e15d5 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -16,6 +16,7 @@ Required properties:
   Use "cdns,zynq-gem" Xilinx Zynq-7xxx SoC.
   Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
   Use "sifive,fu540-c000-gem" for SiFive FU540-C000 SoC.
+  Use "microchip,sama7g5-emac" for Microchip SAMA7G5 ethernet interface.
   Or the generic form: "cdns,emac".
 - reg: Address and length of the register set for the device
 	For "sifive,fu540-c000-gem", second range is required to specify the
-- 
2.7.4

