Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539C2336BC4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 06:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhCKF4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 00:56:23 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13592 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCKF4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 00:56:15 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DwynW6K50z17J3b;
        Thu, 11 Mar 2021 13:54:23 +0800 (CST)
Received: from localhost (10.174.179.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Thu, 11 Mar 2021
 13:56:02 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] netfilter: conntrack: Remove unused variable declaration
Date:   Thu, 11 Mar 2021 13:55:59 +0800
Message-ID: <20210311055559.51572-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.96]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit e97c3e278e95 ("tproxy: split off ipv6 defragmentation to a separate
module") left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index 7b3c873f8839..e95483192d1b 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -4,7 +4,4 @@
 
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
-#include <linux/sysctl.h>
-extern struct ctl_table nf_ct_ipv6_sysctl_table[];
-
 #endif /* _NF_CONNTRACK_IPV6_H*/
-- 
2.17.1

