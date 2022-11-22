Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADCD633FF5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbiKVPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiKVPSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:18:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEFC697EF;
        Tue, 22 Nov 2022 07:18:40 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669130318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zKbYB4/x4Eioa7NTJUmecxu616udhot1tUi1AdzIwgg=;
        b=Ey2IoXawMVtLO5Oz/+AojWtt7Y1O6buWlGKuq2VPYazDeXZbmqwmiwCVUWLojKqA8lddS3
        Vom/NA5oRvZCJhKAvZFTtk7bnke16rUjp4gkbgj1yljYcFgAkgnF5w6gQCmL+YKAm6Mrci
        Ev09bKcwBCLrD85tFVZfLqCteK++Ydlp/jSNEcK3zLhnQvEiaYozZYkm+O9pz5RrszB/Q6
        3j9meXZS5KnAd24TvtZcNlDXtsPbobEsmxVGHwnv/UeG/jstji3fqbxhQQQDfwCx1p0nrl
        J2esgdPB/9O7su2vHr4T5nG9p8wXd6uEuVk1YwnxyH55SwcBMMNwFZwQUZsp/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669130318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zKbYB4/x4Eioa7NTJUmecxu616udhot1tUi1AdzIwgg=;
        b=ICE1QM57jId/IFgN6qEk+MfqfeLm8OOmL9ViEHwpjhMU2eO4RrRFphenE7lb1cEJa8mvTG
        Ln7mObid0wx01WDw==
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [patch 06/15] timers: Update kernel-doc for various functions
In-Reply-To: <20221121154358.36856ca6@gandalf.local.home>
References: <20221115195802.415956561@linutronix.de>
 <20221115202117.323694948@linutronix.de>
 <20221121154358.36856ca6@gandalf.local.home>
Date:   Tue, 22 Nov 2022 16:18:37 +0100
Message-ID: <878rk3ggqa.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21 2022 at 15:43, Steven Rostedt wrote:
> On Tue, 15 Nov 2022 21:28:43 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
>>  EXPORT_SYMBOL(mod_timer_pending);
>>  
>>  /**
>> - * mod_timer - modify a timer's timeout
>> - * @timer: the timer to be modified
>> - * @expires: new timeout in jiffies
>> + * mod_timer - Modify a timer's timeout
>> + * @timer:	The timer to be modified
>> + * @expires:	New timeout in jiffies
>>   *
>>   * mod_timer() is a more efficient way to update the expire field of an
>
> BTW, one can ask, "more efficient" than what?
>
> If you are updating this, perhaps swap it around a little.
>
>  * mod_timer(timer, expires) is equivalent to:
>  *
>  *     del_timer(timer); timer->expires = expires; add_timer(timer);
>  *
>  * mod_timer() is a more efficient way to update the expire field of an
>  * active timer (if the timer is inactive it will be activated)
>  *
>
> As seeing the equivalent first and then seeing "more efficient" makes a bit
> more sense.

Point taken.

>>   *
>> - * The timer's ->expires, ->function fields must be set prior calling this
>> - * function.
>> + * The @timer->expires and @timer->function fields must be set prior
>> + * calling this function.
>
>  "set prior to calling this function"

Fixed.

>>   *
>> - * The function returns whether it has deactivated a pending timer or not.
>> - * (ie. del_timer() of an inactive timer returns 0, del_timer() of an
>> - * active timer returns 1.)
>> + * Contrary to del_timer_sync() this function does not wait for an
>> + * eventually running timer callback on a different CPU and it neither
>
> I'm a little confused with the "eventually running timer". Does that simply
> mean one that is about to run next (that is, it doesn't handle race
> conditions and the timer is in the process of starting), but will still
> deactivate one that has not been started and the timer code for that CPU
> hasn't triggered yet?

Let me try again.

  The function only deactivates a pending timer, but contrary to
  del_timer_sync() it does not take into account whether the timers
  callback function is concurrently executed on a different CPU or not.

Does that make more sense?

>> + * prevents rearming of the timer.  If @timer can be rearmed concurrently
>> + * then the return value of this function is meaningless.
>> + *
>> + * Return:
>> + * * %0 - The timer was not pending
>> + * * %1 - The timer was pending and deactivated
>>   */
>>  int del_timer(struct timer_list *timer)
>>  {
>> @@ -1270,10 +1284,16 @@ EXPORT_SYMBOL(del_timer);
>>  
>>  /**
>>   * try_to_del_timer_sync - Try to deactivate a timer
>> - * @timer: timer to delete
>> + * @timer:	Timer to deactivate
>>   *
>> - * This function tries to deactivate a timer. Upon successful (ret >= 0)
>> - * exit the timer is not queued and the handler is not running on any CPU.
>> + * This function cannot guarantee that the timer cannot be rearmed right
>> + * after dropping the base lock. That needs to be prevented by the calling
>> + * code if necessary.
>
>
> Hmm, you seemed to have deleted the description of what the function does
> and replaced it with only what it cannot do.

Ooops.
