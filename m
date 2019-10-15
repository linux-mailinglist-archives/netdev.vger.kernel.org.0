Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E45CD7FC1
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfJOTSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:18:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45694 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389440AbfJOTSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 15:18:48 -0400
Received: from localhost ([127.0.0.1] helo=localhost.localdomain)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iKSLA-00067i-1z; Tue, 15 Oct 2019 21:18:40 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 21/34] net: Use CONFIG_PREEMPTION
Date:   Tue, 15 Oct 2019 21:18:08 +0200
Message-Id: <20191015191821.11479-22-bigeasy@linutronix.de>
In-Reply-To: <20191015191821.11479-1-bigeasy@linutronix.de>
References: <20191015191821.11479-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

CONFIG_PREEMPTION is selected by CONFIG_PREEMPT and by CONFIG_PREEMPT_RT.
Both PREEMPT and PREEMPT_RT require the same functionality which today
depends on CONFIG_PREEMPT.

Update the comment to use CONFIG_PREEMPTION.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abafe..11a60d69434bc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -901,7 +901,7 @@ EXPORT_SYMBOL(dev_get_by_napi_id);
  *
  *	The use of raw_seqcount_begin() and cond_resched() before
  *	retrying is required as we want to give the writers a chance
- *	to complete when CONFIG_PREEMPT is not set.
+ *	to complete when CONFIG_PREEMPTION is not set.
  */
 int netdev_get_name(struct net *net, char *name, int ifindex)
 {
--=20
2.23.0

