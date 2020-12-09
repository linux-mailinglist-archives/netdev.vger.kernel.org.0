Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9842D42AC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbgLINFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:05:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:33548 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732022AbgLINFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607519137; x=1639055137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DUxcKkP9tne2ZEad42EnpND5G9jdrOj1iXVeTt57jG8=;
  b=mmF/+rNc95drpj6imE+Y2aXXi+fU4GUgdJENa0FG1V6t2M7VlrRz5aPp
   MurvVfhTfR1duBGg7YAU/WI/58qyXVyMSqH/iZkF9Zkgytfq1HqcqsJqc
   gMdM8yIC526qSCf3vfQVbhzCTPmJGawwLMOXGgnlNNw7cU2M/9d5vJGz0
   3KjleGmuM959QEmWEHu2ptLfFl3o1QbB8qw5xNSCvHaJN5sQtmJM5OX3g
   V0xY4dZtbXHU9jfNUrRmV+86VazDURnuagXnNi967Ocin5GpFg6eQlesh
   msiZeP9TZ6HQ+rcAlBpWuV0i3TeZSaO+XBdBUpHGnVk7L7CDxwdAtQMMy
   g==;
IronPort-SDR: WnhyyC67VAqaMCBDpwz2vNsmDbtjfzkkqnGtk85N3D9h3jDYItoQ7C4Nnupdn/1sNsgHXOc+kL
 +ZhyWyra5UpPa/Q1iDXyyg0beKqDen8eBpbzgHrIYCQ92sFgThhCzmk6bxR5Wyode6wTY7TsSI
 AwxWeIEMBCK2AQq9QpTPJ/5SWq8yun4cV7tOWkm78T9TksbTZPRf0k2Ewy37Q5GjEs4TK4zeEA
 x+mgpY8Hs9oQMUoDITxKmCbfiVzsBvOCEX4PJPeWv5f8It7MbfLzf9POufURyhRXrgd9TNs3XN
 q+k=
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="106862448"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2020 06:04:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 06:04:16 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Dec 2020 06:04:11 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 5/8] dt-bindings: add documentation for sama7g5 ethernet interface
Date:   Wed, 9 Dec 2020 15:03:36 +0200
Message-ID: <1607519019-19103-6-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
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

