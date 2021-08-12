Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1DA3E9FAF
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhHLHpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:45:05 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35108 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbhHLHpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 03:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628754279; x=1660290279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=G9BCGG5pauZB4Jkjlwe0QadzDPfoCQnRp0F34qHKRaA=;
  b=FTEjo4FSE9BVDIC/8TEfu1Sk6tqSvk0p2Ztx9kZrnN602RBoHC/Qx+cq
   zpk7wMIBnOTqu6A21z/Mvi++GtbLM7VKcv19jAoaM9pS+hZ5I0Ye4OsVs
   lDpTxlckGKOr0W69KBLCR/Gx4z8ftr3RDd+gzaQnKZ2+lMoRajn1A/JhX
   lFpf5S/aD26dXjSEdQUX8kWhAekDxaigkqs/AXomYFAV++Ue3aA3qIohG
   +Fg1vdlgRih5op2X/fb3+sNTfXiK8Vl/3+2s6DMSUCzROIu/ZvpW9e42v
   yl8dAeN2oSiAtRF1s5hzAhtLAm2++/oWjvzOzn+BPCih8BPvtgAq/7uqY
   w==;
IronPort-SDR: 2zo4hHfaqqyttP/q70Rk5GL9gM0GhzHctVUow+5Yslnr4UWGYAU6TPiOQcn7xYZx4WAu0rOcDj
 yHmqYNZkzp/IjXd9AJTEXDWmo5nIsdZ6gUrp6QqkyvkIZmuPnLScoqpnYOC83gU5doNHOScUnf
 ovQLLKBSShZtJNRey2XeshyhXb28zm0Jjrv9cXWI1W8CckIc/PWQ5NhwoaWH/JyQM5H2NzIfHe
 Vcixyaar95lJaEMgyOUMeVI9FUl3MxR038a5av/Mdqoa5frvVJelWaVBOYWWO/VBT8aLDWVa36
 IBsN1KTsfkxSpmVGAwwk6pJk
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="132520197"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2021 00:44:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 12 Aug 2021 00:44:38 -0700
Received: from che-lt-i63539u.amer.actel.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 12 Aug 2021 00:44:33 -0700
From:   Hari Prasath <Hari.PrasathGE@microchip.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>,
        <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <mpuswlinux@microchip.com>, <Hari.PrasathGE@microchip.com>
Subject: [PATCH net-next 2/2] dt-bindings: net: macb: add documentation for sama5d29 ethernet interface
Date:   Thu, 12 Aug 2021 13:14:22 +0530
Message-ID: <20210812074422.13487-2-Hari.PrasathGE@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210812074422.13487-1-Hari.PrasathGE@microchip.com>
References: <20210812074422.13487-1-Hari.PrasathGE@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for SAMA5D29 ethernet interface.

Signed-off-by: Hari Prasath <Hari.PrasathGE@microchip.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index a4d547efc32a..af9df2f01a1c 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -8,6 +8,7 @@ Required properties:
   Use "cdns,np4-macb" for NP4 SoC devices.
   Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
   Use "atmel,sama5d2-gem" for the GEM IP (10/100) available on Atmel sama5d2 SoCs.
+  Use "atmel,sama5d29-gem" for GEM XL IP (10/100) available on Atmel sama5d29 SoCs.
   Use "atmel,sama5d3-macb" for the 10/100Mbit IP available on Atmel sama5d3 SoCs.
   Use "atmel,sama5d3-gem" for the Gigabit IP available on Atmel sama5d3 SoCs.
   Use "atmel,sama5d4-gem" for the GEM IP (10/100) available on Atmel sama5d4 SoCs.
-- 
2.17.1

