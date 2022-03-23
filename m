Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB98B4E4C61
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 06:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbiCWFo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 01:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiCWFo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 01:44:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D339FF4;
        Tue, 22 Mar 2022 22:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65C4861005;
        Wed, 23 Mar 2022 05:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920F9C340E8;
        Wed, 23 Mar 2022 05:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648014177;
        bh=oVYHNw62hSMNdVg5hD9UB13JLJULBnj8IoZ38rPtinU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s4Lkbsk1m1hffCQrS0J/wB2E6SRuGlqVI4hRHcI0Yd+jdd5d4iQld7HL4g1UBl+/X
         5lnK1+W5DOLR9/P6ywlYZmyK/EqVZieZijatKiwtMsBFnMwU19LNcFGSzoth/Vq3R9
         YM/mB6cfi3B+dx0WDqqzkx5FgamaubgUw96qs0r/sMGGODki5GOWkAnN0pMt1mjhY5
         pma016kEeXGQ1vLsK/E7zaXFBAYFng3KN94PChRHJCOY/Fa9YQch37C+8xgL1xbtNW
         XYeWem4xdeyew+WYM4vdG0q/Rd6ws4uz0qKX0Y3VvNZzpugKnmumrfghAPsk/7EOUq
         ffEekYOw2vItg==
Date:   Wed, 23 Mar 2022 14:42:48 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v13 bpf-next 0/1] fprobe: Introduce fprobe function
 entry/exit probe
Message-Id: <20220323144248.9bccc3051bae40a85981c14e@kernel.org>
In-Reply-To: <164800288611.1716332.7053663723617614668.stgit@devnote2>
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The title is not updated. It should be;

rethook: x86: Add rethook x86 porting (drived from "fprobe: Introduce fprobe function entry/exit probe" series)

Thank you,

On Wed, 23 Mar 2022 11:34:46 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Hi,
> 
> Here is the 13th version of rethook x86 port. This is developed for a part
> of fprobe series [1] for hooking function return. But since I forgot to send
> it to arch maintainers, that caused conflict with IBT and SLS mitigation series.
> Now I picked the x86 rethook part and send it to x86 maintainers to be
> reviewed.
> 
> [1] https://lore.kernel.org/all/164735281449.1084943.12438881786173547153.stgit@devnote2/T/#u
> 
> Note that this patch is still for the bpf-next since the rethook itself
> is on the bpf-next tree. But since this also uses the ANNOTATE_NOENDBR
> macro which has been introduced by IBT/ENDBR patch, to build this series
> you need to merge the tip/master branch with the bpf-next.
> (hopefully, it is rebased soon)
> 
> The fprobe itself is for providing the function entry/exit probe
> with multiple probe point. The rethook is a sub-feature to hook the
> function return as same as kretprobe does. Eventually, I would like
> to replace the kretprobe's trampoline with this rethook.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (1):
>       rethook: x86: Add rethook x86 implementation
> 
> 
>  arch/x86/Kconfig                 |    1 
>  arch/x86/include/asm/unwind.h    |    8 ++-
>  arch/x86/kernel/Makefile         |    1 
>  arch/x86/kernel/kprobes/common.h |    1 
>  arch/x86/kernel/rethook.c        |  121 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 131 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kernel/rethook.c
> 
> --
> Masami Hiramatsu (Linaro) <mhiramat@kernel.org>


-- 
Masami Hiramatsu <mhiramat@kernel.org>
