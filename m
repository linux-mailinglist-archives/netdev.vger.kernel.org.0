Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49BB634073
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiKVPlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiKVPlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:41:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026EC70A2F;
        Tue, 22 Nov 2022 07:41:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C7E6176D;
        Tue, 22 Nov 2022 15:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D20EC433D7;
        Tue, 22 Nov 2022 15:41:26 +0000 (UTC)
Date:   Tue, 22 Nov 2022 10:41:24 -0500
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
Message-ID: <20221122104124.2f04c7be@gandalf.local.home>
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

> >> + * This function cannot guarantee that the timer cannot be rearmed right
> >> + * after dropping the base lock. That needs to be prevented by the calling
> >> + * code if necessary.  
> >

Also, re-reading it again, I wounder if we can avoid the double use of
"cannot", in "cannot guarantee that the timer cannot".

What about:

    This function does not prevent the timer from being rearmed right after
    dropping the base lock.

?

-- Steve
