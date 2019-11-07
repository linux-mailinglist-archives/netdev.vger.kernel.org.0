Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CDDF3572
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfKGRJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:09:59 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:33924 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKGRJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:09:59 -0500
Received: by mail-vs1-f65.google.com with SMTP id y23so1806855vso.1;
        Thu, 07 Nov 2019 09:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bFoWiHIDD/GwjcdUWkXgeGk2PtQ/WhBnLKDjzzNM1zE=;
        b=aAssOPDhJr5ro0/otKMbRGCCCPa6I3JDiFfajq1Ed7+Mf9NxLWZqTfaCtl4mPxQJDb
         3Iaan1SU2lchad3/PlTPM8ZnhBxJ8A5MBZHHpVBS5cdWSGdknFDusaADRPGOIk22Px8G
         yvj+mw71d0mj5Uc8gwYmBxJzGgq5zDcROVPEa2myUvsn9JTvuT7wr46UTOfiLGoySqgc
         yjxZs9DYSqTXfUHvGNgR4FYdg20HQkq3lwx6NWK8JyrLRCwilSbwSO8WeY9yTRVShVzT
         oSGfDY79sN4wrO1E6FgXksf7s6X7ko5k1pdiY8mGdB0A8yH0kcC5qh8Qij4tRSuwKSjo
         x8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bFoWiHIDD/GwjcdUWkXgeGk2PtQ/WhBnLKDjzzNM1zE=;
        b=aeV5qCSzHQ5WAmd2PO8ePgHFB/7vJqLbhhez9A+DBCgs67k8/lYLmw+D/yc/GYoh64
         yo8LxAiaEXwk55DFpnj4rBLejouLD/I92ZwRtbcRVwXJBFgPsmSK+S8N/fPoYD0gUz5j
         lQwcwHiCX4tKmLbxUsuOdb3ayek18sgP4YXg1ryIuRHKiG+L+qHgMkHqcWuEv8BorRCw
         aUwDyQQBQkt0z9Zg0jzLJchC7mShUg2X8taD32AeNV9wMh/tVqh85eiXqbxg5ibpmLDW
         inV1OWB8QH4zAPX0TAJpIj8Q6givBubMPr3ntWioBvZMw7I3oN/eSVTUsfN3tk9gMn8b
         uVkQ==
X-Gm-Message-State: APjAAAWUOqCf4Qj/IDAxBcfVV/qqxZIqbwwa3SveyWFyvy6KxFVv4dhX
        GqKkcHuMIn8hAS+OJFoMEaivup3NCNqOZR+NpOE=
X-Google-Smtp-Source: APXvYqzkhJ1jcmLwwSepOeDUJPo4I5FC9IMs2+wNruQnxPLVlAtpuYAjNyd2M970JWJQlEsl3Kf0fz2frfwANJ0r65k=
X-Received: by 2002:a67:747:: with SMTP id 68mr713170vsh.123.1573146597177;
 Thu, 07 Nov 2019 09:09:57 -0800 (PST)
MIME-Version: 1.0
References: <20191105041223.5622-1-ethercflow@gmail.com> <CAEf4Bzbbmfwd1m4F6iz_P2o5qGShd2orTF_vJBK_d-aSUXqkqw@mail.gmail.com>
In-Reply-To: <CAEf4Bzbbmfwd1m4F6iz_P2o5qGShd2orTF_vJBK_d-aSUXqkqw@mail.gmail.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Fri, 8 Nov 2019 01:09:45 +0800
Message-ID: <CABtjQmZ+TMoEtysqWxgZE6GOcsyU6pCEQ7vm4YraC8dfHgm91Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] selftests/bpf: test for bpf_get_file_path()
 from raw tracepoint
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is not a zero byte, it's a character "0", was this intentional?
My intention is to initialize array elements to 0 like memset.

> you can just pass path_info_index directly, there is absolutely no
> need for global counter for this...

Thanks, I'll change to this.

> why do you need alloca()? Doesn't int fds[MAX_FDS] work? But honestly,
> you needs fds just to have a loop to close all FDs. You can just as
> well have a set of directl close(pipefd); close(sockfd); and so on,
> with same amount of code, but more simplicity.

My mistake, at first, I thought of a dynamic array that was used to
store more other file descriptors at runtime,
but later implemented, I chose to use my only own file descriptors,
then forgot to change it to int fds[MAX_FDS].
I'll use pipefd, sockfd directly instead of  int fds[MAX_FDS], as you
said, make as simplicity as it can be.

