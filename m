Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2A0390397
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhEYOMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:12:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:4005 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbhEYOMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:12:32 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FqGCB4P7tzmbSq;
        Tue, 25 May 2021 22:08:38 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:58 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/6] net: wan: fix an code style issue about "foo* bar
Date:   Tue, 25 May 2021 22:07:55 +0800
Message-ID: <1621951678-23466-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
References: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Fix the checkpatch error as "foo* bar" and should be "foo *bar".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/n2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index 5ad8c5032900..180fb2c9a442 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -32,8 +32,8 @@
 #include <asm/io.h>
 #include "hd64570.h"
 
-static const char* version = "SDL RISCom/N2 driver version: 1.15";
-static const char* devname = "RISCom/N2";
+static const char *version = "SDL RISCom/N2 driver version: 1.15";
+static const char *devname = "RISCom/N2";
 
 #undef DEBUG_PKT
 #define DEBUG_RINGS
-- 
2.8.1

