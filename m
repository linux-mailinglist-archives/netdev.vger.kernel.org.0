Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194289E445
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 11:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfH0Jb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 05:31:28 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11957 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729750AbfH0Jb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 05:31:27 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Razvan.Stefanescu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="Razvan.Stefanescu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Razvan.Stefanescu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: WU9m2Yh9AyzMQi/6XtTrKZl0vfA1qPyDztmnC1ra1IDqZ105/A1q2N9zGWqO3RtCa6Q3JDdsuk
 ifmt9MFhNsp7LAYLLbNELOFJJtrqQS/rqYfJSu+cVUUAlm9SlumiQrSdUP+liMRQAp7noqb9po
 21NCCNJdeZvL3oCPfAs9nW1xSq7NgVXq6xVTW/EeWroIdO/cIUTsKL7YgNCsOQmoSviSb8qe4y
 GZILk1FJEuJJ7jQtydK/lr4/3hgEfHdrc6/f+XbabrwIHtW9X92mSRVs+/np7iUR6tRVs+nXjw
 uoA=
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="46731630"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Aug 2019 02:31:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 02:31:25 -0700
Received: from rob-ult-m50855.microchip.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 27 Aug 2019 02:31:23 -0700
From:   Razvan Stefanescu <razvan.stefanescu@microchip.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Razvan Stefanescu" <razvan.stefanescu@microchip.com>
Subject: [PATCH 2/4] net: dsa: microchip: add KSZ8563 compatibility string
Date:   Tue, 27 Aug 2019 12:31:08 +0300
Message-ID: <20190827093110.14957-3-razvan.stefanescu@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
References: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a 3-Port 10/100 Ethernet Switch with 1588v2 PTP.

Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477_spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index a226b389e12d..2e402e4d866f 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -80,6 +80,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9897" },
 	{ .compatible = "microchip,ksz9893" },
 	{ .compatible = "microchip,ksz9563" },
+	{ .compatible = "microchip,ksz8563" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
-- 
2.20.1

