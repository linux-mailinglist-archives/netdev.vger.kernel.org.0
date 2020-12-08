Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844412D2172
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgLHD3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgLHD3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:29:35 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6724C061749;
        Mon,  7 Dec 2020 19:28:55 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id t33so14946370ybd.0;
        Mon, 07 Dec 2020 19:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vGYs5Gkmvt+IN0Va079gulyVZYQxUla2XbMiolKa4aY=;
        b=uCeFzefGJWiB8oNn9JGQ8iSumMZNiKYId6RjlMGwVZXH8NvE4SQ2QDnVllnAXRj0F6
         JW2tzdj0cSEWn4T9cw3VkzOArysdkkQYwaEUuJLSImovp+HuED/rpq7WRr1rkocApssB
         cjQ3FzKYxCReK6vWGsNv1/bTrB1UYFLFiCTC3Pbng2cAn523n9POYRiZiFAKTBwAiNPt
         VwgmkCTRtb4AZkyIaYaoeO1yKFQg3F/kbHoggaQGsxhUn0MBLDvAZQKOKhvf7nAfdFSP
         Uy+peLjaAMFiJyYrN7z9NfFZh6BKz3hZCqADzELu2HFEUmgyhgfifR2x9JNIE4O6/zlA
         te3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vGYs5Gkmvt+IN0Va079gulyVZYQxUla2XbMiolKa4aY=;
        b=kTUNXJksNM48Vskw9wTKq77pqp/euUt2DKSBOL8d5kfKTCAtm2HdDN0Dv2BeI91SCU
         Da217H3cf8EmTMW3Ps/0bDSK444d/TIQP9PhkALsQOlidTKrXGhMjQNHLK+QND0PUAPJ
         KmcrzC4ORt4biIFnzCQ8fdvvNwk/cQgr8BDKRobOz8SbSluF+KXk0dcwwx1ebHcJHtZF
         YiOUpDjvhuZU/LWJMGmxzTC8L1OSbOvECmFZ5aWW+tuwJNsbPgm2SRobiFi/xBi5U9CO
         gPSU8QGdX4UIVqbqKYwHrfmBecbiiWPJ2VZkTjCmorAzhmhnCIuLlzFlJhnJiV28nmXi
         INnQ==
X-Gm-Message-State: AOAM5315lf83NQoOFd1orsOCVNa9ksGSE2zWhRoeLU+BfOQT4qABFPMV
        kBXd3ATRAM7L3t2c0ME3oVqjykd6VVUzHlTHOO8zCa0EffB+9g==
X-Google-Smtp-Source: ABdhPJwcIoHs4gP/Ilq1AOrCi+5LHXOLqz0GcesF2Xw8HthhaENmvf0nNgXk8azO4yKXZHJxfjRcQ+1tpRPOyU0+pRg=
X-Received: by 2002:a25:6a05:: with SMTP id f5mr23815351ybc.459.1607398134898;
 Mon, 07 Dec 2020 19:28:54 -0800 (PST)
MIME-Version: 1.0
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012060025520.1505@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2012060025520.1505@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 19:28:43 -0800
Message-ID: <CAEf4BzbB87SDiD+=4u2u5iLhQiXUCc0Bf-7SX6BXZ4tkhjFU=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for
 BPF_TYPE_ID_TARGET CO-RE relocation
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 4:38 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Fri, 4 Dec 2020, Andrii Nakryiko wrote:
>
> > When Clang emits ldimm64 instruction for BPF_TYPE_ID_TARGET CO-RE relocation,
> > put module BTF FD, containing target type, into upper 32 bits of imm64.
> >
> > Because this FD is internal to libbpf, it's very cumbersome to test this in
> > selftests. Manual testing was performed with debug log messages sprinkled
> > across selftests and libbpf, confirming expected values are substituted.
> > Better testing will be performed as part of the work adding module BTF types
> > support to  bpf_snprintf_btf() helpers.
> >
> > Cc: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Thanks so much for doing this Andrii! When I tested, I ran into a problem;
> it turns out when a module struct such as "veth_stats" is used, it's
> classified as BTF_KIND_FWD, and as a result when we iterate over
> the modules and look in the veth module, "struct veth_stats" does not
> match since its module kind (BTF_KIND_STRUCT) does not match the candidate
> kind (BTF_KIND_FWD). I'm kind of out of my depth here, but the below
> patch (on top of your patch) worked.

I'm not quite clear on the situation. BTF_KIND_FWD is for the local
type or the remote type? Maybe a small example would help, before we
go straight to assuming FWD can be always resolved into a concrete
STRUCT/UNION.


>  However without it - when we find
> 0  candidate matches - as well as not substituting the module object
> id/type id - we hit a segfault:

Yep, I missed the null check in:

targ_spec->btf != prog->obj->btf_vmlinux

I'll fix that.

>
> Program terminated with signal 11, Segmentation fault.
> #0  0x0000000000480bf9 in bpf_core_calc_relo (prog=0x4d6ba40,
> relo=0x4d70e7c,
>     relo_idx=0, local_spec=0x7ffe2cf17b00, targ_spec=0x0,
> res=0x7ffe2cf17ae0)
>     at libbpf.c:4408
> 4408            switch (kind) {
> Missing separate debuginfos, use: debuginfo-install
> elfutils-libelf-0.172-2.el7.x86_64 glibc-2.17-196.el7.x86_64
> libattr-2.4.46-13.el7.x86_64 libcap-2.22-9.el7.x86_64
> libgcc-4.8.5-36.0.1.el7_6.2.x86_64 zlib-1.2.7-18.el7.x86_64
> (gdb) bt
> #0  0x0000000000480bf9 in bpf_core_calc_relo (prog=0x4d6ba40,
> relo=0x4d70e7c,
>     relo_idx=0, local_spec=0x7ffe2cf17b00, targ_spec=0x0,
> res=0x7ffe2cf17ae0)
>     at libbpf.c:4408
>
>
> The dereferences of targ_spec in bpf_core_recalc_relo() seem
> to be the cause; that function is called with a NULL targ_spec
> when 0 candidates are found, so it's possible we'd need to
> guard those accesses for cases where a bogus type was passed
> in and no candidates were found.  If the below looks good would
> it make sense to roll it into your patch or will I add it to my
> v3 patch series?
>
> Thanks again for your help with this!
>
> Alan
>
> From 08040730dbff6c5d7636927777ac85a71c10827f Mon Sep 17 00:00:00 2001
> From: Alan Maguire <alan.maguire@oracle.com>
> Date: Sun, 6 Dec 2020 01:10:28 +0100
> Subject: [PATCH] libbpf: handle fwd kinds when checking candidate relocations
>  for modules
>
> when a struct belonging to a module is being assessed, it will be
> designated a fwd kind (BTF_KIND_FWD); when matching candidate
> types constraints on exact type matching need to be relaxed to
> ensure that such structures are found successfully.  Introduce
> kinds_match() function to handle this comparison.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>

[...]
