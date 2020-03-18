Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7459B18A52F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgCRU4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgCRU4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C74C2166E;
        Wed, 18 Mar 2020 20:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564994;
        bh=VrmNVisaFkgSu0GnQDdpKQDJ4aUhX8gk0Z7ERu8Byk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbZVmqeLIjjyRiTU6isk51t8EXt33V0ttwgqtlxMjbSUQrxALqE9Ta4TIxDuHO/n6
         kkHTkTy/i4tRaZ/KwEbJyEjdUMyrrBheTKmLjQPmOTCnbnKkYlQM1U4U9o+9OfCtpq
         VANyYD36hHPhMPgj6P/9MqPg8YJeWd2ev3AMAhXU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/15] fib: add missing attribute validation for tun_id
Date:   Wed, 18 Mar 2020 16:56:18 -0400
Message-Id: <20200318205629.17750-4-sashal@kernel.org>
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
index 456e4a6006abf..0b0ad792dd5c3 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -87,6 +87,7 @@ struct fib_rules_ops {
 	[FRA_OIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
 	[FRA_PRIORITY]	= { .type = NLA_U32 }, \
 	[FRA_FWMARK]	= { .type = NLA_U32 }, \
+	[FRA_TUN_ID]	= { .type = NLA_U64 }, \
 	[FRA_FWMASK]	= { .type = NLA_U32 }, \
 	[FRA_TABLE]     = { .type = NLA_U32 }, \
 	[FRA_SUPPRESS_PREFIXLEN] = { .type = NLA_U32 }, \
-- 
2.20.1

