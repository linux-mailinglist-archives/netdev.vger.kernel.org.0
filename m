Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4151025BE
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfKSNr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:47:29 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:44013 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSNr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:47:29 -0500
Received: by mail-ua1-f68.google.com with SMTP id k11so6509393ual.10;
        Tue, 19 Nov 2019 05:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gB6LL2IuJ2qWmWm72MuwyFZejYLe1ArO37Ascw9he74=;
        b=lhXZ+eKyWs4qbl1wCIl1FGjBvlkriVtDebbekx7atrDl4bw6x4C6yrm5N+rGx7iXP7
         Bn+CN0lISFs2ODqD8PESDfhfOIxNrOrrH3d6dGVxKYo+zUpnp2yb6zsRrFAKvAhJq2Y+
         YVs8BBraBxa26IjHd6YgU/OKZCDEe6g7XhQiGme7JAz9jjxNK9QE2hjmRC7Y6W03A+J4
         8lDfXXDjkcN3WXRr/9soCHRSC+D18QyQGIfRWB5lNynPWD+kluaLXR0rcSwX4I4myvIk
         ie7W11xgFZ+wo+a2GXtRqdgtOSzdFM3WPD6fkVRNbd+yICw0Lx/93MWKJ05NlYuSJZaL
         k0IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gB6LL2IuJ2qWmWm72MuwyFZejYLe1ArO37Ascw9he74=;
        b=PRpOSfS8xMuD2tGGCQcGVA6iExNF9y6NW/TVzuu+mjzfuKeXOBc+wMdmB3gkca5lAG
         fkVXgoQVIYw6Mc8D/yUnFxRDJhvxMZQb+bX31WC4MEko0J7ZqwfOocoRMqJhuUDZ0rYm
         YAFAbxxB9HrwogEbR64FNS+eWX7DcHozwAxdFO9HyE03Ij0UwI2Fr4EwRIUqx6hgUrGm
         ZSmzAeY9P+i2DRvPrAy/0BkQCCBOZ93JnJfsnjiQM6Fxp56RjA5+a0CAevRfCQGgc4+H
         6jm/rc8/59N0HAqxgzhb/SM2J2cOVRctSsxy2GSNjWpxe7IDNUfdesWj0EbXIRREu0sd
         dmyQ==
X-Gm-Message-State: APjAAAVihaUBx3p0aalprMFPgxGJfMk4Jy1c0D3ud2GuxEWtqtASlQHd
        DY4DqWk8tL3J0sFUKTsy6Ct+aOzWLFEWVaAOWd8IfR3AlTQ=
X-Google-Smtp-Source: APXvYqzuFqJsLFzl+F4ziawHbHd9pBi+ZAU44K3y+jeDwjl2z1mGkP1KC+foqs3nAeA+Y+2DvwYCKFNBIV5hX0gDFv8=
X-Received: by 2002:ab0:189a:: with SMTP id t26mr21072608uag.87.1574171246261;
 Tue, 19 Nov 2019 05:47:26 -0800 (PST)
MIME-Version: 1.0
References: <20191115135901.8114-1-ethercflow@gmail.com> <CAEf4BzZ5sEDDmX4hYJFJ4-rB1ZftZ9=yVv3Y=WNSdLVXA6sipg@mail.gmail.com>
In-Reply-To: <CAEf4BzZ5sEDDmX4hYJFJ4-rB1ZftZ9=yVv3Y=WNSdLVXA6sipg@mail.gmail.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Tue, 19 Nov 2019 21:47:16 +0800
Message-ID: <CABtjQmZ4nnPf7H-gH7dgrefwbECZfP2hyh8_0dgVBr4MdSxWAQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] selftests/bpf: test for bpf_get_file_path()
 from raw tracepoint
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I like this much better, so much simpler BPF program and userspace
> parts has less unnecessary moving pieces. I just have minor nits
> below.

Thank you for your patience, you're so sweet. I've read your comments
and will fix them and resubmit as patchset.

> you can just pass NULL for opts, as you are not really using any

Agree, and I found if opt is NULL,

> const char *obj_file =3D "./test_get_file_path.o";

must be changed to "test_get_file_path.o", or bpf_obj_name_cpy will
return -EINVAL. :)


> your patch subject says "raw tracepoint", but you are really using a
> normal tracepoint here

Sorry for this,  I'll make it keep up with the code

> see comment below, you can just use getpid(), as this test is single-thre=
aded

> you don't have to use thread id, given test_progs is single-threaded,
> so can do (bpf_get_current_pid_tgid() >> 32) here and use getpid() in
> userspace part.

I found I was thinking too much. I thought test_progs maybe
multi-threaded one day,
so I used SYS_gettid. I feel that it is very bad now. It will make
people misunderstand that it
is multi-threaded. Thank you for point it out.

> nit: unnecessary parens around check

Agree, I'll fix this.


Thank you.

Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2019=E5=B9=B411=E6=9C=
=8818=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=882:45=E5=86=99=E9=81=93=
=EF=BC=9A

