Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB2E5125D3
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiD0W4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbiD0Wy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:54:59 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D6F8CD97;
        Wed, 27 Apr 2022 15:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sBnzQEgOETevrWvoFDe4UXYaoyJvnokumNTnFd8nYd4=; b=C3WoMDzHemUiz3TJonrj4OLB2r
        FSxQF+F2lHHptNuVBTghKMJZClefE6Imxei6ehl090Dy2iIiwWYXrKfz8k6+wORL9DMg3LEbLg3HV
        Yy5IDocQKz78CwwV1x1BjunLLiApngptGwnQE+MM0c5kIHbxgr5QD1BtqzYPoELgJZUScA99Ow0T5
        DgoMAXPJxcpvr2MM73b5S2P6pfeIYXcyYWBlbiqaBO38Mb9qP/Auq8X4+iMlX3NAoRdIHY9DVHKc8
        OvjiTLZuxC2PHt1XEzIKelV5l8TbSCfHnuQVB2KdJOLt6lDAQzFhqrTn+CsXTsATCFcE2SPeUMfAC
        eC7wzCXg==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqVW-000250-IT; Thu, 28 Apr 2022 00:51:39 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 07/30] mips: ip22: Reword PANICED to PANICKED and remove useless header
Date:   Wed, 27 Apr 2022 19:49:01 -0300
Message-Id: <20220427224924.592546-8-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many other place in the kernel prefer the latter, so let's keep
it consistent in MIPS code as well. Also, removes a useless header.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/mips/sgi-ip22/ip22-reset.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index 9028dbbb45dd..8f0861c58080 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -11,7 +11,6 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/pm.h>
 #include <linux/timer.h>
@@ -41,7 +40,7 @@
 static struct timer_list power_timer, blink_timer, debounce_timer;
 static unsigned long blink_timer_timeout;
 
-#define MACHINE_PANICED		1
+#define MACHINE_PANICKED		1
 #define MACHINE_SHUTTING_DOWN	2
 
 static int machine_state;
@@ -112,7 +111,7 @@ static void debounce(struct timer_list *unused)
 		return;
 	}
 
-	if (machine_state & MACHINE_PANICED)
+	if (machine_state & MACHINE_PANICKED)
 		sgimc->cpuctrl0 |= SGIMC_CCTRL0_SYSINIT;
 
 	enable_irq(SGI_PANEL_IRQ);
@@ -120,7 +119,7 @@ static void debounce(struct timer_list *unused)
 
 static inline void power_button(void)
 {
-	if (machine_state & MACHINE_PANICED)
+	if (machine_state & MACHINE_PANICKED)
 		return;
 
 	if ((machine_state & MACHINE_SHUTTING_DOWN) ||
@@ -167,9 +166,9 @@ static irqreturn_t panel_int(int irq, void *dev_id)
 static int panic_event(struct notifier_block *this, unsigned long event,
 		      void *ptr)
 {
-	if (machine_state & MACHINE_PANICED)
+	if (machine_state & MACHINE_PANICKED)
 		return NOTIFY_DONE;
-	machine_state |= MACHINE_PANICED;
+	machine_state |= MACHINE_PANICKED;
 
 	blink_timer_timeout = PANIC_FREQ;
 	blink_timeout(&blink_timer);
-- 
2.36.0

