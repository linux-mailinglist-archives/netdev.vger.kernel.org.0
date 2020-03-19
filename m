Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B01418B144
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 11:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCSK0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 06:26:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60268 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgCSK0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 06:26:52 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jEsNR-0005K1-NA; Thu, 19 Mar 2020 11:26:13 +0100
Date:   Thu, 19 Mar 2020 11:26:13 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch V2 07/15] powerpc/ps3: Convert half completion to rcuwait
Message-ID: <20200319102613.hbwax7zrrvgcde4x@linutronix.de>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.102694393@linutronix.de>
 <20200319100459.GA18506@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319100459.GA18506@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-19 03:04:59 [-0700], Christoph Hellwig wrote:
> But I wonder how alive the whole PS3 support is to start with..

OtherOS can only be used on "old" PS3 which do not have have their
firmware upgraded past version 3.21, released April 1, 2010 [0].
It was not possible to install OtherOS on PS3-slim and I don't remember
if it was a successor or a budget version (but it had lower power
consumption as per my memory).
*I* remember from back then that a few universities bought quite a few
of them and used them as a computation cluster. However, whatever broke
over the last 10 years is broken.

[0] https://en.wikipedia.org/wiki/OtherOS

Sebastian
