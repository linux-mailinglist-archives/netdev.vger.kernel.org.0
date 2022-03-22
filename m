Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDFE4E3833
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 06:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiCVFHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 01:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbiCVFHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 01:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56587634F;
        Mon, 21 Mar 2022 22:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C09CB81B2B;
        Tue, 22 Mar 2022 05:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A1EC340EC;
        Tue, 22 Mar 2022 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647925543;
        bh=Tz/5lG8aBHGvmRR6A54wkwnMHzC6WpwBtQ5akoyWEFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lSs7NdwWA0q8kjjbBh34PfYMrRyF07sRfuL96MNhW7yTnvTb4y8bZmfYbJyhgtX/t
         CW1/8djaD6JqUfxQJYFhTpT0xfZGKnjQeTfKrXgNd4dDXbH9DuBJKK3QUImA5m+VYC
         w9Xpvy1FJ0JSsJiu1eNClBWa/KqxsJ0IOPR6iz4Jm5chm5L3QodXGorZcjxmtIYPLW
         8be6+hgMsarjcr0upm21m1pqesKakPTuuj2Wzd/XHDW0MiBjf7ZKWwSfN1dsgMevzF
         JzlLYk3kD4EmnG5xHgEXNsrjxhoNjB/IsCsEeQiRNExFmW2xejS8UOmUlECqYmlFZk
         zlKebKYI8ymXw==
Date:   Tue, 22 Mar 2022 14:05:37 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf-next 2022-03-21
Message-Id: <20220322140537.d3f3fa3600d3b80c4f226e7c@kernel.org>
In-Reply-To: <CAADnVQ+HEeBXm0qXdnxn1of-dPr7THcVZxb9Adud0t9epVsWKQ@mail.gmail.com>
References: <20220321224608.55798-1-alexei.starovoitov@gmail.com>
        <CAHk-=wheGrBxOfMpWhQg1iswCKYig8vADnFVsA4oFWTY9NU5jA@mail.gmail.com>
        <CAADnVQK=JsytH_OtT6Q6fnijkTyv7NANV2902woQ6XT-fwWXQA@mail.gmail.com>
        <CAHk-=wi0fNH+FS-ng2Nvq2p1Jbfn+-G1AsK-XY7MD4gTJZg5ZA@mail.gmail.com>
        <CAADnVQKreLtGkfAVXxwLGUVKobqYhBS5r+GtNa6Oc8BUzYa92Q@mail.gmail.com>
        <20220322113641.763885257f741ac5c0cb2c06@kernel.org>
        <CAADnVQ+HEeBXm0qXdnxn1of-dPr7THcVZxb9Adud0t9epVsWKQ@mail.gmail.com>
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

On Mon, 21 Mar 2022 21:35:55 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Mon, Mar 21, 2022 at 7:36 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > Hi Linus and Alexei,
> >
> > At first, sorry about this issue. I missed to Cc'ed to arch maintainers.
> >
> > On Mon, 21 Mar 2022 17:31:28 -0700
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > > On Mon, Mar 21, 2022 at 4:59 PM Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > On Mon, Mar 21, 2022 at 4:11 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > Did you look at the code?
> > > > > In particular:
> > > > > https://lore.kernel.org/bpf/164735286243.1084943.7477055110527046644.stgit@devnote2/
> > > > >
> > > > > it's a copy paste of arch/x86/kernel/kprobes/core.c
> > > > >
> > > > > How is it "bad architecture code" ?
> > > >
> > > > It's "bad architecture code" because the architecture maintainers have
> > > > made changes to check ENDBR in the meantime.
> > > >
> > > > So it used to be perfectly fine. It's not any longer - and the
> > > > architecture maintainers were clearly never actually cc'd on the
> > > > changes, so they didn't find out until much too late.
> >
> > Let me retry porting fprobe on top of ENDBR things and confirm with
> > arch maintainers.
> 
> Just look at linux-next.
> objtool warning is the only issue.

Actually, there are conflicts with arm tree and Rust tree too.
I found I missed the objtool annotation patch on IBT series and fixed it.

> 
> > >
> > > Not denying that missing cc was an issue.
> > >
> > > We can drop just arch patches:
> > >       rethook: x86: Add rethook x86 implementation
> > >       arm64: rethook: Add arm64 rethook implementation
> > >       powerpc: Add rethook support
> > >       ARM: rethook: Add rethook arm implementation
> > >
> > > or everything including Jiri's work on top of it.
> > > Which would be a massive 27 patches.
> > >
> > > We'd prefer the former, of course.
> > > Later during the merge window we can add a single
> > > 'rethook: x86' patch that takes endbr into account,
> > > so that multi-kprobe feature will work on x86.
> > > For the next merge window we can add other archs.
> > > Would that work?
> >
> > BTW, As far as I can see the ENDBR things, the major issue on fprobe
> > is that the ftrace'ed ip address will be different from the symbol
> > address (even) on x86. That must be ensured to work before merge.
> > Let me check it on Linus's tree at first.
> 
> That's not an issue. Peter tweaked ftrace logic and fprobe plugs
> into that.
> The fprobe/multi-kprobe works fine in linux-next.

Yeah, I think fprobe should work because it uses 
ftrace_location_range(func-entry, func-end) for non-x86 arch.

> 
> bpf selftest for multi kprobe needs this hack:
> diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi.c
> b/tools/testing/selftests/bpf/progs/kprobe_multi.c
> index af27d2c6fce8..530a64e2996a 100644
> --- a/tools/testing/selftests/bpf/progs/kprobe_multi.c
> +++ b/tools/testing/selftests/bpf/progs/kprobe_multi.c
> @@ -45,7 +45,7 @@ static void kprobe_multi_check(void *ctx, bool is_return)
>         __u64 addr = bpf_get_func_ip(ctx);
> 
>  #define SET(__var, __addr, __cookie) ({                        \
> -       if (((const void *) addr == __addr) &&          \
> +       if (((const void *) addr == __addr + 4) &&              \
>              (!test_cookie || (cookie == __cookie)))    \

Hmm, this is an ugly hack... You need to use actual ftrace addr, instead of
symbol addr. With IBT series, you can use ftrace_location(symbol-addr) to
get the ftrace-addr. (e.g. addr == ftrace_location(__addr) should work)

> 
> to pass when both CONFIG_FPROBE=y and CONFIG_X86_KERNEL_IBT=y.
> The test is too strict. It didn't account for the possibility of endbr.
> 
> So I'm inclined to drop only 4 arch patches instead of the whole thing.

OK, but it is hard to understand how it works without knowing rethook itself.
I would like to send whole v13 patch series to arch maintainers.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
