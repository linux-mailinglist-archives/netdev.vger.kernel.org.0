Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43138CB024
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbfJCU3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:29:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40817 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfJCU3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:29:04 -0400
Received: by mail-qt1-f196.google.com with SMTP id f7so5480198qtq.7;
        Thu, 03 Oct 2019 13:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+vXSND0cwR9CTG7GTWITe+uioSqf+T6L6JSvoQTNkeo=;
        b=tc5rLxMb5m8V3z23dQn9uiG/eyyZP7YQ9qkpNhrRnGmbm5Xe7IJ9x8Pc1jwrC8gICb
         UoZh0Uf7NpZT9vw178I1LQgODrEukijUe1zF4eiB/3zOLRyMfd33zxJCcI8emBKBg68d
         FIZbwLnGZ2l2DhMxPZ2O9N+q0ZJi4xhvH/Ay61Youxp9d8IFxsBAMwKil/e0zXvWp6AT
         wlus8H87eicbpQaWpyhTnDtzMqO/HTeNz3Fss5WwFMRADsYihNdwRvlvFc//uSc8dSFK
         QskxUxiz3sLFcc+42K0Eu8iN2zjGG/ZYV9WBqXpmB0TzpVOKmVkjqSW9E91vNAsGZj+M
         UKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+vXSND0cwR9CTG7GTWITe+uioSqf+T6L6JSvoQTNkeo=;
        b=SRg0DSDbL0nEssUZuMr8gb9DBAvCWYRzsWxbj3HBExYHeWAImB64hrrH0krguq7do8
         fIvBgJJ8xbzKBfLYdq6vJCVK8dSwU9DJahJ/9JFk1JvpJXi++5zo4yDrJZwQrZIIZ7IR
         nvvJLQ07EXnFZpo0PLjqEXDfNN9O/4jCe8sYirpkiybW9n9SCPaLI6wHVTDPpgY3/bvm
         9B7ISeTqjmMZULBDSHy5gCv/Z1nj8PVmAP+SNknNYYoJC6JkuNcd4YrY2kNiYU5UTdZE
         o+apwCjXFlBs6bd7un4KBgdH/k/ol+dehrEPiEiZLEZS/32N0nwaKt6qUYzCQmjRRsiM
         raGw==
X-Gm-Message-State: APjAAAVhh/Armfg7jyBWBvv3HZK/24XKFNE4ZerZBR2rlf5EOyW6Nqik
        SDt7TZIACHKbRum41j8RP0Fqu26IBymFScRIVCA=
X-Google-Smtp-Source: APXvYqw8YWZ4WGJgq8ca1lsIffLM3d7j0HJV38kQAfFAHrf582KAy5gnTFghRN2lE7YlpJH53LX3xVeG2wI9hdliBrM=
X-Received: by 2002:ac8:1417:: with SMTP id k23mr11446034qtj.93.1570134542968;
 Thu, 03 Oct 2019 13:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-4-andriin@fb.com>
 <CAPhsuW7CHQAq-N9-OE=jRqgYhq71ZhzEYexNcHCP=docrhNptg@mail.gmail.com>
In-Reply-To: <CAPhsuW7CHQAq-N9-OE=jRqgYhq71ZhzEYexNcHCP=docrhNptg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 13:28:52 -0700
Message-ID: <CAEf4BzbhDw0GZ0eY2ctH+--LCk99oCTLGJ=2zaG-_vcyqvYLTw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] selftests/bpf: adjust CO-RE reloc tests
 for new bpf_core_read() macro
To:     Song Liu <liu.song.a23@gmail.com>
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

On Thu, Oct 3, 2019 at 1:17 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Wed, Oct 2, 2019 at 3:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > To allow adding a variadic BPF_CORE_READ macro with slightly different
> > syntax and semantics, define CORE_READ in CO-RE reloc tests, which is
> > a thin wrapper around low-level bpf_core_read() macro, which in turn is
> > just a wrapper around bpf_probe_read().
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/bpf_helpers.h      |  8 ++++----
> >  .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
> >  .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
> >  .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
> >  .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
> >  .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
> >  .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
> >  .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
> >  .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
> >  .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
> >  10 files changed, 58 insertions(+), 40 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> > index 7b75c38238e4..5210cc7d7c5c 100644
> > --- a/tools/testing/selftests/bpf/bpf_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> > @@ -483,7 +483,7 @@ struct pt_regs;
> >  #endif
> >
> >  /*
> > - * BPF_CORE_READ abstracts away bpf_probe_read() call and captures offset
> > + * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
> >   * relocation for source address using __builtin_preserve_access_index()
> >   * built-in, provided by Clang.
> >   *
> > @@ -498,8 +498,8 @@ struct pt_regs;
> >   * actual field offset, based on target kernel BTF type that matches original
> >   * (local) BTF, used to record relocation.
> >   */
> > -#define BPF_CORE_READ(dst, src)                                                \
> > -       bpf_probe_read((dst), sizeof(*(src)),                           \
> > -                      __builtin_preserve_access_index(src))
> > +#define bpf_core_read(dst, sz, src)                                        \
> > +       bpf_probe_read(dst, sz,                                             \
> > +                      (const void *)__builtin_preserve_access_index(src))
> >
> >  #endif
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > index bf67f0fdf743..58efe4944594 100644
> > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
> > @@ -31,6 +31,8 @@ struct core_reloc_arrays {
> >         struct core_reloc_arrays_substruct d[1][2];
> >  };
> >
> > +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
>
> We are using sizeof(*dst) now, but I guess sizeof(*src) is better?
> And it should be sizeof(*(src)).

