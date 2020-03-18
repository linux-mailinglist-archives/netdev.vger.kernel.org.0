Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E46A18A588
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgCRVCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgCRU4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85B96208CA;
        Wed, 18 Mar 2020 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564965;
        bh=00nORI7dnwMcqWiv7O87Jn9altOa8vMwClu8L6DjZz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOxfh3AHcP2wV/pwvNbRJ2oOOWR9XzMhWu1ofUaJof9q8FH5lC/rNa69GRLQFE6KL
         i5e61UFG3auZ9fIZdPGxx/TRNz4usKTRDId+R6Xc+bVjAL+SVJBzQmKqfVlM8tFg9N
         mcyeZoDUhB23P+WsXxo0AL3QMBtkuvfAGCJg8tYE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/28] fib: add missing attribute validation for tun_id
Date:   Wed, 18 Mar 2020 16:55:35 -0400
Message-Id: <20200318205555.17447-8-sashal@kernel.org>
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

[ Upstream commit 4c16d64ea04056f1b1b324ab6916019f6a064114 ]

Add missing netlink policy entry for FRA_TUN_ID.

Fixes: e7030878fc84 ("fib: Add fib rule match on tunnel id")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/fib_rules.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 648caf90ec07a..b8fd023ba625a 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -102,6 +102,7 @@ struct fib_rule_notifier_info {
 	[FRA_OIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
 	[FRA_PRIORITY]	= { .type = NLA_U32 }, \
 	[FRA_FWMARK]	= { .type = NLA_U32 }, \
+	[FRA_TUN_ID]	= { .type = NLA_U64 }, \
 	[FRA_FWMASK]	= { .type = NLA_U32 }, \
 	[FRA_TABLE]     = { .type = NLA_U32 }, \
 	[FRA_SUPPRESS_PREFIXLEN] = { .type = NLA_U32 }, \
-- 
2.20.1

