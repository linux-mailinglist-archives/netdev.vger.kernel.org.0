Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0D21B544A
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgDWFlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWFlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:41:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEABDC03C1AB;
        Wed, 22 Apr 2020 22:41:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f11so265431ljp.1;
        Wed, 22 Apr 2020 22:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aXDMJwohGZ6IvlYLhXvvNxx9EMYFi0QPAE1VRsQo3s4=;
        b=vGqzrstDstBRVZZuR3+ZJyJfyD10+fvvyE9iTKu/ltvyy7tz0BIDxSOKCg0jUh2iDR
         IXxg4XtJRSpFZx/3vYg+66n1vjbHtZpJ1LxsM+AV58rIKuvIqAvDUKVK/hqxQzcwhh7f
         7CsWpJtHxVNdAR/Bw8ldVurlJXGoaUyLXltH280sdYadVQK07HH8UhpNMZgaqn94mUmO
         94bSbH96ROD+oOkrMx9ihxfn1UMMZyF4NVdLRyLJPxkHfTWTWMUk6NTr3JUt3EGv1pew
         WPiaWCnFIpMUndjGGtlPzlUtjxxPfew8z3NZe4B3wNgEgAC6cMM2dWSQB/ZPY29WiOAH
         JRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aXDMJwohGZ6IvlYLhXvvNxx9EMYFi0QPAE1VRsQo3s4=;
        b=n3PHiC/wcwOrMZTMmElwaKnpKDX6pji5TmTNbmmipDyxBEzh1WHtrnOgqzbWKrLo7z
         5NYVz7PFt1L8ddNNb0rs50oRgd4z9rn/3XXPvXsXNXVegpxQRsosEmVMRdms8x8Rg8Fg
         1kha76BupDzcqLVIdIZjqnLGs+xOmmrXVQPZ5uf7BFTqF9lMsxIgJy1JOqp7hxUQuJ1z
         wOHSbdNjYqBUMQfUpklfKytm8BPm5zsL1jclGHC0GWvFIiLM47q83NerJROCUQ2kEikX
         asehmm0MRlPUwb23kGQxlYtTw+sIk/7ctDP+AXCeqwZ4T6O5Ut4lDn4b6ZUeiVKsiYL3
         IuZA==
X-Gm-Message-State: AGi0PuZZUNeshmq2xLTfjPviU62rpV6d/PrCAYq/kWqdbEXjkDXZjAMn
        TJz8oHyb9zbvM/sfZ9a2tMlxIacYVwzwkU3CJMo4TLBC
X-Google-Smtp-Source: APiQypL3h38I9jnXuIjvZNl6wwj0VhrGpoU99cAXN2ofBBFDItCCED8sltfHFljl9q0cZ/4sszL0b5pyHCJ1gU7SfQY=
X-Received: by 2002:a2e:a169:: with SMTP id u9mr1379442ljl.144.1587620471405;
 Wed, 22 Apr 2020 22:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200421051040.4087681-1-andriin@fb.com>