> Given you control the order of open()'s, you should know the order of
> captured paths, so there is no need to find it or do hits++ logic.
> Just check it positionally. See also below about global data usage.
> This is not global variables, it's just maps. What I had in mind (and
> what would still simplify even userspace part of tests, IMO) is
> something like this:
> struct file_path_test_data {
>    pid_t pid;
>    int cnt;
>    unsigned long fds[MAX_EVENT_NUM];
>    char paths[MAX_EVENT_NUM][MAX_PATH_LENGTH];
> } data;

Oh, sorry. I misunderstood, I find I didn't keep up with the progress
of bpf,  still staying in the era where bpf doesn't support
real global variable and needs to use map to implement large memory
objects. Happy to hear this news (even though it's
implemented in April, not new forgive me) .

With the help of your case code,  I learned
https://lwn.net/Articles/784936/ and
https://patchwork.ozlabs.org/patch/676285/

From https://lwn.net/Articles/784936/ I see, currently, we should
define global variable with static (non-static global hasn't been
supported right?), then in user-space use  bpf_find_map  to get
"test_get.bss"'s fd to set pid filter and read paths.

> here, you'll do:

> if (pid !=3D data.pid) return 0;
> data.cnt++;
> if (data.cnt > MAX_EVENT_NUM) return 0; /* check overflow in userspace */

> data.fds[data.cnt - 1] =3D /* read fd */
> bpf_get_file_path(data.paths[data.cnt - 1], ...)

> This is x86_64-specific, use one of PT_REGS_* macro from bpf_tracing.h he=
ader.

Get it. I'll fix these soon then resubmit.

