Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEE179C9C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfG2XKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:10:12 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45509 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfG2XKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 19:10:11 -0400
Received: by mail-qt1-f193.google.com with SMTP id x22so56272560qtp.12;
        Mon, 29 Jul 2019 16:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eQsA9zRaoWdTwFadOkdwaGhh9O/cfdYOZJ97Vej1RqQ=;
        b=AXXfUKjFelej1J8q45jwO/aVPG+n1q5oD/61FtofLfA5lFaD6Z64RJ639cs58x2sTi
         +FUnDeLIORgdiBkxc9B0dAAhf5SPhNQKRpf1YAcRpaxvRn9XXga/eTePqt6f0Bd84lLW
         c2iX2v15VPVIsqe+hqn5NX51CKgQv3Rt2djRCn0l4XcSpjJFOZwN89H8L7OBz6M6/AYz
         xbUhVQQg0MIHCvSTWlBDLOMcXN6dbf2JME7Jc5zlsxBVYG1PDLHIMEOZX42sU4iFLKrS
         2C/KIeo47NssRH6BKVhKrVVLJnIfp8ZHuAVSBMyYxYHMbSUnJPw1PaGn18ZReSdJFrpq
         viUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eQsA9zRaoWdTwFadOkdwaGhh9O/cfdYOZJ97Vej1RqQ=;
        b=enJYZ+1X01OWMBmMoygmF+AStLZ0ilHTUvxzeDfJknnNmSbzR++XL8La9sJWZ61O3U
         dV6MnKonQwpSgTr+qRp3aIle/SLgBu3/Lker9QvAudALzgqXtpGjc6Scx2GRbazN3ZjJ
         dYrO2zPd8nqd6qqhBNA1HGIt+6pATmoR/1X3J7tU8DG5PvfMqOq8ytVpAOEkDDpcHqvY
         VY9Trx3rBConYrkNTOjsAwjJvrKAE+msL/VfNWKv2K9CG7GX8fzV3KfkTWyP/aCeHMoJ
         dFfnY8Zp5Pc8jxeRnERU76c1RxQg1MuquPxEO7/r2acQjFikOQsGQ1wlbefdhtPmj+F1
         J5oA==
X-Gm-Message-State: APjAAAWacUiDoYNVS7YPDOW9vqjKaZD65WkyeKdc3EztKVVe1POKG4vW
        MXtCM+0BG/Je5XtlKz0j3HYLh12v8NjrSKpmMi8=
X-Google-Smtp-Source: APXvYqy/T26DH5afpLVU87f8UQMiYRsS6w4jf3XddT3+lvGslVcVqdqHCggwrTRHPF7Wk88bb07XWdGXnMO15EtQWDc=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr78839097qvc.60.1564441810242;
 Mon, 29 Jul 2019 16:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <CAPhsuW4hd2NJU5VZAwXDTMwrJRA4O-O2iNm8OywtJd0EZd5DmA@mail.gmail.com>
 <CAPhsuW5H2QQjuASV2iXTdA73E7AQnj73b77x4FmJomc-gJy-Cg@mail.gmail.com>
