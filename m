Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F9E4BB9F0
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 14:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbiBRNQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 08:16:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiBRNQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 08:16:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FDD2B31A0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 05:16:01 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1nL373-0001yU-NQ; Fri, 18 Feb 2022 14:15:53 +0100
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1nL372-007hS3-G3; Fri, 18 Feb 2022 14:15:52 +0100
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [PATCH net-next] net: dsa: microchip: add ksz8563 to ksz9477 I2C driver
Date:   Fri, 18 Feb 2022 14:15:40 +0100
Message-Id: <20220218131540.1833838-1-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ9477 SPI driver already has support for the KSZ8563. The same switch
chip can also be managed via i2c and we have an KSZ9477 I2C driver, but
that one lacks the relevant compatible entry. Add it.

DT bindings already describe this compatible.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index f3afb8b8c4cc..cbc0b20e7e1b 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -92,6 +92,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	{ .compatible = "microchip,ksz9893" },
 	{ .compatible = "microchip,ksz9563" },
 	{ .compatible = "microchip,ksz9567" },
+	{ .compatible = "microchip,ksz8563" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
-- 
2.30.2

