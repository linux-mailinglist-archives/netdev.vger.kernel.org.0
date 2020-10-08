Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EF32876FF
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730946AbgJHPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730650AbgJHPSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:18:54 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C259C061755;
        Thu,  8 Oct 2020 08:18:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d20so6517428iop.10;
        Thu, 08 Oct 2020 08:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=alGG3XuJL9GyniNRzmL5hrCDmsY/C9fr3t35SMib7RQ=;
        b=ALH9BCOidDBZkvBQEaIa3ISoyeO46WUyzNVDSn7pSLYS90tQl79cXcw03/HfGKB1a/
         nrwMtrc+f3zzChKw+xAuzJ2GHpiLAMVK192uboB95PU9Ezgj48XuwuCDxJGb9iPAC8b5
         mqaWLD0l1A1qE+CUFSL98tE/YepJimouLmzgEh6K9+RANVg15q3alQpbUstnUU4W+Hkf
         DHjhlFA9HU72NIqLkCnYC/ofADehsTg2EStAc93ObDUCMIye997zQr9GyPx5eGicDTLl
         Zpr5XjlK+XfJqNtPtlevUaxmM5HYejD8aNqe3rBay8f2dTLC7nleNehjKHypTcK78+Py
         BT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=alGG3XuJL9GyniNRzmL5hrCDmsY/C9fr3t35SMib7RQ=;
        b=Az7tGhcpvLKXZVACkTckgaL41P2Qd4eFEem/OCxpg5fGXLKnnAxNmMss34PL7n5KkE
         AAUvWdLVozjm7d6qm8sANu5qzYX9EjsFbVqjmh1zLtrro20RlX7VgU/xMPn/8bWoHc+1
         LYaQeICE9eU18P1hoMzk6Y4oodc9+o8Gzyz7WCLnNadMeZxwWAgugS38wPFfe6VdSe/G
         eRdRmB0odrtHdMCL/dnhtDXvfdASR8o1vMliqOVUmzT+NF3Vjb8sh8h75UC6pOMGjgCR
         L6N/dRlUyDt1TlkF/Xb77vUKipSIHTAzToG070d66rEp5FTTakoFL6OiHxMlnrYVl/y4
         dNsQ==
X-Gm-Message-State: AOAM53331iYpgu6FrshGl3c7CPXi48Jdyh554/v3mYGg83PBCvkJP3SS
        btrXzAUYf8MGYhoR50kqGEMr+ZpKZeB9Ew==
X-Google-Smtp-Source: ABdhPJzzQYnV6UW5Fw1LUtf6pmahV4ZmioSr2XnePUZP3cZe71kbEvCWMmkaIi8d4uaThdVEf3l7zw==
X-Received: by 2002:a05:6638:1381:: with SMTP id w1mr7448069jad.34.1602170333818;
        Thu, 08 Oct 2020 08:18:53 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z19sm2410090ioz.4.2020.10.08.08.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:18:53 -0700 (PDT)
Date:   Thu, 08 Oct 2020 08:18:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5f7f2dd685aa6_2007208e9@john-XPS-13-9370.notmuch>
In-Reply-To: <20201008014553.tbw7gioqnsg6zowb@ast-mbp>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
 <5f7e52ce81308_1a83120890@john-XPS-13-9370.notmuch>
 <5f7e556c1e610_1a831208d2@john-XPS-13-9370.notmuch>
 <20201008014553.tbw7gioqnsg6zowb@ast-mbp>
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Oct 07, 2020 at 04:55:24PM -0700, John Fastabend wrote:
> > John Fastabend wrote:
> > > Alexei Starovoitov wrote:
> > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > 
> > > > The llvm register allocator may use two different registers representing the
> > > > same virtual register. In such case the following pattern can be observed:
> > > > 1047: (bf) r9 = r6
> > > > 1048: (a5) if r6 < 0x1000 goto pc+1
> > > > 1050: ...
> > > > 1051: (a5) if r9 < 0x2 goto pc+66
> > > > 1052: ...
> > > > 1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */
> > > > 
> > > > In order to track this information without backtracking allocate ID
> > > > for scalars in a similar way as it's done for find_good_pkt_pointers().
> > > > 
> > > > When the verifier encounters r9 = r6 assignment it will assign the same ID
> > > > to both registers. Later if either register range is narrowed via conditional
> > > > jump propagate the register state into the other register.
> > > > 
> > > > Clear register ID in adjust_reg_min_max_vals() for any alu instruction.
> > > 
> > > Do we also need to clear the register ID on reg0 for CALL ops into a
> > > helper?
> 
> Thank you for asking all those questions. Much appreciate it!
> 
> > > 
> > > Looks like check_helper_call might mark reg0 as a scalar, but I don't
> > > see where it would clear the reg->id? Did I miss it. Either way maybe
> > > a comment here would help make it obvious how CALLs are handled?
> > > 
> > > Thanks,
> > > John
> > 
> > OK sorry for the noise found it right after hitting send. Any call to
> > mark_reg_unknown will zero the id.
> 
> 
> Right. The verifier uses mark_reg_unknown() in lots of places,
> so I figured it doesn't make sense to list them all.

