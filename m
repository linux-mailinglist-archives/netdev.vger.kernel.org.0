Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE9A61271
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfGFRmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 13:42:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34795 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfGFRmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 13:42:42 -0400
Received: by mail-qt1-f194.google.com with SMTP id k10so6591069qtq.1;
        Sat, 06 Jul 2019 10:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uippvqttXYUbA5qCRTOY4oG+aWLS6ZiufCdu6ZQKDTI=;
        b=LuWVxLHfpFlsZshjmfoSG6iyted7pScGf1SZhRP4gDMmnTbFkuLuXpYNvCqt+IwyqY
         QpQ3rviCtLihY/puFy/EF2l2Mgu7rZuNCW7DZHT4Wh1WSjd7ZTIeo6h3f9FT4NP0s7uy
         N5moIcUB9F+aYjRFsQ3UXdaEidLKNGdebQQEPp17IMcUYumlVzofjEoVpQmkLpDB4+Ld
         8pC0XSRK9jXWdwKDs0B06FMGgJsNiS/C7iz6ZyBa6+Bmf+QVFoWM4BIYmIWwjyAVa4D2
         bEB4Q81YN6ml5JLylFsRiUxqTS5ZCgfWvjS0W5rO+BGfjT6Rw/yrnNrkv3KP65zhnox6
         Rmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uippvqttXYUbA5qCRTOY4oG+aWLS6ZiufCdu6ZQKDTI=;
        b=t1QFgO6hW9dUnfSfC/PVx4ZQ0W2Dfz03WTnIrlX8oKi93KehteCTcDDJvpvt68m2O5
         iMeP4//N+gqzUwAGjKqYYeXoFErRex28ZdlXnrVrZ1y4DlNnfJnyQd7ifA7ZMbYaU548
         2jnueize8cJkKcRqIWjZdXuoXa8qhz9BVEFke+9HvJethaSYPpZ+ZBXgHqoR9R+b/Nq4
         uByw5BFIdy0qEPRLrQHsp6ih7Aye5NLeaopbkX7cSgVnN9mKqVGfWNd12sm0dPrpwhQX
         itPHk/p9048+GoaL0QaosU1VTHPNeMkA5jhwiVmxRk6GQmWxLHgq5DY9mrxg4VmIgduN
         D3Rg==
X-Gm-Message-State: APjAAAXYOzemidC1iyczH+5vqNrlHysR4HCyDvGi5NeXll30IC/JqNSh
        gpgk4LIxcVyABfC2fDpgRxv3U5m/YZBwe6WEYbc=
X-Google-Smtp-Source: APXvYqzecxwJkG6J0FFmwvwVwehmiZXN4uMszUG3EW9ybELxltQHL1MtuQT0WH3EX0ZzWt8S96EP+x+4x+j2mO74uvc=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr8406642qvh.78.1562434961246;
 Sat, 06 Jul 2019 10:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190701235903.660141-1-andriin@fb.com> <20190701235903.660141-9-andriin@fb.com>
 <ed0d9c3d-da7c-b925-e3a6-767098765850@fb.com>
