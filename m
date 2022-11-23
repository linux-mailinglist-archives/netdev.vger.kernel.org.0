Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD4C634BAC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 01:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiKWA3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 19:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiKWA3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 19:29:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E4174CF0;
        Tue, 22 Nov 2022 16:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63EDBB80DB3;
        Wed, 23 Nov 2022 00:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70AAC433C1;
        Wed, 23 Nov 2022 00:28:58 +0000 (UTC)
Date:   Tue, 22 Nov 2022 19:28:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        LKML <linux-kernel@vger.kernel.org>,
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
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [patch V2 09/17] timers: Rename del_timer_sync() to
 timer_delete_sync()
Message-ID: <20221122192857.57adc15f@gandalf.local.home>
In-Reply-To: <87fseafs6i.ffs@tglx>
References: <20221122171312.191765396@linutronix.de>
        <20221122173648.619071341@linutronix.de>
        <2c42cb1fe1fa4b11ba3c0263d7886b68@AcuMS.aculab.com>
        <20221122174506.08ce49bd@gandalf.local.home>
        <87fseafs6i.ffs@tglx>
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

On Wed, 23 Nov 2022 01:08:53 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> >> To change the colo[u]r of the bikeshed, would it be better to
> >> name the functions timer_start() and timer_stop[_sync]().  
> >
> > I kinda like this color. ;-)  
> 
> Feel free to repaint the series with this new color. My spare cycles are
> exhausted by now.

Yep, it can always be repainted. Let's just get this in now.

-- Steve
