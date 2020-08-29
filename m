Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F16256736
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgH2LpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:45:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37948 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727904AbgH2LoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:44:06 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E078EAD0C42DCAA74677;
        Sat, 29 Aug 2020 19:43:48 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:43:39 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <mptcp@lists.01.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] mptcp: Remove unused macro MPTCP_SAME_STATE
Date:   Sat, 29 Aug 2020 19:42:26 +0800
Message-ID: <20200829114226.17976-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree any more.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/mptcp/protocol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1aad411a0e46..e6216c4f308c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -24,8 +24,6 @@
 #include "protocol.h"
 #include "mib.h"
 
-#define MPTCP_SAME_STATE TCP_MAX_STATES
-
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 struct mptcp6_sock {
 	struct mptcp_sock msk;
-- 
2.17.1


