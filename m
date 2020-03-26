Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BF71935FD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 03:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgCZCkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 22:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgCZCkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 22:40:39 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23B020714;
        Thu, 26 Mar 2020 02:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585190438;
        bh=B/0A+EakHUoxJZZH8Zsz0E0Jrwx9AZ5KMhmmm4tWgAU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=hlvpwsdFfUlivcRX+rgOky3Qzz9W6+h3DS6rDIiFCMTcOVT/UZK7XAVPOw5xlfZmc
         U4gWvMk+HY610Ebp67p0IXeEOlLqhqArE8W38Bn1Pstxz2UMd+wQaxLwVqwPtOGuCa
         LHixNahpVcBZT1S+4QWNrSt9INUA9VsBP8hxz+k8=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id C134335226B0; Wed, 25 Mar 2020 19:40:37 -0700 (PDT)
Date:   Wed, 25 Mar 2020 19:40:37 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH v2] Documentation/locking/locktypes: minor copy editor
 fixes
Message-ID: <20200326024037.GJ19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200323025501.GE3199@paulmck-ThinkPad-P72>
 <87r1xhz6qp.fsf@nanos.tec.linutronix.de>
 <20200325002811.GO19865@paulmck-ThinkPad-P72>
 <87wo78y5yy.fsf@nanos.tec.linutronix.de>
 <ac615f36-0b44-408d-aeab-d76e4241add4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac615f36-0b44-408d-aeab-d76e4241add4@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 09:58:14AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Minor editorial fixes:
> - add some hyphens in multi-word adjectives
> - add some periods for consistency
> - add "'" for possessive CPU's
> - capitalize IRQ when it's an acronym and not part of a function name
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Paul McKenney <paulmck@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sebastian Siewior <bigeasy@linutronix.de>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>

Some nits below, but with or without those suggested changes:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  Documentation/locking/locktypes.rst |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> --- linux-next-20200325.orig/Documentation/locking/locktypes.rst
> +++ linux-next-20200325/Documentation/locking/locktypes.rst
> @@ -84,7 +84,7 @@ rtmutex
>  
>  RT-mutexes are mutexes with support for priority inheritance (PI).
>  
> -PI has limitations on non PREEMPT_RT enabled kernels due to preemption and
> +PI has limitations on non-PREEMPT_RT-enabled kernels due to preemption and

Or just drop the " enabled".

>  interrupt disabled sections.
>  
>  PI clearly cannot preempt preemption-disabled or interrupt-disabled
> @@ -150,7 +150,7 @@ kernel configuration including PREEMPT_R
>  
>  raw_spinlock_t is a strict spinning lock implementation in all kernels,
>  including PREEMPT_RT kernels.  Use raw_spinlock_t only in real critical
> -core code, low level interrupt handling and places where disabling
> +core code, low-level interrupt handling and places where disabling
>  preemption or interrupts is required, for example, to safely access
>  hardware state.  raw_spinlock_t can sometimes also be used when the
>  critical section is tiny, thus avoiding RT-mutex overhead.
> @@ -160,20 +160,20 @@ spinlock_t
>  
>  The semantics of spinlock_t change with the state of PREEMPT_RT.
>  
> -On a non PREEMPT_RT enabled kernel spinlock_t is mapped to raw_spinlock_t
> +On a non-PREEMPT_RT-enabled kernel spinlock_t is mapped to raw_spinlock_t

Ditto.

>  and has exactly the same semantics.
>  
>  spinlock_t and PREEMPT_RT
>  -------------------------
>  
> -On a PREEMPT_RT enabled kernel spinlock_t is mapped to a separate
> +On a PREEMPT_RT-enabled kernel spinlock_t is mapped to a separate

And here as well.

>  implementation based on rt_mutex which changes the semantics:
>  
> - - Preemption is not disabled
> + - Preemption is not disabled.
>  
>   - The hard interrupt related suffixes for spin_lock / spin_unlock
> -   operations (_irq, _irqsave / _irqrestore) do not affect the CPUs
> -   interrupt disabled state
> +   operations (_irq, _irqsave / _irqrestore) do not affect the CPU's
> +   interrupt disabled state.
>  
>   - The soft interrupt related suffix (_bh()) still disables softirq
>     handlers.
> @@ -279,7 +279,7 @@ fully preemptible context.  Instead, use
>  spin_lock_irqsave() and their unlock counterparts.  In cases where the
>  interrupt disabling and locking must remain separate, PREEMPT_RT offers a
>  local_lock mechanism.  Acquiring the local_lock pins the task to a CPU,
> -allowing things like per-CPU irq-disabled locks to be acquired.  However,
> +allowing things like per-CPU IRQ-disabled locks to be acquired.  However,

Quite a bit of text in the kernel uses "irq", lower case.  Another
option is to spell out "interrupt".

>  this approach should be used only where absolutely necessary.
>  
>  
> 
