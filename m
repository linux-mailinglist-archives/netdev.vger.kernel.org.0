Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A56124A6EC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHSTaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHSTaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:30:02 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B4CC061757;
        Wed, 19 Aug 2020 12:30:02 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id g3so13960032ybc.3;
        Wed, 19 Aug 2020 12:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3CT5ErOBOtyeOjBNV6soZlwbmIzQP8RXf7wZQnGFgjU=;
        b=QZlVL81wAgM0w97m8DlbMm3171oM2VyecMYu+bKVCMo9lVcTlMw6UoeChwgtwmchxl
         YXmfdTRXPeF/Dsro2NVUtG0yMTlun7rDhdv+nXmVr9ofNWsW0AqHFm9uXkXDWd6dBXD4
         jYARR3H8kjPrgT/OvsJB482FZ/rYHbzXCORjhdbWeqBLPC5xcjXAO1eX4cBOP7gjxpFd
         4XL3uCuvhh786p5IdNL6yHtX2liUhkiOKSgFck0kDrlM1U/o36VQDxFUYUgWmD5MfkdV
         ejQHsFWriyfsKjiCS9JYTgGc0evLKTjMFVoDVcj4H48XTD659YsRCrK4WDBzJ1zVTUMz
         q15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3CT5ErOBOtyeOjBNV6soZlwbmIzQP8RXf7wZQnGFgjU=;
        b=JR3Glvu8H3RFWhvLxy4vEbABS3uivniS2dB+h6r5lKq1Tr0jCgPDLj6oRI8OeqrP/z
         AUhUJiz6Ns0/HGGe3OP6QNgPx8WWxYiT8RD/bmzG1PqbjcWmU954jHyGmESDXKhpIufU
         PmuFuFr3HKbCuNlZ02o7OjdyT3ht6d9w2nNbnyV8BNdmjF4f/bnNfBAAWq7uBB6H49Ek
         2SNBSCqznEwm5iKI30zATLi/2JUg4PozR9wHJP9Uxqy4HF+swBDMwwA9yALZbDbHHVCF
         PQamIg38ub3lbPARsyGYDYFgLb2wFYMFsPCkfkhxtdoQDH2QBWYUyekCIQlczRAurM4p
         vCgA==
X-Gm-Message-State: AOAM530EJwpp5/l8JCukJgozizqA1F38k5+fENFKJgFiV0lgcRWqAvb6
        wY2bvYZEjf79tj3lm9ynK1XlS3eiQ76m83apwwj3D2lA
X-Google-Smtp-Source: ABdhPJwGi3gU34HVjVhmmqw2iXGTQglavFm0z1dzWWXrSiuZdqJbIqUezRKGndvBRiViwt2MMUhLW8rbufBdoJoGPXk=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr33205467ybk.230.1597865401372;
 Wed, 19 Aug 2020 12:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200819052849.336700-1-andriin@fb.com> <20200819052849.336700-3-andriin@fb.com>
 <8840d113-86bb-bd55-b97c-1d5a869472fe@fb.com>
In-Reply-To: <8840d113-86bb-bd55-b97c-1d5a869472fe@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Aug 2020 12:29:49 -0700
Message-ID: <CAEf4Bzb=6hpK_tURacWUKB7guQN-v3mfOM6sFWiiqbo32L4_yg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/5] selftests/bpf: test TYPE_EXISTS and
 TYPE_SIZE CO-RE relocations
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 9:31 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/18/20 10:28 PM, Andrii Nakryiko wrote:
> > Add selftests for TYPE_EXISTS and TYPE_SIZE relocations, testing correctness
> > of relocations and handling of type compatiblity/incompatibility.
> >
> > If __builtin_preserve_type_info() is not supported by compiler, skip tests.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   .../selftests/bpf/prog_tests/core_reloc.c     | 125 +++++++++--
> >   .../bpf/progs/btf__core_reloc_type_based.c    |   3 +
> >   ...btf__core_reloc_type_based___all_missing.c |   3 +
> >   .../btf__core_reloc_type_based___diff_sz.c    |   3 +
> >   ...f__core_reloc_type_based___fn_wrong_args.c |   3 +
> >   .../btf__core_reloc_type_based___incompat.c   |   3 +
> >   .../selftests/bpf/progs/core_reloc_types.h    | 203 +++++++++++++++++-
> >   .../bpf/progs/test_core_reloc_kernel.c        |   2 +
> >   .../bpf/progs/test_core_reloc_type_based.c    | 125 +++++++++++
> >   9 files changed, 448 insertions(+), 22 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___all_missing.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___diff_sz.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___fn_wrong_args.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___incompat.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > index 4d650e99be28..b775ce0ede41 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
> > @@ -177,14 +177,13 @@
> >       .fails = true,                                                  \
> >   }
> >
> [...]
> > +/* func_proto with incompatible signature */
> > +typedef void (*func_proto_typedef___fn_wrong_ret1)(long);
> > +typedef int * (*func_proto_typedef___fn_wrong_ret2)(long);
> > +typedef struct { int x; } int_struct_typedef;
> > +typedef int_struct_typedef (*func_proto_typedef___fn_wrong_ret3)(long);
> > +typedef int (*func_proto_typedef___fn_wrong_arg)(void *);
> > +typedef int (*func_proto_typedef___fn_wrong_arg_cnt1)(long, long);
> > +typedef int (*func_proto_typedef___fn_wrong_arg_cnt2)(void);
> > +
> > +struct core_reloc_type_based___fn_wrong_args {
> > +     /* one valid type to make sure relos still work */
> > +     struct a_struct f1;
> > +     func_proto_typedef___fn_wrong_ret1 f2;
> > +     func_proto_typedef___fn_wrong_ret2 f3;
> > +     func_proto_typedef___fn_wrong_ret3 f4;
> > +     func_proto_typedef___fn_wrong_arg f5;
> > +     func_proto_typedef___fn_wrong_arg_cnt1 f6;
> > +     func_proto_typedef___fn_wrong_arg_cnt2 f7;
> > +};
> > +
>
> empty line at the end of file?

