Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88369285BEB
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgJGJbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:31:45 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:33419 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbgJGJbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 05:31:45 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4C5pxn1Rn0z9w8y;
        Wed,  7 Oct 2020 11:31:41 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4C5px03DLtz2xGR;
        Wed,  7 Oct 2020 11:31:00 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.119) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 7 Oct
 2020 11:31:00 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next] net: dsa: microchip: add ksz9563 to ksz9477 I2C driver
Date:   Wed, 7 Oct 2020 11:30:49 +0200
Message-ID: <20201007093049.13078-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.119]
X-RMX-ID: 20201007-113100-4C5px03DLtz2xGR-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the KSZ9563 3-Port Gigabit Ethernet Switch to the
ksz9477 driver. The KSZ9563 supports both SPI (already in) and I2C. The
ksz9563 is already in the device tree binding documentation.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 7951f52d860d..4e053a25d077 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -80,6 +80,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9477" },
 	{ .compatible = "microchip,ksz9897" },
 	{ .compatible = "microchip,ksz9893" },
+	{ .compatible = "microchip,ksz9563" },
 	{ .compatible = "microchip,ksz9567" },
 	{},
 };
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

