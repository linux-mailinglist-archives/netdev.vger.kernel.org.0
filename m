Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B98513EFF0
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395404AbgAPSS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392655AbgAPR2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C502246E8;
        Thu, 16 Jan 2020 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195727;
        bh=N6NL80NyMEmBK1Ck48h21G8o7JDmrLH68BcMhLlv+3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJQqak/USWV+Rx5bGj5xy5gur37QstpW+i0wTmG/MXfod+3TURj0D52xj6kIdABvq
         hzf20qm0Nb0xQWnwregGBrMABx64cqRsRa/Chy3kl4xdFMvRAs9QtWIlqM5nVkkARD
         3a5+wXkEDJ/98uQnWg7HBzfyrj9RiQ/vZCGBToJY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerd Rausch <gerd.rausch@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 4.14 268/371] net/rds: Add a few missing rds_stat_names entries
Date:   Thu, 16 Jan 2020 12:22:20 -0500
Message-Id: <20200116172403.18149-211-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit 55c70ca00c982fbc0df4c4d3e31747fb73f4ddb5 ]

In a previous commit, fields were added to "struct rds_statistics"
but array "rds_stat_names" was not updated accordingly.

Please note the inconsistent naming of the string representations
that is done in the name of compatibility
with the Oracle internal code-base.

s_recv_bytes_added_to_socket     -> "recv_bytes_added_to_sock"
s_recv_bytes_removed_from_socket -> "recv_bytes_freed_fromsock"

Fixes: 192a798f5299 ("RDS: add stat for socket recv memory usage")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/stats.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/stats.c b/net/rds/stats.c
index 73be187d389e..6bbab4d74c4f 100644
--- a/net/rds/stats.c
+++ b/net/rds/stats.c
@@ -76,6 +76,8 @@ static const char *const rds_stat_names[] = {
 	"cong_update_received",
 	"cong_send_error",
 	"cong_send_blocked",
+	"recv_bytes_added_to_sock",
+	"recv_bytes_freed_fromsock",
 };
 
 void rds_stats_info_copy(struct rds_info_iterator *iter,
-- 
2.20.1