There is no clear winner and I've debated which one I should go with,
but I'm leaning towards using destination for the following reason.
Size of destination doesn't change, it's not relocatable and whatnot,
so this represents actual amount of storage we can safely read into
(if the program logic is correct, of course). On the other hand, size
of source might be different between kernels and we don't support
relocating it when it's passed into bpf_probe_read() as second arg.

There is at least one valid case where we should use destination size,
not source size: if we have an array of something (e.g, chars) and we
want to read only up to first N elements. In this case sizeof(*dst) is
what you really want: program will pre-allocate exact amount of data
and we'll do, say, char comm[16]; bpf_core_read(dst,
task_struct->comm). If task_struct->comm ever increases, this all will
work: we'll read first 16 characters only.

In almost every other case it doesn't matter whether its dst or src,
they have to match (i.e., we don't support relocation from int32 to
int64 right now).

>
> > +
> >  SEC("raw_tracepoint/sys_enter")
> >  int test_core_arrays(void *ctx)
> >  {
> > @@ -38,16 +40,16 @@ int test_core_arrays(void *ctx)
> >         struct core_reloc_arrays_output *out = (void *)&data.out;
> >
> >         /* in->a[2] */
> > -       if (BPF_CORE_READ(&out->a2, &in->a[2]))
> > +       if (CORE_READ(&out->a2, &in->a[2]))
> >                 return 1;
> >         /* in->b[1][2][3] */
> > -       if (BPF_CORE_READ(&out->b123, &in->b[1][2][3]))
> > +       if (CORE_READ(&out->b123, &in->b[1][2][3]))
> >                 return 1;
> >         /* in->c[1].c */
> > -       if (BPF_CORE_READ(&out->c1c, &in->c[1].c))
> > +       if (CORE_READ(&out->c1c, &in->c[1].c))
> >                 return 1;
> >         /* in->d[0][0].d */
> > -       if (BPF_CORE_READ(&out->d00d, &in->d[0][0].d))
> > +       if (CORE_READ(&out->d00d, &in->d[0][0].d))
> >                 return 1;
> >
> >         return 0;
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
> > index 9fda73e87972..3348acc7e50b 100644
> > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
> > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
> > @@ -39,6 +39,8 @@ struct core_reloc_flavors___weird {
> >         };
> >  };
> >
> > +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
> > +
> >  SEC("raw_tracepoint/sys_enter")
> >  int test_core_flavors(void *ctx)
> >  {
> > @@ -48,13 +50,13 @@ int test_core_flavors(void *ctx)
> >         struct core_reloc_flavors *out = (void *)&data.out;
> >
> >         /* read a using weird layout */
> > -       if (BPF_CORE_READ(&out->a, &in_weird->a))
> > +       if (CORE_READ(&out->a, &in_weird->a))
> >                 return 1;
> >         /* read b using reversed layout */
> > -       if (BPF_CORE_READ(&out->b, &in_rev->b))
> > +       if (CORE_READ(&out->b, &in_rev->b))
> >                 return 1;
> >         /* read c using original layout */
> > -       if (BPF_CORE_READ(&out->c, &in_orig->c))
> > +       if (CORE_READ(&out->c, &in_orig->c))
> >                 return 1;
> >
> >         return 0;
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
> > index d99233c8008a..cfe16ede48dd 100644
> > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
> > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
> > @@ -23,20 +23,22 @@ struct core_reloc_ints {
> >         int64_t         s64_field;
> >  };
> >
> > +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
>
> ditto.
>
> > +
> >  SEC("raw_tracepoint/sys_enter")
> >  int test_core_ints(void *ctx)
> >  {
> >         struct core_reloc_ints *in = (void *)&data.in;
> >         struct core_reloc_ints *out = (void *)&data.out;
> >
> > -       if (BPF_CORE_READ(&out->u8_field, &in->u8_field) ||
> > -           BPF_CORE_READ(&out->s8_field, &in->s8_field) ||
> > -           BPF_CORE_READ(&out->u16_field, &in->u16_field) ||
> > -           BPF_CORE_READ(&out->s16_field, &in->s16_field) ||
> > -           BPF_CORE_READ(&out->u32_field, &in->u32_field) ||
> > -           BPF_CORE_READ(&out->s32_field, &in->s32_field) ||
> > -           BPF_CORE_READ(&out->u64_field, &in->u64_field) ||
> > -           BPF_CORE_READ(&out->s64_field, &in->s64_field))
> > +       if (CORE_READ(&out->u8_field, &in->u8_field) ||
> > +           CORE_READ(&out->s8_field, &in->s8_field) ||
> > +           CORE_READ(&out->u16_field, &in->u16_field) ||
> > +           CORE_READ(&out->s16_field, &in->s16_field) ||
> > +           CORE_READ(&out->u32_field, &in->u32_field) ||
> > +           CORE_READ(&out->s32_field, &in->s32_field) ||
> > +           CORE_READ(&out->u64_field, &in->u64_field) ||
> > +           CORE_READ(&out->s64_field, &in->s64_field))
> >                 return 1;
> >
> >         return 0;
> > diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > index 37e02aa3f0c8..e5308026cfda 100644
> > --- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > +++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
> > @@ -17,6 +17,8 @@ struct task_struct {
> >         int tgid;
> >  };
> >
> > +#define CORE_READ(dst, src) bpf_core_read(dst, sizeof(*dst), src)
> ditto again, and more below.
>
> Thanks,
> Song
