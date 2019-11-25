Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB6391090F0
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfKYPUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:20:24 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37615 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfKYPUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:20:24 -0500
Received: by mail-qk1-f193.google.com with SMTP id e187so13043586qkf.4;
        Mon, 25 Nov 2019 07:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4ALprPArxIlD1+sUIUiV79lDDblL6eJWQJUs7Pq4xgU=;
        b=qroBwld/uB8Au1dtWdfE9w+zBB67nfiXa2HtZi+GlkfAUU3omXAIexNkL0Z6PffsxT
         loiO56zKuh0m7U3dnUn8Uo93s9Y1fibMVtttG+nulOWiKqrWt7dEo/KtI8Ri6au+SkcP
         gjglj/z2+q7KP1kl4MyYRl3RzmtHpGjgT4G5CfEESZYqAPRRKSLrN5zgIAC4GUj4sP1V
         /lkjkGkqmAr75wEctaK1/Q0A98U12JeFblaHt0BcguxLHKYxPR6j3u3fJfHrniR3yQLA
         LAB66Xpk+Sra1d3dRnIhlhZSu4jJTH94osI1XXjhyVBDZSrKEWv9TRrQChvvUE6A4t0u
         TkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4ALprPArxIlD1+sUIUiV79lDDblL6eJWQJUs7Pq4xgU=;
        b=oLL2Cc6h89CTQR6js8u/LCxUHHZNhUM9qLAXA5yJobC0pOOVMlCvikVSPT33YFixhW
         zMCDq0wkb/XzBoJMsjBOR9b4aAcLxaAm+vdQ+57F8S+6e+cgBg66X4T4OjSyHzyUGGzr
         s4mN2jL+j0goN8ALWvphfXX42rJPwCW68XK2LVBTaIUF/0qEbObT45wwHPDDjMF20hTx
         5Gh75Hdi+ThdziYZB5Kj1EbP8C7qiF6TIxADdVj3kwLUFZCu3y16UReXVZel6/dqrG7G
         Ru7KCOwbiLm/UNkPzjjZyJ0LyqcAKng2QdW2ZwzbKFAc+cNvj8YtariG4d1Cd7dPYTI4
         1R1w==
X-Gm-Message-State: APjAAAUHHYmrjAf2J6mWZoLAWnfqMWEZ3BzHFadpRsXd8McWUfJ9cUe4
        VOaRPgOiTo1Z1PMg/yMrZJeFa8x9CCTFVe626p4=
X-Google-Smtp-Source: APXvYqwIvYYdIQtlx8y6klhsGEAUR3mdPtOC9BI8qyM1051oZTKGGjf8/hAeZg01n11yRk2NQP3/qvjMpbg5dtTWuN8=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr11806693qke.297.1574695223056;
 Mon, 25 Nov 2019 07:20:23 -0800 (PST)
MIME-Version: 1.0
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-2-bjorn.topel@gmail.com>
 <20191125105337.GA14828@pc-9.home>
