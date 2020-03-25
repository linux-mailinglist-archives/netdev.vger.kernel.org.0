Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05039192ECC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgCYQ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:58:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgCYQ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=nzNtddxyHToIfzwzcRpU+rkJvFePaVcVMvDxhJ0zIm8=; b=Ny0TO9lEhbmvUL2PtdSbl/e3Gm
        dLHrOkD5v8ewIwjLPXGarl7V5+K4iXFzHb2IblMXtRLy0e1xYPfEYd/TNMgeQMms4qdMS3GnsSBzh
        MG4FkMj0CmZIJdF594Ere7tUatW2cpHFY1FN56RNDDvW3fQmt0gVnStPqemN2Xr9H/2N8GLHIr5Wg
        jCmOaOYFpQoZFzr/LNFj0CHFygyAwaMnjmIJLMM/2ZdRTd590pAvjPj/dIFmu4oG/94o0FTc9L0qs
        q8JUj6IqIVy73yedpWdJ2Myuil5rim24S7yVdJXA5SxDwBhAKySclpEAQs+h4mmF+uJG1N1o3ZfNM
        CTBQSfOQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH9M9-0002V3-KT; Wed, 25 Mar 2020 16:58:17 +0000
Subject: [PATCH v2] Documentation/locking/locktypes: minor copy editor fixes
To:     Thomas Gleixner <tglx@linutronix.de>, paulmck@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Logan Gunthorpe <logang@deltatee.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org,
        Brian Cain <bcain@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        linuxppc-dev@lists.ozlabs.org, Davidlohr Bueso <dbueso@suse.de>
References: <20200323025501.GE3199@paulmck-ThinkPad-P72>
 <87r1xhz6qp.fsf@nanos.tec.linutronix.de>
 <20200325002811.GO19865@paulmck-ThinkPad-P72>
 <87wo78y5yy.fsf@nanos.tec.linutronix.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ac615f36-0b44-408d-aeab-d76e4241add4@infradead.org>
Date:   Wed, 25 Mar 2020 09:58:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87wo78y5yy.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Minor editorial fixes:
- add some hyphens in multi-word adjectives
- add some periods for consistency
- add "'" for possessive CPU's
- capitalize IRQ when it's an acronym and not part of a function name

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Paul McKenney <paulmck@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 Documentation/locking/locktypes.rst |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-next-20200325.orig/Documentation/locking/locktypes.rst
+++ linux-next-20200325/Documentation/locking/locktypes.rst
@@ -84,7 +84,7 @@ rtmutex
 
 RT-mutexes are mutexes with support for priority inheritance (PI).
 
-PI has limitations on non PREEMPT_RT enabled kernels due to preemption and
+PI has limitations on non-PREEMPT_RT-enabled kernels due to preemption and
 interrupt disabled sections.
 
 PI clearly cannot preempt preemption-disabled or interrupt-disabled
@@ -150,7 +150,7 @@ kernel configuration including PREEMPT_R
 
 raw_spinlock_t is a strict spinning lock implementation in all kernels,
 including PREEMPT_RT kernels.  Use raw_spinlock_t only in real critical
-core code, low level interrupt handling and places where disabling
+core code, low-level interrupt handling and places where disabling
 preemption or interrupts is required, for example, to safely access
 hardware state.  raw_spinlock_t can sometimes also be used when the
 critical section is tiny, thus avoiding RT-mutex overhead.
@@ -160,20 +160,20 @@ spinlock_t
 
 The semantics of spinlock_t change with the state of PREEMPT_RT.
 
-On a non PREEMPT_RT enabled kernel spinlock_t is mapped to raw_spinlock_t
+On a non-PREEMPT_RT-enabled kernel spinlock_t is mapped to raw_spinlock_t
 and has exactly the same semantics.
 
 spinlock_t and PREEMPT_RT
 -------------------------
 
-On a PREEMPT_RT enabled kernel spinlock_t is mapped to a separate
+On a PREEMPT_RT-enabled kernel spinlock_t is mapped to a separate
 implementation based on rt_mutex which changes the semantics:
 
- - Preemption is not disabled
+ - Preemption is not disabled.
 
  - The hard interrupt related suffixes for spin_lock / spin_unlock
-   operations (_irq, _irqsave / _irqrestore) do not affect the CPUs
-   interrupt disabled state
+   operations (_irq, _irqsave / _irqrestore) do not affect the CPU's
+   interrupt disabled state.
 
  - The soft interrupt related suffix (_bh()) still disables softirq
    handlers.
@@ -279,7 +279,7 @@ fully preemptible context.  Instead, use
 spin_lock_irqsave() and their unlock counterparts.  In cases where the
 interrupt disabling and locking must remain separate, PREEMPT_RT offers a
 local_lock mechanism.  Acquiring the local_lock pins the task to a CPU,
-allowing things like per-CPU irq-disabled locks to be acquired.  However,
+allowing things like per-CPU IRQ-disabled locks to be acquired.  However,
 this approach should be used only where absolutely necessary.
 
 

