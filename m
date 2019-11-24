Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D7F108166
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfKXBzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:55:11 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34938 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXBzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:55:11 -0500
Received: by mail-pf1-f194.google.com with SMTP id q13so5524930pff.2;
        Sat, 23 Nov 2019 17:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=TA/wkDdtw5MCXP9DmsUdOk1w93veOJplI81Ptr1ZMJk=;
        b=P64oa/c0l8NvGIAqouyga/CAQ2klZKRcAWB1fBmoz6gCVnN2JYR4ZiMZzrQu1XKlLH
         Dp+Bh2Sau9xZEDAF5NMqQ8gbRcXWRU3AMvW08wO3J3GDdzA6cwZYoFkP+oVf0/Js8jqj
         /QOV2RpM/6KdskxKzP24avVPf+1d39HqjAJOi/f9qtRbFU/X95NbZXvbt1lH+u2aVmqJ
         SFiIv2I7u72RrJ3SwiLF0RGDzTiPq+Tcm1LekZunQyzy4N75GdkYcNu0LyCRBkJYJo2+
         JL0ByJ6y5thgZG9XbOkgvL0jvohe5bkBLaKR2XCBJ3p16y9uZ02+1FOCqnh8QaflrehN
         ltUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=TA/wkDdtw5MCXP9DmsUdOk1w93veOJplI81Ptr1ZMJk=;
        b=Ep4YFNMu3gtF+6sp90G5ufR3MwF4H6iPQ3yx2etQ5egik8WjSJSMc6EvJqhZkkEK02
         F5DXK6eRjaBxk79iMgNDDf8U1AoS5HaaWqSrws5fbJ+waihGyAtQKlMNDcobjet1oUfH
         uQD3nmVH+sYfWqgoQtCzulbAk6pc9MbQFhpkRhawKAbJhkcKmtDaGLHOu8CAujQKCGZi
         K0Rqt2D+CZsfn5Pik4Qq1cSgHOyp8FD5bC+qw/4tW+sy01u+chjRVzc52T8yElJy0nBQ
         hv8SuCLrCTQ4ujv+0lHD7o0kdelGBUu0Ztw3wZ7vIeAWwG90bIo55HC7gogsPI+S9uOC
         PfNA==
X-Gm-Message-State: APjAAAXHEdK0WCRpiPdVAHQDXqV2CuNKcCo2pwyVaQEci0cokvpzQDmJ
        iT7rBJRL1A9qSJFp7i5COmKWvrj+
X-Google-Smtp-Source: APXvYqw/pThZjOLFK1yoa0ob0lDVJOXkgRLyIQc2tCdjBvkvBmZHmzxrAbRZmhvfIkHsHwzsn/jDOg==
X-Received: by 2002:a63:de08:: with SMTP id f8mr24537847pgg.107.1574560508373;
        Sat, 23 Nov 2019 17:55:08 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::c39e])
        by smtp.gmail.com with ESMTPSA id v15sm2925331pfe.44.2019.11.23.17.55.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 17:55:07 -0800 (PST)
Date:   Sat, 23 Nov 2019 17:55:06 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com, tariqt@mellanox.com,
        saeedm@mellanox.com, maximmi@mellanox.com
Subject: Re: [PATCH bpf-next v2 1/6] bpf: introduce BPF dispatcher
Message-ID: <20191124015504.yypqw4gx52e5e6og@ast-mbp.dhcp.thefacebook.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com>
 <20191123071226.6501-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191123071226.6501-2-bjorn.topel@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 08:12:20AM +0100, Björn Töpel wrote:
> +
> +		err = emit_jump(&prog,			/* jmp thunk */
> +				__x86_indirect_thunk_rdx, prog);

could you please add a comment that this is gcc specific and gate it
by build_bug_on ?
I think even if compiler stays the change of flags:
RETPOLINE_CFLAGS_GCC := -mindirect-branch=thunk-extern -mindirect-branch-register
may change the name of this helper?
I wonder whether it's possible to make it compiler independent.

> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> new file mode 100644
> index 000000000000..385dd76ab6d2
> --- /dev/null
> +++ b/kernel/bpf/dispatcher.c
> @@ -0,0 +1,208 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2019 Intel Corporation. */
> +
> +#ifdef CONFIG_RETPOLINE

