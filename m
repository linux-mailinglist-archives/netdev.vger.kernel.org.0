Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E4111F154
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 11:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfLNKKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 05:10:15 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51112 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfLNKKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 05:10:14 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C9F154F69E9C71D1194A;
        Sat, 14 Dec 2019 18:10:10 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Sat, 14 Dec 2019
 18:10:02 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH net-next] net: phy: dp83869: Remove unneeded semicolon
Date:   Sat, 14 Dec 2019 18:17:24 +0800
Message-ID: <1576318644-38066-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/phy/dp83869.c:337:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/phy/dp83869.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 9302190..7996a4a 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -334,7 +334,7 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}

 	return ret;
 }
--
2.7.4

