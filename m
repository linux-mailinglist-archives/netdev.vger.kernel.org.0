Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E093AC0D6
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhFRChz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:37:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7483 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhFRChr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 22:37:47 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5jd42VBMzZjTs;
        Fri, 18 Jun 2021 10:32:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 10:35:37 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 1/7] net: hostess_sv11: fix the code style issue about "foo* bar"
Date:   Fri, 18 Jun 2021 10:32:18 +0800
Message-ID: <1623983544-39879-2-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
References: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the checkpatch error as "foo* bar" should be "foo *bar".

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/hostess_sv11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index 6c05c4c..a18c09d 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -48,7 +48,7 @@ static int dma;
  *	Network driver support routines
  */
 
-static inline struct z8530_dev* dev_to_sv(struct net_device *dev)
+static inline struct z8530_dev *dev_to_sv(struct net_device *dev)
 {
 	return (struct z8530_dev *)dev_to_hdlc(dev)->priv;
 }
-- 
2.8.1

