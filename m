Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD9D22C3C4
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgGXKvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:51:20 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:21329 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbgGXKvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595587877; x=1627123877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jetXb1L6fLqY5EPX3I8ct9K8ZfusnMFMrVfT80KlChM=;
  b=yp4bhniKIzAKVrSICWkUxPqN9C2HieEtCNXzUyZaEQc4sjoE9LbzM+9v
   fwkBFn/ynva13u9ixXsFP044CMxJBrDBb0eEH5q/YMbxZwc+E+9+fi4gZ
   eAcahy5QMS78lNVssoVawixY46O9kmKOfJFKpTNUwFDG1Xl+DxyClssUc
   b832cEsHp5QamEuddXuD9lCkPwKhfzYw3BjddNF0ocSB/dvCuuTPOI30Z
   ZjMjtsJguQThpZC5WQVFEDLnVtT9vDwBKzkSrfaLGWGjqEGmGRLz3g+gv
   o8DkdOZljh8bWwRhLSu+JXPGL7t8dNq1TrzUG9JztafwyK81vLyOCxfVs
   Q==;
IronPort-SDR: lQaUv3GuPcpn9wqPTQPNY5I+P0KI30PcbwRSVMJS8dB52UJmfZ61GaxtoKnzIt5yjxpgUL2iYf
 ABFtzYYHQ6d0y91tkj9c7Kw2M5QwaA5zxWWSH5+6d9u7azEICqShsRadMrSX1S89TfW2UyEZpx
 Npu/rQHs5vqIZb0ag/fQsmCdQdBoAZTLNQbmQkxKCkNu9R0eMh9iMb9e+pGVTuAWiYrkU+v+GR
 /YFSjLoOm3plQAoMlUosdDiZhRpDYlMIQ6ugdWkk7kiOBd1kXy86GKMePDZwWGU1FClUAMsyNI
 jOA=
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="85237040"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 03:51:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 03:51:16 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 24 Jul 2020 03:50:31 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v3 7/7] ARM: dts: at91: sam9x60: add an mdio sub-node to macb
Date:   Fri, 24 Jul 2020 13:50:33 +0300
Message-ID: <20200724105033.2124881-8-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

Changes in v3:
 - added tag from Florian

Changes in v2:
 - none

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

