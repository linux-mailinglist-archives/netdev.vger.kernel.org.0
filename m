Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D4F2D42E2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732240AbgLINLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:11:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:57523 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgLINFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607519139; x=1639055139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=P6cdKIf6J3Sjbkovv9YjPeCYdVmSSKRAJ4HlEMmNDCs=;
  b=mhFcaTXe76gBMDLnRX0YrkL6RDIOcUb2PfjPbLqXuihaXGERRaxsFf5h
   KOXYRfet+Y7xiTf2Q+7J7NS0xxqO+Bbg9bMx+HPer7HWUmEKTyy7hCkSr
   4kSFR4zCp2OH7hlk+4oo1+vKOGRMrFX1DEZ318lSp43VGWePJI2kK9tHM
   yjfmMQTa2JoqOZHLzLbxRkj0ltYm3x/i/w7yQrcx/uxwc6b4SPHwaN+Dy
   HJldYCA/9KNEm2W3xIdpLbJNgscpvcjSb4107BJxkoNolHuLS6kJ8UuRZ
   PmvNGID2ssJ7GEHwb0UQ/K6MkysnA74UDo7wEcM+ElfoZdqe0KWKrXiVe
   Q==;
IronPort-SDR: D85279wlbtKwsgMbnckM6EJMxob2UCJPsIBQCPI5//ojOFlbb4sQCrmNjkCCY07+E+qqJy6EUZ
 SjgOZoZ6MqsB7d6RN1X5fYMtLhCbkhOjlyXV21hfmjE1+JFu5WJgtK+0D6SwJVwhHmHbPEE/qF
 WNhzlIsztmGHXQpIUKJx7OyX5Bus+3gG2q0kKFAaBZJF7kvsyw2m415BurTRR1wNnUFC/eJGLW
 7f3xShAP/9I0SbqLTxr6NHr5pdRw7LaYyhWslmfVCNYJXhYcM8FkUIIVlPs5gbmpIoCd7XVahn
 Sdc=
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="102102705"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2020 06:04:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 06:04:22 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Dec 2020 06:04:16 -0700
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
Subject: [PATCH v3 6/8] dt-bindings: add documentation for sama7g5 gigabit ethernet interface
Date:   Wed, 9 Dec 2020 15:03:37 +0200
Message-ID: <1607519019-19103-7-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
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

