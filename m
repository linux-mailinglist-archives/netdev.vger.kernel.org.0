Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636AC3D7E85
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 21:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhG0Tcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 15:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhG0Tcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 15:32:45 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06502C061757;
        Tue, 27 Jul 2021 12:32:45 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z18so22516150ybg.8;
        Tue, 27 Jul 2021 12:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKGudjWz4P0yfu8H7h9Egb1yILRZd+4RjJ2BxVRVxt0=;
        b=Odw84ZCGYBa10VyTcd4pInhM81ZJp2bYw73FsM7f29lD+qv1LfWODOuPK9y8wlvxjo
         anZuKixmoXVcIPON7PO/mMhPSR+N61i4eT56AyMKju1I6Bpf8mi2BlJt2/O55OcTgs+P
         OEANFZp9W/hC2o/1aN7AlNwf38t5xSmfLTGOuBdfITPieRrfK4DmQj87SEdR2Vpiz+oG
         9haOvcTdlX+Q7PnahZwDcpXK5BCenB+InrmBbeFdAi+E290oGkIDlk/VslnO3MfOWKSK
         ZCQNBVASq7DqDKaH0WRbveCN9q9GXLvNxqU2T4Edhfpx/O3TrbVYqKcTGYb8t0Hm0hfu
         vxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKGudjWz4P0yfu8H7h9Egb1yILRZd+4RjJ2BxVRVxt0=;
        b=LqCOilR9s0mo1o2m6EKwzUr8H5TV+vJ/a5wfQZ9a2cnNqCHKPB2ZlnKKTfbulHF9TF
         /bVOSXdOU8HewHftPRy8ZJRUxK/yjwT51ikz4k03B5mU2o/jTcSpHvO1S5dzs6CUaQmT
         H6Ef58snqJJxDix2S1qyiiLaSAAuhWmjkMIAhZe5g2O45MdtfVE/Zr5Kw4C8H08CCeRe
         +wbTTGdJKlQAc4ZPBUX9UA0SGsv6NcF5qHhc8brtDrFGgI6/MXEThLORqBp+jVrOqVSt
         19uyMuBTqM8lMS7gBuub6NO/kFhyg3VQuQkoXVMHST3aFUj/gmo5AKN/4DkD8TKv5jqJ
         r1zQ==
X-Gm-Message-State: AOAM532ZNBbjkdToEwQYJxGuygFNMaWXPqxZDYe1F2EWaq0b8f8QUdQz
        UEM/GywNlsqtoJkQfgE7YYIAEOxwNeih+E7a/sM=
X-Google-Smtp-Source: ABdhPJyEL/XgqG+n3IkwbadQR//4Q8qsUKPZeYtYteHMgblVzKYhXMolKDvU0h+GQ1qhhzULY2horAFkYNyJsGYdc90=
X-Received: by 2002:a25:b203:: with SMTP id i3mr33856402ybj.260.1627414364248;
 Tue, 27 Jul 2021 12:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210726230032.1806348-1-sdf@google.com>
