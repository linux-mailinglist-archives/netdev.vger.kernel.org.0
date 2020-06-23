Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351FC2062E6
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391528AbgFWUeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391514AbgFWUeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C17342080C;
        Tue, 23 Jun 2020 20:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944457;
        bh=3hHV1jtb2Ql+/V2fdM36+lpmCrBcLd9rMcBpsTVI68M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehypAUd9ej4vnTFf/YbmcD/j4Pb1X7fp8VgIqOAIZ12Kx+6wfzsBJc+OscAEK4F2N
         8xgitsW4Ski5DNW2Q8LhakdOxb1kfsM87vXDJLCxtU7d7dRmHQZ5hRCgmEjnp0TIxl
         bk9FTvPDD9dzcLERQKeA+TD619KU6TXutya/dAkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 313/314] sched/rt, net: Use CONFIG_PREEMPTION.patch
Date:   Tue, 23 Jun 2020 21:58:28 +0200
Message-Id: <20200623195353.932589002@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2da2b32fd9346009e9acdb68c570ca8d3966aba7 ]

CONFIG_PREEMPTION is selected by CONFIG_PREEMPT and by CONFIG_PREEMPT_RT.
Both PREEMPT and PREEMPT_RT require the same functionality which today
depends on CONFIG_PREEMPT.

Update the comment to use CONFIG_PREEMPTION.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/20191015191821.11479-22-bigeasy@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8552874e5aac1..b127f022d8bd9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -819,7 +819,7 @@ EXPORT_SYMBOL(dev_get_by_napi_id);
  *
  *	The use of raw_seqcount_begin() and cond_resched() before
  *	retrying is required as we want to give the writers a chance
- *	to complete when CONFIG_PREEMPT is not set.
+ *	to complete when CONFIG_PREEMPTION is not set.
  */
 int netdev_get_name(struct net *net, char *name, int ifindex)
 {
-- 
2.25.1



