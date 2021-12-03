Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D64467F1B
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 22:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383173AbhLCVMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 16:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353812AbhLCVME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 16:12:04 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E940C061353
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 13:08:39 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id z8so8504858ljz.9
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 13:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2wzc+KKHAWDws9fh0Y0IZtWFtJ7npzM5S9JWp043qXc=;
        b=ioh10zh2M2cDxOBCszqSskebb5dM34p/fn0fd/a2dqpZXDOHkexjrAZqIW5uIlc0JS
         2dVZ1woVdQDEKe0slSOaXiI7BfHgaBleLvXaR7K+Rn5t1BYz0JL/ca5MxFyAk5xsUeHn
         xMv1YhQexVRSQ5lk87+UF1yp5QQHOVvpfPXec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2wzc+KKHAWDws9fh0Y0IZtWFtJ7npzM5S9JWp043qXc=;
        b=LP6T9coo+97f4aSthdZb94yPecMAWv0mgTm9X0SshGsEZsLk3r/YHajfhrzIcur9EY
         YJDDkvbucUA4EPI+QNb73Mm2fXkKGshVHk7dlHNqq+HR84t/Wh7tqeizHfp7sRqYdeft
         0CFIPdFFn7NRzO3Dga+4vpZnoUN6ZJVvy4dTNS8873urmoWPgv2a9bqEqbGMGInxyGsm
         fMokZHO5iSuQbIlNV0HDiO6vtygbt9hZ8g0p+w1fsQQ9SrqPBsViKvWqwb+1W0Kkv8cF
         g/Cnl7jMFJnkLj4I64125MOfQh13OfP2Cyp1R6z6u8OV+eN1SJxEk4WwwkoGGBMf9RoF
         tWpQ==
X-Gm-Message-State: AOAM530vbFpu9YBaczSB2wQVl8abggLkg+dCFsVLL+6OBCKxLTC3qZ8c
        SAguK0wYr79LZ/lq/6BABeLAkJGp6MAeDhLzNVTD2Q==
X-Google-Smtp-Source: ABdhPJzOXUXBlcX70qYjo0HBAqRt5p6szLOBHIkBTHQXVdm1MkMFMMYp60Wedsv2efYX39BvHlXf2IoLJfMQ65ZZISo=
X-Received: by 2002:a2e:151b:: with SMTP id s27mr20326119ljd.274.1638565717379;
 Fri, 03 Dec 2021 13:08:37 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-5-mauricio@kinvolk.io>
 <CAEf4BzZ0pEXzEvArpzL=0qbVC65z=hmeVuP7cbLKk-0_Gv5Y+A@mail.gmail.com>
In-Reply-To: <CAEf4BzZ0pEXzEvArpzL=0qbVC65z=hmeVuP7cbLKk-0_Gv5Y+A@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 3 Dec 2021 16:08:26 -0500
Message-ID: <CAHap4ztw05d7gfko+bjOcgoGoJiW2rsnGar11TVO5au80LsfHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: Expose CO-RE relocation results
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 12:25 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 16, 2021 at 8:42 AM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> >
> > The result of the CO-RE relocations can be useful for some use cases
> > like BTFGen[0]. This commit adds a new =E2=80=98record_core_relos=E2=80=
=99 option to
> > save the result of such relocations and a couple of functions to access
> > them.
> >
> > [0]: https://github.com/kinvolk/btfgen/
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/lib/bpf/libbpf.c    | 63 ++++++++++++++++++++++++++++++++++++++-
> >  tools/lib/bpf/libbpf.h    | 49 +++++++++++++++++++++++++++++-
> >  tools/lib/bpf/libbpf.map  |  2 ++
> >  tools/lib/bpf/relo_core.c | 28 +++++++++++++++--
> >  tools/lib/bpf/relo_core.h | 21 ++-----------
> >  5 files changed, 140 insertions(+), 23 deletions(-)
> >
>
> Ok, I've meditated on this patch set long enough. I still don't like
> that libbpf will be doing all this just for the sake of BTFGen's use
> case.
>
> In the end, I think giving bpftool access to internal APIs of libbpf
> is more appropriate, and it seems like it's pretty easy to achieve. It
> might actually clean up gen_loader parts a bit as well. So we'll need
> to coordinate all this with Alexei's current work on CO-RE for kernel
> as well.

