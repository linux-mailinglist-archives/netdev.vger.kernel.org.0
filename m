Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541AB33F060
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCQMa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:30:59 -0400
Received: from m12-18.163.com ([220.181.12.18]:40102 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhCQMaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=S9Xzg
        t86NTlEV3A1RGJJ5Cmf6VJv4IO/WfjOmNy3Gbw=; b=okK8FaUt1wV5FxDnaXF1D
        6D7VwSox3g/LYf0qWcPiC8Ul9DWie2cRafu8akhXLwYWAtgo3ClM4DYZyvP4HSdT
        ecSc0o9z7DZ+wetQmg5OMWx7gf707zB1gdxxidq244xHlhTOAA5mw7woo/25RHDP
        nHrs3/BFJiftl1Tsmhl5jY=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp14 (Coremail) with SMTP id EsCowADX4hle9lFgU7grZQ--.46217S2;
        Wed, 17 Mar 2021 20:30:23 +0800 (CST)
From:   dingsenjie@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH v2] ethernet/microchip:remove unneeded variable: "ret"
Date:   Wed, 17 Mar 2021 20:30:30 +0800
Message-Id: <20210317123030.70808-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowADX4hle9lFgU7grZQ--.46217S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrur43XF4xKw1rur4xJw4xJFb_yoWDAFcEkr
        4vqwn8Kw40yryUZr4UKw4UZ3sYgF4DZFn5Zan2k3y5Z3s3uw4rAr1Dury8XrykWrZ8CF9r
        Cr1akF1fCw13KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8EzuJUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiTh9YyFUDIPkqtQAAsR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

remove unneeded variable: "ret".

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/ethernet/microchip/encx24j600.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index 2c0dcd7..a66a179 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -222,7 +222,6 @@ static int encx24j600_wait_for_autoneg(struct encx24j600_priv *priv)
 	unsigned long timeout = jiffies + msecs_to_jiffies(2000);
 	u16 phstat1;
 	u16 estat;
-	int ret = 0;
 
 	phstat1 = encx24j600_read_phy(priv, PHSTAT1);
 	while ((phstat1 & ANDONE) == 0) {
@@ -258,7 +257,7 @@ static int encx24j600_wait_for_autoneg(struct encx24j600_priv *priv)
 		encx24j600_write_reg(priv, MACLCON, 0x370f);
 	}
 
-	return ret;
+	return 0;
 }
 
 /* Access the PHY to determine link status */
-- 
1.9.1


