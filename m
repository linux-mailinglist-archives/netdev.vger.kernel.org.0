Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234A0176E64
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgCCFGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgCCFFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:42 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 557A724677;
        Tue,  3 Mar 2020 05:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211941;
        bh=bqBxf1Sh8kubHRVs/Zaxe0LHhoBQwwFZ+zP3hAuWN/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAO2hw+yKUaulfCu7R/mvxw17KhG7QawaB0lJGsCD+2PX+n/6OBBodQ+DiNxAd6No
         NseG38nEaJI18/d/gJxigkYy+hfpmacUhjD0gkOlpc9aVkSKaSt34Q6B2hhkLXaKfB
         xAb4mPtzRJYP6kyDx3yGxyafZufWO/NSYf6+X2jk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        dsahern@kernel.org, Thomas Graf <tgraf@suug.ch>
Subject: [PATCH net 03/16] fib: add missing attribute validation for tun_id
Date:   Mon,  2 Mar 2020 21:05:13 -0800
Message-Id: <20200303050526.4088735-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing netlink policy entry for FRA_TUN_ID.

Fixes: e7030878fc84 ("fib: Add fib rule match on tunnel id")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: dsahern@kernel.org
CC: Thomas Graf <tgraf@suug.ch>
---
 include/net/fib_rules.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 54e227e6b06a..a259050f84af 100644
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
2.24.1

