Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092BC3D9C71
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhG2ECr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:02:47 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:25707 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2ECq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:02:46 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea6102283d7d6-b0042; Thu, 29 Jul 2021 12:02:08 +0800 (CST)
X-RM-TRANSID: 2eea6102283d7d6-b0042
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86102283cb6d-fca0b;
        Thu, 29 Jul 2021 12:02:07 +0800 (CST)
X-RM-TRANSID: 2ee86102283cb6d-fca0b
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH v2] bcm63xx_enet: delete a redundant assignment
Date:   Thu, 29 Jul 2021 12:03:00 +0800
Message-Id: <20210729040300.25928-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function bcm_enetsw_probe(), 'ret' will be assigned by
bcm_enet_change_mtu(), so 'ret = 0' make no sense.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
Changes from v1
 - fix up the subject
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 916824cca..509e10013 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -2646,7 +2646,6 @@ static int bcm_enetsw_probe(struct platform_device *pdev)
 	if (!res_mem || irq_rx < 0)
 		return -ENODEV;
 
-	ret = 0;
 	dev = alloc_etherdev(sizeof(*priv));
 	if (!dev)
 		return -ENOMEM;
-- 
2.20.1.windows.1



