Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0E463406A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiKVPik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbiKVPif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:38:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0552E1DD;
        Tue, 22 Nov 2022 07:38:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91557B81BE7;
        Tue, 22 Nov 2022 15:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF2CC433D6;
        Tue, 22 Nov 2022 15:38:28 +0000 (UTC)
Date:   Tue, 22 Nov 2022 10:38:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Message-ID: <20221122103826.319644d0@gandalf.local.home>
In-Reply-To: <878rk3ggqa.ffs@tglx>
References: <20221115195802.415956561@linutronix.de>
        <20221115202117.323694948@linutronix.de>
        <20221121154358.36856ca6@gandalf.local.home>
        <878rk3ggqa.ffs@tglx>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Nov 2022 16:18:37 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> >>   *
> >> - * The function returns whether it has deactivated a pending timer or not.
> >> - * (ie. del_timer() of an inactive timer returns 0, del_timer() of an
> >> - * active timer returns 1.)
> >> + * Contrary to del_timer_sync() this function does not wait for an
> >> + * eventually running timer callback on a different CPU and it neither  
> >
> > I'm a little confused with the "eventually running timer". Does that simply
> > mean one that is about to run next (that is, it doesn't handle race
> > conditions and the timer is in the process of starting), but will still
> > deactivate one that has not been started and the timer code for that CPU
> > hasn't triggered yet?  
> 
> Let me try again.
> 
>   The function only deactivates a pending timer, but contrary to
>   del_timer_sync() it does not take into account whether the timers
>   callback function is concurrently executed on a different CPU or not.
> 
> Does that make more sense?

Yes, much better. Thanks!

-- Steve
