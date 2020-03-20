Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2385018C943
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgCTI4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:56:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:43204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCTI4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 04:56:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9FE4AE5C;
        Fri, 20 Mar 2020 08:56:33 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de
Cc:     arnd@arndb.de, balbi@kernel.org, bhelgaas@google.com,
        bigeasy@linutronix.de, dave@stgolabs.net, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 16/15] rcuwait: Get rid of stale name comment
Date:   Fri, 20 Mar 2020 01:55:24 -0700
Message-Id: <20200320085527.23861-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200318204302.693307984@linutronix.de>
References: <20200318204302.693307984@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'trywake' name was renamed to simply 'wake',
update the comment.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 0b81b26a872a..6cc6cc485d07 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -243,7 +243,7 @@ void rcuwait_wake_up(struct rcuwait *w)
 	/*
 	 * Order condition vs @task, such that everything prior to the load
 	 * of @task is visible. This is the condition as to why the user called
-	 * rcuwait_trywake() in the first place. Pairs with set_current_state()
+	 * rcuwait_wake() in the first place. Pairs with set_current_state()
 	 * barrier (A) in rcuwait_wait_event().
 	 *
 	 *    WAIT                WAKE
-- 
2.16.4

