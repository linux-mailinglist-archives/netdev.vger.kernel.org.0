Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326E73AC0DA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhFRCh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:37:58 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7484 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhFRChr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 22:37:47 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5jd50RSCzZhWP;
        Fri, 18 Jun 2021 10:32:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 10:35:37 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 5/7] net: hostess_sv11: remove dead code
Date:   Fri, 18 Jun 2021 10:32:22 +0800
Message-ID: <1623983544-39879-6-git-send-email-lipeng321@huawei.com>
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

This patch removes the dead code.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/hostess_sv11.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index 7a59d7e..4e11c86 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -151,8 +151,6 @@ static int hostess_close(struct net_device *d)
 
 static int hostess_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
 {
-	/* struct z8530_dev *sv11=dev_to_sv(d);
-	   z8530_ioctl(d,&sv11->chanA,ifr,cmd) */
 	return hdlc_ioctl(d, ifr, cmd);
 }
 
-- 
2.8.1

