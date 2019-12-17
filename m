Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E38F1227D7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLQJoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:44:22 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:43876 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQJoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 04:44:22 -0500
Received: by mail-vs1-f68.google.com with SMTP id x4so6046234vsx.10;
        Tue, 17 Dec 2019 01:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H/5NcrJGu3CjoG+hc50b8vgyXhwzQCm3cF8uGW+Z5Dw=;
        b=uAfULoxiQye70sBlIeX9wo8ItlYRNp8GDLUjMKQLKTkQUT4gA+brV9mHgprqClssE/
         IbD+VFAXW6549zx14sozJkFVFEXM3hkGC/iVQ8uuW8O3wNX0Y7T82teUyfaUPl2chLla
         mx2HVDfx2iitbUdHSZIcNj3ED9dYMERTRuFCCg5cgqXUnax1m5KTk6tShrk8n4gnx0rH
         rWkojdcQbuZq38N9FnvZU7lHcXosAZYOzaoNVaiHrgPvig5fGfEWjI+e+xjg1nHavnFF
         bu2G9xHdnfzzjj+PSUxpNVLy05pwibRS7EvV1JuhZYqVCyifRulry+rhNt8VULGW+ap2
         cIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H/5NcrJGu3CjoG+hc50b8vgyXhwzQCm3cF8uGW+Z5Dw=;
        b=ZmnwpCvrVvLPIM7/V9TNB/e/hSllKat7WTuSJ/U8Bzz11NBECf9oA3iVyvBjrqkvDq
         E2tfEqayHV28TywFzM6hEOiDNRnrMsQAq9Hd2JDxTkTajkzn2cE55r2QFfQlgUrGmFyz
         KxeDym+WETksirR+0YN73vwUgHq4en4wOcQvqvGbUBHj7/bDDb//BFrYASdgDMhBdX13
         URp3S/1qTK0494HQZrhOEn7pxM2Fb6rxNME4m57uZOi0XUdDzPDhcgD/MxbxAJgvp5vz
         /VR5+1RirQbX8418pCJeF4t0PzkCh1a82MhTxfTOy3+MWo6h9tsHNIYK2UUUbVZL7b7+
         iEjw==
X-Gm-Message-State: APjAAAUkHQtr8uvAUwhlwoFTbrn8LejrpVyhwlaDcjzuPAwAtMkrJnJk
        gsnF5wJCNZzk2tm8/QUwSlx9mGsaLrFg0bDyHt4=
X-Google-Smtp-Source: APXvYqy+3+fxVvyCQPgbavAlnkEPcV1KXs36vzU/hAeaEnOLVZzzFgoygtXfvYMGEddBXoz9zQH44Zblpjw7ZZh3KPw=
X-Received: by 2002:a67:ed07:: with SMTP id l7mr2153176vsp.47.1576575860599;
 Tue, 17 Dec 2019 01:44:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576381511.git.ethercflow@gmail.com> <088f1485865016d639cadc891957918060261405.1576381512.git.ethercflow@gmail.com>
 <737b90af-aa51-bd7d-8f68-b68050cbb028@fb.com> <CABtjQmZtzZT+OmZCn=eL9pvTeeCQ+TzKUMGgFJcGzwJDqyk6vw@mail.gmail.com>
 <71c53be6-add4-2557-bc8f-8acb8e4a2f39@fb.com>
In-Reply-To: <71c53be6-add4-2557-bc8f-8acb8e4a2f39@fb.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Tue, 17 Dec 2019 17:44:09 +0800
Message-ID: <CABtjQmYOQy05W8PfK1d--cdWu7hkTGbkm_4gEZp8HBKNPfPddQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v12 2/2] selftests/bpf: test for
 bpf_get_file_path() from tracepoint
To:     Yonghong Song <yhs@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The kernel will actually have 8 bytes of memory to store fd
> based on trace_event_raw_sys_enter.

> For little endian machine, the lower 4 bytes are read based on
> your sys_enter_newfstat_args, which is "accidentally" the lower
> 4 bytes in u64, so you get the correct answer.

> For big endian machine, the lower 4 bytes read based on
> your sys_enter_newfstat_args will be high 4 bytes in u64, which
> is incorrect.

Oh, get it. Thank you, I'll fix this in the next version.

