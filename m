Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E641C394FC7
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhE3G3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2105 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhE3G3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ft7dc6Z83zWqSB;
        Sun, 30 May 2021 14:23:00 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:39 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:39 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 05/10] net: sealevel: add some required spaces
Date:   Sun, 30 May 2021 14:24:29 +0800
Message-ID: <1622355874-18933-6-git-send-email-huangguangbin2@huawei.com>
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

Add spaces required around that '='.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/sealevel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index b484d1f7b176..be618fd0b9a8 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -347,10 +347,10 @@ static void __exit slvl_shutdown(struct slvl_board *b)
 	kfree(b);
 }
 
-static int io=0x238;
-static int txdma=1;
-static int rxdma=3;
-static int irq=5;
+static int io = 0x238;
+static int txdma = 1;
+static int rxdma = 3;
+static int irq = 5;
 static bool slow=false;
 
 module_param_hw(io, int, ioport, 0);
-- 
2.8.1

