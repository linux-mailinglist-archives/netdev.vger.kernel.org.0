Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF0844A064
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhKIBDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:03:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237104AbhKIBDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:03:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F0B061215;
        Tue,  9 Nov 2021 01:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419619;
        bh=fw69DV3f6rPulC53Y+5A2PWiFq76x3LnNtPX4Riyub4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJZnoEDJLKo+TjQEpVPX5hVSgXN4kxqxE1UrH2WfXn827c+wW5PvMOTYQZmv8ui23
         7twZ9xFDh6hdv6y+TnvhTGBaFwRXkk4ziHCd/Ojgj1uZu5V2FE1eSgzV0Qkf7GJ2OE
         qWASPgBxIInsSWSaWG3VqyrxP81dMBcL0xJr59RnSWk+5e9tv6dnXzHboYkxMtxPP/
         Ea2BZLuc0g7riNL+xva4ZUQB4HVRLSvj4MG/eaOcYFG01gZUraunVLbmlfp65kBjJh
         LBb29/k2yjogmRM/rqnmgMet5niHzLLfv5nSWjbOYv7ZpQJZ8jDdN/Fas1KUHl1z7q
         rpYokoYv8L/PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 021/146] NET: IPV4: fix error "do not initialise globals to 0"
Date:   Mon,  8 Nov 2021 12:42:48 -0500
Message-Id: <20211108174453.1187052-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
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
index 099259fc826aa..62d5f99760aac 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -73,7 +73,7 @@ struct cipso_v4_map_cache_entry {
 static struct cipso_v4_map_cache_bkt *cipso_v4_cache;
 
 /* Restricted bitmap (tag #1) flags */
-int cipso_v4_rbm_optfmt = 0;
+int cipso_v4_rbm_optfmt;
 int cipso_v4_rbm_strictvalid = 1;
 
 /*
-- 
2.33.0

