Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FDE34893E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhCYGhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:37:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14872 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhCYGhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:37:06 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F5b1v6zhQz9spJ;
        Thu, 25 Mar 2021 14:34:59 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 14:36:59 +0800
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
Subject: [PATCH -next 1/5] net: ceph: Fix a typo in osdmap.c
Date:   Thu, 25 Mar 2021 14:38:21 +0800
Message-ID: <20210325063825.228167-2-luwei32@huawei.com>
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

Modify "inital" to "initial" in net/ceph/osdmap.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 2b1dd252f231..c959320c4775 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1069,7 +1069,7 @@ static struct crush_work *get_workspace(struct workspace_manager *wsm,
 
 		/*
 		 * Do not return the error but go back to waiting.  We
-		 * have the inital workspace and the CRUSH computation
+		 * have the initial workspace and the CRUSH computation
 		 * time is bounded so we will get it eventually.
 		 */
 		WARN_ON(atomic_read(&wsm->total_ws) < 1);
-- 
2.17.1

