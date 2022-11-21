Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0644632805
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 16:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiKUP1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 10:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiKUP1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 10:27:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB35BA44E;
        Mon, 21 Nov 2022 07:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77AD5612E7;
        Mon, 21 Nov 2022 15:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D8FC433C1;
        Mon, 21 Nov 2022 15:26:59 +0000 (UTC)
Date:   Mon, 21 Nov 2022 10:26:58 -0500
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch 00/15] timers: Provide timer_shutdown[_sync]()
Message-ID: <20221121102658.12cd3d17@gandalf.local.home>
In-Reply-To: <87mt8kibkb.ffs@tglx>
References: <20221115195802.415956561@linutronix.de>
        <87mt8kibkb.ffs@tglx>
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

On Mon, 21 Nov 2022 16:15:00 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> > As Steven is short of cycles, I made some spare cycles available and
> > reworked the patch series to follow the new semantics and plugged the races
> > which were discovered during review.  
> 
> Any opinions on this pile or should I just declare it's perfect and
> queue it for 6.2?

I have time cut out of today to go over it. Thanks Thomas,

-- Steve