In-Reply-To: <20200421051040.4087681-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Apr 2020 22:41:00 -0700
Message-ID: <CAADnVQLcSVHxXz_7jNedf3ys7DLsfJU2_RA0cUEGZQLh6tsRXg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: make verifier log more relevant by default
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 10:11 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> To make BPF verifier verbose log more releavant and easier to use to debug
> verification failures, "pop" parts of log that were successfully verified.
> This has effect of leaving only verifier logs that correspond to code branches
> that lead to verification failure, which in practice should result in much
> shorter and more relevant verifier log dumps. This behavior is made the
> default behavior and can be overriden to do exhaustive logging by specifying
> BPF_LOG_LEVEL2 log level.
>
> Using BPF_LOG_LEVEL2 to disable this behavior is not ideal, because in some
> cases it's good to have BPF_LOG_LEVEL2 per-instruction register dump
> verbosity, but still have only relevant verifier branches logged. But for this
> patch, I didn't want to add any new flags. It might be worth-while to just
> rethink how BPF verifier logging is performed and requested and streamline it
> a bit. But this trimming of successfully verified branches seems to be useful
> and a good default behavior.
>
> To test this, I modified runqslower slightly to introduce read of
> uninitialized stack variable. Log (**truncated in the middle** to save many
> lines out of this commit message) BEFORE this change:
>
> ; int handle__sched_switch(u64 *ctx)
> 0: (bf) r6 = r1
> ; struct task_struct *prev = (struct task_struct *)ctx[1];
> 1: (79) r1 = *(u64 *)(r6 +8)
> func 'sched_switch' arg1 has btf_id 151 type STRUCT 'task_struct'
> 2: (b7) r2 = 0
> ; struct event event = {};
> 3: (7b) *(u64 *)(r10 -24) = r2
> last_idx 3 first_idx 0
> regs=4 stack=0 before 2: (b7) r2 = 0
> 4: (7b) *(u64 *)(r10 -32) = r2
> 5: (7b) *(u64 *)(r10 -40) = r2
> 6: (7b) *(u64 *)(r10 -48) = r2
> ; if (prev->state == TASK_RUNNING)
>
> [ ... instructions from insn #7 through #50 are cut out ... ]
>
> 51: (b7) r2 = 16
> 52: (85) call bpf_get_current_comm#16
> last_idx 52 first_idx 42
> regs=4 stack=0 before 51: (b7) r2 = 16
> ; bpf_perf_event_output(ctx, &events, BPF_F_CURRENT_CPU,
> 53: (bf) r1 = r6
> 54: (18) r2 = 0xffff8881f3868800
> 56: (18) r3 = 0xffffffff
> 58: (bf) r4 = r7
> 59: (b7) r5 = 32
> 60: (85) call bpf_perf_event_output#25
> last_idx 60 first_idx 53
> regs=20 stack=0 before 59: (b7) r5 = 32
> 61: (bf) r2 = r10
> ; event.pid = pid;
> 62: (07) r2 += -16
> ; bpf_map_delete_elem(&start, &pid);
> 63: (18) r1 = 0xffff8881f3868000
> 65: (85) call bpf_map_delete_elem#3
> ; }
> 66: (b7) r0 = 0
> 67: (95) exit
>
> from 44 to 66: safe
>
> from 34 to 66: safe
>
> from 11 to 28: R1_w=inv0 R2_w=inv0 R6_w=ctx(id=0,off=0,imm=0) R10=fp0 fp-8=mmmm???? fp-24_w=00000000 fp-32_w=00000000 fp-40_w=00000000 fp-48_w=00000000
> ; bpf_map_update_elem(&start, &pid, &ts, 0);
> 28: (bf) r2 = r10
> ;
> 29: (07) r2 += -16
> ; tsp = bpf_map_lookup_elem(&start, &pid);
> 30: (18) r1 = 0xffff8881f3868000
> 32: (85) call bpf_map_lookup_elem#1
> invalid indirect read from stack off -16+0 size 4
> processed 65 insns (limit 1000000) max_states_per_insn 1 total_states 5 peak_states 5 mark_read 4
>
> Notice how there is a successful code path from instruction 0 through 67, few
> successfully verified jumps (44->66, 34->66), and only after that 11->28 jump
> plus error on instruction #32.
>
> AFTER this change (full verifier log, **no truncation**):
>
> ; int handle__sched_switch(u64 *ctx)
> 0: (bf) r6 = r1
> ; struct task_struct *prev = (struct task_struct *)ctx[1];
> 1: (79) r1 = *(u64 *)(r6 +8)
> func 'sched_switch' arg1 has btf_id 151 type STRUCT 'task_struct'
> 2: (b7) r2 = 0
> ; struct event event = {};
> 3: (7b) *(u64 *)(r10 -24) = r2
> last_idx 3 first_idx 0
> regs=4 stack=0 before 2: (b7) r2 = 0
> 4: (7b) *(u64 *)(r10 -32) = r2
> 5: (7b) *(u64 *)(r10 -40) = r2
> 6: (7b) *(u64 *)(r10 -48) = r2
> ; if (prev->state == TASK_RUNNING)
> 7: (79) r2 = *(u64 *)(r1 +16)
> ; if (prev->state == TASK_RUNNING)
> 8: (55) if r2 != 0x0 goto pc+19
>  R1_w=ptr_task_struct(id=0,off=0,imm=0) R2_w=inv0 R6_w=ctx(id=0,off=0,imm=0) R10=fp0 fp-24_w=00000000 fp-32_w=00000000 fp-40_w=00000000 fp-48_w=00000000
> ; trace_enqueue(prev->tgid, prev->pid);
> 9: (61) r1 = *(u32 *)(r1 +1184)
> 10: (63) *(u32 *)(r10 -4) = r1
> ; if (!pid || (targ_pid && targ_pid != pid))
> 11: (15) if r1 == 0x0 goto pc+16
>
> from 11 to 28: R1_w=inv0 R2_w=inv0 R6_w=ctx(id=0,off=0,imm=0) R10=fp0 fp-8=mmmm???? fp-24_w=00000000 fp-32_w=00000000 fp-40_w=00000000 fp-48_w=00000000
> ; bpf_map_update_elem(&start, &pid, &ts, 0);
> 28: (bf) r2 = r10
> ;
> 29: (07) r2 += -16
> ; tsp = bpf_map_lookup_elem(&start, &pid);
> 30: (18) r1 = 0xffff8881db3ce800
> 32: (85) call bpf_map_lookup_elem#1
> invalid indirect read from stack off -16+0 size 4
> processed 65 insns (limit 1000000) max_states_per_insn 1 total_states 5 peak_states 5 mark_read 4
>
> Notice how in this case, there are 0-11 instructions + jump from 11 to
> 28 is recorded + 28-32 instructions with error on insn #32.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

This is great idea!

But two test_verifier tests failed:
#722/p precise: ST insn causing spi > allocated_stack FAIL
Unexpected verifier log in successful load!
EXP: 5: (2d) if r4 > r0 goto pc+0
RES:
0: (bf) r3 = r10
1: (55) if r3 != 0x7b goto pc+0

from 1 to 2: safe
processed 8 insns (limit 1000000) max_states_per_insn 0 total_states 4
peak_states 4 mark_read 1

Please fix them up.
