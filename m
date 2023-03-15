Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963E46BB3F4
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjCONJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjCONJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:09:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEBFBDEE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:09:47 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1pcQst-0004p7-00; Wed, 15 Mar 2023 14:09:39 +0100
Received: from [2a0a:edc0:0:1101:1d::54] (helo=dude05.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1pcQss-004JKX-9z; Wed, 15 Mar 2023 14:09:38 +0100
Received: from afa by dude05.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1pcQsr-00FFHG-Kl; Wed, 15 Mar 2023 14:09:37 +0100
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     kernel@pengutronix.de, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: dsa: realtek: fix missing new lines in error messages
Date:   Wed, 15 Mar 2023 14:09:16 +0100
Message-Id: <20230315130917.3633491-2-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some error messages lack a new line, add them.

Fixes: d40f607c181f ("net: dsa: realtek: rtl8365mb: add RTL8367S support")
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
 drivers/net/dsa/realtek/rtl8365mb.c    | 2 +-
 drivers/net/dsa/realtek/rtl8366-core.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..33d28951f461 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -2068,7 +2068,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
 	if (!mb->chip_info) {
 		dev_err(priv->dev,
-			"unrecognized switch (id=0x%04x, ver=0x%04x)", chip_id,
+			"unrecognized switch (id=0x%04x, ver=0x%04x)\n", chip_id,
 			chip_ver);
 		return -ENODEV;
 	}
diff --git a/drivers/net/dsa/realtek/rtl8366-core.c b/drivers/net/dsa/realtek/rtl8366-core.c
index dc5f75be3017..f353483b281b 100644
--- a/drivers/net/dsa/realtek/rtl8366-core.c
+++ b/drivers/net/dsa/realtek/rtl8366-core.c
@@ -329,7 +329,7 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 
 	ret = rtl8366_set_vlan(priv, vlan->vid, member, untag, 0);
 	if (ret) {
-		dev_err(priv->dev, "failed to set up VLAN %04x", vlan->vid);
+		dev_err(priv->dev, "failed to set up VLAN %04x\n", vlan->vid);
 		return ret;
 	}
 
@@ -338,7 +338,7 @@ int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 
 	ret = rtl8366_set_pvid(priv, port, vlan->vid);
 	if (ret) {
-		dev_err(priv->dev, "failed to set PVID on port %d to VLAN %04x",
+		dev_err(priv->dev, "failed to set PVID on port %d to VLAN %04x\n",
 			port, vlan->vid);
 		return ret;
 	}
-- 
2.30.2

