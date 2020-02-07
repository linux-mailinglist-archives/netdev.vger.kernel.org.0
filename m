Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5B21555FE
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgBGKqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:46:50 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:45317 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBGKqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:46:50 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Codrin.Ciubotariu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="Codrin.Ciubotariu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Codrin.Ciubotariu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 87j9cQQnN4cbEZgRpjK7cF3NWU6vgrdkR7FVdsnhdF4QBRWZbrN46BdJXLmc6GHzstz4EepgcN
 cQeoFc1EWBmJG8X2OFwuw9MXwmOASWmjkifgyI+Oii/xmUk5Bpfcf7aJUynhf1w8YE4C/FUbx+
 mm00GHhjOVkHJMP0VDlJeZgNA8T4wNUoZGATBh9nujqlOTGw03F8bZYKg+3AGF6g3fdapo81xG
 9niYDLOoI/pycG7Y5/ubO8DaEY5YNv0k146SArIhIgwgCzIpyfHK2ftJmKAelq8V1HNgoDqutu
 +gA=
X-IronPort-AV: E=Sophos;i="5.70,413,1574146800"; 
   d="scan'208";a="1646136"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2020 03:46:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Feb 2020 03:46:49 -0700
Received: from rob-ult-m19940.microchip.com (10.10.85.251) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 7 Feb 2020 03:46:46 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        Razvan Stefanescu <razvan.stefanescu@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH v2] net: dsa: microchip: enable module autoprobe
Date:   Fri, 7 Feb 2020 12:46:43 +0200
Message-ID: <20200207104643.1049-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Razvan Stefanescu <razvan.stefanescu@microchip.com>

This matches /sys/devices/.../spi1.0/modalias content.

Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---

Changes in v2:
 - added alias for all the variants of this driver

 drivers/net/dsa/microchip/ksz9477_spi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index c5f64959a184..1142768969c2 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -101,6 +101,12 @@ static struct spi_driver ksz9477_spi_driver = {
 
 module_spi_driver(ksz9477_spi_driver);
 
+MODULE_ALIAS("spi:ksz9477");
+MODULE_ALIAS("spi:ksz9897");
+MODULE_ALIAS("spi:ksz9893");
+MODULE_ALIAS("spi:ksz9563");
+MODULE_ALIAS("spi:ksz8563");
+MODULE_ALIAS("spi:ksz9567");
 MODULE_AUTHOR("Woojung Huh <Woojung.Huh@microchip.com>");
 MODULE_DESCRIPTION("Microchip KSZ9477 Series Switch SPI access Driver");
 MODULE_LICENSE("GPL");
-- 
2.20.1

