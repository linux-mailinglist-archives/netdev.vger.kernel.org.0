Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C601A63D9
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 09:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgDMHyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 03:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbgDMHyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 03:54:39 -0400
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779A8C008651;
        Mon, 13 Apr 2020 00:54:38 -0700 (PDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6D3C3FC6FF1CF58152C8;
        Mon, 13 Apr 2020 15:54:35 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 13 Apr 2020
 15:54:28 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <yanaijie@huawei.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] orinoco: remove useless variable 'err' in spectrum_cs_suspend()
Date:   Mon, 13 Apr 2020 16:20:43 +0800
Message-ID: <20200413082043.22468-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/intersil/orinoco/spectrum_cs.c:281:5-8: Unneeded
variable: "err". Return "0" on line 286

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/intersil/orinoco/spectrum_cs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/spectrum_cs.c b/drivers/net/wireless/intersil/orinoco/spectrum_cs.c
index b60048c95e0a..291ef97ed45e 100644
--- a/drivers/net/wireless/intersil/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/intersil/orinoco/spectrum_cs.c
@@ -278,12 +278,11 @@ static int
 spectrum_cs_suspend(struct pcmcia_device *link)
 {
 	struct orinoco_private *priv = link->priv;
-	int err = 0;
 
 	/* Mark the device as stopped, to block IO until later */
 	orinoco_down(priv);
 
-	return err;
+	return 0;
 }
 
 static int
-- 
2.21.1

