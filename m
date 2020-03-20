Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812D918CA17
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 10:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgCTJUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 05:20:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34890 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgCTJUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 05:20:02 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jFDoh-0000M7-2n; Fri, 20 Mar 2020 10:19:47 +0100
Date:   Fri, 20 Mar 2020 10:19:47 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     tglx@linutronix.de, arnd@arndb.de, balbi@kernel.org,
        bhelgaas@google.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 19/15] sched/swait: Reword some of the main description
Message-ID: <20200320091947.qmj2nsjri3xq6vif@linutronix.de>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-4-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320085527.23861-4-dave@stgolabs.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-20 01:55:27 [-0700], Davidlohr Bueso wrote:
> diff --git a/include/linux/swait.h b/include/linux/swait.h
> index 73e06e9986d4..6e5b5d0e64fd 100644
> --- a/include/linux/swait.h
> +++ b/include/linux/swait.h
> @@ -39,7 +26,7 @@
>   *    sleeper state.
>   *
>   *  - the !exclusive mode; because that leads to O(n) wakeups, everything is
> - *    exclusive.
> + *    exclusive. As such swait_wake_up_one will only ever awake _one_ waiter.
                            swake_up_one()

>   *  - custom wake callback functions; because you cannot give any guarantees
>   *    about random code. This also allows swait to be used in RT, such that

Sebastian