In-Reply-To: <ed0d9c3d-da7c-b925-e3a6-767098765850@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 6 Jul 2019 10:42:30 -0700
Message-ID: <CAEf4BzZhXS1q_tLGdbwarRRQMx0YfhugYwCKZM=7RUKa=2uHMA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 8/9] selftests/bpf: add kprobe/uprobe selftests
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 6, 2019 at 10:21 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/1/19 4:59 PM, Andrii Nakryiko wrote:
> > Add tests verifying kprobe/kretprobe/uprobe/uretprobe APIs work as
> > expected.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > ---
> >   .../selftests/bpf/prog_tests/attach_probe.c   | 166 ++++++++++++++++++
> >   .../selftests/bpf/progs/test_attach_probe.c   |  55 ++++++
> >   2 files changed, 221 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > new file mode 100644
> > index 000000000000..a4686395522c
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > @@ -0,0 +1,166 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +
> > +ssize_t get_base_addr() {
> > +     size_t start;
> > +     char buf[256];
> > +     FILE *f;
> > +
> > +     f = fopen("/proc/self/maps", "r");
> > +     if (!f)
> > +             return -errno;
> > +
> > +     while (fscanf(f, "%zx-%*x %s %*s\n", &start, buf) == 2) {
> > +             if (strcmp(buf, "r-xp") == 0) {
> > +                     fclose(f);
> > +                     return start;
> > +             }
> > +     }
> > +
> > +     fclose(f);
> > +     return -EINVAL;
> > +}
> > +
> > +#ifdef __x86_64__
> > +#define SYS_KPROBE_NAME "__x64_sys_nanosleep"
> > +#else
> > +#define SYS_KPROBE_NAME "sys_nanosleep"
> > +#endif
> > +
> > +void test_attach_probe(void)
> > +{
> > +     const char *kprobe_name = "kprobe/sys_nanosleep";
> > +     const char *kretprobe_name = "kretprobe/sys_nanosleep";
> > +     const char *uprobe_name = "uprobe/trigger_func";
> > +     const char *uretprobe_name = "uretprobe/trigger_func";
> > +     const int kprobe_idx = 0, kretprobe_idx = 1;
> > +     const int uprobe_idx = 2, uretprobe_idx = 3;
> > +     const char *file = "./test_attach_probe.o";
> > +     struct bpf_program *kprobe_prog, *kretprobe_prog;
> > +     struct bpf_program *uprobe_prog, *uretprobe_prog;
> > +     struct bpf_object *obj;
> > +     int err, prog_fd, duration = 0, res;
> > +     struct bpf_link *kprobe_link = NULL;
> > +     struct bpf_link *kretprobe_link = NULL;
> > +     struct bpf_link *uprobe_link = NULL;
> > +     struct bpf_link *uretprobe_link = NULL;
> > +     int results_map_fd;
> > +     size_t uprobe_offset;
> > +     ssize_t base_addr;
> > +
> > +     base_addr = get_base_addr();
> > +     if (CHECK(base_addr < 0, "get_base_addr",
> > +               "failed to find base addr: %zd", base_addr))
> > +             return;
> > +     uprobe_offset = (size_t)&get_base_addr - base_addr;
> > +
> > +     /* load programs */
> > +     err = bpf_prog_load(file, BPF_PROG_TYPE_KPROBE, &obj, &prog_fd);
> > +     if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> > +             return;
> > +
> > +     kprobe_prog = bpf_object__find_program_by_title(obj, kprobe_name);
> > +     if (CHECK(!kprobe_prog, "find_probe",
> > +               "prog '%s' not found\n", kprobe_name))
> > +             goto cleanup;
> > +     kretprobe_prog = bpf_object__find_program_by_title(obj, kretprobe_name);
> > +     if (CHECK(!kretprobe_prog, "find_probe",
> > +               "prog '%s' not found\n", kretprobe_name))
> > +             goto cleanup;
> > +     uprobe_prog = bpf_object__find_program_by_title(obj, uprobe_name);
> > +     if (CHECK(!uprobe_prog, "find_probe",
> > +               "prog '%s' not found\n", uprobe_name))
> > +             goto cleanup;
> > +     uretprobe_prog = bpf_object__find_program_by_title(obj, uretprobe_name);
> > +     if (CHECK(!uretprobe_prog, "find_probe",
> > +               "prog '%s' not found\n", uretprobe_name))
> > +             goto cleanup;
> > +
> > +     /* load maps */
> > +     results_map_fd = bpf_find_map(__func__, obj, "results_map");
> > +     if (CHECK(results_map_fd < 0, "find_results_map",
> > +               "err %d\n", results_map_fd))
> > +             goto cleanup;
> > +
> > +     kprobe_link = bpf_program__attach_kprobe(kprobe_prog,
> > +                                              false /* retprobe */,
> > +                                              SYS_KPROBE_NAME);
> > +     if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
> > +               "err %ld\n", PTR_ERR(kprobe_link))) {
> > +             kprobe_link = NULL;
> > +             goto cleanup;
> > +     }
> > +     kretprobe_link = bpf_program__attach_kprobe(kretprobe_prog,
> > +                                                 true /* retprobe */,
> > +                                                 SYS_KPROBE_NAME);
> > +     if (CHECK(IS_ERR(kretprobe_link), "attach_kretprobe",
> > +               "err %ld\n", PTR_ERR(kretprobe_link))) {
> > +             kretprobe_link = NULL;
> > +             goto cleanup;
> > +     }
> > +     uprobe_link = bpf_program__attach_uprobe(uprobe_prog,
> > +                                              false /* retprobe */,
> > +                                              0 /* self pid */,
> > +                                              "/proc/self/exe",
> > +                                              uprobe_offset);
> > +     if (CHECK(IS_ERR(uprobe_link), "attach_uprobe",
> > +               "err %ld\n", PTR_ERR(uprobe_link))) {
> > +             uprobe_link = NULL;
> > +             goto cleanup;
> > +     }
> > +     uretprobe_link = bpf_program__attach_uprobe(uretprobe_prog,
> > +                                                 true /* retprobe */,
> > +                                                 -1 /* any pid */,
> > +                                                 "/proc/self/exe",
> > +                                                 uprobe_offset);
> > +     if (CHECK(IS_ERR(uretprobe_link), "attach_uretprobe",
> > +               "err %ld\n", PTR_ERR(uretprobe_link))) {
> > +             uretprobe_link = NULL;
> > +             goto cleanup;
> > +     }
> > +
> > +     /* trigger & validate kprobe && kretprobe */
> > +     usleep(1);
> > +
> > +     err = bpf_map_lookup_elem(results_map_fd, &kprobe_idx, &res);
> > +     if (CHECK(err, "get_kprobe_res",
> > +               "failed to get kprobe res: %d\n", err))
> > +             goto cleanup;
> > +     if (CHECK(res != kprobe_idx + 1, "check_kprobe_res",
> > +               "wrong kprobe res: %d\n", res))
> > +             goto cleanup;
> > +
> > +     err = bpf_map_lookup_elem(results_map_fd, &kretprobe_idx, &res);
> > +     if (CHECK(err, "get_kretprobe_res",
> > +               "failed to get kretprobe res: %d\n", err))
> > +             goto cleanup;
> > +     if (CHECK(res != kretprobe_idx + 1, "check_kretprobe_res",
> > +               "wrong kretprobe res: %d\n", res))
> > +             goto cleanup;
> > +
> > +     /* trigger & validate uprobe & uretprobe */
> > +     get_base_addr();
> > +
> > +     err = bpf_map_lookup_elem(results_map_fd, &uprobe_idx, &res);
> > +     if (CHECK(err, "get_uprobe_res",
> > +               "failed to get uprobe res: %d\n", err))
> > +             goto cleanup;
> > +     if (CHECK(res != uprobe_idx + 1, "check_uprobe_res",
> > +               "wrong uprobe res: %d\n", res))
> > +             goto cleanup;
> > +
> > +     err = bpf_map_lookup_elem(results_map_fd, &uretprobe_idx, &res);
> > +     if (CHECK(err, "get_uretprobe_res",
> > +               "failed to get uretprobe res: %d\n", err))
> > +             goto cleanup;
> > +     if (CHECK(res != uretprobe_idx + 1, "check_uretprobe_res",
> > +               "wrong uretprobe res: %d\n", res))
> > +             goto cleanup;
> > +
> > +cleanup:
> > +     bpf_link__destroy(kprobe_link);
> > +     bpf_link__destroy(kretprobe_link);
> > +     bpf_link__destroy(uprobe_link);
> > +     bpf_link__destroy(uretprobe_link);
> > +     bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> > new file mode 100644
> > index 000000000000..7a7c5cd728c8
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
> > @@ -0,0 +1,55 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2017 Facebook
> > +
> > +#include <linux/ptrace.h>
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +
> > +struct {
> > +     int type;
> > +     int max_entries;
> > +     int *key;
> > +     int *value;
> > +} results_map SEC(".maps") = {
> > +     .type = BPF_MAP_TYPE_ARRAY,
> > +     .max_entries = 4,
> > +};
>
> After the new .maps convention patch is merged, test_progs is broken due
> to this. The above .maps definition needs to be updated to
>
> struct {
>         __uint(type, BPF_MAP_TYPE_ARRAY);
>         __uint(max_entries, 4);
>         __type(key, int);
>         __type(value, int);
> } results_map SEC(".maps");
>