you cut the line showing which file it is, so I had to guess :) but fixed

>
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > index aba928fd60d3..145028b52ad8 100644
> > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > @@ -3,6 +3,7 @@
> >
> >   #include <linux/bpf.h>
> >   #include <stdint.h>
> > +#include <stdbool.h>
> >   #include <bpf/bpf_helpers.h>
> >   #include <bpf/bpf_core_read.h>
> >
> > @@ -11,6 +12,7 @@ char _license[] SEC("license") = "GPL";
> >   struct {
> >       char in[256];
> >       char out[256];
> > +     bool skip;
> >       uint64_t my_pid_tgid;
> >   } data = {};
> >
> [...]
> > +
> > +SEC("raw_tracepoint/sys_enter")
> > +int test_core_type_based(void *ctx)
> > +{
> > +#if __has_builtin(__builtin_preserve_type_info)
> > +     struct core_reloc_type_based_output *out = (void *)&data.out;
> > +
> > +     out->struct_exists = bpf_core_type_exists(struct a_struct);
> > +     out->union_exists = bpf_core_type_exists(union a_union);
> > +     out->enum_exists = bpf_core_type_exists(enum an_enum);
> > +     out->typedef_named_struct_exists = bpf_core_type_exists(named_struct_typedef);
> > +     out->typedef_anon_struct_exists = bpf_core_type_exists(anon_struct_typedef);
> > +     out->typedef_struct_ptr_exists = bpf_core_type_exists(struct_ptr_typedef);
> > +     out->typedef_int_exists = bpf_core_type_exists(int_typedef);
> > +     out->typedef_enum_exists = bpf_core_type_exists(enum_typedef);
> > +     out->typedef_void_ptr_exists = bpf_core_type_exists(void_ptr_typedef);
> > +     out->typedef_func_proto_exists = bpf_core_type_exists(func_proto_typedef);
> > +     out->typedef_arr_exists = bpf_core_type_exists(arr_typedef);
> > +
> > +     out->struct_sz = bpf_core_type_size(struct a_struct);
> > +     out->union_sz = bpf_core_type_size(union a_union);
> > +     out->enum_sz = bpf_core_type_size(enum an_enum);
> > +     out->typedef_named_struct_sz = bpf_core_type_size(named_struct_typedef);
> > +     out->typedef_anon_struct_sz = bpf_core_type_size(anon_struct_typedef);
> > +     out->typedef_struct_ptr_sz = bpf_core_type_size(struct_ptr_typedef);
> > +     out->typedef_int_sz = bpf_core_type_size(int_typedef);
> > +     out->typedef_enum_sz = bpf_core_type_size(enum_typedef);
> > +     out->typedef_void_ptr_sz = bpf_core_type_size(void_ptr_typedef);
> > +     out->typedef_func_proto_sz = bpf_core_type_size(func_proto_typedef);
> > +     out->typedef_arr_sz = bpf_core_type_size(arr_typedef);
> > +#else
> > +     data.skip = true;
> > +#endif
> > +     return 0;
> > +}
> > +
>
> empty line at the end of file?

fixed
