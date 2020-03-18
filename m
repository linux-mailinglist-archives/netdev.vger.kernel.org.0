Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD87D18A546
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgCRVAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbgCRU4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56ECA2166E;
        Wed, 18 Mar 2020 20:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564997;
        bh=onoiNj67Li7ArrWTRP5pydx7Di1dU5uyf4sm/wAU0AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wfwPz0VhIlCJpaMMDLxHzfsJhfnNzomvOB1IHs0kggeYAV74gkQu4mPD3DYYXywNm
         igW6jQn+7Ve20+IAoQYWBQ2pW/htMuqdwBI1gOAKDTta1xYsyHxINotpeofYlrc2Xm
         DshUqCsWjXXJuPgCK2DOlJVQX2Ny9Z2zEq3mVj4w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 06/15] team: add missing attribute validation for port ifindex
Date:   Wed, 18 Mar 2020 16:56:20 -0400
Message-Id: <20200318205629.17750-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205629.17750-1-sashal@kernel.org>
References: <20200318205629.17750-1-sashal@kernel.org>
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
index fd2573cca803b..eaae1ac4749bd 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2216,6 +2216,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_MAX + 1] = {
 	[TEAM_ATTR_OPTION_CHANGED]		= { .type = NLA_FLAG },
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
+	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)
-- 
2.20.1

