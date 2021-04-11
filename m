Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38EE35B69C
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 20:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhDKSrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 14:47:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235559AbhDKSrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 14:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618166845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/j9y2btoqO1c0Evplz4jdccpWFMTVusOQ6AtByiGqOw=;
        b=fLrNuTKBkeJnB9xE5EYYw7FiYEF7vbfElal6O4K1QIlHjNQWhMeBXYchT1Hic85FnXfgjI
        UMXe+42erjTZpbrgew3cN7H/KKSj1leypJItvW6bh92Z+U7yu8QTWm/wES1H3xY3jMOzbZ
        dq8s1FsrB+d6uiMId8m37dJotpNYin4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-YGHtXGSDOi-GxPfIaZVYMA-1; Sun, 11 Apr 2021 14:47:12 -0400
X-MC-Unique: YGHtXGSDOi-GxPfIaZVYMA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6C2610053EC;
        Sun, 11 Apr 2021 18:47:10 +0000 (UTC)
Received: from krava (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 246985D6D5;
        Sun, 11 Apr 2021 18:47:03 +0000 (UTC)
Date:   Sun, 11 Apr 2021 20:47:03 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        kbuild-all@lists.01.org
Subject: Re: [PATCHv3 bpf-next 1/5] bpf: Allow trampoline re-attach for
 tracing and lsm programs (fwd)
Message-ID: <YHNEJ2K/22vxr7vs@krava>
References: <alpine.DEB.2.22.394.2104111952420.11703@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.22.394.2104111952420.11703@hadrien>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 07:54:34PM +0200, Julia Lawall wrote:
> Please check the goto on line 2663.  Is an unlock needed here?

oops, yes, it's missing unlock.. I'll send new version

thanks,
jirka

> 
> julia
> 
> ---------- Forwarded message ----------
> Date: Mon, 12 Apr 2021 01:28:54 +0800
> From: kernel test robot <lkp@intel.com>
> To: kbuild@lists.01.org
> Cc: lkp@intel.com, Julia Lawall <julia.lawall@lip6.fr>
> Subject: Re: [PATCHv3 bpf-next 1/5] bpf: Allow trampoline re-attach for tracing
>     and lsm programs
> 
> CC: kbuild-all@lists.01.org
> In-Reply-To: <20210411130010.1337650-2-jolsa@kernel.org>
> References: <20210411130010.1337650-2-jolsa@kernel.org>
> TO: Jiri Olsa <jolsa@kernel.org>
> TO: Alexei Starovoitov <ast@kernel.org>
> TO: Daniel Borkmann <daniel@iogearbox.net>
> TO: Andrii Nakryiko <andriin@fb.com>
> CC: "Toke Høiland-Jørgensen" <toke@redhat.com>
> CC: netdev@vger.kernel.org
> CC: bpf@vger.kernel.org
> CC: Martin KaFai Lau <kafai@fb.com>
> CC: Song Liu <songliubraving@fb.com>
> CC: Yonghong Song <yhs@fb.com>
> CC: John Fastabend <john.fastabend@gmail.com>
> 
> Hi Jiri,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on bpf-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Jiri-Olsa/bpf-Tracing-and-lsm-programs-re-attach/20210411-210314
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> :::::: branch date: 4 hours ago
> :::::: commit date: 4 hours ago
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> 
> 
> cocci warnings: (new ones prefixed by >>)
> >> kernel/bpf/syscall.c:2738:1-7: preceding lock on line 2633
> 
> vim +2738 kernel/bpf/syscall.c
> 
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2564
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2565  static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2566  				   int tgt_prog_fd,
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2567  				   u32 btf_id)
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2568  {
> a3b80e1078943d Andrii Nakryiko        2020-04-28  2569  	struct bpf_link_primer link_primer;
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2570  	struct bpf_prog *tgt_prog = NULL;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2571  	struct bpf_trampoline *tr = NULL;
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2572  	struct bpf_tracing_link *link;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2573  	u64 key = 0;
> a3b80e1078943d Andrii Nakryiko        2020-04-28  2574  	int err;
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2575
> 9e4e01dfd3254c KP Singh               2020-03-29  2576  	switch (prog->type) {
> 9e4e01dfd3254c KP Singh               2020-03-29  2577  	case BPF_PROG_TYPE_TRACING:
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2578  		if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
> be8704ff07d237 Alexei Starovoitov     2020-01-20  2579  		    prog->expected_attach_type != BPF_TRACE_FEXIT &&
> 9e4e01dfd3254c KP Singh               2020-03-29  2580  		    prog->expected_attach_type != BPF_MODIFY_RETURN) {
> 9e4e01dfd3254c KP Singh               2020-03-29  2581  			err = -EINVAL;
> 9e4e01dfd3254c KP Singh               2020-03-29  2582  			goto out_put_prog;
> 9e4e01dfd3254c KP Singh               2020-03-29  2583  		}
> 9e4e01dfd3254c KP Singh               2020-03-29  2584  		break;
> 9e4e01dfd3254c KP Singh               2020-03-29  2585  	case BPF_PROG_TYPE_EXT:
> 9e4e01dfd3254c KP Singh               2020-03-29  2586  		if (prog->expected_attach_type != 0) {
> 9e4e01dfd3254c KP Singh               2020-03-29  2587  			err = -EINVAL;
> 9e4e01dfd3254c KP Singh               2020-03-29  2588  			goto out_put_prog;
> 9e4e01dfd3254c KP Singh               2020-03-29  2589  		}
> 9e4e01dfd3254c KP Singh               2020-03-29  2590  		break;
> 9e4e01dfd3254c KP Singh               2020-03-29  2591  	case BPF_PROG_TYPE_LSM:
> 9e4e01dfd3254c KP Singh               2020-03-29  2592  		if (prog->expected_attach_type != BPF_LSM_MAC) {
> 9e4e01dfd3254c KP Singh               2020-03-29  2593  			err = -EINVAL;
> 9e4e01dfd3254c KP Singh               2020-03-29  2594  			goto out_put_prog;
> 9e4e01dfd3254c KP Singh               2020-03-29  2595  		}
> 9e4e01dfd3254c KP Singh               2020-03-29  2596  		break;
> 9e4e01dfd3254c KP Singh               2020-03-29  2597  	default:
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2598  		err = -EINVAL;
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2599  		goto out_put_prog;
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2600  	}
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2601
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2602  	if (!!tgt_prog_fd != !!btf_id) {
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2603  		err = -EINVAL;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2604  		goto out_put_prog;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2605  	}
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2606
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2607  	if (tgt_prog_fd) {
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2608  		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2609  		if (prog->type != BPF_PROG_TYPE_EXT) {
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2610  			err = -EINVAL;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2611  			goto out_put_prog;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2612  		}
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2613
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2614  		tgt_prog = bpf_prog_get(tgt_prog_fd);
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2615  		if (IS_ERR(tgt_prog)) {
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2616  			err = PTR_ERR(tgt_prog);
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2617  			tgt_prog = NULL;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2618  			goto out_put_prog;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2619  		}
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2620
> 22dc4a0f5ed11b Andrii Nakryiko        2020-12-03  2621  		key = bpf_trampoline_compute_key(tgt_prog, NULL, btf_id);
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2622  	}
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2623
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2624  	link = kzalloc(sizeof(*link), GFP_USER);
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2625  	if (!link) {
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2626  		err = -ENOMEM;
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2627  		goto out_put_prog;
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2628  	}
> f2e10bff16a0fd Andrii Nakryiko        2020-04-28  2629  	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING,
> f2e10bff16a0fd Andrii Nakryiko        2020-04-28  2630  		      &bpf_tracing_link_lops, prog);
> f2e10bff16a0fd Andrii Nakryiko        2020-04-28  2631  	link->attach_type = prog->expected_attach_type;
> 70ed506c3bbcfa Andrii Nakryiko        2020-03-02  2632
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29 @2633  	mutex_lock(&prog->aux->dst_mutex);
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2634
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2635  	/* There are a few possible cases here:
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2636  	 *
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2637  	 * - if prog->aux->dst_trampoline is set, the program was just loaded
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2638  	 *   and not yet attached to anything, so we can use the values stored
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2639  	 *   in prog->aux
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2640  	 *
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2641  	 * - if prog->aux->dst_trampoline is NULL, the program has already been
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2642           *   attached to a target and its initial target was cleared (below)
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2643  	 *
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2644  	 * - if tgt_prog != NULL, the caller specified tgt_prog_fd +
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2645  	 *   target_btf_id using the link_create API.
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2646  	 *
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2647  	 * - if tgt_prog == NULL when this function was called using the old
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2648  	 *   raw_tracepoint_open API, and we need a target from prog->aux
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2649  	 *
> fc909cd5516914 Jiri Olsa              2021-04-11  2650  	 * - if prog->aux->dst_trampoline and tgt_prog is NULL, the program
> fc909cd5516914 Jiri Olsa              2021-04-11  2651  	 *   was detached and is going for re-attachment.
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2652  	 */
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2653  	if (!prog->aux->dst_trampoline && !tgt_prog) {
> fc909cd5516914 Jiri Olsa              2021-04-11  2654  		/*
> fc909cd5516914 Jiri Olsa              2021-04-11  2655  		 * Allow re-attach for TRACING and LSM programs. If it's
> fc909cd5516914 Jiri Olsa              2021-04-11  2656  		 * currently linked, bpf_trampoline_link_prog will fail.
> fc909cd5516914 Jiri Olsa              2021-04-11  2657  		 * EXT programs need to specify tgt_prog_fd, so they
> fc909cd5516914 Jiri Olsa              2021-04-11  2658  		 * re-attach in separate code path.
> fc909cd5516914 Jiri Olsa              2021-04-11  2659  		 */
> fc909cd5516914 Jiri Olsa              2021-04-11  2660  		if (prog->type != BPF_PROG_TYPE_TRACING &&
> fc909cd5516914 Jiri Olsa              2021-04-11  2661  		    prog->type != BPF_PROG_TYPE_LSM) {
> fc909cd5516914 Jiri Olsa              2021-04-11  2662  			err = -EINVAL;
> fc909cd5516914 Jiri Olsa              2021-04-11  2663  			goto out_put_prog;
> fc909cd5516914 Jiri Olsa              2021-04-11  2664  		}
> fc909cd5516914 Jiri Olsa              2021-04-11  2665  		btf_id = prog->aux->attach_btf_id;
> fc909cd5516914 Jiri Olsa              2021-04-11  2666  		key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf, btf_id);
> babf3164095b06 Andrii Nakryiko        2020-03-09  2667  	}
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2668
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2669  	if (!prog->aux->dst_trampoline ||
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2670  	    (key && key != prog->aux->dst_trampoline->key)) {
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2671  		/* If there is no saved target, or the specified target is
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2672  		 * different from the destination specified at load time, we
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2673  		 * need a new trampoline and a check for compatibility
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2674  		 */
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2675  		struct bpf_attach_target_info tgt_info = {};
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2676
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2677  		err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2678  					      &tgt_info);
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2679  		if (err)
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2680  			goto out_unlock;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2681
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2682  		tr = bpf_trampoline_get(key, &tgt_info);
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2683  		if (!tr) {
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2684  			err = -ENOMEM;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2685  			goto out_unlock;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2686  		}
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2687  	} else {
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2688  		/* The caller didn't specify a target, or the target was the
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2689  		 * same as the destination supplied during program load. This
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2690  		 * means we can reuse the trampoline and reference from program
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2691  		 * load time, and there is no need to allocate a new one. This
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2692  		 * can only happen once for any program, as the saved values in
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2693  		 * prog->aux are cleared below.
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2694  		 */
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2695  		tr = prog->aux->dst_trampoline;
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2696  		tgt_prog = prog->aux->dst_prog;
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2697  	}
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2698
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2699  	err = bpf_link_prime(&link->link, &link_primer);
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2700  	if (err)
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2701  		goto out_unlock;
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2702
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2703  	err = bpf_trampoline_link_prog(prog, tr);
> babf3164095b06 Andrii Nakryiko        2020-03-09  2704  	if (err) {
> a3b80e1078943d Andrii Nakryiko        2020-04-28  2705  		bpf_link_cleanup(&link_primer);
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2706  		link = NULL;
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2707  		goto out_unlock;
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2708  	}
> babf3164095b06 Andrii Nakryiko        2020-03-09  2709
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2710  	link->tgt_prog = tgt_prog;
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2711  	link->trampoline = tr;
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2712
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2713  	/* Always clear the trampoline and target prog from prog->aux to make
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2714  	 * sure the original attach destination is not kept alive after a
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2715  	 * program is (re-)attached to another target.
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2716  	 */
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2717  	if (prog->aux->dst_prog &&
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2718  	    (tgt_prog_fd || tr != prog->aux->dst_trampoline))
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2719  		/* got extra prog ref from syscall, or attaching to different prog */
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2720  		bpf_prog_put(prog->aux->dst_prog);
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2721  	if (prog->aux->dst_trampoline && tr != prog->aux->dst_trampoline)
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2722  		/* we allocated a new trampoline, so free the old one */
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2723  		bpf_trampoline_put(prog->aux->dst_trampoline);
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2724
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2725  	prog->aux->dst_prog = NULL;
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2726  	prog->aux->dst_trampoline = NULL;
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2727  	mutex_unlock(&prog->aux->dst_mutex);
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2728
> a3b80e1078943d Andrii Nakryiko        2020-04-28  2729  	return bpf_link_settle(&link_primer);
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2730  out_unlock:
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2731  	if (tr && tr != prog->aux->dst_trampoline)
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2732  		bpf_trampoline_put(tr);
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2733  	mutex_unlock(&prog->aux->dst_mutex);
> 3aac1ead5eb6b7 Toke Høiland-Jørgensen 2020-09-29  2734  	kfree(link);
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2735  out_put_prog:
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2736  	if (tgt_prog_fd && tgt_prog)
> 4a1e7c0c63e02d Toke Høiland-Jørgensen 2020-09-29  2737  		bpf_prog_put(tgt_prog);
> fec56f5890d93f Alexei Starovoitov     2019-11-14 @2738  	return err;
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2739  }
> fec56f5890d93f Alexei Starovoitov     2019-11-14  2740
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


