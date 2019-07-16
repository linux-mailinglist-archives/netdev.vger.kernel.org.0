Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB96AF1A
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388584AbfGPSsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:48:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbfGPSsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:48:39 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIfcQY073922;
        Tue, 16 Jul 2019 14:47:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsj86da8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:47:00 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GIhGPC084720;
        Tue, 16 Jul 2019 14:47:00 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsj86da76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:46:59 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6GIiLPa019184;
        Tue, 16 Jul 2019 18:46:57 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 2tq6x6s8f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 18:46:57 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GIku0V48496986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:46:56 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B604AB2073;
        Tue, 16 Jul 2019 18:46:56 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F539B2064;
        Tue, 16 Jul 2019 18:46:56 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:46:56 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 6A72B16C905B; Tue, 16 Jul 2019 11:46:56 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:46:56 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 0/9] Harden list_for_each_entry_rcu() and family
Message-ID: <20190716184656.GK14271@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190715143705.117908-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160229
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 10:36:56AM -0400, Joel Fernandes (Google) wrote:
> Hi,
> This series aims to provide lockdep checking to RCU list macros for additional
> kernel hardening.
> 
> RCU has a number of primitives for "consumption" of an RCU protected pointer.
> Most of the time, these consumers make sure that such accesses are under a RCU
> reader-section (such as rcu_dereference{,sched,bh} or under a lock, such as
> with rcu_dereference_protected()).
> 
> However, there are other ways to consume RCU pointers, such as by
> list_for_each_entry_rcu or hlist_for_each_enry_rcu. Unlike the rcu_dereference
> family, these consumers do no lockdep checking at all. And with the growing
> number of RCU list uses (1000+), it is possible for bugs to creep in and go
> unnoticed which lockdep checks can catch.
> 
> Since RCU consolidation efforts last year, the different traditional RCU
> flavors (preempt, bh, sched) are all consolidated. In other words, any of these
> flavors can cause a reader section to occur and all of them must cease before
> the reader section is considered to be unlocked. Thanks to this, we can
> generically check if we are in an RCU reader. This is what patch 1 does. Note
> that the list_for_each_entry_rcu and family are different from the
> rcu_dereference family in that, there is no _bh or _sched version of this
> macro. They are used under many different RCU reader flavors, and also SRCU.
> Patch 1 adds a new internal function rcu_read_lock_any_held() which checks
> if any reader section is active at all, when these macros are called. If no
> reader section exists, then the optional fourth argument to
> list_for_each_entry_rcu() can be a lockdep expression which is evaluated
> (similar to how rcu_dereference_check() works). If no lockdep expression is
> passed, and we are not in a reader, then a splat occurs. Just take off the
> lockdep expression after applying the patches, by using the following diff and
> see what happens:
> 
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -55,7 +55,7 @@ static void list_add_sorted(struct pci_mmcfg_region *new)
>         struct pci_mmcfg_region *cfg;
> 
>         /* keep list sorted by segment and starting bus number */
> -       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list, pci_mmcfg_lock_held()) {
> +       list_for_each_entry_rcu(cfg, &pci_mmcfg_list, list) {
> 
> 
> The optional argument trick to list_for_each_entry_rcu() can also be used in
> the future to possibly remove rcu_dereference_{,bh,sched}_protected() API and
> we can pass an optional lockdep expression to rcu_dereference() itself. Thus
> eliminating 3 more RCU APIs.
> 
> Note that some list macro wrappers already do their own lockdep checking in the
> caller side. These can be eliminated in favor of the built-in lockdep checking
> in the list macro that this series adds. For example, workqueue code has a
> assert_rcu_or_wq_mutex() function which is called in for_each_wq().  This
> series replaces that in favor of the built-in check.
> 
> Also in the future, we can extend these checks to list_entry_rcu() and other
> list macros as well, if needed.
> 
> Please note that I have kept this option default-disabled under a new config:
> CONFIG_PROVE_RCU_LIST. This is so that until all users are converted to pass
> the optional argument, we should keep the check disabled. There are about a
> 1000 or so users and it is not possible to pass in the optional lockdep
> expression in a single series since it is done on a case-by-case basis. I did
> convert a few users in this series itself.

I do like the optional argument as opposed to the traditional practice
of expanding the RCU API!  Good stuff!!!

Please resend incorporating the acks and the changes from feedback.
I will hold off on any patches not yet having their maintainer's ack,
but it is OK to include them in v4.  (I will just avoid applying them.)

The documentation patch needs a bit of wordsmithing, but I can do that.
Feel free to take another pass on it if you wish, though.

							Thanx, Paul

> v2->v3: Simplified rcu-sync logic after rebase (Paul)
> 	Added check for bh_map (Paul)
> 	Refactored out more of the common code (Joel)
> 	Added Oleg ack to rcu-sync patch.
> 
> v1->v2: Have assert_rcu_or_wq_mutex deleted (Daniel Jordan)
> 	Simplify rcu_read_lock_any_held()   (Peter Zijlstra)
> 	Simplified rcu-sync logic	    (Oleg Nesterov)
> 	Updated documentation and rculist comments.
> 	Added GregKH ack.
> 
> RFC->v1: 
> 	Simplify list checking macro (Rasmus Villemoes)
> 
> Joel Fernandes (Google) (9):
> rcu/update: Remove useless check for debug_locks (v1)
> rcu: Add support for consolidated-RCU reader checking (v3)
> rcu/sync: Remove custom check for reader-section (v2)
> ipv4: add lockdep condition to fix for_each_entry (v1)
> driver/core: Convert to use built-in RCU list checking (v1)
> workqueue: Convert for_each_wq to use built-in list check (v2)
> x86/pci: Pass lockdep condition to pcm_mmcfg_list iterator (v1)
> acpi: Use built-in RCU list checking for acpi_ioremaps list (v1)
> doc: Update documentation about list_for_each_entry_rcu (v1)
> 
> Documentation/RCU/lockdep.txt   | 15 ++++++++---
> Documentation/RCU/whatisRCU.txt |  9 ++++++-
> arch/x86/pci/mmconfig-shared.c  |  5 ++--
> drivers/acpi/osl.c              |  6 +++--
> drivers/base/base.h             |  1 +
> drivers/base/core.c             | 10 +++++++
> drivers/base/power/runtime.c    | 15 +++++++----
> include/linux/rcu_sync.h        |  4 +--
> include/linux/rculist.h         | 28 +++++++++++++++----
> include/linux/rcupdate.h        |  7 +++++
> kernel/rcu/Kconfig.debug        | 11 ++++++++
> kernel/rcu/update.c             | 48 ++++++++++++++++++---------------
> kernel/workqueue.c              | 10 ++-----
> net/ipv4/fib_frontend.c         |  3 ++-
> 14 files changed, 119 insertions(+), 53 deletions(-)
> 
> --
> 2.22.0.510.g264f2c817a-goog
> 
