Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E13394FCC
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhE3G3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2472 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhE3G3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:19 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ft7gd4q5Dz68QJ;
        Sun, 30 May 2021 14:24:45 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 08/10] net: sealevel: remove meaningless comments
Date:   Sun, 30 May 2021 14:24:32 +0800
Message-ID: <1622355874-18933-9-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
References: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Remove the meaningless stylistically wrong comment.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/sealevel.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index e07309e0d971..6665732f96ce 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -105,9 +105,6 @@ static int sealevel_open(struct net_device *d)
 
 	slvl->chan->rx_function = sealevel_input;
 
-	/*
-	 *	Go go go
-	 */
 	netif_start_queue(d);
 	return 0;
 }
-- 
2.8.1

