Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE6D60F1D
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 07:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfGFFyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 01:54:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:47078 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfGFFyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 01:54:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id h21so11026138qtn.13;
        Fri, 05 Jul 2019 22:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SkClHqDZsLZc3Gl/8fvbSk8K/NcNF51u8oeg+tfP/II=;
        b=qpaLa08YpYCHPDP+G++tjiiODMNvd5IgyGopg+gBOVNwKCJFUYhFbeqCywm9JWAKFM
         ws3e9hqPQhnev7h2vVlGHHoRDpddlHMUwsw1byXuqQJ2WIVEQPzy78LWyJsxqBuhheDZ
         JeBbg+q28aVhJMS7BRdfCxkiSIh4Ib4tnYIVwqu8EP/kGBdLL4CqZXnVHgbpu2FcuJdB
         C6uYWzvNM9eckZn6wueKsgAjcEzKhR+cA2sFjRsXoxihsEUYagCcnWYFOlvNEsgB13qc
         XMadLccKSDov3U24WUONzOKYPmH7/W9FfHaIYtAmOaUmEWiflYWGVyK6bU/QTpWQUgFo
         yFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SkClHqDZsLZc3Gl/8fvbSk8K/NcNF51u8oeg+tfP/II=;
        b=VsIoU+HDQoehlLAeMKKenQsffSv+GuE1n7K8mXzV9gqZQN3QRzwNHdyczMBetPV610
         8dqXmKplEo0FTtkyk2PAdKPbh63G17KE5/CaaIyPyqLE1tjMRL9TT8JnGE/yhe327Sq0
         /l0H0MfHHJpoFHrZ1+SBrcpyeej+X8xPfuKh4gUe42vbVtQoFVqvGm3cXfdOt+2cOSvn
         Qi2nVJsqUZTf2dW8b+9p7MBv3l/lV/T64JZR+79BREv+rjcWn5joll9meZhdlX1f9jNs
         dd/wY4TerRYAi+/i6OxKvAvF4hpRw6NMle/tfsWW3CF4b6zpZIMkQpvdHLSp4eghRzO2
         FUrw==
X-Gm-Message-State: APjAAAX/eWsp4U5QcpG6cO3GvrGWtHjP7zoOpgoaiOwgunNkkeffFACF
        TheS9k0UP0upOpJ4USgrg3ru5LCa5fy0MQ1NhkoH2kHPDAE=
X-Google-Smtp-Source: APXvYqxSYZcB/VHZRRCBxarLVJv87Nxq1PlBO4WbUhm+5bX/iMKTIiWfd41vMy8YmiRSryT+IVNKy9yu62cE0OqvFTw=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr5418753qta.171.1562392493722;
 Fri, 05 Jul 2019 22:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190706043522.1559005-1-andriin@fb.com> <20190706043522.1559005-2-andriin@fb.com>
 <e0e2f6d2-016c-70bd-a0c6-5c147d5b7aca@fb.com>
In-Reply-To: <e0e2f6d2-016c-70bd-a0c6-5c147d5b7aca@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Jul 2019 22:54:42 -0700
Message-ID: <CAEf4BzZYAN5t+6Kkt+W4ee13PL7dR4FG8P71dFnk_CHWqMmHPQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 1/5] libbpf: add perf buffer API
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 10:42 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/5/19 9:35 PM, Andrii Nakryiko wrote:
> > BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF p=
rogram
> > to user space for additional processing. libbpf already has very low-le=
vel API
> > to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's =
hard to
> > use and requires a lot of code to set everything up. This patch adds
> > perf_buffer abstraction on top of it, abstracting setting up and pollin=
g
> > per-CPU logic into simple and convenient API, similar to what BCC provi=
des.
> >
> > perf_buffer__new() sets up per-CPU ring buffers and updates correspondi=
ng BPF
> > map entries. It accepts two user-provided callbacks: one for handling r=
aw
> > samples and one for get notifications of lost samples due to buffer ove=
rflow.
> >
> > perf_buffer__new_raw() is similar, but provides more control over how
> > perf events are set up (by accepting user-provided perf_event_attr), ho=
w
> > they are handled (perf_event_header pointer is passed directly to
> > user-provided callback), and on which CPUs ring buffers are created
> > (it's possible to provide a list of CPUs and corresponding map keys to
> > update). This API allows advanced users fuller control.
> >
> > perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
> > utilizing epoll instance.
> >
> > perf_buffer__free() does corresponding clean up and unsets FDs from BPF=
 map.
> >
> > All APIs are not thread-safe. User should ensure proper locking/coordin=
ation if
> > used in multi-threaded set up.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/libbpf.c   | 366 ++++++++++++++++++++++++++++++++++++++=
+
> >   tools/lib/bpf/libbpf.h   |  49 ++++++
> >   tools/lib/bpf/libbpf.map |   4 +
> >   3 files changed, 419 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 2a08eb106221..72149d68b8c1 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -32,7 +32,9 @@
> >   #include <linux/limits.h>
> >   #include <linux/perf_event.h>
> >   #include <linux/ring_buffer.h>
> > +#include <sys/epoll.h>
> >   #include <sys/ioctl.h>
> > +#include <sys/mman.h>
> >   #include <sys/stat.h>
> >   #include <sys/types.h>
> >   #include <sys/vfs.h>
> > @@ -4354,6 +4356,370 @@ bpf_perf_event_read_simple(void *mmap_mem, size=
_t mmap_size, size_t page_size,
> >       return ret;
> >   }
> >
> > +struct perf_buffer;
> > +
> > +struct perf_buffer_params {
> > +     struct perf_event_attr *attr;
> > +     /* if event_cb is specified, it takes precendence */
> > +     perf_buffer_event_fn event_cb;
> > +     /* sample_cb and lost_cb are higher-level common-case callbacks *=
/
> > +     perf_buffer_sample_fn sample_cb;
> > +     perf_buffer_lost_fn lost_cb;
> > +     void *ctx;
> > +     int cpu_cnt;
> > +     int *cpus;
> [...]
> > +
> > +int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
> > +{
> > +     int cnt, err;
> > +
> > +     cnt =3D epoll_wait(pb->epoll_fd, pb->events, pb->cpu_cnt, timeout=
_ms);
> > +     for (int i =3D 0; i < cnt; i++) {
>
> Find one compilation error here.
>
> libbpf.c: In function =E2=80=98perf_buffer__poll=E2=80=99:
> libbpf.c:4728:2: error: =E2=80=98for=E2=80=99 loop initial declarations a=
re only allowed
> in C99 mode
>    for (int i =3D 0; i < cnt; i++) {
>    ^
>

Ah... Fixing, thanks!. How did you compile? make -C tools/lib/bpf
doesn't show this, should we update libbpf Makefile to catch stuff
like this?

> > +             struct perf_cpu_buf *cpu_buf =3D pb->events[i].data.ptr;
> > +
> > +             err =3D perf_buffer__process_records(pb, cpu_buf);
> > +             if (err) {
> > +                     pr_warning("error while processing records: %d\n"=
, err);
> > +                     return err;
> > +             }
> > +     }
> > +     return cnt < 0 ? -errno : cnt;
> > +}
> > +
> >   struct bpf_prog_info_array_desc {
> >       int     array_offset;   /* e.g. offset of jited_prog_insns */
> >       int     count_offset;   /* e.g. offset of jited_prog_len */
> [...]
