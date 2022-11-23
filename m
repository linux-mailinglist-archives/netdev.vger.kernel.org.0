Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C383635A4D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237641AbiKWKjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbiKWKjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:39:07 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11663EA126;
        Wed, 23 Nov 2022 02:23:21 -0800 (PST)
Date:   Wed, 23 Nov 2022 11:23:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669198999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pCNbF4SuwWPa50jU17KKs3SR5/H3opMA3Pjr70EBkKY=;
        b=RyyL/kUIfO69KG2ebYhWMU9yRzcCB+OUddjvlP3+8Lzk0x91j1CrFxIfylL+JBIFA2ipQw
        QC8EvK1gXVHT/9Il0lnsrSaLjRdbmu0ucJy8bKtAzwK1p8nRBSuBR8lqHTQdwB/jCnDpI5
        0id74nNRF4/PgxZ7EX8MjHVLiRxoFDVXlQKPEm3Cm23yXfBEHNwD1L1lpPzHR2v6GMGWGC
        1QxLmgBWeZNgEApWLRK77ix/rfcPyEvn42LJZe4FDFwEbej3k8ZoGNpV7U84x1VHvICZXJ
        dPDamAj8glb6roQxZOorLCefZSAeu3lUQg9GIFtJ9nNn38rEDL9rNOC20dR6xA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669198999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pCNbF4SuwWPa50jU17KKs3SR5/H3opMA3Pjr70EBkKY=;
        b=Q5HeSF3VEAhUCLuKNJi+gLlPLLnK9ykcngKERUFjUseshebHXLmdxSj87dJvh4qANAFMr8
        JMuniKC4+2QG8BAQ==
From:   Anna-Maria Behnsen <anna-maria@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch V2 07/17] timers: Update kernel-doc for various
 functions
In-Reply-To: <20221122173648.501792201@linutronix.de>
Message-ID: <c3e79ef-a9c4-bee8-cf4-1bea9ad85920@linutronix.de>
References: <20221122171312.191765396@linutronix.de> <20221122173648.501792201@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Nov 2022, Thomas Gleixner wrote:

> The kernel-doc of timer related functions is partially uncomprehensible
> word salad. Rewrite it to make it useful.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> ---
> V2: Refined comments (Steven)
> ---
>  kernel/time/timer.c |  148 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 88 insertions(+), 60 deletions(-)
> 
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1200,11 +1212,12 @@ void add_timer(struct timer_list *timer)
>  EXPORT_SYMBOL(add_timer);
>  
>  /**
> - * add_timer_on - start a timer on a particular CPU
> - * @timer: the timer to be added
> - * @cpu: the CPU to start it on
> + * add_timer_on - Start a timer on a particular CPU
> + * @timer:	The timer to be started
> + * @cpu:	The CPU to start it on
>   *
> - * This is not very scalable on SMP. Double adds are not possible.
> + * This can only operate on an inactive timer. Attempts to invoke this on
> + * an active timer are rejected with a warning.

This is also true for add_timer(). Is it possible to add this to
add_timer() function description and just referencing to add_timer()
function description in add_timer_on()? They behave the same, only
difference is the CPU where the timer is enqueued.

>   */
>  void add_timer_on(struct timer_list *timer, int cpu)
>  {
> @@ -1240,15 +1253,18 @@ void add_timer_on(struct timer_list *tim
>  EXPORT_SYMBOL_GPL(add_timer_on);
>  
>  /**
> - * del_timer - deactivate a timer.
> - * @timer: the timer to be deactivated
> - *
> - * del_timer() deactivates a timer - this works on both active and inactive
> - * timers.
> + * del_timer - Deactivate a timer.
> + * @timer:	The timer to be deactivated
>   *
> - * The function returns whether it has deactivated a pending timer or not.
> - * (ie. del_timer() of an inactive timer returns 0, del_timer() of an
> - * active timer returns 1.)
> + * The function only deactivates a pending timer, but contrary to
> + * del_timer_sync() it does not take into account whether the timers

timer's callback function or timer callback function (if the latter one is
used, please replace it in description for del_timer_sync() as well).

> + * callback function is concurrently executed on a different CPU or not.
> + * It neither prevents rearming of the timer.  If @timer can be rearmed

NIT                                             ^ two whitespaces

> + * concurrently then the return value of this function is meaningless.
> + *
> + * Return:
> + * * %0 - The timer was not pending
> + * * %1 - The timer was pending and deactivated
>   */
>  int del_timer(struct timer_list *timer)
>  {

Thanks,

	Anna-Maria
