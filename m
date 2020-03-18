Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773C918A67F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgCRVIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbgCRUx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A1EC20B1F;
        Wed, 18 Mar 2020 20:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564838;
        bh=LOpwmiK83qi8XIvAAVhYA1val7Qvb9HzWBWoIYbpGSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=of5/YPdIG5i/9VkhiKvW5dtMB53ylYILYOleO60LOUthqTwBXr1McLb3qabRC2GIP
         qpsQNH/gnCkKjHHI0mD7n8njG+mb1bj8SlPJnCnhrkA+lVU9o8h40DroYIuRy/LZxC
         ywvmYRGzZ/xyev5BvsYz5tWfBk2ShQfuGEhnc80I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/73] team: add missing attribute validation for port ifindex
Date:   Wed, 18 Mar 2020 16:52:42 -0400
Message-Id: <20200318205337.16279-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit dd25cb272ccce4db67dc8509278229099e4f5e99 ]

Add missing attribute validation for TEAM_ATTR_OPTION_PORT_IFINDEX
to the netlink policy.

Fixes: 80f7c6683fe0 ("team: add support for per-port options")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index ca70a1d840eb3..44dd26a62a6d3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2240,6 +2240,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_MAX + 1] = {
 	[TEAM_ATTR_OPTION_CHANGED]		= { .type = NLA_FLAG },
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
+	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)
-- 
2.20.1

