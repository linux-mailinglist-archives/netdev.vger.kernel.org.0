Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A824129CE0
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 03:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfLXCoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 21:44:38 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45802 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbfLXCoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 21:44:38 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4E948923AD52C7E06906;
        Tue, 24 Dec 2019 10:44:34 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Dec 2019 10:44:24 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <linux@rempel-privat.de>, <maowenan@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: dsa: drop pointless static qualifier in ar9331_sw_mbus_init
Date:   Tue, 24 Dec 2019 10:40:59 +0800
Message-ID: <20191224024059.184847-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to have the 'T *v' variable static
since new value always be assigned before use it.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/dsa/qca/ar9331.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 0d1a7cd85fe8..da3bece75e21 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -266,7 +266,7 @@ static int ar9331_sw_mbus_read(struct mii_bus *mbus, int port, int regnum)
 static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
 {
 	struct device *dev = priv->dev;
-	static struct mii_bus *mbus;
+	struct mii_bus *mbus;
 	struct device_node *np, *mnp;
 	int ret;
 
-- 
2.20.1

