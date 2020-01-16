Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E3013F329
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390350AbgAPRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389018AbgAPRLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:11:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940B7246A0;
        Thu, 16 Jan 2020 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194714;
        bh=VMxSnVGIwtCxxKxJeP4Q7uYMqhofEoA/E2CG4sUyupk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SS3pvIaWr+Qn337e2vDzM/2ty4g/E64EzKklydR6RvACrWTAtwEuS9cVsAj5Y+Ipl
         8uIOs607aGyzDEVYSpvPQKSZdho6kwbUJR4EG+Rn3DLerDvVDh0+0kkIA/GHrLtDzv
         yDaLga0PK34QPBFdWhPlCnYkavfcun8F8UvlHUXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.19 551/671] net/rds: Fix 'ib_evt_handler_call' element in 'rds_ib_stat_names'
Date:   Thu, 16 Jan 2020 12:03:09 -0500
Message-Id: <20200116170509.12787-288-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit 05a82481a3024b94db00b8c816bb3d526b5209e0 ]

All entries in 'rds_ib_stat_names' are stringified versions
of the corresponding "struct rds_ib_statistics" element
without the "s_"-prefix.

Fix entry 'ib_evt_handler_call' to do the same.

Fixes: f4f943c958a2 ("RDS: IB: ack more receive completions to improve performance")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib_stats.c b/net/rds/ib_stats.c
index 9252ad126335..ac46d8961b61 100644
--- a/net/rds/ib_stats.c
+++ b/net/rds/ib_stats.c
@@ -42,7 +42,7 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
 static const char *const rds_ib_stat_names[] = {
 	"ib_connect_raced",
 	"ib_listen_closed_stale",
-	"s_ib_evt_handler_call",
+	"ib_evt_handler_call",
 	"ib_tasklet_call",
 	"ib_tx_cq_event",
 	"ib_tx_ring_full",
-- 
2.20.1

