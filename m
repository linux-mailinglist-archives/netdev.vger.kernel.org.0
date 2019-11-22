Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9114910721D
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 13:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfKVM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 07:26:08 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:54468 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbfKVM0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 07:26:08 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 58FE480CE13315BE073B;
        Fri, 22 Nov 2019 20:26:01 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 22 Nov 2019 20:25:52 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH] net: dsa: ocelot: fix "should it be static?" warnings
Date:   Fri, 22 Nov 2019 20:32:45 +0800
Message-ID: <1574425965-97890-1-git-send-email-chenwandun@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following sparse warnings:
drivers/net/dsa/ocelot/felix.c:351:6: warning: symbol 'felix_txtstamp' was not declared. Should it be static?

Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 drivers/net/dsa/ocelot/felix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 167e415..b7f9246 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -348,8 +348,8 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	return false;
 }
 
-bool felix_txtstamp(struct dsa_switch *ds, int port,
-		    struct sk_buff *clone, unsigned int type)
+static bool felix_txtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *clone, unsigned int type)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-- 
2.7.4

