Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13DA1342AC
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 13:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgAHM5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 07:57:09 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:15794 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgAHM5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 07:57:08 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: ix45JeaUMxHbr5AU0CVJMK3ny3iXJcUXITcGZWjACrY3Mj2cKs7Rhiy3iWBcp8nSxg94IOONkR
 iJXYhOB+QjW8tb7xJJS/Ap3hOWsiCrS9aGa8ywYj8+2wdg4zLEWrdVsHzNHWPkk1aBB4n0KtWx
 /GpeQpGgFVxqM9s0GjL7MTc1X6SsTgp0Dn1l6v5x11EXBzUZG3dtD+7WOaEUJEgKkqsXh1+OqH
 LQUW+bBan2oS2g0ZVplMpyDZhr0H0XFXsnm3uiCwkfB6uFIceni3Y1iEj4skicBES02Je1EBA4
 sLs=
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="64014420"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2020 05:57:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 05:56:48 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 8 Jan 2020 05:56:41 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <vkoul@kernel.org>,
        <eugen.hristev@microchip.com>, <jic23@kernel.org>,
        <knaack.h@gmx.de>, <lars@metafoo.de>, <pmeerw@pmeerw.net>,
        <mchehab@kernel.org>, <lee.jones@linaro.org>,
        <richard.genoud@gmail.com>, <radu_nicolae.pirea@upb.ro>,
        <tudor.ambarus@microchip.com>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <a.zummo@towertech.it>, <broonie@kernel.org>
CC:     <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rtc@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 06/16] dt-bindings: atmel-matrix: add microchip,sam9x60-matrix
Date:   Wed, 8 Jan 2020 14:55:13 +0200
Message-ID: <1578488123-26127-7-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
References: <1578488123-26127-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add microchip,sam9x60-matrix to DT bindings documentation.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 Documentation/devicetree/bindings/mfd/atmel-matrix.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/atmel-matrix.txt b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
index e3ef50ca02a5..89d05c64fb01 100644
--- a/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
+++ b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
@@ -13,6 +13,7 @@ Required properties:
 			"atmel,at91sam9n12-matrix", "syscon"
 			"atmel,at91sam9x5-matrix", "syscon"
 			"atmel,sama5d3-matrix", "syscon"
+			"microchip,sam9x60-matrix", "syscon"
 - reg:			Contains offset/length value of the Bus Matrix
 			memory region.
 
-- 
2.7.4

