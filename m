Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C3918C91F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCTIqA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Mar 2020 04:46:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34773 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgCTIqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 04:46:00 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jFDHJ-000826-Ud; Fri, 20 Mar 2020 09:45:17 +0100
Date:   Fri, 20 Mar 2020 09:45:17 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 06/15] rcuwait: Add @state argument to
 rcuwait_wait_event()
Message-ID: <20200320084517.2tqbi2iwjlu6je2b@linutronix.de>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.010461877@linutronix.de>
 <20200320053657.ggvcqsjtdotmrl7p@linux-p48b>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200320053657.ggvcqsjtdotmrl7p@linux-p48b>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-19 22:36:57 [-0700], Davidlohr Bueso wrote:
> On Wed, 18 Mar 2020, Thomas Gleixner wrote:
> 
> Right now I'm not sure what the proper fix should be.

I though that v2 has it fixed with the previous commit (acpi: Remove
header dependency). The kbot just reported that everything is fine.
Let me look…

> Thanks,
> Davidlohr

Sebastian
