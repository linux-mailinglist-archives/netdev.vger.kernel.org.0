Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21179180DDA
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 03:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgCKCIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 22:08:30 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:48892 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKCIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 22:08:30 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7]) by rmmx-syy-dmz-app11-12011 (RichMail) with SMTP id 2eeb5e6847394c0-6e133; Wed, 11 Mar 2020 10:04:42 +0800 (CST)
X-RM-TRANSID: 2eeb5e6847394c0-6e133
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee45e684735012-97a6c;
        Wed, 11 Mar 2020 10:04:42 +0800 (CST)
X-RM-TRANSID: 2ee45e684735012-97a6c
From:   tangbin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, corbet@lwn.net, benh@kernel.crashing.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tangbin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] net:ftgmac100:remove redundant judgement
Date:   Wed, 11 Mar 2020 10:05:37 +0800
Message-Id: <20200311020537.12420-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this function, ftgmac100_probe() can be triggered only
if the platform_device and platform_driver matches, so the
judgement at the beginning is redundant.

Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 4572797f0..c7ed7e871 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1757,9 +1757,6 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	struct device_node *np;
 	int err = 0;
 
-	if (!pdev)
-		return -ENODEV;
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENXIO;
-- 
2.20.1.windows.1



