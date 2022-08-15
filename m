Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB506593217
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiHOPjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiHOPjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:39:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862AB13F69;
        Mon, 15 Aug 2022 08:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4161FB80F96;
        Mon, 15 Aug 2022 15:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB0DC433D6;
        Mon, 15 Aug 2022 15:39:14 +0000 (UTC)
Date:   Mon, 15 Aug 2022 11:39:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <thoiland@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
Message-ID: <20220815113921.5b3305f5@gandalf.local.home>
In-Reply-To: <20220815111658.58d75672@gandalf.local.home>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
        <20191211123017.13212-3-bjorn.topel@gmail.com>
        <20220815101303.79ace3f8@gandalf.local.home>
        <CAADnVQLhHm-gxJXTbWxJN0fFGW_dyVV+5D-JahVA1Wrj2cGu7g@mail.gmail.com>
        <20220815111658.58d75672@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 11:16:58 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > It sounds that you've invented nop5 and kernel's ability
> > to replace nop5 with a jump or call.  
> 
> Actually I did invent it.
> 
>    https://lore.kernel.org/lkml/20080210072109.GR4100@elte.hu/
> 
> 
> I'm the one that introduced the code to convert mcount into the 5 byte nop,
> and did the research and development to make it work at run time. I had one
> hiccup along the way that caused the e1000e network card breakage.
> 
> The "daemon" approach was horrible, and then I created the recordmcount.pl
> perl script to accomplish the same thing at compile time.

I guess you were not paying attention to my talk at the Kernel Recipes I
invited you to in 2019. The talk I gave was the history of how fentry came
about.

  https://kernel-recipes.org/en/2019/talks/ftrace-where-modifying-a-running-kernel-all-started/

 ;-)

-- Steve
