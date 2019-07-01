Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1282D5C5B1
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfGAWcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:32:47 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37306 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfGAWcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:32:47 -0400
Received: by mail-qt1-f195.google.com with SMTP id y57so16451385qtk.4;
        Mon, 01 Jul 2019 15:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a95GT78PT5iseFERN5E9tWGnMuxmlQAAqyBHQQVhorA=;
        b=kKukLsDs9E5ETEzMmHtQ/KKedJiXMJQYSOsyJ+f/7X6lTeBol208DpugsqcarINB2r
         PCJh2ueX5SfKOMO1srfZ5ZZqs6CKhsaDJzDgZmj9RSaFs4ChplV5qDQ+nWvXuqyEPkHK
         JE1s2C2oGfVZuyqVL42m2KXg2woFfL6Vp2I/uYG/uYek3dsiarnUlVcymwx2/TENBvXy
         D5uGtY2VOyW21US8evG98b6rcvJpyRifwAcVbhuBElH0yKVaYsYFjixKYlivXcGYw4zt
         ieG9sg36pGrB19WgNrhV8Y6Z0Vr6B+1Zg2rMqYq6ChaPHqhz1PCPjdOIEVni7R7rkHnG
         F+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a95GT78PT5iseFERN5E9tWGnMuxmlQAAqyBHQQVhorA=;
        b=HGMcvNJ5qI9qCDDjPM4OacZfsoBIhFwoK5fgoRktk9jym2RVfKYgCqJc698q31BSEC
         j2Oq0sPLPO0MuqOnuPx6jkXPmViwZ2hbdvLRTMjuTRoTr1AenzBvOUoCiEnDAh9TRbir
         dpz6l9fqzuGiT9UAqVlKYeufXa2s1ePE3fVB/ShHtli6eSnB5+145wBgiGDQRgnUBkXk
         0iCK3tzU8Xny/UWEX41O1L/cFj8qDQQ9SdO7sKNh4+2KXhCzr/5bdQZNrZAG8dZh6rOj
         SgOu3rey043NgjlXXfip1gxnSD6Tf2FJ/avL/znq6U1mZ2T9/XR5kEeBMNjXfXMDpEPo
         H6gQ==
X-Gm-Message-State: APjAAAUIQMSfzz2JkmOcTLxbzUdZMJCeHaP/2ai0v4PXAv6wufrGZBQ4
        KhDht6A39YEGXxS3W8b6SdIRqb5l61RnPAxXk/k=
X-Google-Smtp-Source: APXvYqzqEQ7z2t/Qlj5Xr3N1yRJoVFc81uW3FsFmKy90vtlHCurqLTs6X4+lpFBCFpeyXR0XP6kgL6zG9Iy/uPNOfR0=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr22095425qty.141.1562020365582;
 Mon, 01 Jul 2019 15:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-8-andriin@fb.com>
 <60e7bee0-0ab9-dacb-0211-6b93c94f603c@fb.com>
In-Reply-To: <60e7bee0-0ab9-dacb-0211-6b93c94f603c@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 15:32:34 -0700
Message-ID: <CAEf4BzbDP=e+jVUBJjCUpPCewxp7-Uwq9L5TuPfUzn9j9MxUeg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 7/9] selftests/bpf: switch test to new
 attach_perf_event API
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

On Mon, Jul 1, 2019 at 10:16 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/19 8:49 PM, Andrii Nakryiko wrote:
> > Use new bpf_program__attach_perf_event() in test previously relying on
> > direct ioctl manipulations.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > ---
> >   .../bpf/prog_tests/stacktrace_build_id_nmi.c  | 31 +++++++++----------
> >   1 file changed, 15 insertions(+), 16 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> > index 1c1a2f75f3d8..9557b7dfb782 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> > @@ -17,6 +17,7 @@ static __u64 read_perf_max_sample_freq(void)
> >   void test_stacktrace_build_id_nmi(void)
> >   {
> >       int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
> > +     const char *prog_name = "tracepoint/random/urandom_read";
> >       const char *file = "./test_stacktrace_build_id.o";
> >       int err, pmu_fd, prog_fd;
> >       struct perf_event_attr attr = {
> > @@ -25,7 +26,9 @@ void test_stacktrace_build_id_nmi(void)
> >               .config = PERF_COUNT_HW_CPU_CYCLES,
> >       };
> >       __u32 key, previous_key, val, duration = 0;
> > +     struct bpf_program *prog;
> >       struct bpf_object *obj;
> > +     struct bpf_link *link;
> >       char buf[256];
> >       int i, j;
> >       struct bpf_stack_build_id id_offs[PERF_MAX_STACK_DEPTH];
> > @@ -39,6 +42,10 @@ void test_stacktrace_build_id_nmi(void)
> >       if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
> >               return;
> >
> > +     prog = bpf_object__find_program_by_title(obj, prog_name);
> > +     if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
> > +             goto close_prog;
> > +
> >       pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
> >                        0 /* cpu 0 */, -1 /* group id */,
> >                        0 /* flags */);
> > @@ -47,15 +54,12 @@ void test_stacktrace_build_id_nmi(void)
> >                 pmu_fd, errno))
> >               goto close_prog;
> >
> > -     err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> > -     if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n",
> > -               err, errno))
> > -             goto close_pmu;
> > -
> > -     err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> > -     if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n",
> > -               err, errno))
> > -             goto disable_pmu;
> > +     link = bpf_program__attach_perf_event(prog, pmu_fd);
> > +     if (CHECK(IS_ERR(link), "attach_perf_event",
> > +               "err %ld\n", PTR_ERR(link))) {
> > +             close(pmu_fd);
> > +             goto close_prog;
> > +     }
> >
> >       /* find map fds */
> >       control_map_fd = bpf_find_map(__func__, obj, "control_map");
> > @@ -134,8 +138,7 @@ void test_stacktrace_build_id_nmi(void)
> >        * try it one more time.
> >        */
> >       if (build_id_matches < 1 && retry--) {
> > -             ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> > -             close(pmu_fd);
> > +             bpf_link__destroy(link);
> >               bpf_object__close(obj);
> >               printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
> >                      __func__);
> > @@ -154,11 +157,7 @@ void test_stacktrace_build_id_nmi(void)
> >        */
> >
> >   disable_pmu:
> > -     ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
> > -
> > -close_pmu:
> > -     close(pmu_fd);
> > -
> > +     bpf_link__destroy(link);
>
> There is a problem in bpf_link__destroy(link).
> The "link = bpf_program__attach_perf_event(prog, pmu_fd)"
> may be an error pointer (IS_ERR(link) is true), in which
> case, link should be reset to NULL and then call
> bpf_link__destroy(link). Otherwise, the program may
> segfault or function incorrectly.

Not really, if bpf_program__attach_perf_event fails and IS_ERR(link)
is true, we'll close pmu_fd explicitly and `goto close_prog` bypassing
bpf_link__destroy. `goto disable_pmu` is done only after we
successfully established attached link.

So unless I still miss something, I think this will work reliably.

>
> >   close_prog:
> >       bpf_object__close(obj);
> >   }
> >
