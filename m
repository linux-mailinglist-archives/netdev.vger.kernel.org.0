Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE881B8E6D
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDZJlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:41:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3303 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726401AbgDZJlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 05:41:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9600194A452CEF78B6C3;
        Sun, 26 Apr 2020 17:41:42 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 17:41:36 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <adobriyan@gmail.com>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ray_cs: use true,false for bool variable
Date:   Sun, 26 Apr 2020 17:41:03 +0800
Message-ID: <20200426094103.23213-1-yanaijie@huawei.com>
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

drivers/net/wireless/ray_cs.c:2797:5-14: WARNING: Comparison of 0/1 to
bool variable
drivers/net/wireless/ray_cs.c:2798:2-11: WARNING: Assignment of 0/1 to
bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/ray_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index c1d542bfa530..f9402424accd 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2794,8 +2794,8 @@ static int __init init_ray_cs(void)
 	proc_create_data("driver/ray_cs/translate", 0200, NULL, &int_proc_ops,
 			 &translate);
 #endif
-	if (translate != 0)
-		translate = 1;
+	if (!translate)
+		translate = true;
 	return 0;
 } /* init_ray_cs */
 
-- 
2.21.1

