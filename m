Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18567210A47
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 13:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgGAL2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 07:28:02 -0400
Received: from mail.intenta.de ([178.249.25.132]:41692 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730159AbgGAL2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 07:28:01 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2020 07:28:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Subject:CC:To:From:Date; bh=a0P1npTuZMmjzXtpmaWShlW8svumYAOukhwxaeZSHAk=;
        b=BIuFLY9Q60knadZHy2EnID1H6f+EpLqFQ0jPPqljbHEZdROa8s+DfnhpdaH3KCiykZTn52pyNoLnoWYHc0N92MDXlwVR+JPxYvb6MY8E7KYy6ullCGtjnXljTXPY1xwqTmNCxv5lf4wft5eTle2XMF07GNCmOPKr8e6IRj8xO31MZFggOPAGqQeGSZqi6B1ESCS+mMzuEbQCARrdQOEjQ/5t7p9pwvYYvIIAJtqjZBs/sgfLBvgy+zF6K6TCi5ccGyeEzJgdMtVerzSCq5/Sf2Gnfc4KhMCFs8Z7E8Ny9EyRYjoQ9dzP1EqZDi4jN97fZ4ChYHEV40Gk49PuafF0rQ==;
Date:   Wed, 1 Jul 2020 13:22:20 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: dsa: microchip: enable ksz9893 via i2c in the ksz9477
 driver
Message-ID: <20200701112216.GA8098@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ9893 3-Port Gigabit Ethernet Switch can be controlled via SPI,
I²C or MDIO (very limited and not supported by this driver). While there
is already a compatible entry for the SPI bus, it was missing for I²C.

Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index fdffd9e0c518..2805839e5c55 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -79,6 +79,7 @@ MODULE_DEVICE_TABLE(i2c, ksz9477_i2c_id);
 static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9477" },
 	{ .compatible = "microchip,ksz9897" },
+	{ .compatible = "microchip,ksz9893" },
 	{ .compatible = "microchip,ksz9567" },
 	{},
 };
-- 
2.20.1

