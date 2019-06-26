Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4456189
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 06:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfFZEpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 00:45:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:47101 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfFZEpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 00:45:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id x18so557923qkn.13;
        Tue, 25 Jun 2019 21:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VEPY8UjfFAYNda4yFr7vjJw3sVyZMI2NFnMjG+Cp1Ys=;
        b=cpVIAabEsQay2BeDTyBkxoi7dP2Jb49WJmzwdQtmOFjpytNecJI/WPa1JacVny7q0T
         l0bB7HOtYUfx7xSm/VS9/zUnx9fYGPW2Mxz0Dc1NDhXWZt2K6PQj2Q4C2d0a27h1Z8kg
         /8saIep8d7tnBT3cE0IxMMlbv9gcvp4wU6jlkWRE/Clb9NqvCXYTrYElt91l1FoM9WMi
         nmLPyOOeydM9luSjIYFsoNiPC+J6bgn1dwG7IbRouyl4iNK2GNL52TK1NYMsJv5rLV7F
         8kC7dTsWdoFGsjSyE/BHHQX4LPLDBCRCx+PS91SPRw9fYos1uhxir29PPYPilL7/TdMp
         RDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VEPY8UjfFAYNda4yFr7vjJw3sVyZMI2NFnMjG+Cp1Ys=;
        b=jW1vbzEANiIyy1Qe0AFA+7fDJKhhN3XFdZpP8ZoYXxEjwijjLzjZgn8B4WLN8I6DZ+
         a9Pifx8Ix3vDY8evi9d6y3hBi5Jbpvc/gKhMGZUNN/OjzKUdglB+BeEqo5MdzLL1h233
         kfO9vZW5c8tq+hlydE6pZyZJn7nAus17kVwbcQNSDRt85KSbSj/IWdxX/iW/L85LwvPM
         raeduSVGcXdiDDMtwHhWyXWjHCF41I/QYtNNMLBnwS7Xv+/sBY8e58Dtk/ATVgnHyhQx
         KaxfxUtVdXF5Ol9AUByYdD3SFK4oyDI1e9EG8cY1TINgX+OzwT1PQs9sE2Zpnh6UaDjw
         UhFw==
X-Gm-Message-State: APjAAAUIGHu5nu26Bc6yVxzNUP9oaK9hDpMCroAxIPu6KsfO+McIw+yc
        8jBVFnW8/Q17hDrMPESCMoFrAhTZ9vS774f3Bzi1T21CMTo=
X-Google-Smtp-Source: APXvYqwaAbo5SQiYU71OsnlhjKZpe6UDd49icHySfEdDwviFt5wv+onIZEIWFHc+zHNFkqmQ2igCY1ivtk0t8i/2K0c=
X-Received: by 2002:ae9:d803:: with SMTP id u3mr2100160qkf.437.1561524304866;
 Tue, 25 Jun 2019 21:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190625232601.3227055-1-andriin@fb.com> <20190625232601.3227055-2-andriin@fb.com>
 <CAPhsuW6FeBHHNgT3OA6x6i9kVsKutnVR46DFdkeG0cggaKbTnQ@mail.gmail.com>
In-Reply-To: <CAPhsuW6FeBHHNgT3OA6x6i9kVsKutnVR46DFdkeG0cggaKbTnQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 Jun 2019 21:44:52 -0700
Message-ID: <CAEf4BzYe0pz3Qa_xA0Du-mxh=OPSdu3gChUekjaGJ9UgwjyFLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: add perf buffer reading API
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 7:19 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Tue, Jun 25, 2019 at 4:28 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF program
> > to user space for additional processing. libbpf already has very low-level API
> > to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's hard to
> > use and requires a lot of code to set everything up. This patch adds
> > perf_buffer abstraction on top of it, abstracting setting up and polling
> > per-CPU logic into simple and convenient API, similar to what BCC provides.
> >
> > perf_buffer__new() sets up per-CPU ring buffers and updates corresponding BPF
> > map entries. It accepts two user-provided callbacks: one for handling raw
> > samples and one for get notifications of lost samples due to buffer overflow.
> >
> > perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
> > utilizing epoll instance.
> >
> > perf_buffer__free() does corresponding clean up and unsets FDs from BPF map.
> >
> > All APIs are not thread-safe. User should ensure proper locking/coordination if
> > used in multi-threaded set up.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Overall looks good. Some nit below.

