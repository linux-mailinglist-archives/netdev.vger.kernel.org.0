Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10B02CEE29
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388188AbgLDMgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:36:13 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:4422 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388097AbgLDMgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:36:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085372; x=1638621372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=CEAhOF2TJwycrOj7z9P3j3P2KFYumQb/0Mv/EX+Mw/g=;
  b=KBwhlyA6Ip2tbhTuolQhd2BzKPMLZPZpjGIVzmgeWuMgfyKbYi8NwBNm
   ngK3ImYV1Dq0VVpO2CDK6qUD2CR7BHUxY6Qjo50MNo+aiEjycXZIna0I/
   q3lcDvHQ5pxlychwrMTDlnw84KvYt0rycEnHlVh4oxCVQRhC+tp5U0kTZ
   NVLV1nkMqQggW7bZHAJ/mzcWy8qz0MuPeDrlr+xepaSr+l4OHn6d3SOO8
   byJQbk+e/AmRF0aBipcio/j4w5eD7v2++9jjjqTOaF3GAFDcovdg2F6Tl
   svRCQoFf6FK8KY1g7IIJIYncgpseg/ko7kBS1RSiL8Ycm/xBkgZEh+ZWa
   w==;
IronPort-SDR: lGZYJVQlGn78KeShwwy5zzLE4V2cI87zhM3mRW+H4nfUuJIjaxIj9prdO2BjlZZNx3Q08R76ft
 /lehhDedLFk43Ra0ahkWnbH7UY41S4+mgo19GFj9aIuKVHVy50mRgQk/eewLu4u+y7BAfhrRsj
 sC6a6tZ9Zp+ajhRaX0fV9CziK3DGbfFxWFr+4HlLyMoEb96S4oQrvKTvqeh1/3NNXANyEWZ9/h
 whf/8Jwf+E+KiHYSdRpoZF5MnhTKaXJnp6YypLa4vS4o9gd/LU0RSdmvuwVY+DKOMh6el3ULSr
 zYk=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="100918867"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:35:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:35:05 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:34:59 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 5/7] dt-bindings: add documentation for sama7g5 gigabit ethernet interface
Date:   Fri, 4 Dec 2020 14:34:19 +0200
Message-ID: <1607085261-25255-6-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for SAMA7G5 gigabit ethernet interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
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

