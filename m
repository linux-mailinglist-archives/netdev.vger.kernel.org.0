Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC764CB7
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfGJT0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:26:10 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45682 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfGJT0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 15:26:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id j19so3676125qtr.12
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 12:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1iSF39uz5Nd649Q/D1BA0AIvaA8oUzyuhR82IX5F2r4=;
        b=pnzaYvIkUoaGvhq5ArQW1PFRmJz8Ttjj0sQxrFZ1+5eQmjbO/M9YhFiRTPP1e0NbJ6
         ac7itauOU4J84VzMk2iiVuL+zriAI3iS9S6+qei5aROXXo6l/V1QoxLekkjns46ES3e/
         E/5m5nmfn9NFSxnTtp1OkobyLSL3hxePKnCjbIcrQj4UuQsZbJ4Sat1zuQrM+BOqB9TG
         sitW2/DVk2Jlt+wfUKcqX382KID9NtJTH5Qez8JUEUR7woeGteoSTKFjC7mKAFXMaSM+
         7NRYvS9e7uwLWtgVCYOLfBdokXQeQ2/X214+WmLiW5QauTg18VcmB6pehfPMueGtHzey
         DFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1iSF39uz5Nd649Q/D1BA0AIvaA8oUzyuhR82IX5F2r4=;
        b=TzuEvm2wt/cJyXLbnszWKnvE/8NVOEj3S0XM8RWMU1plBa0oV+HaSSyf9HCKDKgvOU
         7KL3AH7VA5Hua+i9HsAeGJEnPMbicqJXr1FClUou2ezNWv7nImN778vuMnR7l9W1hdWj
         EiEeK4TqLLh0nZBw7EyTEj50v95QL4gufxZg1888j1sezjonrFxSFqOZWv8RFOmrUK2M
         Kd1zaocbzHuNFYZ1CzbrkJm0WYOOfmzgzoT5zOk+KVxLdcQpyFiPKfo0il3oYNGeC8cE
         hh5IP506ulM9+vEpcEwZkYPW55iX3sCenMhlyk0y3Mag8d/ee4XfB7n+H9/peVFljp++
         NxEA==
X-Gm-Message-State: APjAAAUK8dAP0TtozWCM5BwvyDUcGRFQYd8MFJoj0vh8fzbnABkxeRHl
        0qwMV8Sc1Q2Jb/qqi8kmsBPJQ10wcjO0KDS0L0lhRdiNIc/E2ku3
X-Google-Smtp-Source: APXvYqxGQyc/F6JjV/iIyQLgtSuDq4JCBei0TTE3YQJFpDZyvdrdjRtJ7qVlEzdT71xb8jLYvXqB6hO4Nn74UnPykkM=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr26477980qvh.78.1562786768231;
 Wed, 10 Jul 2019 12:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190410203631.1576576-1-javierhonduco@fb.com>
 <20190710180025.94726-1-javierhonduco@fb.com> <20190710180025.94726-4-javierhonduco@fb.com>
In-Reply-To: <20190710180025.94726-4-javierhonduco@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 12:25:57 -0700
Message-ID: <CAEf4BzboSWpktGxgYbQCH_GuLqfx2NE2SuR3j0voEN2RiVz_jg@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 3/3] bpf: add tests for bpf_descendant_of
To:     Javier Honduvilla Coto <javierhonduco@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Kernel Team <kernel-team@fb.com>, jonhaslam@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 11:31 AM Javier Honduvilla Coto
<javierhonduco@fb.com> wrote:
>
> Adding the following test cases:

FYI, bpf-next is closed, so this won't be able to go in for about 2 weeks.

