Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0B64BA59D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242971AbiBQQVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:21:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiBQQVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:21:54 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E4E160411
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:21:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d6b40fc9bdso8168247b3.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X1zv51X/EMgT10tLJYpOZUeca3ANCiP8pFvnZzQE4y4=;
        b=g5dRo9CI3+lG2ap+EK7k8u1cqcIXDr8+Uz4XIRVopWxmKEkwktoQIVV79+/2CbN0Le
         3tx9+mGtq/gMEWBsPclodQFwS0mXhI5wK59vkno6RM6lTJhdLrGNmI+59Ou5ngRxlUOZ
         gcQNAT4iR9usQFQisVjsUWaim8aibOlFR74Fc4Pp7fsP/mG0/MCCNfjPLpfms6j+RU5z
         dINd9P9snyqPdSJTx1snOqYz6oKn3zUdCkunwexIBFqk5AHxi/OD2MuEtuie31gnYy4L
         zd3EGaHn9NDleqF1fBXg85WpXej4xVK89E2png7wLeGr14rD1ncHiq3sVwAnsmKkM5mm
         CASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X1zv51X/EMgT10tLJYpOZUeca3ANCiP8pFvnZzQE4y4=;
        b=HSstQ3lbujqyOg++JACy/AAvBMDZvqOKwAJ3rtV9LDQvLVSTj0Q5i3HwdKoXEHJRfw
         czytch12IxKiugE6U0ZJ09FN+9eu2nx3QGXWiy+3YczkN4HLEs8Pk3bfW4jf/NkM9RPN
         W3NsjITKop8XWFfCvCN/RyzxDDZI6dBrfp5nfp8VbGg7enMzBf7UKPRW7yFEkMN4uYme
         heC1/1Z4Fp8ho5aljdMRoV6ly1ChFcXlcqUWFHi4yzulbMavTSat2lZMZV0ASIDPsWsc
         TjZBQxEky2l+eatF/OFeQ16PhBrhwItBdBFIZSQMTEiZYfJluDaSOhllHOMTKEl7MTB+
         OUfg==
X-Gm-Message-State: AOAM53303FIFyn7YjYQXUchyfswcHAIVOVIriJqiuziDWQCa2sJOCW1O
        dszeQHCK6zcIez58hhFQ64bArhw=
X-Google-Smtp-Source: ABdhPJzVKUg1MESOupT6eR4wt24r6afwj0Dr+lIhTzoktqiI/X7BdX+JOuKHT/4EqKlQnctiS4M4Lx8=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:2e4c:d90d:2d44:5aaf])
 (user=sdf job=sendgmr) by 2002:a5b:cc8:0:b0:622:e87:2087 with SMTP id
 e8-20020a5b0cc8000000b006220e872087mr3041448ybr.106.1645114898557; Thu, 17
 Feb 2022 08:21:38 -0800 (PST)
