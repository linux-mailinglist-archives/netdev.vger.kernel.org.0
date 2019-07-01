Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7161A5C5AB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfGAW0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:26:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44180 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGAW0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:26:42 -0400
Received: by mail-qt1-f194.google.com with SMTP id x47so16397544qtk.11;
        Mon, 01 Jul 2019 15:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=66DWTuWXUJ0ql4q7+5V6j5T5jdJVDAmGHQX4n5r2ZWo=;
        b=m2h4yDHSP63uuY4sUTesQIFB0BQaBMFZ+WmN0MqL1mIq0z3KkZsYIgjDYW8P3k4FRg
         mY3PRzcHRLEH1orDhNBzb79lkwPqiPfDtE8AqMAbc5My5UP60b69q2CJ3lQwcoYsN/uk
         ba/ki88bpFMM+1BLOJOxRrz2gl8L3oELxSgyKG6s57EQ+YaEBMk+l3voIcaOEZbqXabX
         /7MVVU9cr8RvtoA2SQK/2mFyG9roQWZ5EcLhG0IYmTc5C4oJph3nSTBxpaoSiq9IKxgH
         aXcbW0VVLN6lv89gfJJ+0QvLffrvpCvVeVcrhXuo75ReC9ai1cr3bWZ/XCEGcwqWRE3D
         fsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=66DWTuWXUJ0ql4q7+5V6j5T5jdJVDAmGHQX4n5r2ZWo=;
        b=tNmJssbLAHSV5dVohRE+eO4HE4KCbiAUDRmHzxGfT4NE9A0NI+aciz7EyRKJP7H2Ci
         VOoceWjId+IjhhyG9VkPebsBiCdN6K3SGTZ17ZSFbNYffbHsfxf5Bd1MYZTXfRJfivFX
         wZNJZLzMV+SEQI19hTNaIpDvbGaAnnzA6uHQB+NFhSg2Z7lJEJ89MOluO9NIEYLYue9w
         Kvl7J5ufpiKyQKg9vq7feSEfF2z0oD5hwfZemGeCaK/sueVKLM9hKLVbEMJyrBXmOgi9
         pcmiP1CUAhLGdZjwN0Qx8ILzBDxcJtdK4W+2jrWE5PgPRTBIkRDRdty3ej7mvPTyXNMS
         55mg==
X-Gm-Message-State: APjAAAUR957zQE9UJj0hT/MMBLIeSJXIvnpVQAzGrNq+o/90AC4YeaxQ
        VEMG+UIzdlV8S68eZtWdL7brl4h1gcOo/Cm88+Y2eaHIZq4=
X-Google-Smtp-Source: APXvYqxh1uHATvT9WDhHp0mRxdEjPFPRQ4YgbHmTJ66QHfK2tJO/SVYlEoNbMtDtKmyspSn605fyWuL1mKRY30ZUZqY=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr23234760qvc.60.1562020001712;
 Mon, 01 Jul 2019 15:26:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-7-andriin@fb.com>
 <e6be6907-4587-6106-9868-e76fbf38a3f5@fb.com>
In-Reply-To: <e6be6907-4587-6106-9868-e76fbf38a3f5@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 15:26:30 -0700
Message-ID: <CAEf4BzYRpgE5VPwuv2zkXZ2N9BQVPASvYbtsZDM10C1kwdX3eg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 6/9] libbpf: add raw tracepoint attach API
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/19 8:49 PM, Andrii Nakryiko wrote:
> > Add a wrapper utilizing bpf_link "infrastructure" to allow attaching BPF
> > programs to raw tracepoints.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > ---
> >   tools/lib/bpf/libbpf.c   | 37 +++++++++++++++++++++++++++++++++++++
> >   tools/lib/bpf/libbpf.h   |  3 +++
> >   tools/lib/bpf/libbpf.map |  1 +
> >   3 files changed, 41 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 8ad4f915df38..f8c7a7ecb35e 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4263,6 +4263,43 @@ struct bpf_link *bpf_program__attach_tracepoint(struct bpf_program *prog,
> >       return link;
> >   }
> >
> > +static int bpf_link__destroy_fd(struct bpf_link *link)
> > +{
> > +     struct bpf_link_fd *l = (void *)link;
> > +
> > +     return close(l->fd);
> > +}
> > +
> > +struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
> > +                                                 const char *tp_name)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     struct bpf_link_fd *link;
> > +     int prog_fd, pfd;
> > +
> > +     prog_fd = bpf_program__fd(prog);
> > +     if (prog_fd < 0) {
> > +             pr_warning("program '%s': can't attach before loaded\n",
> > +                        bpf_program__title(prog, false));
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> > +     link = malloc(sizeof(*link));
> > +     link->link.destroy = &bpf_link__destroy_fd;
>
> You can move the "link = malloc(...)" etc. after
> bpf_raw_tracepoint_open(). That way, you do not need to free(link)
> in the error case.

It's either `free(link)` here, or `close(pfd)` if malloc fails after
we attached program. Either way extra clean up is needed. I went with
the first one.

>
> > +
> > +     pfd = bpf_raw_tracepoint_open(tp_name, prog_fd);
> > +     if (pfd < 0) {
> > +             pfd = -errno;
> > +             free(link);
> > +             pr_warning("program '%s': failed to attach to raw tracepoint '%s': %s\n",
> > +                        bpf_program__title(prog, false), tp_name,
> > +                        libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> > +             return ERR_PTR(pfd);
> > +     }
> > +     link->fd = pfd;
> > +     return (struct bpf_link *)link;
> > +}
> > +
> >   enum bpf_perf_event_ret
> >   bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >                          void **copy_mem, size_t *copy_size,
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 60611f4b4e1d..f55933784f95 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -182,6 +182,9 @@ LIBBPF_API struct bpf_link *
> >   bpf_program__attach_tracepoint(struct bpf_program *prog,
> >                              const char *tp_category,
> >                              const char *tp_name);
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
> > +                                const char *tp_name);
> >
> >   struct bpf_insn;
> >
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 3c618b75ef65..e6b7d4edbc93 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -171,6 +171,7 @@ LIBBPF_0.0.4 {
> >               bpf_object__load_xattr;
> >               bpf_program__attach_kprobe;
> >               bpf_program__attach_perf_event;
> > +             bpf_program__attach_raw_tracepoint;
> >               bpf_program__attach_tracepoint;
> >               bpf_program__attach_uprobe;
> >               btf_dump__dump_type;
> >
