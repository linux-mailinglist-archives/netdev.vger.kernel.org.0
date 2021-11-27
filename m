Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552C545FDB4
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 10:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353702AbhK0Jn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 04:43:59 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31916 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353200AbhK0Jl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 04:41:58 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J1RPp683wzcbDK;
        Sat, 27 Nov 2021 17:38:38 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 27 Nov 2021 17:38:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 27 Nov 2021 17:38:42 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 1/2] net: vxlan: add macro definition for number of IANA VXLAN-GPE port
Date:   Sat, 27 Nov 2021 17:34:04 +0800
Message-ID: <20211127093405.47218-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211127093405.47218-1-huangguangbin2@huawei.com>
References: <20211127093405.47218-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add macro definition for number of IANA VXLAN-GPE port for generic use.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/vxlan.c | 2 +-
 include/net/vxlan.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index fecff0a46612..359d16780dbb 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3747,7 +3747,7 @@ static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
 
 	if (!conf->dst_port) {
 		if (conf->flags & VXLAN_F_GPE)
-			conf->dst_port = htons(4790); /* IANA VXLAN-GPE port */
+			conf->dst_port = htons(IANA_VXLAN_GPE_UDP_PORT);
 		else
 			conf->dst_port = htons(vxlan_port);
 	}
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 08537aa14f7c..5a934bebe630 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -10,6 +10,7 @@
 #include <net/nexthop.h>
 
 #define IANA_VXLAN_UDP_PORT     4789
+#define IANA_VXLAN_GPE_UDP_PORT 4790
 
 /* VXLAN protocol (RFC 7348) header:
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-- 
2.33.0

