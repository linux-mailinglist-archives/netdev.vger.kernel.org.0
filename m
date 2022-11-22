Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC04634A31
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiKVWpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiKVWpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:45:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF53BEB5E;
        Tue, 22 Nov 2022 14:45:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F10EB81DEC;
        Tue, 22 Nov 2022 22:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C55C433B5;
        Tue, 22 Nov 2022 22:45:07 +0000 (UTC)
Date:   Tue, 22 Nov 2022 17:45:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Thomas Gleixner' <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Julia Lawall" <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [patch V2 09/17] timers: Rename del_timer_sync() to
 timer_delete_sync()
Message-ID: <20221122174506.08ce49bd@gandalf.local.home>
In-Reply-To: <2c42cb1fe1fa4b11ba3c0263d7886b68@AcuMS.aculab.com>
References: <20221122171312.191765396@linutronix.de>
        <20221122173648.619071341@linutronix.de>
        <2c42cb1fe1fa4b11ba3c0263d7886b68@AcuMS.aculab.com>
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

On Tue, 22 Nov 2022 22:23:11 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > Rename del_timer_sync() to timer_delete_sync() and provide del_timer_sync()
> > as a wrapper. Document that del_timer_sync() is not for new code.  
> 
> To change the colo[u]r of the bikeshed, would it be better to
> name the functions timer_start() and timer_stop[_sync]().

I kinda like this color. ;-)

-- Steve