Date:   Thu, 17 Feb 2022 08:21:36 -0800
In-Reply-To: <20220217023849.jn5pcwz23rj2772x@ast-mbp.dhcp.thefacebook.com>
Message-Id: <Yg52EAB3ncoj22iK@google.com>
Mime-Version: 1.0
References: <20220216001241.2239703-1-sdf@google.com> <20220216001241.2239703-2-sdf@google.com>
 <20220217023849.jn5pcwz23rj2772x@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [RFC bpf-next 1/4] bpf: cgroup_sock lsm flavor
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/16, Alexei Starovoitov wrote:
> On Tue, Feb 15, 2022 at 04:12:38PM -0800, Stanislav Fomichev wrote:
> >  {
> > @@ -1767,14 +1769,23 @@ static int invoke_bpf_prog(const struct  
> btf_func_model *m, u8 **pprog,
> >
> >  	/* arg1: lea rdi, [rbp - stack_size] */
> >  	EMIT4(0x48, 0x8D, 0x7D, -stack_size);
> > -	/* arg2: progs[i]->insnsi for interpreter */
> > -	if (!p->jited)
> > -		emit_mov_imm64(&prog, BPF_REG_2,
> > -			       (long) p->insnsi >> 32,
> > -			       (u32) (long) p->insnsi);
> > -	/* call JITed bpf program or interpreter */
> > -	if (emit_call(&prog, p->bpf_func, prog))
> > -		return -EINVAL;
> > +
> > +	if (p->expected_attach_type == BPF_LSM_CGROUP_SOCK) {
> > +		/* arg2: progs[i] */
> > +		emit_mov_imm64(&prog, BPF_REG_2, (long) p >> 32, (u32) (long) p);
> > +		if (emit_call(&prog, __cgroup_bpf_run_lsm_sock, prog))
> > +			return -EINVAL;
> > +	} else {
> > +		/* arg2: progs[i]->insnsi for interpreter */
> > +		if (!p->jited)
> > +			emit_mov_imm64(&prog, BPF_REG_2,
> > +				       (long) p->insnsi >> 32,
> > +				       (u32) (long) p->insnsi);
> > +
> > +		/* call JITed bpf program or interpreter */
> > +		if (emit_call(&prog, p->bpf_func, prog))
> > +			return -EINVAL;

> Overall I think it's a workable solution.
> As far as mechanism I think it would be better
> to allocate single dummy bpf_prog and use normal fmod_ret
> registration mechanism instead of hacking arch trampoline bits.
> Set dummy_bpf_prog->bpf_func = __cgroup_bpf_run_lsm_sock;
> and keep as dummy_bpf_prog->jited = false;
>  From p->insnsi pointer in arg2 it's easy to go back to struct bpf_prog.
> Such dummy prog might even be statically defined like dummy_bpf_prog.
> Or allocated dynamically once.
> It can be added as fmod_ret to multiple trampolines.
> Just gut the func_model check.

Oooh, that's much cleaner, thanks!

> As far as api the attach should probably be to a cgroup+lsm_hook pair.
> link_create.target_fd will be cgroup_fd.
> At prog load time attach_btf_id should probably be one
> of existing bpf_lsm_* hooks.
> Feels wrong to duplicate the whole set into lsm_cgroup_sock set.

lsm_cgroup_sock is there to further limit which particular lsm
hooks BPF_LSM_CGROUP_SOCK can use. I guess I can maybe look at
BTF's first argument to verify that it's 'struct socket'? Let
me try to see whether it's a good alternative..

> It's fine to have prog->expected_attach_type == BPF_LSM_CGROUP_SOCK
> to disambiguate. Will we probably only have two:
> BPF_LSM_CGROUP_SOCK and BPF_LSM_CGROUP_TASK ?

I hope so. Unless objects other than socket and task can have cgroup
association.

> > +int __cgroup_bpf_run_lsm_sock(u64 *regs, const struct bpf_prog *prog)
> > +{
> > +	struct socket *sock = (void *)regs[BPF_REG_0];
> > +	struct cgroup *cgrp;
> > +	struct sock *sk;
> > +
> > +	sk = sock->sk;
> > +	if (!sk)
> > +		return 0;
> > +
> > +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > +
> > +	return  
> BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > +				     regs, bpf_prog_run, 0);
> > +}

> Would it be fast enough?
> We went through a bunch of optimization for normal cgroup and ended with:
>          if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) &&
>              cgroup_bpf_sock_enabled(sk, CGROUP_INET_INGRESS))
> Here the trampoline code plus call into __cgroup_bpf_run_lsm_sock
> will be there for all cgroups.
> Since cgroup specific check will be inside BPF_PROG_RUN_ARRAY_CG.
> I suspect it's ok, since the link_create will be for few specific lsm  
> hooks
> which are typically not in the fast path.
> Unlike traditional cgroup hook like ingress that is hot.

Right, cgroup_bpf_enabled() is not needed because lsm is by definition
off/unattached by default. Seems like we can add cgroup_bpf_sock_enabled()  
to
__cgroup_bpf_run_lsm_sock.

> For BPF_LSM_CGROUP_TASK it will take cgroup from current instead of sock,  
> right?

Right. Seems like the only difference is where we get the cgroup pointer
from: current vs sock->cgroup. Although, I'm a bit unsure whether to
allow hooks that are clearly sock-cgroup-based to use
BPF_LSM_CGROUP_TASK. For example, should we allow
BPF_LSM_CGROUP_TASK to attach to that socket_post_create? I'd prohibit that  
at
least initially to avoid some subtle 'why sometimes my
programs trigger on the wrong cgroup' types of issues.

> Args access should magically work. 'regs' above should be fine for
> all lsm hooks.

> The typical prog:
> +SEC("lsm_cgroup_sock/socket_post_create")
> +int BPF_PROG(socket_post_create, struct socket *sock, int family,
> +            int type, int protocol, int kern)
> looks good too.
> Feel natural.
> I guess they can be sleepable too?

Haven't gone into the sleepable world, but I don't see any reason why
there couldn't be a sleepable variation.

Thank you for a review!
