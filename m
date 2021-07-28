Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2335D3D8EF7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhG1NYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:24:40 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:7319 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbhG1NYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 09:24:40 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.5]) by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee661015a72652-a7e8d; Wed, 28 Jul 2021 21:24:02 +0800 (CST)
X-RM-TRANSID: 2ee661015a72652-a7e8d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee361015a6f432-7be9f;
        Wed, 28 Jul 2021 21:24:02 +0800 (CST)
X-RM-TRANSID: 2ee361015a6f432-7be9f
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] bcm63xx_enet: remove needless variable definitions
Date:   Wed, 28 Jul 2021 21:24:56 +0800
Message-Id: <20210728132456.2540-1-tangbin@cmss.chinamobile.com>
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



