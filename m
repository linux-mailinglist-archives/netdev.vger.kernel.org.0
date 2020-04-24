Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AE41B7030
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDXJBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:01:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59084 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbgDXJBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 05:01:51 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5C41F9ECEE24E739F83A;
        Fri, 24 Apr 2020 17:01:50 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 17:01:40 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] net: phy: dp83867: Remove unneeded semicolon
Date:   Fri, 24 Apr 2020 17:08:50 +0800
Message-ID: <20200424090850.96778-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/phy/dp83867.c:368:2-3: Unneeded semicolon
drivers/net/phy/dp83867.c:403:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/phy/dp83867.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index b55e3c0403ed..4017ae1692d8 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -365,7 +365,7 @@ static int dp83867_get_downshift(struct phy_device *phydev, u8 *data)
 		break;
 	default:
 		return -EINVAL;
-	};
+	}

 	*data = enable ? count : DOWNSHIFT_DEV_DISABLE;

@@ -400,7 +400,7 @@ static int dp83867_set_downshift(struct phy_device *phydev, u8 cnt)
 			phydev_err(phydev,
 				   "Downshift count must be 1, 2, 4 or 8\n");
 			return -EINVAL;
-	};
+	}

 	val = DP83867_DOWNSHIFT_EN;
 	val |= FIELD_PREP(DP83867_DOWNSHIFT_ATTEMPT_MASK, count);
--
2.26.0.106.g9fadedd

