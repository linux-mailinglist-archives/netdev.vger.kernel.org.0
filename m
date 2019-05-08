Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573E7175E2
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 12:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfEHKWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 06:22:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38750 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfEHKWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 06:22:16 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hOJiF-0007RM-CM; Wed, 08 May 2019 10:22:11 +0000
From:   Colin King <colin.king@canonical.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: lantiq: fix spelling mistake "brigde" -> "bridge"
Date:   Wed,  8 May 2019 11:22:09 +0100
Message-Id: <20190508102209.6830-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several spelling mistakes in dev_err messages. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/lantiq_gswip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 553831df58fe..4e64835deac2 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1235,7 +1235,7 @@ static void gswip_port_fast_age(struct dsa_switch *ds, int port)
 
 		err = gswip_pce_table_entry_read(priv, &mac_bridge);
 		if (err) {
-			dev_err(priv->dev, "failed to read mac brigde: %d\n",
+			dev_err(priv->dev, "failed to read mac bridge: %d\n",
 				err);
 			return;
 		}
@@ -1252,7 +1252,7 @@ static void gswip_port_fast_age(struct dsa_switch *ds, int port)
 		mac_bridge.valid = false;
 		err = gswip_pce_table_entry_write(priv, &mac_bridge);
 		if (err) {
-			dev_err(priv->dev, "failed to write mac brigde: %d\n",
+			dev_err(priv->dev, "failed to write mac bridge: %d\n",
 				err);
 			return;
 		}
@@ -1328,7 +1328,7 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 
 	err = gswip_pce_table_entry_write(priv, &mac_bridge);
 	if (err)
-		dev_err(priv->dev, "failed to write mac brigde: %d\n", err);
+		dev_err(priv->dev, "failed to write mac bridge: %d\n", err);
 
 	return err;
 }
@@ -1360,7 +1360,7 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 
 		err = gswip_pce_table_entry_read(priv, &mac_bridge);
 		if (err) {
-			dev_err(priv->dev, "failed to write mac brigde: %d\n",
+			dev_err(priv->dev, "failed to write mac bridge: %d\n",
 				err);
 			return err;
 		}
-- 
2.20.1

