Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A5918C456
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgCTApY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:45:24 -0400
Received: from ozlabs.org ([203.11.71.1]:46035 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCTApY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 20:45:24 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48k4n82YYsz9sPF;
        Fri, 20 Mar 2020 11:45:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1584665121;
        bh=W+Z34vvZKks0HjWcw4Ddw/+LfmZqr1ApEjeY4QXdx4k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=iC9emPAuS206WtkabWO9eiUH5LztrJbBox0vIOO3kG0SPAnzRJgryz3vVCJbwNVHg
         ChJHL3XBrOvTGVMVOfltoDKGUtZFjkxVnXFTzQ1TYd6mypfOAF2KMXB3DUTC7uSKTh
         oF4RTptfsRx2oy1FfM0kULYxXYx8zNnnnAUk08dO+rJphnaXy06EWZx71jVHnDP127
         l5uCxuHEqQ850rzJ6nQGBNnVW7w5K2Yf8/sIlxW2i0QNGxfOMb5MTgdjv4/CTROVBe
         Iwn7NXnhB6fPJK4bYVeFjWm2DLK9TZs1BTFTRTJ2s4T76HvHWDDPHqlOiIIkN1syjf
         /ka3XQZiH7IEA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-usb@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        linux-pci@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>,
        Geoff Levand <geoff@infradead.org>
Subject: Re: [patch V2 07/15] powerpc/ps3: Convert half completion to rcuwait
In-Reply-To: <20200319102613.hbwax7zrrvgcde4x@linutronix.de>
References: <20200318204302.693307984@linutronix.de> <20200318204408.102694393@linutronix.de> <20200319100459.GA18506@infradead.org> <20200319102613.hbwax7zrrvgcde4x@linutronix.de>
Date:   Fri, 20 Mar 2020 11:45:16 +1100
Message-ID: <87lfnvdfc3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
> On 2020-03-19 03:04:59 [-0700], Christoph Hellwig wrote:
>> But I wonder how alive the whole PS3 support is to start with..
>
> OtherOS can only be used on "old" PS3 which do not have have their
> firmware upgraded past version 3.21, released April 1, 2010 [0].
> It was not possible to install OtherOS on PS3-slim and I don't remember
> if it was a successor or a budget version (but it had lower power
> consumption as per my memory).
> *I* remember from back then that a few universities bought quite a few
> of them and used them as a computation cluster. However, whatever broke
> over the last 10 years is broken.
>
> [0] https://en.wikipedia.org/wiki/OtherOS

Last time I asked on the list there were still a handful of users.

And I had a patch submitted from a user as recently as last October, so
it still has some life.

cheers
