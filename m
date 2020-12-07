Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622C52D1063
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgLGMRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:17:46 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:16534 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgLGMRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343465; x=1638879465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=P6cdKIf6J3Sjbkovv9YjPeCYdVmSSKRAJ4HlEMmNDCs=;
  b=e5j4xWtkqtQpp8QI8Em+MI/ZRL5W86nbcsqC1Ys6XeidXgMHPztEe2WA
   B2tuxqcWZYAIK49jqgblL47c4oxT8APEIrPkLyEoWSnjHahaamKdyIxu5
   AY6h9QDF82iCoqvyfiZSCmNWC8Z76O210QKyyKChXvlQmdln8DjeuAaqT
   xz4REvf6kwsiUEzsPvnDylMOiOuw3PqjSAOzK2MsWZ6OKNQxl6G95GuNn
   2Fpx9Jied5j/S2wgxS0pWq09nWxnz8cfMwBl+Zptre4MQ/k9g2sDncq1S
   KSoWyi6pxp16SWhFmjWjakum3cnpW6Mur6da9w3+mZgaBCyU1hobJ5fgO
   Q==;
IronPort-SDR: 2cRnLYN91b6QJn0p4Dg8Qd9vR2NnlMKdEYJahY0q1e37wdBuH2wMb7hxvDVLM+zqTCvWL9Rgeg
 KObGtUGlf5FgTuchzJbcMtphHGxxQHVCziqf3/3isiRWNtTr2NLfcatafAqNQI95GoA93i8IXA
 /GUAlZ7fWIc/ts06voBvjubZFcDVoXv6+va0N1DPh9H/4yf0Y6U8PLRTVZvlfvzQpNBer6JYTc
 wN3GP2A3rqReJAZ0M7A+62oJVF2txnbPZP4Mu4Mmm1Mx1fK41DJVNkMq+jYs/aW7QzLOcQfPY9
 RbQ=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="101729141"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:16:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:16:29 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:16:21 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 6/8] dt-bindings: add documentation for sama7g5 gigabit ethernet interface
Date:   Mon, 7 Dec 2020 14:15:31 +0200
Message-ID: <1607343333-26552-7-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for SAMA7G5 gigabit ethernet interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/devicetree/bindings/net/macb.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 26543a4e15d5..e08c5a9d53da 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -17,6 +17,7 @@ Required properties:
   Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
   Use "sifive,fu540-c000-gem" for SiFive FU540-C000 SoC.
   Use "microchip,sama7g5-emac" for Microchip SAMA7G5 ethernet interface.
+  Use "microchip,sama7g5-gem" for Microchip SAMA7G5 gigabit ethernet interface.
   Or the generic form: "cdns,emac".
 - reg: Address and length of the register set for the device
 	For "sifive,fu540-c000-gem", second range is required to specify the
-- 
2.7.4