>
> - bpf_descendant_of(current->pid) == 1
> - bpf_descendant_of(current->real_parent->pid) == 1
> - bpf_descendant_of(1) == 1
> - bpf_descendant_of(0) == 1
>
> - bpf_descendant_of(-1) == 0
> - bpf_descendant_of(current->children[0]->pid) == 0
>
> Signed-off-by: Javier Honduvilla Coto <javierhonduco@fb.com>
> ---
>  tools/testing/selftests/bpf/.gitignore        |   1 +
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
>  .../bpf/progs/test_descendant_of_kern.c       |  43 +++
>  .../selftests/bpf/test_descendant_of_user.c   | 266 ++++++++++++++++++
>  5 files changed, 314 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_descendant_of_kern.c
>  create mode 100644 tools/testing/selftests/bpf/test_descendant_of_user.c
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 90f70d2c7c22..4b63d7105ba2 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -43,3 +43,4 @@ test_sockopt
>  test_sockopt_sk
>  test_sockopt_multi
>  test_tcp_rtt
> +test_descendant_of_user
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 2620406a53ec..b3dc1e26c41c 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -27,7 +27,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>         test_cgroup_storage test_select_reuseport test_section_names \
>         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
>         test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
> -       test_sockopt_multi test_tcp_rtt
> +       test_sockopt_multi test_tcp_rtt test_descendant_of_user

Could you please instead add this test as part of test_progs? See for
instance prog_tests/attach_probe.c for recently added test.

>
>  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
>  TEST_GEN_FILES = $(BPF_OBJ_FILES)
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 5a3d92c8bec8..7525783ffbc9 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -1,4 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> +#include <sys/types.h>
> +
>  #ifndef __BPF_HELPERS_H
>  #define __BPF_HELPERS_H
>
> @@ -228,6 +230,7 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
>  static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
>         (void *)BPF_FUNC_sk_storage_delete;
>  static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
> +static int (*bpf_descendant_of)(pid_t pid) = (void *) BPF_FUNC_descendant_of;

Can you split bpf_helpers.h update into a separate commit?

