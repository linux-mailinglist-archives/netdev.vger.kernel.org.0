Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5514227C8D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgGUKHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:07:39 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:5938 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbgGUKHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595326058; x=1626862058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q+YIkrycvE7mcy6+CcZBaCVfDuosYUTIYGmg/IJOMjg=;
  b=I1LiMBUt99LODxcE+2imt48hzOQ6zg3RSUn8IrxN3MWZHwlvGaXGBsI8
   4DG8IRm3d2kZpOuVCCEAsA2vwHqEv4votN9UfuhojB/ynAZ+/Mh/TO+Te
   k8L+iIMnWBwCIBvrNEO0aZQA1UxRIEaRyyQA9/ffz5tadR7nQg1is6uVR
   7aNi0UDEVCFXIBJnDg9XyhxlFhHGwIvUXHFwG55wkO1FiDr8yDC4AezQI
   akKwNZFzo+4qzU/ZD0R4ziTUpU9kzHOSH9pw34lIudSDZnsEAYSmXfmI1
   ZRjPQ37vAWDMHQPUGsSI7C7dWR+/IXEeWC4L+qkbCCQQxHUaPgBKY7zg/
   Q==;
IronPort-SDR: 85HL3tkoVh4AbHNyzFxxHAv73QwEqsDra0lKxLidJo5i0rztM1sluwyCx1/A36/iYhb5DYgjiF
 MRx0134elbGoDVP7csbkRUty+sor0PGgay+XaV/UZCvehnDN0di+Pz3F977FcC5Kdt7Zhk2Yt2
 PwwOS0r0DZfE5nknjc9wPTsBPnsFuXizVy0g+5tWMzettnaD37EatDtyuvI4A4YATuMAW0xnVJ
 uJNq4Glj3UtTDDVF9ZeO5eSBuBtwYA4Bt/f1DE6NanRIza/MyocMF5elmXTtxj89CqXT7CPOBr
 jI8=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="84749272"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:07:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:06:55 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:06:33 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 7/7] ARM: dts: at91: sam9x60: add an mdio sub-node to macb
Date:   Tue, 21 Jul 2020 13:02:34 +0300
Message-ID: <20200721100234.1302910-8-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new macb bindings and add an mdio sub-node to contain all the
phy nodes.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index a5f5718c711a..ba871ebe10d4 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -324,8 +324,12 @@ &macb0 {
 	pinctrl-0 = <&pinctrl_macb0_rmii>;
 	status = "okay";
 
-	ethernet-phy@0 {
-		reg = <0x0>;
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ethernet-phy@0 {
+			reg = <0x0>;
+		};
 	};
 };
 
-- 
2.25.1