Yonghong Song <yhs@fb.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=8817=E6=97=A5=E5=
=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=8812:14=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 12/16/19 8:01 PM, Wenbo Zhang wrote:
> >> In non-bpf .c file, typically we do not add 'inline' attribute.
> >> It is up to compiler to decide whether it should be inlined.
> >
> > Thank you, I'll fix this.
> >
> >>> +struct sys_enter_newfstat_args {
> >>> +     unsigned long long pad1;
> >>> +     unsigned long long pad2;
> >>> +     unsigned int fd;
> >>> +};
> >
> >> The BTF generated vmlinux.h has the following structure,
> >> struct trace_entry {
> >>           short unsigned int type;
> >>           unsigned char flags;
> >>           unsigned char preempt_count;
> >>           int pid;
> >> };
> >> struct trace_event_raw_sys_enter {
> >>           struct trace_entry ent;
> >>           long int id;
> >>           long unsigned int args[6];
> >>           char __data[0];
> >> };
> >
> >> The third parameter type should be long, otherwise,
> >> it may have issue on big endian machines?
> >
> > Sorry, I don't understand why there is a problem on big-endian machines=
.
> > Would you please explain that in more detail? Thank you.
>
> The kernel will actually have 8 bytes of memory to store fd
> based on trace_event_raw_sys_enter.
>
> For little endian machine, the lower 4 bytes are read based on
> your sys_enter_newfstat_args, which is "accidentally" the lower
> 4 bytes in u64, so you get the correct answer.
>
> For big endian machine, the lower 4 bytes read based on
> your sys_enter_newfstat_args will be high 4 bytes in u64, which
> is incorrect.
>
> >
> > Yonghong Song <yhs@fb.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=8816=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8812:25=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >>
> >>
> >> On 12/14/19 8:01 PM, Wenbo Zhang wrote:
> >>> trace fstat events by tracepoint syscalls/sys_enter_newfstat, and han=
dle
> >>> events only produced by test_file_get_path, which call fstat on sever=
al
> >>> different types of files to test bpf_get_file_path's feature.
> >>>
> >>> v4->v5: addressed Andrii's feedback
> >>> - pass NULL for opts as bpf_object__open_file's PARAM2, as not really
> >>> using any
> >>> - modify patch subject to keep up with test code
> >>> - as this test is single-threaded, so use getpid instead of SYS_getti=
d
> >>> - remove unnecessary parens around check which after if (i < 3)
> >>> - in kern use bpf_get_current_pid_tgid() >> 32 to fit getpid() in
> >>> userspace part
> >>> - with the patch adding helper as one patch series
> >>>
> >>> v3->v4: addressed Andrii's feedback
> >>> - use a set of fd instead of fds array
> >>> - use global variables instead of maps (in v3, I mistakenly thought t=
hat
> >>> the bpf maps are global variables.)
> >>> - remove uncessary global variable path_info_index
> >>> - remove fd compare as the fstat's order is fixed
> >>>
> >>> v2->v3: addressed Andrii's feedback
> >>> - use global data instead of perf_buffer to simplified code
> >>>
> >>> v1->v2: addressed Daniel's feedback
> >>> - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> >>> helper's names
> >>>
> >>> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> >>> ---
> >>>    .../selftests/bpf/prog_tests/get_file_path.c  | 171 ++++++++++++++=
++++
> >>>    .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
> >>>    2 files changed, 214 insertions(+)
> >>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file=
_path.c
> >>>    create mode 100644 tools/testing/selftests/bpf/progs/test_get_file=
_path.c
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b=
/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> >>> new file mode 100644
> >>> index 000000000000..7ec11e43e0fc
> >>> --- /dev/null
> >>> +++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> >>> @@ -0,0 +1,171 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +#define _GNU_SOURCE
> >>> +#include <test_progs.h>
> >>> +#include <sys/stat.h>
> >>> +#include <linux/sched.h>
> >>> +#include <sys/syscall.h>
> >>> +
> >>> +#define MAX_PATH_LEN         128
> >>> +#define MAX_FDS                      7
> >>> +#define MAX_EVENT_NUM                16
> >>> +
> >>> +static struct file_path_test_data {
> >>> +     pid_t pid;
> >>> +     __u32 cnt;
> >>> +     __u32 fds[MAX_EVENT_NUM];
> >>> +     char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> >>> +} src, dst;
> >>> +
> >>> +static inline int set_pathname(int fd)
> >>
> >> In non-bpf .c file, typically we do not add 'inline' attribute.
> >> It is up to compiler to decide whether it should be inlined.
> >>
> >>> +{
> >>> +     char buf[MAX_PATH_LEN];
> >>> +
> >>> +     snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", src.pid, fd);
> >>> +     src.fds[src.cnt] =3D fd;
> >>> +     return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
> >>> +}
> >>> +
> >> [...]
> >>> diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b=
/tools/testing/selftests/bpf/progs/test_get_file_path.c
> >>> new file mode 100644
> >>> index 000000000000..eae663c1262a
> >>> --- /dev/null
> >>> +++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
> >>> @@ -0,0 +1,43 @@
> >>> +// SPDX-License-Identifier: GPL-2.0
> >>> +
> >>> +#include <linux/bpf.h>
> >>> +#include <linux/ptrace.h>
> >>> +#include <string.h>
> >>> +#include <unistd.h>
> >>> +#include "bpf_helpers.h"
> >>> +#include "bpf_tracing.h"
> >>> +
> >>> +#define MAX_PATH_LEN         128
> >>> +#define MAX_EVENT_NUM                16
> >>> +
> >>> +static struct file_path_test_data {
> >>> +     pid_t pid;
> >>> +     __u32 cnt;
> >>> +     __u32 fds[MAX_EVENT_NUM];
> >>> +     char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> >>> +} data;
> >>> +
> >>> +struct sys_enter_newfstat_args {
> >>> +     unsigned long long pad1;
> >>> +     unsigned long long pad2;
> >>> +     unsigned int fd;
> >>> +};
> >>
> >> The BTF generated vmlinux.h has the following structure,
> >> struct trace_entry {
> >>           short unsigned int type;
> >>           unsigned char flags;
> >>           unsigned char preempt_count;
> >>           int pid;
> >> };
> >> struct trace_event_raw_sys_enter {
> >>           struct trace_entry ent;
> >>           long int id;
> >>           long unsigned int args[6];
> >>           char __data[0];
> >> };
> >>
> >> The third parameter type should be long, otherwise,
> >> it may have issue on big endian machines?
