Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021571222C9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfLQEBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:01:42 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:46839 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLQEBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:01:42 -0500
Received: by mail-vk1-f193.google.com with SMTP id u6so2282726vkn.13;
        Mon, 16 Dec 2019 20:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SxvvCplFFbGKcu6AZIZXxAmOWVIjgVE9X9cnFKHMVGI=;
        b=bLG+ioMwsCkYUC2kt1SK+bBL9QjX1/1rtB8EX/RHQ6xZDXyAXTEcRJCT3iqyNInx4x
         nMK9g9caPcPUQZ19TDJxYCyMM+5g4A1YD/0+GqE2u/XWqiPKERzlsVOgox3mjjmlRKhJ
         uDIPaSenmbaDqGD66DpEsS+bgXytQufKnHDGDUtTqA6T9z7vQTY6t2swCgn1BU/V28jD
         4ayFmj2/vXSodeEDAY7lYgQZMCeEcq2/NVb6YlmMEA8H+gPEV72yWeKIV/D6Rmr3UT9f
         /jVkZrv8FU1iFCxkinxVMzXI6y2Z3Dd3nLInnFZQqTirjMLm/0KBYMDQOWtpCHPrFAmy
         7xZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SxvvCplFFbGKcu6AZIZXxAmOWVIjgVE9X9cnFKHMVGI=;
        b=N5KNh2YsbAGlnWKqFlLyRZ6ERxNMqBXQViPsrFJtnGVyMZhnSmYq2JkIJmhy1sNCjZ
         GHLnCrSJ7FbktEWK09s4d9QhSxQqSz5pSsPFBTPmsZCUQHkFLGO82HhDdn1DjFvAaAvJ
         Nwh0mkXcGLFCgUqfs/Fh0tARL4OevG5dzKanHexOuaOSHODWpmDQhcupUl4OL+sxh0WO
         kIni1fiRSTnscequeytBEnm2rxPMpxbFVQ8HRpTtVx2bx20BExwL3wtBgQqNua1NIc67
         0ja+Ls/AlTUUBwQaMNZjIh3Uv9g+f7Ki0/jna3PKkX603nbEtwUFA7cLNjYr2WCREg1v
         RyrA==
X-Gm-Message-State: APjAAAVPO03NLYF45yxVriQ4zF1pqlPDrqA9b/VAn9TWTchz9wHblX1L
        8+30f/1/HZ+pMPpGctGQWSiZYTEYtl4yG/3pYsw=
X-Google-Smtp-Source: APXvYqz4M+iNhpp230LbB61NwArFR0M8wh0oPOmlNkigs5BQqgFQMHPy89TwgZ8q1uW98kUmbr8ltuzeK0GIa9tjTy8=
X-Received: by 2002:a1f:8cd5:: with SMTP id o204mr1787920vkd.66.1576555300995;
 Mon, 16 Dec 2019 20:01:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576381511.git.ethercflow@gmail.com> <088f1485865016d639cadc891957918060261405.1576381512.git.ethercflow@gmail.com>
 <737b90af-aa51-bd7d-8f68-b68050cbb028@fb.com>
In-Reply-To: <737b90af-aa51-bd7d-8f68-b68050cbb028@fb.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Tue, 17 Dec 2019 12:01:29 +0800
Message-ID: <CABtjQmZtzZT+OmZCn=eL9pvTeeCQ+TzKUMGgFJcGzwJDqyk6vw@mail.gmail.com>
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

> In non-bpf .c file, typically we do not add 'inline' attribute.
> It is up to compiler to decide whether it should be inlined.

Thank you, I'll fix this.

> > +struct sys_enter_newfstat_args {
> > +     unsigned long long pad1;
> > +     unsigned long long pad2;
> > +     unsigned int fd;
> > +};

> The BTF generated vmlinux.h has the following structure,
> struct trace_entry {
>          short unsigned int type;
>          unsigned char flags;
>          unsigned char preempt_count;
>          int pid;
> };
> struct trace_event_raw_sys_enter {
>          struct trace_entry ent;
>          long int id;
>          long unsigned int args[6];
>          char __data[0];
> };

