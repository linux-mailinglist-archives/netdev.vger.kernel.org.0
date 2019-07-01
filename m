Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E4B5C5D2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGAXCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:02:55 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43662 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGAXCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:02:55 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so12434566qka.10;
        Mon, 01 Jul 2019 16:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1VoFHZ2vjj5sdUs8Tzj6gb+F0Gv4BS10Si6lMTtBwns=;
        b=C1P2/OvsMzZa/m8dSH00uN7O+98xmx6J8ac0YJEsLULv1sOgkVS7NZUYNiHrrco3xC
         HP1vYIyoDSRwwna8lc4LvVEp+whipSd7tVi8FAal/SUXYT4qJgsX+jZzcNf7qwKt0t5c
         dgxMhaPjZiGOWWp+Z/OgnfocVvsEY6CiAEsx0YwcFP+HTyADL2aXbci0FxRRDGML3cR/
         cvwm61hDxZ6dU4Q++7DxTmEAMuMT58QSZ66R3rRJafKS0VWNFVWSDIR0zJF3g+LWDnXa
         7TsxdURYGqolUZxWxZx1VHDhkVq662qlwqOTQafJ0T7apIdEFYzaEzGoI/Q37i9jQjwW
         Gy0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1VoFHZ2vjj5sdUs8Tzj6gb+F0Gv4BS10Si6lMTtBwns=;
        b=YJ4J54t8DSjeSc77xyRjwUP2jWDB/j5bHbx5YIqmQBWcegXQ1KD9PAWQSF+vjdvfxL
         KIuvRxgZEeT8n+ZGf91akeDAcGDAuIjxX7AVeGDuc6ZvMOgiLXdayB9h8Qxwhgr32Enh
         4qBQEuj0004UUh/sVrMv/88VGn/PWpZkNJRBPNUXXBLFCoNBcQUa3eSPXmGV+YPDG7np
         4U4CJ/+YvtVhNm1u/FLtX3VTBcww2IILRExMR5EhgIb+0d3OOKEo1D332+GN9cUjPqwN
         nb5OjrNbwSGJfrpYJjh60I+A/OyudbZEAOyV++YBuToTCXg1tmzGRWXd7O9wy456MJv4
         beQA==
X-Gm-Message-State: APjAAAW32/3btuhu0m4KDR6uLJ8pBnoHwfGxvcNScRkXS/uz4+b1AsuC
        2yNkaLc4Y7BBPRdjVbkeYeJTfS/QkJTfKy4gLoA=
X-Google-Smtp-Source: APXvYqyS9tpgHgxA0oabm9tBjko/A49YXkiG/EEkgeSuoRsM3LpW4XgbQOsLZkYHXBcWdGiO778DI301zNBmgrFyxdQ=
X-Received: by 2002:a37:a643:: with SMTP id p64mr23419898qke.36.1562022173896;
 Mon, 01 Jul 2019 16:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-9-andriin@fb.com>
 <8c79e0b2-1194-ab60-fda9-62ba4bbe019f@fb.com>
In-Reply-To: <8c79e0b2-1194-ab60-fda9-62ba4bbe019f@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 16:02:42 -0700
Message-ID: <CAEf4BzZ--sJzZYVvHHSX4wcdBShS_YV7WsZ-2fv9+OEg8bmzrA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 8/9] selftests/bpf: add kprobe/uprobe selftests
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

On Mon, Jul 1, 2019 at 10:18 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/19 8:49 PM, Andrii Nakryiko wrote:
> > Add tests verifying kprobe/kretprobe/uprobe/uretprobe APIs work as
> > expected.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > ---
> >   .../selftests/bpf/prog_tests/attach_probe.c   | 155 ++++++++++++++++++
> >   .../selftests/bpf/progs/test_attach_probe.c   |  55 +++++++
> >   2 files changed, 210 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > new file mode 100644
> > index 000000000000..f22929063c58
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > @@ -0,0 +1,155 @@
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
> > +                                              "sys_nanosleep");
> > +     if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
> > +               "err %ld\n", PTR_ERR(kprobe_link)))
> > +             goto cleanup;
> > +
> > +     kretprobe_link = bpf_program__attach_kprobe(kretprobe_prog,
> > +                                                 true /* retprobe */,
> > +                                                 "sys_nanosleep");
> > +     if (CHECK(IS_ERR(kretprobe_link), "attach_kretprobe",
> > +               "err %ld\n", PTR_ERR(kretprobe_link)))
> > +             goto cleanup;
> > +
> > +     uprobe_link = bpf_program__attach_uprobe(uprobe_prog,
> > +                                              false /* retprobe */,
> > +                                              0 /* self pid */,
> > +                                              "/proc/self/exe",
> > +                                              uprobe_offset);
> > +     if (CHECK(IS_ERR(uprobe_link), "attach_uprobe",
> > +               "err %ld\n", PTR_ERR(uprobe_link)))
> > +             goto cleanup;
> > +
> > +     uretprobe_link = bpf_program__attach_uprobe(uretprobe_prog,
> > +                                                 true /* retprobe */,
> > +                                                 -1 /* any pid */,
> > +                                                 "/proc/self/exe",
> > +                                                 uprobe_offset);
> > +     if (CHECK(IS_ERR(uretprobe_link), "attach_uretprobe",
> > +               "err %ld\n", PTR_ERR(uretprobe_link)))
> > +             goto cleanup;
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
>
> if any error happens, kprobe_link etc. will be a non-NULL pointer
> indicating an error. the above bpf_link__destroy() won't work
> properly. The same for patch #9.

Yes, you are absolutely right. Fixing.

I just also double-checked patch #9, it doesn't have this problem:
- stacktrace_build_id.c and stacktrace_map.c never call destroy before
bpf_link is successfully established.
- stacktrace_map_raw_tp.c uses if (!IS_ERR_OR_NULL(link)) check before
bpf_link__destroy.

So I think it's just this one.

>
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
