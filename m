Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEDA4E36C0
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiCVCiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbiCVCiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:38:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0004DDF6A;
        Mon, 21 Mar 2022 19:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B97ACB81B2A;
        Tue, 22 Mar 2022 02:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C7DC340E8;
        Tue, 22 Mar 2022 02:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647916606;
        bh=H2U/BMwBsbk4jfUZgJSssTVvNeLCmKRIuki0dtsxEJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LD0mmBPGGcmYLHc2zdAZwSvK+uwqVzLTEgQU8CzJ0cKjxMVsjgi98LYP6LyRiDVFz
         vG6yoY3dyuiEV81m10c0iWsANnPFAsC7xlxV/s1pq+CyDvqM7U9cS38XU65bwcUpRM
         FBvbKM4V9Jzk076hunuQy9uJk0GbRUp8XX/29ros5wAeh12xnJKfA8PJf6dUh0x4EE
         SOnV6mirN2Lsb0DENfrdisTaCg/VOWYYypV7gcSaVlrT2nHWSD1jLqa3HoayakNX5I
         +nJ4oULTOsY7pWnIeM1RDIFypxqfu9VKgV6Kn6EdZ3N+TmnRR2peKEd2Di1oRg9DPt
         75HogcuFPVLhw==
Date:   Tue, 22 Mar 2022 11:36:41 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf-next 2022-03-21
Message-Id: <20220322113641.763885257f741ac5c0cb2c06@kernel.org>
In-Reply-To: <CAADnVQKreLtGkfAVXxwLGUVKobqYhBS5r+GtNa6Oc8BUzYa92Q@mail.gmail.com>
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
        <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
        <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com>
        <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
        <CAADnVQKreLtGkfAVXxwLGUVKobqYhBS5r+GtNa6Oc8BUzYa92Q@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus and Alexei,

At first, sorry about this issue. I missed to Cc'ed to arch maintainers.

On Mon, 21 Mar 2022 17:31:28 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Mon, Mar 21, 2022 at 4:59 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Mon, Mar 21, 2022 at 4:11 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > Did you look at the code?
> > > In particular:
> > > https://lore.kernel.org/bpf/164735286243.1084943.7477055110527046644.stgit@devnote2/
> > >
> > > it's a copy paste of arch/x86/kernel/kprobes/core.c
> > >
> > > How is it "bad architecture code" ?
> >
> > It's "bad architecture code" because the architecture maintainers have
> > made changes to check ENDBR in the meantime.
> >
> > So it used to be perfectly fine. It's not any longer - and the
> > architecture maintainers were clearly never actually cc'd on the
> > changes, so they didn't find out until much too late.

Let me retry porting fprobe on top of ENDBR things and confirm with
arch maintainers.

> 
> Not denying that missing cc was an issue.
> 
> We can drop just arch patches:
>       rethook: x86: Add rethook x86 implementation
>       arm64: rethook: Add arm64 rethook implementation
>       powerpc: Add rethook support
>       ARM: rethook: Add rethook arm implementation
> 
> or everything including Jiri's work on top of it.
> Which would be a massive 27 patches.
> 
> We'd prefer the former, of course.
> Later during the merge window we can add a single
> 'rethook: x86' patch that takes endbr into account,
> so that multi-kprobe feature will work on x86.
> For the next merge window we can add other archs.
> Would that work?

BTW, As far as I can see the ENDBR things, the major issue on fprobe
is that the ftrace'ed ip address will be different from the symbol
address (even) on x86. That must be ensured to work before merge.
Let me check it on Linus's tree at first.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
