Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE887BC4F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfGaIyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:54:37 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2118 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaIyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:54:36 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5d41572142e-9dcc2; Wed, 31 Jul 2019 16:53:53 +0800 (CST)
X-RM-TRANSID: 2eec5d41572142e-9dcc2
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.105.0.243])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55d415720aae-0e26b;
        Wed, 31 Jul 2019 16:53:53 +0800 (CST)
X-RM-TRANSID: 2ee55d415720aae-0e26b
From:   Ding Xiang <dingxiang@cmss.chinamobile.com>
To:     christopher.lee@cspi.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] myri10ge: remove unneeded variable
Date:   Wed, 31 Jul 2019 16:53:46 +0800
Message-Id: <1564563226-13367-1-git-send-email-dingxiang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"error" is unneeded,just return 0

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index d8b7fba..a4165e1 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3037,7 +3037,6 @@ static int myri10ge_set_mac_address(struct net_device *dev, void *addr)
 static int myri10ge_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct myri10ge_priv *mgp = netdev_priv(dev);
-	int error = 0;
 
 	netdev_info(dev, "changing mtu from %d to %d\n", dev->mtu, new_mtu);
 	if (mgp->running) {
@@ -3049,7 +3048,7 @@ static int myri10ge_change_mtu(struct net_device *dev, int new_mtu)
 	} else
 		dev->mtu = new_mtu;
 
-	return error;
+	return 0;
 }
 
 /*
-- 
1.9.1



