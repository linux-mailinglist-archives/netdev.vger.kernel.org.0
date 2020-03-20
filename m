Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0A18C960
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCTI7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:59:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:44528 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCTI7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 04:59:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3474BAF0E;
        Fri, 20 Mar 2020 08:59:30 +0000 (UTC)
Date:   Fri, 20 Mar 2020 01:58:26 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
Message-ID: <20200320085826.qj5om2ztldc6nfv4@linux-p48b>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.010461877@linutronix.de>
 <20200320053657.ggvcqsjtdotmrl7p@linux-p48b>
 <20200320084517.2tqbi2iwjlu6je2b@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200320084517.2tqbi2iwjlu6je2b@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Mar 2020, Sebastian Andrzej Siewior wrote:

>I though that v2 has it fixed with the previous commit (acpi: Remove
>header dependency). The kbot just reported that everything is fine.
>Let me look???

Nah my bad, that build did not have the full series applied :)

Sorry for the noise.

Thanks,
Davidlohr
