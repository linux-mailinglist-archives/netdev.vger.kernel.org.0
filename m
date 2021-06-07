Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF20B39DF1C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhFGOti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:49:38 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8063 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhFGOth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:49:37 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzGP22BC5zYs6T;
        Mon,  7 Jun 2021 22:44:54 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 22:47:41 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <sam@mendozajonas.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/ncsi: Fix spelling mistakes
Date:   Mon, 7 Jun 2021 23:01:18 +0800
Message-ID: <20210607150118.2856390-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
constuct  ==> construct
chanels  ==> channels
Detination  ==> Destination

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ncsi/internal.h    | 4 ++--
 net/ncsi/ncsi-manage.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 49031f804276..cbbb0de4750a 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -238,7 +238,7 @@ struct ncsi_package {
 	struct ncsi_dev_priv *ndp;        /* NCSI device            */
 	spinlock_t           lock;        /* Protect the package    */
 	unsigned int         channel_num; /* Number of channels     */
-	struct list_head     channels;    /* List of chanels        */
+	struct list_head     channels;    /* List of channels        */
 	struct list_head     node;        /* Form list of packages  */
 
 	bool                 multi_channel; /* Enable multiple channels  */
@@ -339,7 +339,7 @@ struct ncsi_cmd_arg {
 	unsigned char        type;        /* Command in the NCSI packet    */
 	unsigned char        id;          /* Request ID (sequence number)  */
 	unsigned char        package;     /* Destination package ID        */
-	unsigned char        channel;     /* Detination channel ID or 0x1f */
+	unsigned char        channel;     /* Destination channel ID or 0x1f */
 	unsigned short       payload;     /* Command packet payload length */
 	unsigned int         req_flags;   /* NCSI request properties       */
 	union {
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index ffff8da707b8..ca04b6df1341 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -627,7 +627,7 @@ static int clear_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
 	return 0;
 }
 
-/* Find an outstanding VLAN tag and constuct a "Set VLAN Filter - Enable"
+/* Find an outstanding VLAN tag and construct a "Set VLAN Filter - Enable"
  * packet.
  */
 static int set_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
-- 
2.25.1

