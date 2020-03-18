Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6849518A543
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgCRVAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728643AbgCRU4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAE020BED;
        Wed, 18 Mar 2020 20:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564998;
        bh=aCXDfBj6Zf5CZMcX8LIz9/RY1DaZrceSdatsYg1dRFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otKHOQD3/TTpyI/GOMUU85XawrDRROc6PnjRjJexFuMWIpMli+qPZqahmIJh7YkVz
         yklI/7vcYDvo9CXDPzWeo2Lkk6Oa6tbEbF3HOkIBQmDo6zJtSlTXHPv4nGFxchxuy8
         HT9KApUI8DR36YQTBQpO5nhdrHO378PnUhza8a5M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/15] team: add missing attribute validation for array index
Date:   Wed, 18 Mar 2020 16:56:21 -0400
Message-Id: <20200318205629.17750-7-sashal@kernel.org>
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

[ Upstream commit 669fcd7795900cd1880237cbbb57a7db66cb9ac8 ]

Add missing attribute validation for TEAM_ATTR_OPTION_ARRAY_INDEX
to the netlink policy.

Fixes: b13033262d24 ("team: introduce array options")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index eaae1ac4749bd..d0c18e3557f1c 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2217,6 +2217,7 @@ team_nl_option_policy[TEAM_ATTR_OPTION_MAX + 1] = {
 	[TEAM_ATTR_OPTION_TYPE]			= { .type = NLA_U8 },
 	[TEAM_ATTR_OPTION_DATA]			= { .type = NLA_BINARY },
 	[TEAM_ATTR_OPTION_PORT_IFINDEX]		= { .type = NLA_U32 },
+	[TEAM_ATTR_OPTION_ARRAY_INDEX]		= { .type = NLA_U32 },
 };
 
 static int team_nl_cmd_noop(struct sk_buff *skb, struct genl_info *info)
-- 
2.20.1

