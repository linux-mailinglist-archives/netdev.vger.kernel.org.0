Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849D317A551
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCEMcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:32:16 -0500
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:7369 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCEMcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:32:16 -0500
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 07:32:14 EST
Received: from spf.mail.chinamobile.com (unknown[172.16.121.11]) by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee65e60eeef659-ff156; Thu, 05 Mar 2020 20:22:09 +0800 (CST)
X-RM-TRANSID: 2ee65e60eeef659-ff156
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.0.146.245])
        by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee65e60eeeec2d-dd790;
        Thu, 05 Mar 2020 20:22:09 +0800 (CST)
X-RM-TRANSID: 2ee65e60eeeec2d-dd790
From:   tangbin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        tangbin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] ethernet:broadcom:bcm63xx_enet:remove redundant variable definitions
Date:   Thu,  5 Mar 2020 20:22:59 +0800
Message-Id: <20200305122259.6104-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in this function,‘ret’ is always assigned,so this's definition
'ret = 0' make no sense.

Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 620cd3fc1..ea5087a8e 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1706,7 +1706,6 @@ static int bcm_enet_probe(struct platform_device *pdev)
 	if (!res_irq || !res_irq_rx || !res_irq_tx)
 		return -ENODEV;
 
-	ret = 0;
 	dev = alloc_etherdev(sizeof(*priv));
 	if (!dev)
 		return -ENOMEM;
-- 
2.20.1.windows.1



