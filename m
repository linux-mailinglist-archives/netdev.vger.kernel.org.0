Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2936A6341B2
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbiKVQm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbiKVQm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:42:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682821C90E;
        Tue, 22 Nov 2022 08:42:52 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669135370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R1WhU15sqpsop/ukaaUc7gI5zuOdhbblJAEG6t8OCMQ=;
        b=y6naOLGFvz9Sl3hNhfg5l9yNrEiEy+p4FonO2MrfG9k7XMR08lGTOsywj43cUtfU0LnE3C
        1z/dlfqsTuwhJDUYV5Q+J/KdvjrK6UPj7tDDVmMFWFSn9y6ZhtMbMaAT3fD3UYtxbGEzcN
        HVk2ZFRG41+JrBHQEVWn1bPZgn85dwcK/Q/rEdmreRuaBFdUZZmHOZltTc7E3WscOdNfp8
        AECFNaB0pRofNbCIP5kg6Uyjkr9KjBN5oJRwW83/kpQt+3Y3SbMz5R+6Nrlhh/q/8TiZnQ
        kC6BG2KxPeHrNPWoSN6Rq4pRpA6R/DKRUDhRwuGjBVzzQ6E3LBs/n5Xmh9NH7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669135370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R1WhU15sqpsop/ukaaUc7gI5zuOdhbblJAEG6t8OCMQ=;
        b=VNftf6BMJ9EYZyF531LLRIvUW59W4X9URD41xna7lxGvN+xS73oK0xrfl8mQUKKEY5TluR
        IkFKYFgJhDIv84CQ==
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
In-Reply-To: <20221122104124.2f04c7be@gandalf.local.home>
References: <20221115195802.415956561@linutronix.de>
 <20221115202117.323694948@linutronix.de>
 <20221121154358.36856ca6@gandalf.local.home> <878rk3ggqa.ffs@tglx>
 <20221122104124.2f04c7be@gandalf.local.home>
Date:   Tue, 22 Nov 2022 17:42:49 +0100
Message-ID: <8735abgcty.ffs@tglx>
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

On Tue, Nov 22 2022 at 10:41, Steven Rostedt wrote:

> On Tue, 22 Nov 2022 16:18:37 +0100
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> >> + * This function cannot guarantee that the timer cannot be rearmed right
>> >> + * after dropping the base lock. That needs to be prevented by the calling
>> >> + * code if necessary.  
>> >
>
> Also, re-reading it again, I wounder if we can avoid the double use of
> "cannot", in "cannot guarantee that the timer cannot".
>
> What about:
>
>     This function does not prevent the timer from being rearmed right after
>     dropping the base lock.

Funny enough I noticed myself when I copied this sentence into the code
and did exactly the same change :)
