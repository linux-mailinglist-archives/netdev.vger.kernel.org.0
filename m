Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AD8EFFD0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 15:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbfKEOcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 09:32:03 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40011 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfKEOcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 09:32:03 -0500
Received: by mail-pf1-f195.google.com with SMTP id r4so15555805pfl.7;
        Tue, 05 Nov 2019 06:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x1ZY+pRuLvj8PjCeylb49ZokNTiENjUK443/DNBfF84=;
        b=iN8FBBuGC6xd9sMBFu7GTzC72weRBViDl3bsEGR4CTmAPj/dc7jqf+h0og9aZKluUc
         oAoroySxQELZ4aUd8u/UROV7u+ncvkHnYkyaUdVIeafXRMy3aSIvjdwwR/w9myfYr4hg
         27gioQjmXIFkkA14Kn5SgJFZN5T4ymuYWP2727PvblfH8/1MvKqGn8fIEoXwRmKsn6lH
         e4jYzt0UM4+bMtMEgMC2e8GByCLOKhwvWad5SQVSBIfZeP06X8ipUfjyxo+b1JTPnl3x
         Gs68rUXmAq8MlZFFI3cUtTkDr/6SVQaVfK54KiJ4QYcHulK04kwFfGcpfjvy8/etevZy
         CXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x1ZY+pRuLvj8PjCeylb49ZokNTiENjUK443/DNBfF84=;
        b=FP06kH/A/tFyJniSayUmH49WqHibzrbBe2Pp7wOUAaiVYA1yQNeXpEB9DbgACxOCGU
         LafnYAG5BJiYqIMcqpmVD46ysFL44KCr7Sz/fc/vHOOTN2p29tWyrKJ7gAOvlR4VdJEN
         OMNKs21yF3BGHO9gy9+K4pppu/L/K9siwmY+7bDVf2j24JEKiQu6NGVLhm8oSYsESQGB
         j/iyfSW3Oc06qAEKOyC0E6AKY7FUEKIIlxwa90hVxr41TfztufNzVdcxnX2acHQgutMW
         ryiyrCHjpbBzCJj+jBMAk3l20UhJ62I8ilczlwPdKgj7k+a//bNTFQ9lo12a80AjfEF6
         SDnQ==
X-Gm-Message-State: APjAAAUU76XZaRYGl4E0hdnqG+IlziDgF15kVVMMbCzm8Cs+q6xCZ22Z
        eeXtSo9Rf5eSg/S70g+hhZo=
X-Google-Smtp-Source: APXvYqzNOq1oXIxpMrBOJEVGfQS1+teAlyJYM6LCrm8oCZHXUDmNqkoyUNwiBVbDCP9hZBXf7cTvpw==
X-Received: by 2002:a63:a34e:: with SMTP id v14mr120527pgn.58.1572964321247;
        Tue, 05 Nov 2019 06:32:01 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::770a])
        by smtp.gmail.com with ESMTPSA id e1sm18505868pgv.82.2019.11.05.06.31.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 06:31:58 -0800 (PST)
Date:   Tue, 5 Nov 2019 06:31:56 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, peterz@infradead.org,
        rostedt@goodmis.org, x86@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/7] Introduce BPF trampoline
Message-ID: <20191105143154.umojkotnvcx4yeuq@ast-mbp.dhcp.thefacebook.com>
References: <20191102220025.2475981-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191102220025.2475981-1-ast@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 02, 2019 at 03:00:18PM -0700, Alexei Starovoitov wrote:
> Introduce BPF trampoline that works as a bridge between kernel functions and
> BPF programs. The first use case is fentry/fexit BPF programs that are roughly
> equivalent to kprobe/kretprobe. Unlike k[ret]probe there is practically zero
> overhead to call a set of BPF programs before or after kernel function. In the
> future patches networking use cases will be explored. For example: BPF
> trampoline can be used to call XDP programs from drivers with direct calls or
> wrapping BPF program into another BPF program.
> 
> The patch set depends on register_ftrace_direct() API. It's not upstream yet
> and available in [1]. The first patch is a hack to workaround this dependency.
> The idea is to land this set via bpf-next tree and land register_ftrace_direct
> via Steven's ftrace tree. Then during the merge window revert the first patch.
> Steven,
> do you think it's workable?
> As an alternative we can route register_ftrace_direct patches via bpf-next ?
> 
> Peter's static_call patches [2] are solving the issue of indirect call overhead
> for large class of kernel use cases, but unfortunately don't help calling into
> a set of BPF programs.  BPF trampoline's first goal is to translate kernel
> calling convention into BPF calling convention. The second goal is to call a
> set of programs efficiently. In the future we can replace BPF_PROG_RUN_ARRAY
> with BPF trampoline variant. Another future work is to add support for static_key,
> static_jmp and static_call inside generated BPF trampoline.
> 
> Please see patch 3 for details.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git/commit/?h=ftrace/direct&id=3ac423d902727884a389699fd7294c0e2e94b29c

Steven,
look slike your branch hasn't been updated in 13 days.
Are you still planning to fix the bugs and send it in for the merge window?
I cannot afford to wait a full release, since I have my own follow for
XDP/networking based on this and other folks are building their stuff on top of
BPF trampoline too. So I'm thinking for v2 I will switch to using text_poke()
and add appropriate guard checks, so it will be safe out of the box without
ftrace dependency. If register_ftrace_direct() indeed comes in soon I'll
switch to that and will make bpf trampoline to co-operate with ftrace.
text_poke approach will make it such that what ever comes first to trace the
fentry (either bpf trampoline or ftrace) will grab the nop and the other system
will not be able to attach. That's safe and correct, but certainly not nice
long term. So the fix will be needed. The key point that switching to text_poke
will remove the register_ftrace_direct() dependency, unblock bpf developers and
will give you time to land your stuff at your pace.

