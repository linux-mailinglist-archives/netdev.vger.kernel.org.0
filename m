Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8194B787E7
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfG2JBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 05:01:49 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:21110 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfG2JBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 05:01:48 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb5d3eb5e664b-6fdb0; Mon, 29 Jul 2019 17:01:27 +0800 (CST)
X-RM-TRANSID: 2eeb5d3eb5e664b-6fdb0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.105.0.243])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55d3eb5e6e1a-699b1;
        Mon, 29 Jul 2019 17:01:27 +0800 (CST)
X-RM-TRANSID: 2ee55d3eb5e6e1a-699b1
From:   Ding Xiang <dingxiang@cmss.chinamobile.com>
To:     jcliburn@gmail.com, chris.snook@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ag71xx: use resource_size for the ioremap size
Date:   Mon, 29 Jul 2019 17:01:22 +0800
Message-Id: <1564390882-28002-1-git-send-email-dingxiang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use resource_size to calcuate ioremap size and make
the code simpler.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 8b69d0d..77542bd 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1686,7 +1686,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	}
 
 	ag->mac_base = devm_ioremap_nocache(&pdev->dev, res->start,
-					    res->end - res->start + 1);
+					    resource_size(res));
 	if (!ag->mac_base) {
 		err = -ENOMEM;
 		goto err_free;
-- 
1.9.1



