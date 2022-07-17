Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D54557767E
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 15:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiGQN6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 09:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiGQN6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 09:58:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833F85FD8
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 06:58:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oD4n6-0007o0-9R; Sun, 17 Jul 2022 15:58:36 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oD4n3-001WaB-TG; Sun, 17 Jul 2022 15:58:33 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oD4n2-00ASW4-UI; Sun, 17 Jul 2022 15:58:32 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net v2 1/2] net: dsa: sja1105: silent spi_device_id warnings
Date:   Sun, 17 Jul 2022 15:58:30 +0200
Message-Id: <20220717135831.2492844-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add spi_device_id entries to silent following warnings:
 SPI driver sja1105 has no spi_device_id for nxp,sja1105e
 SPI driver sja1105 has no spi_device_id for nxp,sja1105t
 SPI driver sja1105 has no spi_device_id for nxp,sja1105p
 SPI driver sja1105 has no spi_device_id for nxp,sja1105q
 SPI driver sja1105 has no spi_device_id for nxp,sja1105r
 SPI driver sja1105 has no spi_device_id for nxp,sja1105s
 SPI driver sja1105 has no spi_device_id for nxp,sja1110a
 SPI driver sja1105 has no spi_device_id for nxp,sja1110b
 SPI driver sja1105 has no spi_device_id for nxp,sja1110c
 SPI driver sja1105 has no spi_device_id for nxp,sja1110d

Fixes: 5fa6863ba692 ("spi: Check we have a spi_device_id for each DT compatible")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b253e27bcfb4..b03d0d0c3dbf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3382,12 +3382,28 @@ static const struct of_device_id sja1105_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
 
+static const struct spi_device_id sja1105_spi_ids[] = {
+	{ "sja1105e" },
+	{ "sja1105t" },
+	{ "sja1105p" },
+	{ "sja1105q" },
+	{ "sja1105r" },
+	{ "sja1105s" },
+	{ "sja1110a" },
+	{ "sja1110b" },
+	{ "sja1110c" },
+	{ "sja1110d" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, sja1105_spi_ids);
+
 static struct spi_driver sja1105_driver = {
 	.driver = {
 		.name  = "sja1105",
 		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(sja1105_dt_ids),
 	},
+	.id_table = sja1105_spi_ids,
 	.probe  = sja1105_probe,
 	.remove = sja1105_remove,
 	.shutdown = sja1105_shutdown,
-- 
2.30.2

