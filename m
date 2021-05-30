Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9609C394FC9
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhE3G3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2104 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhE3G3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:18 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ft7db0W1szWqS5;
        Sun, 30 May 2021 14:22:59 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:37 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:37 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 01/10] net: sealevel: remove redundant blank lines
Date:   Sun, 30 May 2021 14:24:25 +0800
Message-ID: <1622355874-18933-2-git-send-email-huangguangbin2@huawei.com>
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

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/sealevel.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 7dddc9dcbe23..62cc59892d1e 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -29,14 +29,12 @@
 #include <asm/byteorder.h>
 #include "z85230.h"
 
-
 struct slvl_device
 {
 	struct z8530_channel *chan;
 	int channel;
 };
 
-
 struct slvl_board
 {
 	struct slvl_device dev[2];
@@ -195,7 +193,6 @@ static int slvl_setup(struct slvl_device *sv, int iobase, int irq)
 	return 0;
 }
 
-
 /*
  *	Allocate and setup Sealevel board.
  */
@@ -256,7 +253,6 @@ static __init struct slvl_board *slvl_init(int iobase, int irq,
 
 	outb(3 | (1 << 7), b->iobase + 4);
 
-
 	/* We want a fast IRQ for this device. Actually we'd like an even faster
 	   IRQ ;) - This is one driver RtLinux is made for */
 
@@ -351,7 +347,6 @@ static void __exit slvl_shutdown(struct slvl_board *b)
 	kfree(b);
 }
 
-
 static int io=0x238;
 static int txdma=1;
 static int rxdma=3;
-- 
2.8.1

