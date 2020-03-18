Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFA318A687
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgCRVI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:08:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgCRUxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF01C20724;
        Wed, 18 Mar 2020 20:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564835;
        bh=OVY/Y11x2NrluLtErqwafEtZwWmK7FW0HoGoo+MRIKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEvP1pIHzmVfhnd7fy96cywbmc/it1+w5QtlGdcWUQzZ1wEbK70vWOO3uE91PTKGt
         6DjA6hdF9+OqFebG0DXnkEyWLD166rX9t3ak3k1itBft4yWsRwRukOf0rEBELefp7T
         8kIQQ9oQA7QS/fNHrsMED2chURKaRRjh1wEeX/AI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/73] fib: add missing attribute validation for tun_id
Date:   Wed, 18 Mar 2020 16:52:39 -0400
Message-Id: <20200318205337.16279-15-sashal@kernel.org>
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
index 20dcadd8eed94..7fed3193f81d4 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -108,6 +108,7 @@ struct fib_rule_notifier_info {
 	[FRA_OIFNAME]	= { .type = NLA_STRING, .len = IFNAMSIZ - 1 }, \
 	[FRA_PRIORITY]	= { .type = NLA_U32 }, \
 	[FRA_FWMARK]	= { .type = NLA_U32 }, \
+	[FRA_TUN_ID]	= { .type = NLA_U64 }, \
 	[FRA_FWMASK]	= { .type = NLA_U32 }, \
 	[FRA_TABLE]     = { .type = NLA_U32 }, \
 	[FRA_SUPPRESS_PREFIXLEN] = { .type = NLA_U32 }, \
-- 
2.20.1

