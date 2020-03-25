Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9108B192EB5
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCYQys convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 12:54:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48640 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbgCYQyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:54:47 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jH9IM-00061w-Lf; Wed, 25 Mar 2020 17:54:22 +0100
Date:   Wed, 25 Mar 2020 17:54:22 +0100
From:   Sebastian Siewior <bigeasy@linutronix.de>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>,
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
Subject: Re: Documentation/locking/locktypes: Further clarifications and
 wordsmithing
Message-ID: <20200325165422.hfxzkxcj3jhqcstr@linutronix.de>
References: <20200323025501.GE3199@paulmck-ThinkPad-P72>
 <87r1xhz6qp.fsf@nanos.tec.linutronix.de>
 <20200325002811.GO19865@paulmck-ThinkPad-P72>
 <87wo78y5yy.fsf@nanos.tec.linutronix.de>
 <20200325160212.oavrni7gmzudnczv@linutronix.de>
 <20200325163919.GU19865@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200325163919.GU19865@paulmck-ThinkPad-P72>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-25 09:39:19 [-0700], Paul E. McKenney wrote:
> > > --- a/Documentation/locking/locktypes.rst
> > > +++ b/Documentation/locking/locktypes.rst
> > …
> > > +rw_semaphore
> > > +============
> > > +
> > > +rw_semaphore is a multiple readers and single writer lock mechanism.
> > > +
> > > +On non-PREEMPT_RT kernels the implementation is fair, thus preventing
> > > +writer starvation.
> > > +
> > > +rw_semaphore complies by default with the strict owner semantics, but there
> > > +exist special-purpose interfaces that allow non-owner release for readers.
> > > +These work independent of the kernel configuration.
> > 
> > This reads funny, could be my English. "This works independent …" maybe?
> 
> The "These" refers to "interfaces", which is plural, so "These" rather
> than "This".  But yes, it is a bit awkward, because you have to skip
> back past "readers", "release", and "non-owner" to find the implied
> subject of that last sentence.
> 
> So how about this instead, making the implied subject explicit?
> 
> rw_semaphore complies by default with the strict owner semantics, but there
> exist special-purpose interfaces that allow non-owner release for readers.
> These interfaces work independent of the kernel configuration.

Yes, perfect. Thank you.

> 							Thanx, Paul

Sebastian