Right.

> 
> > 
> > /* Mark a register as having a completely unknown (scalar) value. */
> > static void __mark_reg_unknown(const struct bpf_verifier_env *env,
> > 			       struct bpf_reg_state *reg)
> > {
> > 	/*
> > 	 * Clear type, id, off, and union(map_ptr, range) and
> > 	 * padding between 'type' and union
> > 	 */
> > 	memset(reg, 0, offsetof(struct bpf_reg_state, var_off));
> 
> Excatly and the comment mentions 'id' too.

Yep.

> 
> > 
> > And check_helper_call() does,
> > 
> > 	/* update return register (already marked as written above) */
> > 	if (fn->ret_type == RET_INTEGER) {
> > 		/* sets type to SCALAR_VALUE */
> > 		mark_reg_unknown(env, regs, BPF_REG_0);
> > 
> > so looks good to me. In the check_func_call() case the if is_global
> > branch will mark_reg_unknown(). The other case only seems to do a
> > clear_caller_saved_regs though. Is that enough?
> 
> clear_caller_saved_regs() -> mark_reg_not_init() -> __mark_reg_unknown().

+1

> 
> I couldn't think of any other case where scalar's ID has to be cleared.
> Any kind of assignment and r0 return do it as well.

How about a zero extending move?

 r1 = r2 <- r1.id = r2.id
 w1 = w1

that will narrow the bounds on r1 but r2 should not be narrowed? So
we need to zero the r1.id I believe. But, I don't see where we
would set r1.id = 0 in this case.

> 
> We can clear id in r6 - r10 when we call a helper, but that's a bit
> paranoid, since the registers are still valid and still equal.
> Like:
> r6 = r7
> call foo
> // after the call
> if r6 > 5 goto
> if r7 < 2 goto
> // here both r6 and r7 will have bounds
> 
> I think it's good for the verifier to support that.
> 
> The other case with calls:
> 
> r1 = r2
> call foo
>   // and now inside the callee
>   if r1 > 5 goto
>   if r2 < 2 goto
>   // here both r1 and r2 will have bounds
> 
> This case will also work.
> 
> Both cases are artificial and the verifier doesn't have to be that
> smart, but it doesn't hurt and I don't think it's worth to restrict.

Agree I don't see any advantage to restrict above. I think adding
the restriction would just make it harder to follow.

> 
> I'll add two synthetic tests for these cases.

Thanks.

> 
> Any other case you can think of ?

Still churning on the above zero extending move. Also I thought
it was a bit odd that this wouldn't work,

 r1 = r2
 r0 = r1
 if r0 < 2 goto ...

then r0.id != r2.id because a new id is generated on the second
mov there. I don't actually care that much because I can't recall
seeing this pattern.

> I think some time in the past you've mentioned that you hit
> exactly this greedy register alloc issue in your cilium programs.
> Is it the case or am I misremembering?

Yes, I hit this a lot actually for whatever reason. Something
about the code I write maybe. It also tends to be inside a loop
so messing with volatiles doesn't help. End result is I get
a handful of small asm blocks to force compiler into generating
code the verifier doesn't trip up on. I was going to add I think
the cover letter understates how much this should help.

I still need to try some of Yonghong's latest patches maybe I'll
push this patch on my stack as well and see how much asm I can
delete.

Thanks.