Yep, noticed that yesterday. Fixed in [0].

  [0] https://patchwork.ozlabs.org/patch/1128383/

> > +
> > +SEC("kprobe/sys_nanosleep")
> > +int handle_sys_nanosleep_entry(struct pt_regs *ctx)
> > +{
> > +     const int key = 0, value = 1;
> > +
> > +     bpf_map_update_elem(&results_map, &key, &value, 0);
> > +     return 0;
> > +}
> > +
> > +SEC("kretprobe/sys_nanosleep")
> > +int handle_sys_getpid_return(struct pt_regs *ctx)
> > +{
> > +     const int key = 1, value = 2;
> > +
> > +     bpf_map_update_elem(&results_map, &key, &value, 0);
> > +     return 0;
> > +}
> > +
> > +SEC("uprobe/trigger_func")
> > +int handle_uprobe_entry(struct pt_regs *ctx)
> > +{
> > +     const int key = 2, value = 3;
> > +
> > +     bpf_map_update_elem(&results_map, &key, &value, 0);
> > +     return 0;
> > +}
> > +
> > +SEC("uretprobe/trigger_func")
> > +int handle_uprobe_return(struct pt_regs *ctx)
> > +{
> > +     const int key = 3, value = 4;
> > +
> > +     bpf_map_update_elem(&results_map, &key, &value, 0);
> > +     return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > +__u32 _version SEC("version") = 1;
> >
