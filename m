Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA5CB04F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbfJCUmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:42:11 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43330 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJCUmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:42:10 -0400
Received: by mail-qk1-f194.google.com with SMTP id h126so3743071qke.10;
        Thu, 03 Oct 2019 13:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4SBguRfyDYoRXBT1nhXOnn/sJBvXW34WJjyt5ReItrM=;
        b=Aild8xlbqDi2IfjXqHmdtQFx/TXYNmVM8PHlolPrXeU5ZhuK00nj89goJ98PdcZBHj
         CUk/FThWuyxysN4pAS1p1t/HxEo6nnSEYprsnERlgeb/Aeg9dw8TJRk4WXMqvB8V2Rxl
         KDkziyx9cVA7pmbEU1h1m3Be8kWIpFb5vQ5NxDDcUtw3fqCu66MJV/JZ6uOrlmI+1xJv
         Hb42q6B1VjwSqJAwa5LcHViV1yF/r27SWgWyaPf/lmj+4SZOZc27fYvM8makT2XJhXMz
         1vFQ//xuzwJDBLdPDOKsgdJLRbr3gHqriiGC3RbrILA1zce/9+zVuLDABB6zfNmqX/qG
         ZS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4SBguRfyDYoRXBT1nhXOnn/sJBvXW34WJjyt5ReItrM=;
        b=oxsEAKxENfIQ1FsCPHGLVeTc5KAAX/u5B6qrbu8Ve1yZiQG5ZBjBs1MGutTAGfDg3G
         pC6G3UaEnJYyvWIHeowQIwwIFVdPBcwDReRlPRYMWytrUi0IbcjsQyVU6iw6NBhGse84
         WcjtgiOjeFdII/VXKV14SjUF34apEo0bCLNnMMyfCylU00y5tPxI8KFN/4Ko9gXvoF6M
         PJURDtmYbivEL0QrWE5XSs1el2yW5galEShQihqmQ9dMn/Fj4qaHfdmDLwBQOAElwTHK
         uw+XpybnUJ0wQzyANG/dKXht8+PrAe3nMN/jm00VDUmH4LTsVyP6qByZclnJyoH8BRc3
         BTjw==
X-Gm-Message-State: APjAAAWnr5DVdR9C/vXjulBrZ1G7V0GXRjLruZIKX7CsJCV1XNsWpmf/
        m6MqiW8w+ygEIQVbEdzsNI77R1MC+Y/x6kZ0F3w=
X-Google-Smtp-Source: APXvYqweJD78lseZ99W895p3abFM3ks4YlX1Y1e7mvXEZuf1yGkZ/rf0zRkC881lHuqscdAe0aF40mr427i+AHCJABs=
X-Received: by 2002:ae9:d616:: with SMTP id r22mr4571188qkk.203.1570135327065;
 Thu, 03 Oct 2019 13:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-4-andriin@fb.com>
 <CAPhsuW7CHQAq-N9-OE=jRqgYhq71ZhzEYexNcHCP=docrhNptg@mail.gmail.com> <CAEf4BzbhDw0GZ0eY2ctH+--LCk99oCTLGJ=2zaG-_vcyqvYLTw@mail.gmail.com>
In-Reply-To: <CAEf4BzbhDw0GZ0eY2ctH+--LCk99oCTLGJ=2zaG-_vcyqvYLTw@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:41:55 -0700
Message-ID: <CAPhsuW70RCb5hMGvFN99R+HxkQMMzu-ZbyRwwGL17SgGyp8t9g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] selftests/bpf: adjust CO-RE reloc tests
 for new bpf_core_read() macro
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Thu, Oct 3, 2019 at 1:29 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 3, 2019 at 1:17 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Wed, Oct 2, 2019 at 3:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > To allow adding a variadic BPF_CORE_READ macro with slightly different
> > > syntax and semantics, define CORE_READ in CO-RE reloc tests, which is
> > > a thin wrapper around low-level bpf_core_read() macro, which in turn is
> > > just a wrapper around bpf_probe_read().
> > >
> > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > Acked-by: Song Liu <songliubraving@fb.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/testing/selftests/bpf/bpf_helpers.h      |  8 ++++----
> > >  .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
> > >  .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
> > >  .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
> > >  .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
> > >  .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
> > >  .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
> > >  .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
> > >  .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
> > >  .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
> > >  10 files changed, 58 insertions(+), 40 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > > index 7b75c38238e4..5210cc7d7c5c 100644
> > > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > > @@ -483,7 +483,7 @@ struct pt_regs;
> > >  #endif
> > >
> > >  /*
> > > - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> > > + * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
> > >   * relocation for source address using __builtin_preserve_access_index()
> > >   * built-in, provided by Clang.
> > >   *
> > > @@ -498,8 +498,8 @@ struct pt_regs;
> > >   * actual field offset, based on target kernel BTF type that matches original
> > >   * (local) BTF, used to record relocation.
> > >   */
> > > -#define BPF_CORE_READ(dst, src)                                                \
> > > -       bpf_probe_read((dst), sizeof(*(src)),                           \
> > > -                      __builtin_preserve_access_index(src))
> > > +#define bpf_core_read(dst, sz, src)                                        \
> > > +       bpf_probe_read(dst, sz,                                             \
> > > +                      (const void *)__builtin_preserve_access_index(src))
> > >
> > >  #endif
> > > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > > index bf67f0fdf743..58efe4944594 100644
> > > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > > @@ -31,6 +31,8 @@ struct core_reloc_arrays {
> > >         struct core_reloc_arrays_substruct d[1][2];
> > >  };
> > >
> > > +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
> >
> > We are using sizeof(*dst) now, but I guess sizeof(*src) is better?
> > And it should be sizeof(*(src)).
>
> There is no clear winner and I've debated which one I should go with,
> but I'm leaning towards using destination for the following reason.
> Size of destination doesn't change, it's not relocatable and whatnot,
> so this represents actual amount of storage we can safely read into
> (if the program logic is correct, of course). On the other hand, size
> of source might be different between kernels and we don't support
> relocating it when it's passed into bpf_probe_read() as second arg.
>
> There is at least one valid case where we should use destination size,
> not source size: if we have an array of something (e.g, chars) and we
> want to read only up to first N elements. In this case sizeof(*dst) is
> what you really want: program will pre-allocate exact amount of data
> and we'll do, say, char comm[16]; bpf_core_read(dst,
> task_struct->comm). If task_struct->comm ever increases, this all will
> work: we'll read first 16 characters only.
>
> In almost every other case it doesn't matter whether its dst or src,
> they have to match (i.e., we don't support relocation from int32 to
> int64 right now).

Hmm.. We could also reading multiple items into the same array, no?
Maybe we need another marco that takes size as an third parameter?

Also, for dst, it needs to be sizeof(*(dst)).

Thanks,
Song
