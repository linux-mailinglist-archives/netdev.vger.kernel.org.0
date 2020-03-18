Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8592618A585
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgCRVCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgCRU4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDC220B1F;
        Wed, 18 Mar 2020 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564968;
        bh=2Th750cCWelncARz70TisADoonxUvcNkTJ12UwQGg74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bx2ObR5n1YDmgx9plbbQx9ALULUXQAC9NxUqMVaWQVxyq5LT5UYqoMeFwUTspYRc6
         WaBTiMZrA41jz8cg20uQ2XEjbTf71hYQ7LkCOsY7tGGU2H4abszevFyvUGlOEfUSbV
         HSlBRX5jLzHC1BuVMCF5ida62jJ/b0Uhg6eXuMf0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/28] team: add missing attribute validation for port ifindex
Date:   Wed, 18 Mar 2020 16:55:38 -0400
Message-Id: <20200318205555.17447-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205555.17447-1-sashal@kernel.org>
References: <20200318205555.17447-1-sashal@kernel.org>
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
index f1aabf8a16c2f..01c51a1526ef1 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2207,6 +2207,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_MAX + 1] = {
 	[TEAM_ATTR_OPTION_CHANGED]		= { .type = NLA_FLAG },
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
+	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)
-- 
2.20.1

