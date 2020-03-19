Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B889F18BEFC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 19:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCSSFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 14:05:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33816 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgCSSFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 14:05:18 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jEzX8-0006yI-P7; Thu, 19 Mar 2020 19:04:42 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id CEAC0103088; Thu, 19 Mar 2020 19:04:36 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting documentation
In-Reply-To: <20200319090426.512510cb@lwn.net>
References: <20200318204302.693307984@linutronix.de> <20200318204408.211530902@linutronix.de> <20200319090426.512510cb@lwn.net>
Date:   Thu, 19 Mar 2020 19:04:36 +0100
Message-ID: <871rpo5ih7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:
> On Wed, 18 Mar 2020 21:43:10 +0100
> Thomas Gleixner <tglx@linutronix.de> wrote:
>> Add initial documentation.
>
> ...time to add a a couple of nits...:)

...time

Is that valid RST?

>> +++ b/Documentation/locking/locktypes.rst
>> @@ -0,0 +1,298 @@
>> +.. _kernel_hacking_locktypes:
>> +
>
> So ... I vaguely remember that some Thomas guy added a document saying we
> should be putting SPDX tags on our files? :)

Never met him or heard about that.

>> +
>> +The preferred solution is to use :c:func:`spin_lock_irq()` or
>> +:c:func:`spin_lock_irqsave()` and their unlock counterparts.
>
> We don't need (and shouldn't use) :c:func: anymore; just saying
> spin_lock_irq() will cause the Right Things to happen.

Good to know. Will fix.

Thanks,

        tglx
