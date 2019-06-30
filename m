Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E835AF19
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfF3GoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:44:15 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38672 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfF3GoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:44:15 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so8557502qkk.5;
        Sat, 29 Jun 2019 23:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCLcHU2gnpO9IZQ1PpVF1vMlPkUId5ZuI0eEPAOSg4c=;
        b=uBmg2bad3Cdh7mnUWiWfQJXVUFceYZTqUL0Lzne93fBMy8+s7x2GROOULk6CdjdTlI
         YHbwW/SAroVIDNq2NhlwRlYVsQ0hPwjNbYp9Uz51FmK6CgPbs4xT9hnJX3R2PS434Wc+
         f3kN+HIlcFd2wAUZokkCdHc4pA3GCjiyKV7oxdgUbwJyhFkrzQt4WOoPxFWpnnOrEdCY
         xJnPCcZXJQC2RMBH2pSsHC1dWo/Yt5giT/KWiB5XRTFkqmcOwZ5z0U2XWV5JjkgIlL/C
         1jw4K89DFbfLxbAH/K/+XwK2bdIQPFHevG3/Gu/PEQeXjwOr60a/15lbFICplZ/wT4Lr
         USYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCLcHU2gnpO9IZQ1PpVF1vMlPkUId5ZuI0eEPAOSg4c=;
        b=BBmITYSkYbs3rNQPWcSZ5tRxZqVoNdZrc1KYSIRXpheBRovk4Ggqjk7e2YfovYU3NS
         P+Yx/WDWhoE15ZFh/pEzQ2XwJfCup8KYDqPOILI9m79JjtfaptUMpcRfjuOwdc4iqUYi
         FUQ62mm8QdmHRYRiO0bd+PKVsBFVbONuUxQfzEune6wwXgULqHwGnR4Ju0IxT4UCpIZ9
         gwrKgFwdG4q87Ts5tV9ZVwLheMIh5diE/UssLLU+/lE986ciV2NEcJuT1dQrUsIrJtKW
         y7eOvtWz2MVy+WMz/4Kf+yORZxqNCf1n5dngwYauHy0F0WHfCWw8IJzTdKrVPu/9oPVV
         JGkw==
X-Gm-Message-State: APjAAAWs7bvqwRWSh/TQKMv/63DSUFQrJKFgI26KmUTND72h3NM2Q7Cs
        HoVaeuVj3c2mD395lVXtfMSqUa6woC4ljreINnM=
X-Google-Smtp-Source: APXvYqw3joGbMyCWxDv6WzWINt9JeAkf7WTnXvaYBomCt11K4jfWkGkEGIJ9zy8jEfssVLsr4bLnH2eYEhR1ZtAq4ys=
X-Received: by 2002:a37:a095:: with SMTP id j143mr16271753qke.449.1561877054268;
 Sat, 29 Jun 2019 23:44:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190629055309.1594755-1-andriin@fb.com> <20190629055309.1594755-5-andriin@fb.com>
 <20190629112453.2c46a114@cakuba.netronome.com>
