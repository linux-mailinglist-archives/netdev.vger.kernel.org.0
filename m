Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D6C12D38
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfECMKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:10:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43030 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbfECMKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 08:10:22 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hMX18-00078T-Ax; Fri, 03 May 2019 12:10:18 +0000
From:   Colin King <colin.king@canonical.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: rds: fix spelling mistake "syctl" -> "sysctl"
Date:   Fri,  3 May 2019 13:10:17 +0100
Message-Id: <20190503121017.5227-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pr_warn warning. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/rds/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index faf726e00e27..66121bc6f34e 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -551,7 +551,7 @@ static __net_init int rds_tcp_init_net(struct net *net)
 		tbl = kmemdup(rds_tcp_sysctl_table,
 			      sizeof(rds_tcp_sysctl_table), GFP_KERNEL);
 		if (!tbl) {
-			pr_warn("could not set allocate syctl table\n");
+			pr_warn("could not set allocate sysctl table\n");
 			return -ENOMEM;
 		}
 		rtn->ctl_table = tbl;
-- 
2.20.1