Fine for us. I followed the CO-RE in the kernel patch and I didn't
spot any change that could complicate the BTFGen implementation.

> But here's what I think could be done to keep libbpf internals simple.
> We split bpf_core_apply_relo() into two parts: 1) calculating the
> struct bpf_core_relo_res and

For the BTFGen case we actually need "struct bpf_core_relo_res". I
suppose it's not a big deal to move its definition to a header file
that can be included by bpftool.

> 2) patching the instruction. If you look
> at bpf_core_apply_relo, it needs prog just for prog_name (which we can
> just pass everywhere for logging purposes) and to extract one specific
> instruction to be patched. This instruction is passed at the very end
> to bpf_core_patch_insn() after bpf_core_relo_res is calculated. So I
> propose to make those two explicitly separate steps done by libbpf. So
> bpf_core_apply_relo() (which we should rename to bpf_core_calc_relo()
> or something like that) won't do any modification to the program
> instructions. bpf_object__relocate_core() will do bpf_core_calc_relo()
> first, if that's successful, it will pass the result into
> bpf_core_patch_insn(). Simple and clean, unless I missed some
> complication (happens all the time, but..)

While implementing a prototype of this idea I faced the following challenge=
s:
- bpf_core_apply_relo() requires a candidate cache. I think we can
create two helpers functions to create / destroy a candidate cache so
we don't have to worry about it's internals in bpftool.
- we need to access obj->btf_ext in bpftool. It should be fine to
create bpf_object__btf_ext() as part of the public libbpf api.
- bpf_core_apply_relo() requires the bpf program as argument. Before
Alexei's patches it was used only for logging and getting the
instruction. Now it's also used to call record_relo_core(). Getting it
from bpftool is not that easy, in order to do I had to expose
bpf_program__sec_idx() and find_prog_by_sec_insn() to bpftool. We
could find a way to avoid passing prog but I think it's important for
the logs.
- obj->btf_vmlinux_override needs to be set in order to calculate the
core relocations. It's only set in bpf_object__relocate_core() but
we're not using this function. I created and exposed a
bpf_object_set_vmlinux_override() function to bpftool.
- There are also some naming complications but we can discuss them
when I send the patch.

I'm going to polish a bit more and finish rebasing on top of "CO-RE in
the kernel" changes to then send the patch. Please let me know if you
have any big concerns regarding my points above.

> At this point, we can teach bpftool to just take btf_ext (from BPF
> object file), iterate over all CO-RE relos and call only
> bpf_core_calc_relo() (no instruction patching). Using
> bpf_core_relo_res bpftool will know types and fields that need to be
> preserved and it will be able to construct minimal btf. So interface
> for bpftool looks like this:
>
>    bpftool gen distill_btf (or whatever the name) <file.bpf.o>
> <distilled_raw.btf>
>
> BTFGen as a solution, then, can use bpftool to process each pair of
> btf + bpf object.
>
> Thoughts?

I have the feeling that it could be easier to extend
bpf_object__relocate_core() to be able to calculate the core
relocations without patching the instructions (something similar to
what we did in v1). bpftool could pass two parameters to gather this
information and the normal libbpf workflow could just pass NULL to
indicate the instructions should be actually patched. I think this
could help specially with the difficulty to get the prog argument from
bpftool (we are almost implementing the same logic present on
bpf_object__relocate_core() to get sec_idx, prog and so on).  Does it
make any sense to you?

Thanks!

> [...]
