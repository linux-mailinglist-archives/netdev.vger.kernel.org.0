Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1AA49D258
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244384AbiAZTLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55104 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbiAZTLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C35446165F
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B9CC340E3;
        Wed, 26 Jan 2022 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224278;
        bh=/LFXxTzqXdHR926qqy8NvCjt1QHnFciyauslXiK0KlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcMIsGmdSZXNkKYKH06en9fXfZfVgEY5OsgD+ZwTIU2gps6jNGn+6SVkmefmAEa1a
         gMj01EmWXzGeXMKP90YDyzUitgUL8iy/Ze+UremA1dFjTE5DaczaXmabnT8U4Gy+Fx
         AnDO+5TDGiNKlsRdOBy6YHyu5gj99/lwB5B33XiXZzGaj7xg+2LlezXJf6A9WaWjdr
         mBWq3DYoflc9VmyszjZUf+VVvCNOdbLkR7ufoy6p5Uh/HM0ZXIu0MOu0R9ItwJmsUd
         Qhq+ViFcZuSaQnKNimwYBDJ2OZ5OUkBB06KIleHpphmKwDcDjkgQjsDw5KcdhZr8vB
         9S0foIqFVwRbQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: [PATCH net-next 13/15] net: sched: remove psched_tdiff_bounded()
Date:   Wed, 26 Jan 2022 11:11:07 -0800
Message-Id: <20220126191109.2822706-14-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not used since v3.9.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jhs@mojatatu.com
CC: xiyou.wangcong@gmail.com
CC: jiri@resnulli.us
---
 include/net/pkt_sched.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 9e7b21c0b3a6..44a35531952e 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -63,12 +63,6 @@ static inline psched_time_t psched_get_time(void)
 	return PSCHED_NS2TICKS(ktime_get_ns());
 }
 
-static inline psched_tdiff_t
-psched_tdiff_bounded(psched_time_t tv1, psched_time_t tv2, psched_time_t bound)
-{
-	return min(tv1 - tv2, bound);
-}
-
 struct qdisc_watchdog {
 	u64		last_expires;
 	struct hrtimer	timer;
-- 
2.34.1

