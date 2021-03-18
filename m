Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8BC340704
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhCRNiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:38:02 -0400
Received: from m12-11.163.com ([220.181.12.11]:32998 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhCRNhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 09:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=z0C4g
        MZ+dKD2XjbwS4ucAAKLRBZSRIcbk8zV8GM1uBI=; b=EckjOLQqxkzwOLzCP6K7s
        5e6UzkpPYjJeOJmgXG1cMAIpGqGxY+IY8jd5/xoZD+eErcogQUQ8ve2piaU9Zfbd
        grqZy3jnznA62rMqrZeMHKNEx1X25H8wU7xdL3qTIjNIkreMdJdhkV/vKaM7EhZu
        C4+FSAc59oi+0njdG/4oEA=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowADHv5ddV1NgetOZSw--.19292S2;
        Thu, 18 Mar 2021 21:36:32 +0800 (CST)
From:   zuoqilin1@163.com
To:     davem@davemloft.net, dan.carpenter@oracle.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] nfc/fdp: Simplify the return expression of fdp_nci_open()
Date:   Thu, 18 Mar 2021 21:36:40 +0800
Message-Id: <20210318133640.1377-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowADHv5ddV1NgetOZSw--.19292S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF1xWryxAw1kGF1UXFWxXrb_yoW3KrX_Cr
        Z0vr48GF4UXF1Fy3srGwsxZryDKF1aqFWFgF4vgayayr98ZFs5Gw4Dury3XrWUW348AFy7
        Wws8Ar1rAr1DKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnYg43UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/1tbiZQBZiV8ZNR6q6gAAsY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

Simplify the return expression.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 drivers/nfc/fdp/fdp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 4dc7bd7..824f2da 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -236,15 +236,12 @@ static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
 
 static int fdp_nci_open(struct nci_dev *ndev)
 {
-	int r;
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	r = info->phy_ops->enable(info->phy);
-
-	return r;
+	return info->phy_ops->enable(info->phy);
 }
 
 static int fdp_nci_close(struct nci_dev *ndev)
-- 
1.9.1