Thanks for review!

>
> > ---
> >  tools/lib/bpf/libbpf.c   | 282 +++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |  12 ++
> >  tools/lib/bpf/libbpf.map |   5 +-
> >  3 files changed, 298 insertions(+), 1 deletion(-)
>
> [...]
>
> > +struct perf_buffer *perf_buffer__new(struct bpf_map *map, size_t page_cnt,
> > +                                    perf_buffer_sample_fn sample_cb,
> > +                                    perf_buffer_lost_fn lost_cb, void *ctx)
> > +{
> > +       char msg[STRERR_BUFSIZE];
> > +       struct perf_buffer *pb;
> > +       int err, cpu;
> > +
> > +       if (bpf_map__def(map)->type != BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
> > +               pr_warning("map '%s' should be BPF_MAP_TYPE_PERF_EVENT_ARRAY\n",
> > +                          bpf_map__name(map));
> > +               return ERR_PTR(-EINVAL);
> > +       }
> > +       if (bpf_map__fd(map) < 0) {
> > +               pr_warning("map '%s' doesn't have associated FD\n",
> > +                          bpf_map__name(map));
> > +               return ERR_PTR(-EINVAL);
> > +       }
> > +       if (page_cnt & (page_cnt - 1)) {
> > +               pr_warning("page count should be power of two, but is %zu\n",
> > +                          page_cnt);
> > +               return ERR_PTR(-EINVAL);
> > +       }
> > +
> > +       pb = calloc(1, sizeof(*pb));
> > +       if (!pb)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       pb->sample_cb = sample_cb;
> > +       pb->lost_cb = lost_cb;
>
> I think we need to check sample_cb != NULL && lost_cb != NULL.

I was thinking about making them all either optional or required, but
eventually decided on making sample_cb required and lost_cb optional,
as in practice rarely sample_cb wouldn't be provided, while not every
application would care about handling lost samples (as there is little
you can do about that, except for bumping some counter).

As for checking for NULL. I feel like that's overkill. If someone
provided NULL for sample_cb, they will get SIGSEGV with stack trace
immediately showing that's it's sample_cb being NULL. Unlike Java, C
libraries tend not to double-check every pointer for NULL. Checking
for things like whether map has FD or is of correct type is valuable,
because if you don't check it early, then you'll just eventually get
-EINVAL from kernel and will start a guessing game of what's wrong.
Checking for callback to be non-null feels unnecessary, as it will be
immediately obvious (and it's quite unlikely this will happen in
practice).

>
> > +       pb->ctx = ctx;
> > +       pb->page_size = getpagesize();
> > +       pb->mmap_size = pb->page_size * page_cnt;
> > +       pb->mapfd = bpf_map__fd(map);
> > +
> > +       pb->epfd = epoll_create1(EPOLL_CLOEXEC);
> [...]
> > +perf_buffer__process_record(struct perf_event_header *e, void *ctx)
> > +{
> > +       struct perf_buffer *pb = ctx;
> > +       void *data = e;
> > +
> > +       switch (e->type) {
> > +       case PERF_RECORD_SAMPLE: {
> > +               struct perf_sample_raw *s = data;
> > +
> > +               pb->sample_cb(pb->ctx, s->data, s->size);
> > +               break;
> > +       }
> > +       case PERF_RECORD_LOST: {
> > +               struct perf_sample_lost *s = data;
> > +
> > +               if (pb->lost_cb)
> > +                       pb->lost_cb(pb->ctx, s->lost);
>
> OK, we test lost_cb here, so not necessary at init time.
>
> [...]
> >                 bpf_program__attach_perf_event;
> >                 bpf_program__attach_raw_tracepoint;
> >                 bpf_program__attach_tracepoint;
> >                 bpf_program__attach_uprobe;
> > +               btf__parse_elf;
>
> Why move btf__parse_elf ?

I realized that I haven't put it in correct alphabetical order,
decided to fix it here, as it's just a single line change.

>
> Thanks,
> Song