In-Reply-To: <CAPhsuW5H2QQjuASV2iXTdA73E7AQnj73b77x4FmJomc-gJy-Cg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jul 2019 16:09:59 -0700
Message-ID: <CAEf4BzbKYi53TdF9nAB3i3gAuca8FjM_P3F5aHp1uQ6coMgZ9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/10] CO-RE offset relocations
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 1:37 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Jul 29, 2019 at 1:20 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Wed, Jul 24, 2019 at 1:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > This patch set implements central part of CO-RE (Compile Once - Run
> > > Everywhere, see [0] and [1] for slides and video): relocating field offsets.
> > > Most of the details are written down as comments to corresponding parts of the
> > > code.
> > >
> > > Patch #1 adds loading of .BTF.ext offset relocations section and macros to
> > > work with its contents.
> > > Patch #2 implements CO-RE relocations algorithm in libbpf.
> > > Patches #3-#10 adds selftests validating various parts of relocation handling,
> > > type compatibility, etc.
> > >
> > > For all tests to work, you'll need latest Clang/LLVM supporting
> > > __builtin_preserve_access_index intrinsic, used for recording offset
> > > relocations. Kernel on which selftests run should have BTF information built
> > > in (CONFIG_DEBUG_INFO_BTF=y).
> > >
> > >   [0] http://vger.kernel.org/bpfconf2019.html#session-2
> > >   [1] http://vger.kernel.org/lpc-bpf2018.html#session-2CO-RE relocations
> > >
> > > This patch set implements central part of CO-RE (Compile Once - Run
> > > Everywhere, see [0] and [1] for slides and video): relocating field offsets.
> > > Most of the details are written down as comments to corresponding parts of the
> > > code.
> > >
> > > Patch #1 adds loading of .BTF.ext offset relocations section and macros to
> > > work with its contents.
> > > Patch #2 implements CO-RE relocations algorithm in libbpf.
> > > Patches #3-#10 adds selftests validating various parts of relocation handling,
> > > type compatibility, etc.
> > >
> > > For all tests to work, you'll need latest Clang/LLVM supporting
> > > __builtin_preserve_access_index intrinsic, used for recording offset
> > > relocations. Kernel on which selftests run should have BTF information built
> > > in (CONFIG_DEBUG_INFO_BTF=y).
> > >
> > >   [0] http://vger.kernel.org/bpfconf2019.html#session-2
> > >   [1] http://vger.kernel.org/lpc-bpf2018.html#session-2
> > >
> > > Andrii Nakryiko (10):
> > >   libbpf: add .BTF.ext offset relocation section loading
> > >   libbpf: implement BPF CO-RE offset relocation algorithm
> > >   selftests/bpf: add CO-RE relocs testing setup
> > >   selftests/bpf: add CO-RE relocs struct flavors tests
> > >   selftests/bpf: add CO-RE relocs nesting tests
> > >   selftests/bpf: add CO-RE relocs array tests
> > >   selftests/bpf: add CO-RE relocs enum/ptr/func_proto tests
> > >   selftests/bpf: add CO-RE relocs modifiers/typedef tests
> > >   selftest/bpf: add CO-RE relocs ptr-as-array tests
> > >   selftests/bpf: add CO-RE relocs ints tests
> > >
> > >  tools/lib/bpf/btf.c                           |  64 +-
> > >  tools/lib/bpf/btf.h                           |   4 +
> > >  tools/lib/bpf/libbpf.c                        | 866 +++++++++++++++++-
> > >  tools/lib/bpf/libbpf.h                        |   1 +
> > >  tools/lib/bpf/libbpf_internal.h               |  91 ++
> > >  .../selftests/bpf/prog_tests/core_reloc.c     | 363 ++++++++
> > >  .../bpf/progs/btf__core_reloc_arrays.c        |   3 +
> > >  .../btf__core_reloc_arrays___diff_arr_dim.c   |   3 +
> > >  ...btf__core_reloc_arrays___diff_arr_val_sz.c |   3 +
> > >  .../btf__core_reloc_arrays___err_non_array.c  |   3 +
> > >  ...btf__core_reloc_arrays___err_too_shallow.c |   3 +
> > >  .../btf__core_reloc_arrays___err_too_small.c  |   3 +
> > >  ..._core_reloc_arrays___err_wrong_val_type1.c |   3 +
> > >  ..._core_reloc_arrays___err_wrong_val_type2.c |   3 +
> > >  .../bpf/progs/btf__core_reloc_flavors.c       |   3 +
> > >  .../btf__core_reloc_flavors__err_wrong_name.c |   3 +
> > >  .../bpf/progs/btf__core_reloc_ints.c          |   3 +
> > >  .../bpf/progs/btf__core_reloc_ints___bool.c   |   3 +
> > >  .../btf__core_reloc_ints___err_bitfield.c     |   3 +
> > >  .../btf__core_reloc_ints___err_wrong_sz_16.c  |   3 +
> > >  .../btf__core_reloc_ints___err_wrong_sz_32.c  |   3 +
> > >  .../btf__core_reloc_ints___err_wrong_sz_64.c  |   3 +
> > >  .../btf__core_reloc_ints___err_wrong_sz_8.c   |   3 +
> > >  .../btf__core_reloc_ints___reverse_sign.c     |   3 +
> > >  .../bpf/progs/btf__core_reloc_mods.c          |   3 +
> > >  .../progs/btf__core_reloc_mods___mod_swap.c   |   3 +
> > >  .../progs/btf__core_reloc_mods___typedefs.c   |   3 +
> > >  .../bpf/progs/btf__core_reloc_nesting.c       |   3 +
> > >  .../btf__core_reloc_nesting___anon_embed.c    |   3 +
> > >  ...f__core_reloc_nesting___dup_compat_types.c |   5 +
> > >  ...core_reloc_nesting___err_array_container.c |   3 +
> > >  ...tf__core_reloc_nesting___err_array_field.c |   3 +
> > >  ...e_reloc_nesting___err_dup_incompat_types.c |   4 +
> > >  ...re_reloc_nesting___err_missing_container.c |   3 +
> > >  ...__core_reloc_nesting___err_missing_field.c |   3 +
> > >  ..._reloc_nesting___err_nonstruct_container.c |   3 +
> > >  ...e_reloc_nesting___err_partial_match_dups.c |   4 +
> > >  .../btf__core_reloc_nesting___err_too_deep.c  |   3 +
> > >  .../btf__core_reloc_nesting___extra_nesting.c |   3 +
> > >  ..._core_reloc_nesting___struct_union_mixup.c |   3 +
> > >  .../bpf/progs/btf__core_reloc_primitives.c    |   3 +
> > >  ...f__core_reloc_primitives___diff_enum_def.c |   3 +
> > >  ..._core_reloc_primitives___diff_func_proto.c |   3 +
> > >  ...f__core_reloc_primitives___diff_ptr_type.c |   3 +
> > >  ...tf__core_reloc_primitives___err_non_enum.c |   3 +
> > >  ...btf__core_reloc_primitives___err_non_int.c |   3 +
> > >  ...btf__core_reloc_primitives___err_non_ptr.c |   3 +
> > >  .../bpf/progs/btf__core_reloc_ptr_as_arr.c    |   3 +
> > >  .../btf__core_reloc_ptr_as_arr___diff_sz.c    |   3 +
> > >  .../selftests/bpf/progs/core_reloc_types.h    | 642 +++++++++++++
> > >  .../bpf/progs/test_core_reloc_arrays.c        |  58 ++
> > >  .../bpf/progs/test_core_reloc_flavors.c       |  65 ++
> > >  .../bpf/progs/test_core_reloc_ints.c          |  48 +
> > >  .../bpf/progs/test_core_reloc_kernel.c        |  39 +
> > >  .../bpf/progs/test_core_reloc_mods.c          |  68 ++
> > >  .../bpf/progs/test_core_reloc_nesting.c       |  48 +
> > >  .../bpf/progs/test_core_reloc_primitives.c    |  50 +
> > >  .../bpf/progs/test_core_reloc_ptr_as_arr.c    |  34 +
> > >  58 files changed, 2527 insertions(+), 47 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_dim.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_val_sz.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_non_array.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_shallow.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_small.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_flavors.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_flavors__err_wrong_name.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___bool.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___reverse_sign.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods___mod_swap.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods___typedefs.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___anon_embed.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___dup_compat_types.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_container.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_field.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_dup_incompat_types.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_container.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_field.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_nonstruct_container.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_partial_match_dups.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_too_deep.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___extra_nesting.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___struct_union_mixup.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_enum_def.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_func_proto.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_ptr_type.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_enum.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_int.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_ptr.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr___diff_sz.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/core_reloc_types.h
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c
> >
> > We have created a lot of small files. Would it be cleaner if we can
> > somehow put these
> > data in one file (maybe different sections?).
>
> After reading more, I guess you have tried this and end up with current
> design: keep most struct defines in core_reloc_types.h.

Yeah, I have all the definition in one header file, but then I need
individual combinations as separate BTFs, so I essentially "pick"
desired types using function declarations. Creating those BTFs by hand
would be a nightmare to create and maintain.

>
> >
> > Alternatively, maybe create a folder for these files:
> >   tools/testing/selftests/bpf/progs/core/
>
> I guess this would still make it cleaner.

There is nothing too special about core tests to split them. Also it
would require Makefile changes and would deviate test_progs
definitions from analogous test_maps, test_verifier, test_btf, etc, so
I'm not sure about that. I though about putting those btf__* files
under separate directory, but I'm on the fence there as well, as I'd
rather have related files to stay together...


>
> Thanks,
> Song
