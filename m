Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB793E1343
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 09:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389978AbfJWHkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 03:40:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48066 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732328AbfJWHkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 03:40:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 94EA234E5549B1E25C9E;
        Wed, 23 Oct 2019 15:40:32 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 23 Oct 2019
 15:40:23 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <simon@thekelleys.org.uk>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] atmel: remove set but not used variable 'dev'
Date:   Wed, 23 Oct 2019 15:40:19 +0800
Message-ID: <20191023074019.29708-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/atmel/atmel_cs.c:120:21:
 warning: variable dev set but not used [-Wunused-but-set-variable]

It is never used, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/atmel/atmel_cs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/atmel/atmel_cs.c b/drivers/net/wireless/atmel/atmel_cs.c
index 7afc9c5..368eebe 100644
--- a/drivers/net/wireless/atmel/atmel_cs.c
+++ b/drivers/net/wireless/atmel/atmel_cs.c
@@ -117,11 +117,9 @@ static int atmel_config_check(struct pcmcia_device *p_dev, void *priv_data)
 
 static int atmel_config(struct pcmcia_device *link)
 {
-	struct local_info *dev;
 	int ret;
 	const struct pcmcia_device_id *did;
 
-	dev = link->priv;
 	did = dev_get_drvdata(&link->dev);
 
 	dev_dbg(&link->dev, "atmel_config\n");
-- 
2.7.4