I'm worried that such strong gating will make the code rot. Especially it's not
covered by selftests.
Could you please add xdp_call_run() to generic xdp and add a selftest ?
Also could you please benchmark it without retpoline?
iirc direct call is often faster than indirect, so I suspect this optimization
may benefit non-mitigated kernels.

> +#define DISPATCHER_HASH_BITS 10
> +#define DISPATCHER_TABLE_SIZE (1 << DISPATCHER_HASH_BITS)
> +
> +static struct hlist_head dispatcher_table[DISPATCHER_TABLE_SIZE];

there is one DEFINE_XDP_CALL per driver, so total number of such
dispatch routines is pretty small. 1<<10 hash table is overkill.
The hash table itself is overkill :)

How about adding below:

> +#define BPF_DISPATCHER_MAX 16
> +
> +struct bpf_dispatcher {
> +	struct hlist_node hlist;
> +	void *func;
> +	struct bpf_prog *progs[BPF_DISPATCHER_MAX];
> +	int num_progs;
> +	void *image;
> +	u64 selector;
> +};

without hlist and without func to DEFINE_XDP_CALL() macro?
Then bpf_dispatcher_lookup() will become bpf_dispatcher_init()
and the rest will become a bit simpler?

> +
> +	set_vm_flush_reset_perms(image);
> +	set_memory_x((long)image, 1);
> +	d->image = image;

Can you add a common helper for this bit to share between
bpf dispatch and bpf trampoline?

> +static void bpf_dispatcher_update(struct bpf_dispatcher *d)
> +{
> +	void *old_image = d->image + ((d->selector + 1) & 1) * PAGE_SIZE / 2;
> +	void *new_image = d->image + (d->selector & 1) * PAGE_SIZE / 2;
> +	s64 ips[BPF_DISPATCHER_MAX] = {}, *ipsp = &ips[0];
> +	int i, err;
> +
> +	if (!d->num_progs) {
> +		bpf_arch_text_poke(d->func, BPF_MOD_JUMP_TO_NOP,
> +				   old_image, NULL);
> +		return;

how does it work? Without doing d->selector = 0; the next addition
will try to do JUMP_TO_JUMP and will fail...

> +	}
> +
> +	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
> +		if (d->progs[i])
> +			*ipsp++ = (s64)(uintptr_t)d->progs[i]->bpf_func;
> +	}
> +	err = arch_prepare_bpf_dispatcher(new_image, &ips[0], d->num_progs);
> +	if (err)
> +		return;
> +
> +	if (d->selector) {
> +		/* progs already running at this address */
> +		err = bpf_arch_text_poke(d->func, BPF_MOD_JUMP_TO_JUMP,
> +					 old_image, new_image);
> +	} else {
> +		/* first time registering */
> +		err = bpf_arch_text_poke(d->func, BPF_MOD_NOP_TO_JUMP,
> +					 NULL, new_image);
> +	}
> +	if (err)
> +		return;
> +	d->selector++;
> +}

Not sure how to share selector logic between dispatch and trampoline.
But above selector=0; weirdness is a sign that sharing is probably necessary?

> +
> +void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
> +				struct bpf_prog *to)
> +{
> +	struct bpf_dispatcher *d;
> +	bool changed = false;
> +
> +	if (from == to)
> +		return;
> +
> +	mutex_lock(&dispatcher_mutex);
> +	d = bpf_dispatcher_lookup(func);
> +	if (!d)
> +		goto out;
> +
> +	changed |= bpf_dispatcher_remove_prog(d, from);
> +	changed |= bpf_dispatcher_add_prog(d, to);
> +
> +	if (!changed)
> +		goto out;
> +
> +	bpf_dispatcher_update(d);
> +	if (!d->num_progs)
> +		bpf_dispatcher_free(d);

I think I got it why it works.
Every time the prog cnt goes to zero you free the trampoline right away
and next time it will be allocated again and kzalloc() will zero selector.
That's hard to spot.
Also if user space does for(;;) attach/detach;
it will keep stressing bpf_jit_alloc_exec.
In case of bpf trampoline attach/detach won't be stressing it.
Only load/unload which are much slower due to verification.
I guess such difference is ok.