In-Reply-To: <20191125105337.GA14828@pc-9.home>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 25 Nov 2019 16:20:11 +0100
Message-ID: <CAJ+HfNhwkkuX4GTP4ATJf_XZbR2p-UR1oW=FOpBE1BzE8u3-fQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] bpf: introduce BPF dispatcher
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 at 11:54, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Sat, Nov 23, 2019 at 08:12:20AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The BPF dispatcher is a multiway branch code generator, mainly
> > targeted for XDP programs. When an XDP program is executed via the
> > bpf_prog_run_xdp(), it is invoked via an indirect call. With
> > retpolines enabled, the indirect call has a substantial performance
> > impact. The dispatcher is a mechanism that transform multiple indirect
> > calls to direct calls, and therefore avoids the retpoline. The
> > dispatcher is generated using the BPF JIT, and relies on text poking
> > provided by bpf_arch_text_poke().
> >
> > The dispatcher hijacks a trampoline function it via the __fentry__ nop
> > of the trampoline. One dispatcher instance currently supports up to 16
> > dispatch points. This can be extended in the future.
> >
> > An example: A module/driver allocates a dispatcher. The dispatcher is
> > shared for all netdevs. Each unique XDP program has a slot in the
> > dispatcher, registered by a netdev. The netdev then uses the
> > dispatcher to call the correct program with a direct call.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> [...]
> > +static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
> > +{
> > +     u8 *jg_reloc, *jg_target, *prog =3D *pprog;
> > +     int pivot, err, jg_bytes =3D 1, cnt =3D 0;
> > +     s64 jg_offset;
> > +
> > +     if (a =3D=3D b) {
> > +             /* Leaf node of recursion, i.e. not a range of indices
> > +              * anymore.
> > +              */
> > +             EMIT1(add_1mod(0x48, BPF_REG_3));       /* cmp rdx,func *=
/
> > +             if (!is_simm32(progs[a]))
> > +                     return -1;
> > +             EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3),
> > +                         progs[a]);
> > +             err =3D emit_cond_near_jump(&prog,        /* je func */
> > +                                       (void *)progs[a], prog,
> > +                                       X86_JE);
> > +             if (err)
> > +                     return err;
> > +
> > +             err =3D emit_jump(&prog,                  /* jmp thunk */
> > +                             __x86_indirect_thunk_rdx, prog);
> > +             if (err)
> > +                     return err;
> > +
> > +             *pprog =3D prog;
> > +             return 0;
> > +     }
> > +
> > +     /* Not a leaf node, so we pivot, and recursively descend into
> > +      * the lower and upper ranges.
> > +      */
> > +     pivot =3D (b - a) / 2;
> > +     EMIT1(add_1mod(0x48, BPF_REG_3));               /* cmp rdx,func *=
/
> > +     if (!is_simm32(progs[a + pivot]))
> > +             return -1;
> > +     EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3), progs[a + pivot]);
> > +
> > +     if (pivot > 2) {                                /* jg upper_part =
*/
> > +             /* Require near jump. */
> > +             jg_bytes =3D 4;
> > +             EMIT2_off32(0x0F, X86_JG + 0x10, 0);
> > +     } else {
> > +             EMIT2(X86_JG, 0);
> > +     }
> > +     jg_reloc =3D prog;
> > +
> > +     err =3D emit_bpf_dispatcher(&prog, a, a + pivot,  /* emit lower_p=
art */
> > +                               progs);
> > +     if (err)
> > +             return err;
> > +
> > +     /* Intel 64 and IA-32 ArchitecturesOptimization Reference
> > +      * Manual, 3.4.1.5 Code Alignment Assembly/Compiler Coding
> > +      * Rule 12. (M impact, H generality) All branch targets should
> > +      * be 16-byte aligned.
>
> Isn't this section 3.4.1.4, rule 11 or are you reading a newer manual
> than on the website [0]? :)

Argh, no, you're right. Typo. Thanks!

> Just wondering, in your IXIA tests, did you
> see any noticeable slowdowns if you don't do the 16-byte alignments as
> in the rest of the kernel [1,2]?
>
>   [0] https://software.intel.com/sites/default/files/managed/9e/bc/64-ia-=
32-architectures-optimization-manual.pdf
>   [1] be6cb02779ca ("x86: Align jump targets to 1-byte boundaries")
>   [2] https://lore.kernel.org/patchwork/patch/560050/
>

Interesting! Thanks for the pointers. I'll do more benchmarking for
the next rev, and hopefully we can leave the nops out. Let's see.


Bj=C3=B6rn

> > +      */
> > +     jg_target =3D PTR_ALIGN(prog, 16);
> > +     if (jg_target !=3D prog)
> > +             emit_nops(&prog, jg_target - prog);
> > +     jg_offset =3D prog - jg_reloc;
> > +     emit_code(jg_reloc - jg_bytes, jg_offset, jg_bytes);
> > +
> > +     err =3D emit_bpf_dispatcher(&prog, a + pivot + 1, /* emit upper_p=
art */
> > +                               b, progs);
> > +     if (err)
> > +             return err;
> > +
> > +     *pprog =3D prog;
> > +     return 0;
> > +}