>
> On Fri, Nov 15, 2019 at 5:59 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
> >
> > trace fstat events by raw tracepoint sys_enter:newfstat, and handle eve=
nts
> > only produced by test_file_get_path, which call fstat on several differ=
ent
> > types of files to test bpf_get_file_path's feature.
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
>
> I like this much better, so much simpler BPF program and userspace
> parts has less unnecessary moving pieces. I just have minor nits
> below.
>
> But I think you should send this patch together with the patch adding
> helper as one patch series. Both patches are either going to get
> accepted together, or declined together; having them as a patch set is
> more meaningful.
>
> >  .../selftests/bpf/prog_tests/get_file_path.c  | 173 ++++++++++++++++++
> >  .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
> >  2 files changed, 216 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_pat=
h.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_pat=
h.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/t=
ools/testing/selftests/bpf/prog_tests/get_file_path.c
> > new file mode 100644
> > index 000000000000..446ee4dd20e2
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> > @@ -0,0 +1,173 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <test_progs.h>
> > +#include <sys/stat.h>
> > +#include <linux/sched.h>
> > +#include <sys/syscall.h>
> > +
> > +#define MAX_PATH_LEN           128
> > +#define MAX_FDS                        7
> > +#define MAX_EVENT_NUM          16
> > +
> > +static struct file_path_test_data {
> > +       pid_t pid;
> > +       __u32 cnt;
> > +       __u32 fds[MAX_EVENT_NUM];
> > +       char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +} src, dst;
> > +
> > +static inline int set_pathname(int fd)
> > +{
> > +       char buf[MAX_PATH_LEN];
> > +
> > +       snprintf(buf, MAX_PATH_LEN, "/proc/%d/fd/%d", src.pid, fd);
> > +       src.fds[src.cnt] =3D fd;
> > +       return readlink(buf, src.paths[src.cnt++], MAX_PATH_LEN);
> > +}
> > +
> > +static int trigger_fstat_events(pid_t pid)
> > +{
> > +       int pipefd[2] =3D { -1, -1 };
> > +       int sockfd =3D -1, procfd =3D -1, devfd =3D -1;
> > +       int localfd =3D -1, indicatorfd =3D -1;
> > +       struct stat fileStat;
> > +       int ret =3D -1;
> > +
> > +       /* unmountable pseudo-filesystems */
> > +       if (CHECK_FAIL(pipe(pipefd) < 0))
> > +               return ret;
> > +       /* unmountable pseudo-filesystems */
> > +       sockfd =3D socket(AF_INET, SOCK_STREAM, 0);
> > +       if (CHECK_FAIL(sockfd < 0))
> > +               goto out_close;
> > +       /* mountable pseudo-filesystems */
> > +       procfd =3D open("/proc/self/comm", O_RDONLY);
> > +       if (CHECK_FAIL(procfd < 0))
> > +               goto out_close;
> > +       devfd =3D open("/dev/urandom", O_RDONLY);
> > +       if (CHECK_FAIL(devfd < 0))
> > +               goto out_close;
> > +       localfd =3D open("/tmp/fd2path_loadgen.txt", O_CREAT|O_RDONLY);
> > +       if (CHECK_FAIL(localfd < 0))
> > +               goto out_close;
> > +       /* bpf_get_file_path will return path with (deleted) */
> > +       remove("/tmp/fd2path_loadgen.txt");
> > +       indicatorfd =3D open("/tmp/", O_PATH);
> > +       if (CHECK_FAIL(indicatorfd < 0))
> > +               goto out_close;
> > +
> > +       src.pid =3D pid;
> > +
> > +       ret =3D set_pathname(pipefd[0]);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret =3D set_pathname(pipefd[1]);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret =3D set_pathname(sockfd);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret =3D set_pathname(procfd);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret =3D set_pathname(devfd);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret =3D set_pathname(localfd);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +       ret =3D set_pathname(indicatorfd);
> > +       if (CHECK_FAIL(ret < 0))
> > +               goto out_close;
> > +
> > +       fstat(pipefd[0], &fileStat);
> > +       fstat(pipefd[1], &fileStat);
> > +       fstat(sockfd, &fileStat);
> > +       fstat(procfd, &fileStat);
> > +       fstat(devfd, &fileStat);
> > +       fstat(localfd, &fileStat);
> > +       fstat(indicatorfd, &fileStat);
> > +
> > +out_close:
> > +       close(indicatorfd);
> > +       close(localfd);
> > +       close(devfd);
> > +       close(procfd);
> > +       close(sockfd);
> > +       close(pipefd[1]);
> > +       close(pipefd[0]);
> > +
> > +       return ret;
> > +}
> > +
> > +void test_get_file_path(void)
> > +{
> > +       const char *prog_name =3D "tracepoint/syscalls/sys_enter_newfst=
at";
> > +       const char *obj_file =3D "./test_get_file_path.o";
> > +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, );
> > +       int err, results_map_fd, duration =3D 0;
> > +       struct bpf_program *tp_prog =3D NULL;
> > +       struct bpf_link *tp_link =3D NULL;
> > +       struct bpf_object *obj =3D NULL;
> > +       const int zero =3D 0;
> > +
> > +       obj =3D bpf_object__open_file(obj_file, &opts);
>
> you can just pass NULL for opts, as you are not really using any
>
> > +       if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(ob=
j)))
> > +               return;
> > +
> > +       tp_prog =3D bpf_object__find_program_by_title(obj, prog_name);
> > +       if (CHECK(!tp_prog, "find_tp",
> > +                 "prog '%s' not found\n", prog_name))
> > +               goto cleanup;
> > +
> > +       err =3D bpf_object__load(obj);
> > +       if (CHECK(err, "obj_load", "err %d\n", err))
> > +               goto cleanup;
> > +
> > +       results_map_fd =3D bpf_find_map(__func__, obj, "test_get.bss");
> > +       if (CHECK(results_map_fd < 0, "find_bss_map",
> > +                 "err %d\n", results_map_fd))
> > +               goto cleanup;
> > +
> > +       tp_link =3D bpf_program__attach_tracepoint(tp_prog, "syscalls",
> > +                                                "sys_enter_newfstat");
>
> your patch subject says "raw tracepoint", but you are really using a
> normal tracepoint here
>
> > +       if (CHECK(IS_ERR(tp_link), "attach_tp",
> > +                 "err %ld\n", PTR_ERR(tp_link))) {
> > +               tp_link =3D NULL;
> > +               goto cleanup;
> > +       }
> > +
> > +       dst.pid =3D syscall(SYS_gettid);
>
> see comment below, you can just use getpid(), as this test is single-thre=
aded
>
> > +       err =3D bpf_map_update_elem(results_map_fd, &zero, &dst, 0);
> > +       if (CHECK(err, "update_elem",
> > +                 "failed to set pid filter: %d\n", err))
> > +               goto cleanup;
> > +
> > +       err =3D trigger_fstat_events(dst.pid);
> > +       if (CHECK_FAIL(err < 0))
> > +               goto cleanup;
> > +
> > +       err =3D bpf_map_lookup_elem(results_map_fd, &zero, &dst);
> > +       if (CHECK(err, "get_results",
> > +                 "failed to get results: %d\n", err))
> > +               goto cleanup;
> > +
> > +       for (int i =3D 0; i < MAX_FDS; i++) {
> > +               if (i < 3) {
> > +                       CHECK((dst.paths[i][0] !=3D '\0'), "get_file_pa=
th",
>
> nit: unnecessary parens around check
>
> > +                              "failed to filter fs [%d]: %u(%s) vs %u(=
%s)\n",
> > +                              i, src.fds[i], src.paths[i], dst.fds[i],
> > +                              dst.paths[i]);
> > +               } else {
> > +                       err =3D strncmp(src.paths[i], dst.paths[i], MAX=
_PATH_LEN);
> > +                       CHECK(err !=3D 0, "get_file_path",
> > +                              "failed to get path[%d]: %u(%s) vs %u(%s=
)\n",
> > +                              i, src.fds[i], src.paths[i], dst.fds[i],
> > +                              dst.paths[i]);
> > +               }
> > +       }
> > +
> > +cleanup:
> > +       bpf_link__destroy(tp_link);
> > +       bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/t=
ools/testing/selftests/bpf/progs/test_get_file_path.c
> > new file mode 100644
> > index 000000000000..c006fa05e32b
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
> > +#define MAX_PATH_LEN           128
> > +#define MAX_EVENT_NUM          16
> > +
> > +static struct file_path_test_data {
> > +       pid_t pid;
> > +       __u32 cnt;
> > +       __u32 fds[MAX_EVENT_NUM];
> > +       char paths[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +} data;
> > +
> > +struct sys_enter_newfstat_args {
> > +       unsigned long long pad1;
> > +       unsigned long long pad2;
> > +       unsigned int fd;
> > +};
> > +
> > +SEC("tracepoint/syscalls/sys_enter_newfstat")
> > +int bpf_prog(struct sys_enter_newfstat_args *args)
> > +{
> > +       pid_t pid =3D bpf_get_current_pid_tgid();
>
> you don't have to use thread id, given test_progs is single-threaded,
> so can do (bpf_get_current_pid_tgid() >> 32) here and use getpid() in
> userspace part.
>
> > +
> > +       if (pid !=3D data.pid)
> > +               return 0;
> > +       if (data.cnt >=3D MAX_EVENT_NUM)
> > +               return 0;
> > +
> > +       data.fds[data.cnt] =3D args->fd;
> > +       bpf_get_file_path(data.paths[data.cnt], MAX_PATH_LEN, args->fd)=
;
> > +       data.cnt++;
> > +
> > +       return 0;
> > +}
> > +
> > +char _license[] SEC("license") =3D "GPL";
> > --
> > 2.17.1
> >