In-Reply-To: <20210726230032.1806348-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 12:32:33 -0700
Message-ID: <CAEf4BzaLc7rvUPquXnf+qxjrLSkCR21D7hj0HNVACmwNpgZvSw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: increase supported cgroup storage value size
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 4:00 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's align
> max cgroup value size with the other storages.
>
> For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> allocator is not happy about larger values.
>
> netcnt test is extended to exercise those maximum values
> (non-percpu max size is close to, but not real max).
>
> v3:
> * refine SIZEOF_BPF_LOCAL_STORAGE_ELEM comment (Yonghong Song)
> * anonymous struct in percpu_net_cnt & net_cnt (Yonghong Song)
> * reorder free (Yonghong Song)
>
> v2:
> * cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)
>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  kernel/bpf/local_storage.c                  | 11 +++++-
>  tools/testing/selftests/bpf/netcnt_common.h | 38 +++++++++++++++++----
>  tools/testing/selftests/bpf/test_netcnt.c   | 17 ++++++---
>  3 files changed, 53 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> index 7ed2a14dc0de..035e9e3a7132 100644
> --- a/kernel/bpf/local_storage.c
> +++ b/kernel/bpf/local_storage.c
> @@ -1,6 +1,7 @@
>  //SPDX-License-Identifier: GPL-2.0
>  #include <linux/bpf-cgroup.h>
>  #include <linux/bpf.h>
> +#include <linux/bpf_local_storage.h>
>  #include <linux/btf.h>
>  #include <linux/bug.h>
>  #include <linux/filter.h>
> @@ -283,9 +284,17 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
>
>  static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>  {
> +       __u32 max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
>         int numa_node = bpf_map_attr_numa_node(attr);
>         struct bpf_cgroup_storage_map *map;
>
> +       /* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
> +        * is the same as other local storages.
> +        */
> +       if (attr->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
> +               max_value_size = min_t(__u32, max_value_size,
> +                                      PCPU_MIN_UNIT_SIZE);
> +
>         if (attr->key_size != sizeof(struct bpf_cgroup_storage_key) &&
>             attr->key_size != sizeof(__u64))
>                 return ERR_PTR(-EINVAL);
> @@ -293,7 +302,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
>         if (attr->value_size == 0)
>                 return ERR_PTR(-EINVAL);
>
> -       if (attr->value_size > PAGE_SIZE)
> +       if (attr->value_size > max_value_size)
>                 return ERR_PTR(-E2BIG);
>
>         if (attr->map_flags & ~LOCAL_STORAGE_CREATE_FLAG_MASK ||
> diff --git a/tools/testing/selftests/bpf/netcnt_common.h b/tools/testing/selftests/bpf/netcnt_common.h
> index 81084c1c2c23..87f5b97e1932 100644
> --- a/tools/testing/selftests/bpf/netcnt_common.h
> +++ b/tools/testing/selftests/bpf/netcnt_common.h
> @@ -6,19 +6,43 @@
>
>  #define MAX_PERCPU_PACKETS 32
>
> +/* sizeof(struct bpf_local_storage_elem):
> + *
> + * It really is about 128 bytes on x86_64, but allocate more to account for
> + * possible layout changes, different architectures, etc.
> + * The kernel will wrap up to PAGE_SIZE internally anyway.
> + */
> +#define SIZEOF_BPF_LOCAL_STORAGE_ELEM          256
> +
> +/* Try to estimate kernel's BPF_LOCAL_STORAGE_MAX_VALUE_SIZE: */
> +#define BPF_LOCAL_STORAGE_MAX_VALUE_SIZE       (0xFFFF - \
> +                                                SIZEOF_BPF_LOCAL_STORAGE_ELEM)
> +
> +#define PCPU_MIN_UNIT_SIZE                     32768
> +
>  struct percpu_net_cnt {
> -       __u64 packets;
> -       __u64 bytes;
> +       union {

so you have a struct with a single anonymous union inside, isn't that
right? Any problems with just making struct percpu_net_cnt into union
percpu_net_cnt?

> +               struct {
> +                       __u64 packets;
> +                       __u64 bytes;
>
> -       __u64 prev_ts;
> +                       __u64 prev_ts;
>
> -       __u64 prev_packets;
> -       __u64 prev_bytes;
> +                       __u64 prev_packets;
> +                       __u64 prev_bytes;
> +               };
> +               __u8 data[PCPU_MIN_UNIT_SIZE];
> +       };
>  };
>
>  struct net_cnt {
> -       __u64 packets;
> -       __u64 bytes;
> +       union {

similarly here

> +               struct {
> +                       __u64 packets;
> +                       __u64 bytes;
> +               };
> +               __u8 data[BPF_LOCAL_STORAGE_MAX_VALUE_SIZE];
> +       };
>  };
>
>  #endif
> diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/selftests/bpf/test_netcnt.c
> index a7b9a69f4fd5..372afccf2d17 100644
> --- a/tools/testing/selftests/bpf/test_netcnt.c
> +++ b/tools/testing/selftests/bpf/test_netcnt.c
> @@ -33,11 +33,11 @@ static int bpf_find_map(const char *test, struct bpf_object *obj,
>
>  int main(int argc, char **argv)
>  {
> -       struct percpu_net_cnt *percpu_netcnt;
> +       struct percpu_net_cnt *percpu_netcnt = NULL;
>         struct bpf_cgroup_storage_key key;
> +       struct net_cnt *netcnt = NULL;
>         int map_fd, percpu_map_fd;
>         int error = EXIT_FAILURE;
> -       struct net_cnt netcnt;
>         struct bpf_object *obj;
>         int prog_fd, cgroup_fd;
>         unsigned long packets;
> @@ -52,6 +52,12 @@ int main(int argc, char **argv)
>                 goto err;
>         }
>
> +       netcnt = malloc(sizeof(*netcnt));

curious, was it too big to be just allocated on the stack? Isn't the
thread stack size much bigger than 64KB (at least by default)?

> +       if (!netcnt) {
> +               printf("Not enough memory for non-per-cpu area\n");
> +               goto err;
> +       }
> +
>         if (bpf_prog_load(BPF_PROG, BPF_PROG_TYPE_CGROUP_SKB,
>                           &obj, &prog_fd)) {
>                 printf("Failed to load bpf program\n");
> @@ -96,7 +102,7 @@ int main(int argc, char **argv)
>                 goto err;
>         }
>
> -       if (bpf_map_lookup_elem(map_fd, &key, &netcnt)) {
> +       if (bpf_map_lookup_elem(map_fd, &key, netcnt)) {
>                 printf("Failed to lookup cgroup storage\n");
>                 goto err;
>         }
> @@ -109,8 +115,8 @@ int main(int argc, char **argv)
>         /* Some packets can be still in per-cpu cache, but not more than
>          * MAX_PERCPU_PACKETS.
>          */
> -       packets = netcnt.packets;
> -       bytes = netcnt.bytes;
> +       packets = netcnt->packets;
> +       bytes = netcnt->bytes;
>         for (cpu = 0; cpu < nproc; cpu++) {
>                 if (percpu_netcnt[cpu].packets > MAX_PERCPU_PACKETS) {
>                         printf("Unexpected percpu value: %llu\n",
> @@ -141,6 +147,7 @@ int main(int argc, char **argv)
>
>  err:
>         cleanup_cgroup_environment();
> +       free(netcnt);
>         free(percpu_netcnt);
>
>  out:
> --
> 2.32.0.432.gabb21c7263-goog
>
