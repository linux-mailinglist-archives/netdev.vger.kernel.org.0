Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5F626FE29
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgIRNVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:21:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42780 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbgIRNVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:21:19 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E9F6F61319B4D8AFBF44;
        Fri, 18 Sep 2020 21:21:17 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:21:14 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: tipc: Supply missing udp_media.h include file
Date:   Fri, 18 Sep 2020 21:18:19 +0800
Message-ID: <20200918131819.28062-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the header file containing a function's prototype isn't included by
the sourcefile containing the associated function, the build system
complains of missing prototypes.

Fixes the following W=1 kernel build warning(s):

net/tipc/udp_media.c:446:5: warning: no previous prototype for ‘tipc_udp_nl_dump_remoteip’ [-Wmissing-prototypes]
net/tipc/udp_media.c:532:5: warning: no previous prototype for ‘tipc_udp_nl_add_bearer_data’ [-Wmissing-prototypes]
net/tipc/udp_media.c:614:5: warning: no previous prototype for ‘tipc_udp_nl_bearer_add’ [-Wmissing-prototypes]

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/tipc/udp_media.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 911d13cd2e67..1d17f4470ee2 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -52,6 +52,7 @@
 #include "bearer.h"
 #include "netlink.h"
 #include "msg.h"
+#include "udp_media.h"
 
 /* IANA assigned UDP port */
 #define UDP_PORT_DEFAULT	6118
-- 
2.17.1

