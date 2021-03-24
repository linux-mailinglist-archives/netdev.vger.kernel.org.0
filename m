Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16CE346F8C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 03:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhCXCcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 22:32:07 -0400
Received: from m12-11.163.com ([220.181.12.11]:47288 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhCXCbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 22:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=QB5sr
        IEpoTZgw2u5PRNuaX6WnECVWqJ2qDsPzwzgx2E=; b=kWeYqymkj4Hb8NJfoUP64
        Kwyn3nl36qiEk7RrY52iedJUHUj+hl3COSSWJAmOYN8GplTKeS8SWtJgJheDfUzo
        9BhoNJXdYhF0U0J9Lrth28zqqFhN9/4V7cto4uMIX7b+KCEaD9XFXnhQt4oSMMUE
        yRJSRLjUkp+MDZNQEYu5Vc=
Received: from caizhichao.ccdomain.com (unknown [218.94.48.178])
        by smtp7 (Coremail) with SMTP id C8CowAAHA_NLpFpgvVEyTw--.11030S2;
        Wed, 24 Mar 2021 10:30:54 +0800 (CST)
From:   caizhichao <tomstomsczc@163.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhichao Cai <caizhichao@yulong.com>
Subject: [PATCH] Simplify the code by using module_platform_driver macro
Date:   Wed, 24 Mar 2021 10:30:47 +0800
Message-Id: <20210324023047.1337-1-tomstomsczc@163.com>
X-Mailer: git-send-email 2.30.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAAHA_NLpFpgvVEyTw--.11030S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7JF4UWw1DXFy3trWkAw15twb_yoW8JrWUpF
        WUJry7Wr48Gw1UX3WkJw1kZry5G3WUKryjgF4UG3s5Xw4kAw1UZr1kA345Xr1UJayUKF13
        tr15Zr43WFZ8JwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jO8n5UUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: pwrp23prpvu6rf6rljoofrz/1tbiyQZeilQHNSrN8gABsp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhichao Cai <caizhichao@yulong.com>

for ftmac100

Signed-off-by: Zhichao Cai <caizhichao@yulong.com>
---
 drivers/net/ethernet/faraday/ftmac100.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index 473b337..5a1a8f2 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -1177,18 +1177,7 @@ static int ftmac100_remove(struct platform_device *pdev)
 /******************************************************************************
  * initialization / finalization
  *****************************************************************************/
-static int __init ftmac100_init(void)
-{
-	return platform_driver_register(&ftmac100_driver);
-}
-
-static void __exit ftmac100_exit(void)
-{
-	platform_driver_unregister(&ftmac100_driver);
-}
-
-module_init(ftmac100_init);
-module_exit(ftmac100_exit);
+module_platform_driver(ftmac100_driver);
 
 MODULE_AUTHOR("Po-Yu Chuang <ratbert@faraday-tech.com>");
 MODULE_DESCRIPTION("FTMAC100 driver");
-- 
1.9.1