Thanks a lot for your patient guidance, have learned a lot with you. I
will pay more attention to the progress of bpf to
keep up with its pace and look forward to making a better contribution
to bpf. Thank you.

Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2019=E5=B9=B411=E6=9C=
=886=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=883:07=E5=86=99=E9=81=93=EF=
=BC=9A
>
> On Mon, Nov 4, 2019 at 8:15 PM Wenbo Zhang <ethercflow@gmail.com> wrote:
> >
> > trace fstat events by raw tracepoint sys_enter:newfstat, and handle eve=
nts
> > only produced by test_file_get_path, which call fstat on several differ=
ent
> > types of files to test bpf_get_file_path's feature.
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
> >  .../selftests/bpf/prog_tests/get_file_path.c  | 171 ++++++++++++++++++
> >  .../selftests/bpf/progs/test_get_file_path.c  |  71 ++++++++
> >  2 files changed, 242 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_pat=
h.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_pat=
h.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/get_file_path.c b/t=
ools/testing/selftests/bpf/prog_tests/get_file_path.c
> > new file mode 100644
> > index 000000000000..26126e55c1f0
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/get_file_path.c
> > @@ -0,0 +1,171 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <test_progs.h>
> > +#include <alloca.h>
> > +#include <sys/stat.h>
> > +
> > +#ifndef MAX_PATH_LENGTH
> > +#define MAX_PATH_LENGTH                128
> > +#endif
> > +
> > +#ifndef TASK_COMM_LEN
> > +#define TASK_COMM_LEN          16
> > +#endif
>
> Do you really need these ifndefs? Either include headers that have
> TASK_COMM_LEN, or don't and just define them directly?
>
> > +
> > +struct get_path_trace_t {
> > +       unsigned long fd;
> > +       char path[MAX_PATH_LENGTH];
> > +};
> > +
> > +enum FS_TYPE {
> > +       PIPE_0,
> > +       PIPE_1,
> > +       SOCK,
> > +       PROC,
> > +       DEV,
> > +       LOCAL,
> > +       INDICATOR,
> > +       MAX_FDS
> > +};
> > +
> > +struct path_info {
> > +       int fd;
> > +       char name[MAX_PATH_LENGTH];
> > +};
> > +
> > +static struct path_info path_infos[MAX_FDS];
> > +static int path_info_index;
> > +static int hits;
> > +
> > +static inline int set_pathname(pid_t pid, int fd)
> > +{
> > +       char buf[MAX_PATH_LENGTH] =3D {'0'};
>
> This is not a zero byte, it's a character "0", was this intentional?
>
> > +
> > +       snprintf(buf, MAX_PATH_LENGTH, "/proc/%d/fd/%d", pid, fd);
> > +       path_infos[path_info_index].fd =3D fd;
>
> you can just pass path_info_index directly, there is absolutely no
> need for global counter for this...
>
> > +       return readlink(buf, path_infos[path_info_index++].name,
> > +                       MAX_PATH_LENGTH);
> > +}
> > +
> > +static inline int compare_pathname(struct get_path_trace_t *data)
> > +{
> > +       for (int i =3D 0; i < MAX_FDS; i++) {
> > +               if (path_infos[i].fd =3D=3D data->fd) {
> > +                       hits++;
> > +                       return strncmp(path_infos[i].name, data->path,
> > +                                       MAX_PATH_LENGTH);
> > +               }
> > +       }
> > +       return 0;
> > +}
> > +
> > +static int trigger_fstat_events(void)
> > +{
> > +       int *fds =3D alloca(sizeof(int) * MAX_FDS);
>
> why do you need alloca()? Doesn't int fds[MAX_FDS] work? But honestly,
> you needs fds just to have a loop to close all FDs. You can just as
> well have a set of directl close(pipefd); close(sockfd); and so on,
> with same amount of code, but more simplicity.
>
> > +       int *pipefd =3D fds;
> > +       int *sockfd =3D fds + SOCK;
> > +       int *procfd =3D fds + PROC;
> > +       int *devfd =3D fds + DEV;
> > +       int *localfd =3D fds + LOCAL;
> > +       int *indicatorfd =3D fds + INDICATOR;
> > +       pid_t pid =3D getpid();
> > +
> > +       /* unmountable pseudo-filesystems */
> > +       if (pipe(pipefd) < 0 || set_pathname(pid, *pipefd++) < 0 ||
> > +               set_pathname(pid, *pipefd) < 0)
> > +               return -1;
> > +
> > +       /* unmountable pseudo-filesystems */
> > +       *sockfd =3D socket(AF_INET, SOCK_STREAM, 0);
> > +       if (*sockfd < 0 || set_pathname(pid, *sockfd) < 0)
> > +               return -1;
> > +
> > +       /* mountable pseudo-filesystems */
> > +       *procfd =3D open("/proc/self/comm", O_RDONLY);
> > +       if (*procfd < 0 || set_pathname(pid, *procfd) < 0)
> > +               return -1;
> > +
> > +       *devfd =3D open("/dev/urandom", O_RDONLY);
> > +       if (*devfd < 0 || set_pathname(pid, *devfd) < 0)
> > +               return -1;
> > +
> > +       *localfd =3D open("/tmp/fd2path_loadgen.txt", O_CREAT|O_RDONLY)=
;
> > +       if (*localfd < 0 || set_pathname(pid, *localfd) < 0)
> > +               return -1;
> > +
> > +       *indicatorfd =3D open("/tmp/", O_PATH);
> > +       if (*indicatorfd < 0 || set_pathname(pid, *indicatorfd) < 0)
> > +               return -1;
>
> on error, you are not closing any file descriptor
>
> > +
> > +       for (int i =3D 0; i < MAX_FDS; i++)
> > +               close(fds[i]);
> > +
> > +       remove("/tmp/fd2path_loadgen.txt");
> > +       return 0;
> > +}
> > +
> > +void test_get_file_path(void)
> > +{
> > +       const char *prog_name =3D "raw_tracepoint/sys_enter:newfstat";
> > +       const char *file =3D "./test_get_file_path.o";
> > +       int pidfilter_map_fd, pathdata_map_fd;
> > +       __u32 key, previous_key, duration =3D 0;
> > +       struct get_path_trace_t val =3D {};
> > +       struct bpf_program *prog =3D NULL;
> > +       struct bpf_object *obj =3D NULL;
> > +       struct bpf_link *link =3D NULL;
> > +       __u32 pid =3D getpid();
> > +       int err, prog_fd;
> > +
> > +       err =3D bpf_prog_load(file, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj,=
 &prog_fd);
> > +       if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
> > +               return;
> > +
> > +       prog =3D bpf_object__find_program_by_title(obj, prog_name);
> > +       if (CHECK(!prog, "find_prog", "prog %s not found\n", prog_name)=
)
> > +               goto out_close;
> > +
> > +       link =3D bpf_program__attach_raw_tracepoint(prog, "sys_enter");
> > +       if (CHECK(IS_ERR(link), "attach_tp", "err %ld\n", PTR_ERR(link)=
))
> > +               goto out_close;
> > +
> > +       pidfilter_map_fd =3D bpf_find_map(__func__, obj, "pidfilter_map=
");
> > +       if (CHECK(pidfilter_map_fd < 0, "bpf_find_map pidfilter_map",
> > +                 "err: %s\n", strerror(errno)))
> > +               goto out_detach;
> > +
> > +       err =3D bpf_map_update_elem(pidfilter_map_fd, &key, &pid, 0);
> > +       if (CHECK(err, "pidfilter_map update_elem", "err: %s\n",
> > +                         strerror(errno)))
> > +               goto out_detach;
> > +
> > +       err =3D trigger_fstat_events();
> > +       if (CHECK(err, "trigger_fstat_events", "open fd failed: %s\n",
> > +                         strerror(errno)))
> > +               goto out_detach;
> > +
> > +       pathdata_map_fd =3D bpf_find_map(__func__, obj, "pathdata_map")=
;
> > +       if (CHECK_FAIL(pathdata_map_fd < 0))
> > +               goto out_detach;
> > +
> > +       do {
> > +               err =3D bpf_map_lookup_elem(pathdata_map_fd, &key, &val=
);
> > +               if (CHECK(err, "lookup_elem from pathdata_map",
> > +                                 "err %s\n", strerror(errno)))
> > +                       goto out_detach;
> > +
> > +               CHECK(compare_pathname(&val) !=3D 0,
> > +                         "get_file_path", "failed to get path: %lu->%s=
\n",
> > +                         val.fd, val.path);
>
> Given you control the order of open()'s, you should know the order of
> captured paths, so there is no need to find it or do hits++ logic.
> Just check it positionally. See also below about global data usage.
>
> > +
> > +               previous_key =3D key;
> > +       } while (bpf_map_get_next_key(pathdata_map_fd,
> > +                                       &previous_key, &key) =3D=3D 0);
> > +
> > +       CHECK(hits !=3D MAX_FDS, "Lost event?", "%d !=3D %d\n", hits, M=
AX_FDS);
> > +
> > +out_detach:
> > +       bpf_link__destroy(link);
> > +out_close:
> > +       bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_get_file_path.c b/t=
ools/testing/selftests/bpf/progs/test_get_file_path.c
> > new file mode 100644
> > index 000000000000..10ec9a70c81c
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_get_file_path.c
> > @@ -0,0 +1,71 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include <linux/ptrace.h>
> > +#include <linux/sched.h>
> > +#include <stdbool.h>
> > +#include <string.h>
> > +#include "bpf_helpers.h"
> > +
> > +#ifndef MAX_PATH_LENGTH
> > +#define MAX_PATH_LENGTH                128
> > +#endif
> > +
> > +#ifndef MAX_EVENT_NUM
> > +#define MAX_EVENT_NUM          32
> > +#endif
> > +
> > +struct path_trace_t {
> > +       unsigned long fd;
> > +       char path[MAX_PATH_LENGTH];
> > +};
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __uint(max_entries, MAX_EVENT_NUM);
> > +       __type(key, __u32);
> > +       __type(value, struct path_trace_t);
> > +} pathdata_map SEC(".maps");
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __uint(max_entries, 1);
> > +       __type(key, __u32);
> > +       __type(value, __u32);
> > +} pidfilter_map SEC(".maps");
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __uint(max_entries, 1);
> > +       __type(key, __u32);
> > +       __type(value, __u32);
> > +} index_map SEC(".maps");
>
> This is not global variables, it's just maps. What I had in mind (and
> what would still simplify even userspace part of tests, IMO) is
> something like this:
>
>
> struct file_path_test_data {
>     pid_t pid;
>     int cnt;
>     unsigned long fds[MAX_EVENT_NUM];
>     char paths[MAX_EVENT_NUM][MAX_PATH_LENGTH];
> } data;
>
> > +
> > +SEC("raw_tracepoint/sys_enter:newfstat")
> > +int bpf_prog(struct bpf_raw_tracepoint_args *ctx)
> > +{
> > +       struct path_trace_t *data;
> > +       struct pt_regs *regs;
> > +       __u32 key =3D 0, *i, *pidfilter, pid;
> > +
> > +       pidfilter =3D bpf_map_lookup_elem(&pidfilter_map, &key);
> > +       if (!pidfilter || *pidfilter =3D=3D 0)
> > +               return 0;
> > +       i =3D bpf_map_lookup_elem(&index_map, &key);
> > +       if (!i || *i =3D=3D MAX_EVENT_NUM)
> > +               return 0;
> > +       pid =3D bpf_get_current_pid_tgid() >> 32;
> > +       if (pid !=3D *pidfilter)
> > +               return 0;
> > +       data =3D bpf_map_lookup_elem(&pathdata_map, i);
> > +       if (!data)
> > +               return 0;
>
> here, you'll do:
>
> if (pid !=3D data.pid) return 0;
> data.cnt++;
> if (data.cnt > MAX_EVENT_NUM) return 0; /* check overflow in userspace */
>
> data.fds[data.cnt - 1] =3D /* read fd */
> bpf_get_file_path(data.paths[data.cnt - 1], ...)
>
>
> > +
> > +       regs =3D (struct pt_regs *)ctx->args[0];
> > +       bpf_probe_read(&data->fd, sizeof(data->fd), &regs->rdi);
>
> This is x86_64-specific, use one of PT_REGS_* macro from bpf_tracing.h he=
ader.
>
> > +       bpf_get_file_path(data->path, MAX_PATH_LENGTH, data->fd);
> > +       *i +=3D 1;
> > +
> > +       return 0;
> > +}
> > +
> > +char _license[] SEC("license") =3D "GPL";
> > --
> > 2.17.1
> >