> The third parameter type should be long, otherwise,
> it may have issue on big endian machines?

Sorry, I don't understand why there is a problem on big-endian machines.
Would you please explain that in more detail? Thank you.

Yonghong Song <yhs@fb.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=8816=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8812:25=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 12/14/19 8:01 PM, Wenbo Zhang wrote:
> > trace fstat events by tracepoint syscalls/sys_enter_newfstat, and handl=
e
> > events only produced by test_file_get_path, which call fstat on several
> > different types of files to test bpf_get_file_path's feature.
> >
> > v4->v5: addressed Andrii's feedback
> > - pass NULL for opts as bpf_object__open_file's PARAM2, as not really
> > using any
> > - modify patch subject to keep up with test code
> > - as this test is single-threaded, so use getpid instead of SYS_gettid
> > - remove unnecessary parens around check which after if (i < 3)
> > - in kern use bpf_get_current_pid_tgid() >> 32 to fit getpid() in
> > userspace part
> > - with the patch adding helper as one patch series
> >
> > v3->v4: addressed Andrii's feedback
> > - use a set of fd instead of fds array
> > - use global variables instead of maps (in v3, I mistakenly thought tha=
t
> > the bpf maps are global variables.)
> > - remove uncessary global variable path_info_index
> > - remove fd compare as the fstat's order is fixed
> >
> > v2->v3: addressed Andrii's feedback
> > - use global data instead of perf_buffer to simplified code
> >
> > v1->v2: addressed Daniel's feedback
> > - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> > helper's names
> >
> > Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> > ---
> >   .../selftests/bpf/prog_tests/get_file_path.c  | 171 +++++++++++++++++=
+
> >   .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
> >   2 files changed, 214 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_pa=
th.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_pa=
th.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/t=
ools/testing/selftests/bpf/prog_tests/get_file_path.c
> > new file mode 100644
> > index 000000000000..7ec11e43e0fc
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> > @@ -0,0 +1,171 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <test_progs.h>
> > +#include <sys/stat.h>
> > +#include <linux/sched.h>
> > +#include <sys/syscall.h>
> > +
> > +#define MAX_PATH_LEN         128
> > +#define MAX_FDS                      7
> > +#define MAX_EVENT_NUM                16
> > +
> > +static struct file_path_test_data {
> > +     pid_t pid;
> > +     __u32 cnt;
> > +     __u32 fds[MAX_EVENT_NUM];
> > +     char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +} src, dst;
> > +
> > +static inline int set_pathname(int fd)
>
> In non-bpf .c file, typically we do not add 'inline' attribute.
> It is up to compiler to decide whether it should be inlined.
>
> > +{
> > +     char buf[MAX_PATH_LEN];
> > +
> > +     snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", src.pid, fd);
> > +     src.fds[src.cnt] =3D fd;
> > +     return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
> > +}
> > +
> [...]
> > diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/t=
ools/testing/selftests/bpf/progs/test_get_file_path.c
> > new file mode 100644
> > index 000000000000..eae663c1262a
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
> > @@ -0,0 +1,43 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/ptrace.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +#include "bpf_helpers.h"
> > +#include "bpf_tracing.h"
> > +
> > +#define MAX_PATH_LEN         128
> > +#define MAX_EVENT_NUM                16
> > +
> > +static struct file_path_test_data {
> > +     pid_t pid;
> > +     __u32 cnt;
> > +     __u32 fds[MAX_EVENT_NUM];
> > +     char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +} data;
> > +
> > +struct sys_enter_newfstat_args {
> > +     unsigned long long pad1;
> > +     unsigned long long pad2;
> > +     unsigned int fd;
> > +};
>
> The BTF generated vmlinux.h has the following structure,
> struct trace_entry {
>          short unsigned int type;
>          unsigned char flags;
>          unsigned char preempt_count;
>          int pid;
> };
> struct trace_event_raw_sys_enter {
>          struct trace_entry ent;
>          long int id;
>          long unsigned int args[6];
>          char __data[0];
> };
>
> The third parameter type should be long, otherwise,
> it may have issue on big endian machines?
