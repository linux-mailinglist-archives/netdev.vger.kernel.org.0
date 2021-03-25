Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD6C348934
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCYGhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:37:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14583 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhCYGhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:37:08 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5b215vh0z19JCD;
        Thu, 25 Mar 2021 14:35:05 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 14:37:00 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <idryomov@gmail.com>, <jlayton@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ceph-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xiyou.wangcong@gmail.com>, <ap420073@gmail.com>,
        <linux-decnet-user@lists.sourceforge.net>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>
Subject: [PATCH -next 2/5] net: core: Fix a typo in dev_addr_lists.c
Date:   Thu, 25 Mar 2021 14:38:22 +0800
Message-ID: <20210325063825.228167-3-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325063825.228167-1-luwei32@huawei.com>
References: <20210325063825.228167-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify "funciton" to "function" in net/core/dev_addr_lists.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/core/dev_addr_lists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index fa1c37ec40c9..1e5bde241185 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -228,7 +228,7 @@ EXPORT_SYMBOL(__hw_addr_unsync);
  *  @sync: function to call if address should be added
  *  @unsync: function to call if address should be removed
  *
- *  This funciton is intended to be called from the ndo_set_rx_mode
+ *  This function is intended to be called from the ndo_set_rx_mode
  *  function of devices that require explicit address add/remove
  *  notifications.  The unsync function may be NULL in which case
  *  the addresses requiring removal will simply be removed without
-- 
2.17.1

