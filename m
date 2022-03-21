Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877E54E342C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiCUXTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiCUXSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:18:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729945C35A;
        Mon, 21 Mar 2022 16:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78056B81A66;
        Mon, 21 Mar 2022 22:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D08C340E8;
        Mon, 21 Mar 2022 22:55:04 +0000 (UTC)
Date:   Mon, 21 Mar 2022 18:55:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        linux-toolchains <linux-toolchains@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: build warnings after merge of the tip tree
Message-ID: <20220321185503.0dcb5d9c@gandalf.local.home>
In-Reply-To: <CAADnVQKg7GPVpg-22B2Ym5HFVoGaquoFZDEkRwTDgXzm+L8OOw@mail.gmail.com>
References: <20220321140327.777f9554@canb.auug.org.au>
        <Yjh11UjDZogc3foM@hirez.programming.kicks-ass.net>
        <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net>
        <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
        <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net>
        <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
        <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net>
        <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
        <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net>
        <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
        <20220322090541.7d06c8cb@canb.auug.org.au>
        <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
        <20220322094526.436ca4f7@elm.ozlabs.ibm.com>
        <CAADnVQKg7GPVpg-22B2Ym5HFVoGaquoFZDEkRwTDgXzm+L8OOw@mail.gmail.com>
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

On Mon, 21 Mar 2022 15:50:17 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > Peter has other concerns, please read the thread and consider them.  
> 
> Masami is an expert in kprobe. He copy pasted a bit of kprobe logic
> to make it into 'multi kprobe' (he calls it fprobe).
> I believe he knows what he's doing.
> Steven reviewed and tested that set.
> We've tested it as well and don't have any correctness or api concerns.

I tested it from a ftrace perspective, not an IBT or other work being done
in the x86 world.

I'm fine with the work being done in kernel/tracing/ but it still requires
the arch maintainer's acks for anything in arch/. I was under the
impression that the arch specific code was Cc'ing the arch maintainers
(which I always do when I touch their code). But I missed that they were
not. That's my fault, I should have caught that.

-- Steve
