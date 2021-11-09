Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6D44A31D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbhKIB0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:26:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235565AbhKIBVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9752F61B1B;
        Tue,  9 Nov 2021 01:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420102;
        bh=pIgLvEmmq+uA9xRWP4MKrkze4N12cdQWrgPJhATtPGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s559xS70dfpKc4a15g7oPHeeMIkSqsGtiiGFaWKu9NmwSLUTw4pL9bdiQNiU76oJ8
         x7u2+LnOO/77qVfQHPtl80B69D7l92Oxk5kcNYXqPUw0NDilaXfPSW9aRGWDOuvitg
         0AnGu/s+oMB2H1si1HHailcJmqnY3TsNdJU3JjL0WGV8I5qBu9PO1usIL2PwuS1kGN
         PPBp4aBgJOG22szbpQMhADjFb+1uJeThwiXJP95ji3JuSmQQg9rufE/PLIXjH21Obs
         0ycgMj22Ba9/jBFd4fvxFPbT6pt8xlt4VnVVvX/6s8z6MJ/u0+wCJ8X0YWkE0wBQej
         NVvbID1No9HPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 08/33] NET: IPV4: fix error "do not initialise globals to 0"
Date:   Mon,  8 Nov 2021 20:07:42 -0500
Message-Id: <20211109010807.1191567-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wangzhitong <wangzhitong@uniontech.com>

[ Upstream commit db9c8e2b1e246fc2dc20828932949437793146cc ]

this patch fixes below Errors reported by checkpatch
    ERROR: do not initialise globals to 0
    +int cipso_v4_rbm_optfmt = 0;

Signed-off-by: wangzhitong <wangzhitong@uniontech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 553cda6f887ad..15448b2d8a267 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -87,7 +87,7 @@ struct cipso_v4_map_cache_entry {
 static struct cipso_v4_map_cache_bkt *cipso_v4_cache;
 
 /* Restricted bitmap (tag #1) flags */
-int cipso_v4_rbm_optfmt = 0;
+int cipso_v4_rbm_optfmt;
 int cipso_v4_rbm_strictvalid = 1;
 
 /*
-- 
2.33.0

