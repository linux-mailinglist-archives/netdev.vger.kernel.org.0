Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB339811B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFBG1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:27:23 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3331 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhFBG1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:27:22 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvzRp5RnZz1BG39;
        Wed,  2 Jun 2021 14:20:54 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:25:35 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <bcm-kernel-feedback-list@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <opendmb@gmail.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: mdio: Fix a typo
Date:   Wed, 2 Jun 2021 14:39:14 +0800
Message-ID: <20210602063914.89177-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hz  ==> hz

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index 63348716b426..bfc9be23c973 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -203,7 +203,7 @@ static void unimac_mdio_clk_set(struct unimac_mdio_priv *priv)
 		return;
 	}
 
-	/* The MDIO clock is the reference clock (typically 250MHz) divided by
+	/* The MDIO clock is the reference clock (typically 250Mhz) divided by
 	 * 2 x (MDIO_CLK_DIV + 1)
 	 */
 	reg = unimac_mdio_readl(priv, MDIO_CFG);
-- 
2.25.1