In-Reply-To: <20190629112453.2c46a114@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 29 Jun 2019 23:44:03 -0700
Message-ID: <CAEf4Bza26tJsftxPrNbsdr34vyC9xihuixNnqLhW_+PQNbEcMg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/4] tools/bpftool: switch map event_pipe to
 libbpf's perf_buffer
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re-sending as plain text, first time it somehow turned into HTML... :(


On Sat, Jun 29, 2019 at 11:24 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 28 Jun 2019 22:53:09 -0700, Andrii Nakryiko wrote:
> >       map_info_len = sizeof(map_info);
> >       map_fd = map_parse_fd_and_info(&argc, &argv, &map_info, &map_info_len);
> > -     if (map_fd < 0)
> > +     if (map_fd < 0) {
> > +             p_err("failed to get map info");
>
> Can't do, map_parse_fd_and_info() prints an error already, we can't
> have multiple errors in JSON.

Oh.. I need to be more careful with printing error in bpftool due to
this JSON business... Thanks!

>
> >               return -1;
> > +     }
> >
> >       if (map_info.type != BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
> >               p_err("map is not a perf event array");
> > @@ -205,7 +157,7 @@ int do_event_pipe(int argc, char **argv)
> >                       char *endptr;
> >
> >                       NEXT_ARG();
> > -                     cpu = strtoul(*argv, &endptr, 0);
> > +                     ctx.cpu = strtoul(*argv, &endptr, 0);
> >                       if (*endptr) {
> >                               p_err("can't parse %s as CPU ID", **argv);
> >                               goto err_close_map;
> > @@ -216,7 +168,7 @@ int do_event_pipe(int argc, char **argv)
> >                       char *endptr;
> >
> >                       NEXT_ARG();
> > -                     index = strtoul(*argv, &endptr, 0);
> > +                     ctx.idx = strtoul(*argv, &endptr, 0);
> >                       if (*endptr) {
> >                               p_err("can't parse %s as index", **argv);
> >                               goto err_close_map;
> > @@ -228,45 +180,32 @@ int do_event_pipe(int argc, char **argv)
> >                       goto err_close_map;
> >               }
> >
> > -             do_all = false;
> > +             ctx.all_cpus = false;
> >       }
> >
> > -     if (!do_all) {
> > -             if (index == -1 || cpu == -1) {
> > +     if (!ctx.all_cpus) {
> > +             if (ctx.idx == -1 || ctx.cpu == -1) {
> >                       p_err("cpu and index must be specified together");
> >                       goto err_close_map;
>
> Now that you look at err looks like we're missing an err = -1 assignment
> here?  but...

No need, see below.

>
> >               }
> > -
> > -             nfds = 1;
> >       } else {
> > -             nfds = min(get_possible_cpus(), map_info.max_entries);
> > -             cpu = 0;
> > -             index = 0;
> > +             ctx.cpu = 0;
> > +             ctx.idx = 0;
> >       }
> >
> > -     rings = calloc(nfds, sizeof(rings[0]));
> > -     if (!rings)
> > +     opts.attr = &perf_attr;
> > +     opts.event_cb = print_bpf_output;
> > +     opts.ctx = &ctx;
> > +     opts.cpu_cnt = ctx.all_cpus ? 0 : 1;
> > +     opts.cpus = &ctx.cpu;
> > +     opts.map_keys = &ctx.idx;
> > +
> > +     pb = perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &opts);
> > +     err = libbpf_get_error(pb);
> > +     if (err) {
> > +             p_err("failed to create perf buffer: %s (%d)",
> > +                   strerror(err), err);
> >               goto err_close_map;
> > -
> > -     pfds = calloc(nfds, sizeof(pfds[0]));
> > -     if (!pfds)
> > -             goto err_free_rings;
> > -
> > -     for (i = 0; i < nfds; i++) {
> > -             rings[i].cpu = cpu + i;
> > -             rings[i].key = index + i;
> > -
> > -             rings[i].fd = bpf_perf_event_open(map_fd, rings[i].key,
> > -                                               rings[i].cpu);
> > -             if (rings[i].fd < 0)
> > -                     goto err_close_fds_prev;
> > -
> > -             rings[i].mem = perf_event_mmap(rings[i].fd);
> > -             if (!rings[i].mem)
> > -                     goto err_close_fds_current;
> > -
> > -             pfds[i].fd = rings[i].fd;
> > -             pfds[i].events = POLLIN;
> >       }
> >
> >       signal(SIGINT, int_exit);
> > @@ -277,35 +216,25 @@ int do_event_pipe(int argc, char **argv)
> >               jsonw_start_array(json_wtr);
> >
> >       while (!stop) {
> > -             poll(pfds, nfds, 200);
> > -             for (i = 0; i < nfds; i++)
> > -                     perf_event_read(&rings[i], &tmp_buf, &tmp_buf_sz);
> > +             err = perf_buffer__poll(pb, 200);
> > +             if (err < 0 && err != -EINTR) {
> > +                     p_err("perf buffer polling failed: %s (%d)",
> > +                           strerror(err), err);
> > +                     goto err_close_pb;
> > +             }
> >       }
> > -     free(tmp_buf);
> >
> >       if (json_output)
> >               jsonw_end_array(json_wtr);
> >
> > -     for (i = 0; i < nfds; i++) {
> > -             perf_event_unmap(rings[i].mem);
> > -             close(rings[i].fd);
> > -     }
> > -     free(pfds);
> > -     free(rings);
> > +     perf_buffer__free(pb);
> >       close(map_fd);
> >
> >       return 0;
> >
> > -err_close_fds_prev:
> > -     while (i--) {
> > -             perf_event_unmap(rings[i].mem);
> > -err_close_fds_current:
> > -             close(rings[i].fd);
> > -     }
> > -     free(pfds);
> > -err_free_rings:
> > -     free(rings);
> > +err_close_pb:
> > +     perf_buffer__free(pb);
> >  err_close_map:
> >       close(map_fd);
> > -     return -1;
> > +     return err ? -1 : 0;
>
> ... how can we return 0 on the error path?

Good catch! I initially was going to merge success and error path, but
after seeing how many explicit `err = <something>` I had to do I
abandoned the effort, but forgot to undo this `return -1` change. I'll
return -1 unconditionally.

>
> >  }
>
