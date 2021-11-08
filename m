Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB1644A114
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbhKIBHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:07:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237709AbhKIBFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4892561406;
        Tue,  9 Nov 2021 01:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419724;
        bh=fw69DV3f6rPulC53Y+5A2PWiFq76x3LnNtPX4Riyub4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJoH5z3J4tXDqRFkZO+kWNpVQKJh11uZjJM6JEb7wW2yD1lI/3Twn56dvXut3wT2I
         VVIFkRg1pgYRcCg8NciHwonxO2cy1KV2Mw7aLe/IXX+GdSId5qKoVyWXMVWn8Ven+P
         thdJ2/4LobKLcVeQva/Yx7hhkMWY55E0ThzCnl8ofjdXiB/BI4fY8b3NQm7gB7SLMh
         WrfDpzHUzLjVc1CW8ffLryiLOhHZTefLpGD7YTJS0BrUzxHJdk8Zp3Mwc6zzrDED2+
         2sezBrtJoxwy7hhzGS+chG8bodeP3UnGwgRuTW4DOcOgiRC8Xe2VQ/gYpqUnIcayCO
         HGJO3L7nhCRVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wangzhitong <wangzhitong@uniontech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, paul@paul-moore.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 019/138] NET: IPV4: fix error "do not initialise globals to 0"
Date:   Mon,  8 Nov 2021 12:44:45 -0500
Message-Id: <20211108174644.1187889-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
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