>
>  /* llvm builtin functions that eBPF C program may use to
>   * emit BPF_LD_ABS and BPF_LD_IND instructions
> diff --git a/tools/testing/selftests/bpf/progs/test_descendant_of_kern.c b/tools/testing/selftests/bpf/progs/test_descendant_of_kern.c
> new file mode 100644
> index 000000000000..802e01595527
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_descendant_of_kern.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +struct bpf_map_def SEC("maps") pidmap = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(__u32),
> +       .max_entries = 2,
> +};
> +
> +struct bpf_map_def SEC("maps") resultmap = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(__u32),
> +       .max_entries = 1,
> +};

Please update this to use new BTF-defined maps (see lots of recently
converted tests for example).

> +
> +SEC("tracepoint/syscalls/sys_enter_open")
> +int trace(void *ctx)
> +{
> +       __u32 pid = bpf_get_current_pid_tgid();
> +       __u32 current_key = 0, ancestor_key = 1, *expected_pid, *ancestor_pid;
> +       __u32 *val;
> +
> +       expected_pid = bpf_map_lookup_elem(&pidmap, &current_key);
> +       if (!expected_pid || *expected_pid != pid)
> +               return 0;
> +
> +       ancestor_pid = bpf_map_lookup_elem(&pidmap, &ancestor_key);
> +       if (!ancestor_pid)
> +               return 0;
> +
> +       val = bpf_map_lookup_elem(&resultmap, &current_key);
> +       if (val)
> +               *val = bpf_descendant_of(*ancestor_pid);
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> +__u32 _version SEC("version") = 1;
> diff --git a/tools/testing/selftests/bpf/test_descendant_of_user.c b/tools/testing/selftests/bpf/test_descendant_of_user.c
> new file mode 100644
> index 000000000000..f616c8c976a4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_descendant_of_user.c
> @@ -0,0 +1,266 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <syscall.h>
> +#include <unistd.h>
> +#include <linux/perf_event.h>
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +
> +#define CHECK(condition, tag, format...)                                       \
> +       ({                                                                     \
> +               int __ret = !!(condition);                                     \
> +               if (__ret) {                                                   \
> +                       printf("%s:FAIL:%s ", __func__, tag);                  \
> +                       printf(format);                                        \
> +               } else {                                                       \
> +                       printf("%s:PASS:%s\n", __func__, tag);                 \
> +               }                                                              \
> +               __ret;                                                         \
> +       })

You won't need this if done as part of test_progs.

> +
> +static int bpf_find_map(const char *test, struct bpf_object *obj,
> +                       const char *name)
> +{
> +       struct bpf_map *map;
> +
> +       map = bpf_object__find_map_by_name(obj, name);
> +       if (!map)
> +               return -1;
> +       return bpf_map__fd(map);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       const char *probe_name = "syscalls/sys_enter_open";
> +       const char *file = "test_descendant_of_kern.o";
> +       int err, bytes, efd, prog_fd, pmu_fd;
> +       int resultmap_fd, pidmap_fd;
> +       struct perf_event_attr attr = {};
> +       struct bpf_object *obj;
> +       __u32 descendant_of_result = 0;
> +       __u32 key = 0, pid;
> +       int exit_code = EXIT_FAILURE;
> +       char buf[256];
> +
> +       int child_pid, ancestor_pid, root_fd, nonexistant = -42;
> +       __u32 ancestor_key = 1;
> +       int pipefd[2];
> +       char marker[1];
> +
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
> +       if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
> +               goto fail;
> +
> +       resultmap_fd = bpf_find_map(__func__, obj, "resultmap");
> +       if (CHECK(resultmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
> +                 resultmap_fd, errno))
> +               goto close_prog;
> +
> +       pidmap_fd = bpf_find_map(__func__, obj, "pidmap");
> +       if (CHECK(pidmap_fd < 0, "bpf_find_map", "err %d errno %d\n", pidmap_fd,
> +                 errno))
> +               goto close_prog;
> +
> +       pid = getpid();
> +       bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
> +       bpf_map_update_elem(pidmap_fd, &ancestor_key, &pid, 0);
> +
> +       snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%s/id",
> +                probe_name);
> +       efd = open(buf, O_RDONLY, 0);
> +       if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
> +               goto close_prog;
> +       bytes = read(efd, buf, sizeof(buf));
> +       close(efd);
> +       if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
> +                 "bytes %d errno %d\n", bytes, errno))
> +               goto close_prog;
> +
> +       attr.config = strtol(buf, NULL, 0);
> +       attr.type = PERF_TYPE_TRACEPOINT;
> +       attr.sample_type = PERF_SAMPLE_RAW;
> +       attr.sample_period = 1;
> +       attr.wakeup_events = 1;
> +
> +       pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
> +       if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
> +                 errno))
> +               goto close_prog;
> +
> +       err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
> +       if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
> +                 errno))
> +               goto close_pmu;
> +
> +       err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
> +       if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
> +                 errno))
> +               goto close_pmu;

Can you please switch all this to new libbpf tracing APIs? see
prog_tests/attach_probe.c for examples.

> +
> +       // Test that descendant_of(current->pid) is true
> +       bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
> +       bpf_map_update_elem(pidmap_fd, &ancestor_key, &pid, 0);
> +       bpf_map_update_elem(resultmap_fd, &key, &nonexistant, 0);
> +
> +       root_fd = open("/", O_RDONLY);
> +       if (CHECK(efd < 0, "open", "errno %d\n", errno))
> +               goto close_prog;
> +       close(root_fd);

I'd suggest to just use raw_tracepoint 'sys_enter', which would be
easy to trigger with just `usleep(1)`. Makes for quite simpler code.
See, e.g., tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c

> +
> +       err = bpf_map_lookup_elem(resultmap_fd, &key, &descendant_of_result);
> +       if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
> +               goto close_pmu;
> +       if (CHECK(descendant_of_result != 1,
> +                 "descendant_of is true with same pid", "%d == %d\n",
> +                 descendant_of_result, 1))
> +               goto close_pmu;
> +

<snip>
