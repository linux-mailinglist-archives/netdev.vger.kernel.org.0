Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E23348743
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCYDAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:00:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13688 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhCYDAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 23:00:30 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5VCS53TdznV6S;
        Thu, 25 Mar 2021 10:57:56 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 11:00:27 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: Fix a misspell in socket.c
Date:   Thu, 25 Mar 2021 11:01:55 +0800
Message-ID: <20210325030155.221795-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/addres/address

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 84a8049c2b09..27e3e7d53f8e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3568,7 +3568,7 @@ EXPORT_SYMBOL(kernel_accept);
  *	@addrlen: address length
  *	@flags: flags (O_NONBLOCK, ...)
  *
- *	For datagram sockets, @addr is the addres to which datagrams are sent
+ *	For datagram sockets, @addr is the address to which datagrams are sent
  *	by default, and the only address from which datagrams are received.
  *	For stream sockets, attempts to connect to @addr.
  *	Returns 0 or an error code.
-- 
2.17.1

