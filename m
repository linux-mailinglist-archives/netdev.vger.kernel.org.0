Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111A73D825D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhG0WRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 18:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbhG0WRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 18:17:16 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05815C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:17:16 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id t35-20020a05622a1823b02902647b518455so7356776qtc.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9iw0dubjE5zsYLP4fIDkD7k0FVzF1I+yTu8hnkFeAyI=;
        b=Wm0wv/lgXSHVAPTL916libelWnwvoxXru+sfKyPX/ALipj8rBdyTmeyggTBNHxuN+M
         st/ZgN+Tpons80RUio/N4vu6GBev+rpCU73584szYakeQ9RGUt5cUf4ZDkxXj1NczQ2a
         KHfWXR1e/NYREyh9jANFhq/C53NPzGqukXnyoE9ZCpUDJIPjRrK5u97Hn5Cn3r2HbCe5
         fymB1KnhMW+cPjp+C7IphVwYSegZmZtgUIaTav3Z5B8wcYEKzjq4sbMfZpR3xBvyzUVX
         FpM1fCb9rM6IyCXIiwc8VnsyQKg/k1S7pMK3Y+WowgKMiN80almbReswJNgaQ3p2ucag
         lgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9iw0dubjE5zsYLP4fIDkD7k0FVzF1I+yTu8hnkFeAyI=;
        b=qQZ3rNSBXg1eB87bRmpdlBuobZvVU0gwKeYFDV4UV4Jrihx019vPEvDdgLZ0IYzABV
         aHKJcS5PXf5Ef+G3LiWv9InPMIi5AB4EpLMu2p4+8k87iLk607797d7rkH3VwCIwmG+q
         m3Ifbb3ITONZGDNeuxl90UaHiCNY9FJdYAKkZqrwewjetLf2ho/WQ7rJWLokQ6CXVPmL
         ZloKV8Pw0I3rbdW/S3jW+YJ4L2BpaFeGE+IunoJZ7HhHemr9MFYIAYptL0/1/sjoDjo8
         1aRYGpOvFssPB/xk12PLkYXj2OFsQg7VADDsWNznsGqyEofbM4IzDYphtawi0TaTO3+4
         2sXw==
X-Gm-Message-State: AOAM531apcIHvfsiyOjm7pu2tGUvHLb1FPP0bUq8jFB74HOQ/ogeO98T
        bDWvna8AYk7YfF8hu2knorB3l5s=
X-Google-Smtp-Source: ABdhPJwncKiMnpWnYEWmiAvbLKUlua34iT+GNNw2ntCT8z97mmM4w8IYf8LJaJdaJtTI/g6EjZsxJ+A=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:d295:8a87:15f8:cb7])
 (user=sdf job=sendgmr) by 2002:a05:6214:dcf:: with SMTP id
 15mr24951771qvt.34.1627424234509; Tue, 27 Jul 2021 15:17:14 -0700 (PDT)
Date:   Tue, 27 Jul 2021 15:17:12 -0700
In-Reply-To: <CAEf4BzbEht9srvg8kJowM1e-t=2WOE3GCHWWJWsYYwKfT06iSQ@mail.gmail.com>
Message-Id: <YQCF6IjN3FJ5bjpx@google.com>
Mime-Version: 1.0
References: <20210726230032.1806348-1-sdf@google.com> <CAEf4BzaLc7rvUPquXnf+qxjrLSkCR21D7hj0HNVACmwNpgZvSw@mail.gmail.com>
 <YQBw+SLUQf0phOik@google.com> <CAEf4BzbEht9srvg8kJowM1e-t=2WOE3GCHWWJWsYYwKfT06iSQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpf: increase supported cgroup storage value size
From:   sdf@google.com
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/27, Andrii Nakryiko wrote:
> On Tue, Jul 27, 2021 at 1:47 PM <sdf@google.com> wrote:
> >
> > On 07/27, Andrii Nakryiko wrote:
> > > On Mon, Jul 26, 2021 at 4:00 PM Stanislav Fomichev <sdf@google.com>  
> wrote:
> > > >
> > > > Current max cgroup storage value size is 4k (PAGE_SIZE). The other  
> local
> > > > storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's
> > > align
> > > > max cgroup value size with the other storages.
> > > >
> > > > For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> > > > allocator is not happy about larger values.
> > > >
> > > > netcnt test is extended to exercise those maximum values
> > > > (non-percpu max size is close to, but not real max).
> > > >
> > > > v3:
> > > > * refine SIZEOF_BPF_LOCAL_STORAGE_ELEM comment (Yonghong Song)
> > > > * anonymous struct in percpu_net_cnt & net_cnt (Yonghong Song)
> > > > * reorder free (Yonghong Song)
> > > >
> > > > v2:
> > > > * cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)
> > > >
> > > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > > Cc: Yonghong Song <yhs@fb.com>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  kernel/bpf/local_storage.c                  | 11 +++++-
> > > >  tools/testing/selftests/bpf/netcnt_common.h | 38  
> +++++++++++++++++----
> > > >  tools/testing/selftests/bpf/test_netcnt.c   | 17 ++++++---
> > > >  3 files changed, 53 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
> > > > index 7ed2a14dc0de..035e9e3a7132 100644
> > > > --- a/kernel/bpf/local_storage.c
> > > > +++ b/kernel/bpf/local_storage.c
> > > > @@ -1,6 +1,7 @@
> > > >  //SPDX-License-Identifier: GPL-2.0
> > > >  #include <linux/bpf-cgroup.h>
> > > >  #include <linux/bpf.h>
> > > > +#include <linux/bpf_local_storage.h>
> > > >  #include <linux/btf.h>
> > > >  #include <linux/bug.h>
> > > >  #include <linux/filter.h>
> > > > @@ -283,9 +284,17 @@ static int cgroup_storage_get_next_key(struct
> > > bpf_map *_map, void *key,
> > > >
> > > >  static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr  
> *attr)
> > > >  {
> > > > +       __u32 max_value_size = BPF_LOCAL_STORAGE_MAX_VALUE_SIZE;
> > > >         int numa_node = bpf_map_attr_numa_node(attr);
> > > >         struct bpf_cgroup_storage_map *map;
> > > >
> > > > +       /* percpu is bound by PCPU_MIN_UNIT_SIZE, non-percu
> > > > +        * is the same as other local storages.
> > > > +        */
> > > > +       if (attr->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
> > > > +               max_value_size = min_t(__u32, max_value_size,
> > > > +                                      PCPU_MIN_UNIT_SIZE);
> > > > +
> > > >         if (attr->key_size != sizeof(struct bpf_cgroup_storage_key)  
> &&
> > > >             attr->key_size != sizeof(__u64))
> > > >                 return ERR_PTR(-EINVAL);
> > > > @@ -293,7 +302,7 @@ static struct bpf_map
> > > *cgroup_storage_map_alloc(union bpf_attr *attr)
> > > >         if (attr->value_size == 0)
> > > >                 return ERR_PTR(-EINVAL);
> > > >
> > > > -       if (attr->value_size > PAGE_SIZE)
> > > > +       if (attr->value_size > max_value_size)
> > > >                 return ERR_PTR(-E2BIG);
> > > >
> > > >         if (attr->map_flags & ~LOCAL_STORAGE_CREATE_FLAG_MASK ||
> > > > diff --git a/tools/testing/selftests/bpf/netcnt_common.h
> > > b/tools/testing/selftests/bpf/netcnt_common.h
> > > > index 81084c1c2c23..87f5b97e1932 100644
> > > > --- a/tools/testing/selftests/bpf/netcnt_common.h
> > > > +++ b/tools/testing/selftests/bpf/netcnt_common.h
> > > > @@ -6,19 +6,43 @@
> > > >
> > > >  #define MAX_PERCPU_PACKETS 32
> > > >
> > > > +/* sizeof(struct bpf_local_storage_elem):
> > > > + *
> > > > + * It really is about 128 bytes on x86_64, but allocate more to
> > > account for
> > > > + * possible layout changes, different architectures, etc.
> > > > + * The kernel will wrap up to PAGE_SIZE internally anyway.
> > > > + */
> > > > +#define SIZEOF_BPF_LOCAL_STORAGE_ELEM          256
> > > > +
> > > > +/* Try to estimate kernel's BPF_LOCAL_STORAGE_MAX_VALUE_SIZE: */
> > > > +#define BPF_LOCAL_STORAGE_MAX_VALUE_SIZE       (0xFFFF - \
> > > > +
> > > SIZEOF_BPF_LOCAL_STORAGE_ELEM)
> > > > +
> > > > +#define PCPU_MIN_UNIT_SIZE                     32768
> > > > +
> > > >  struct percpu_net_cnt {
> > > > -       __u64 packets;
> > > > -       __u64 bytes;
> > > > +       union {
> >
> > > so you have a struct with a single anonymous union inside, isn't that
> > > right? Any problems with just making struct percpu_net_cnt into union
> > > percpu_net_cnt?
> > We'd have to s/struct/union/ everywhere in this case, not sure
> > we want to add more churn? Seemed easier to do anonymous union+struct.

> 4 occurrences for net_cnt and another 4 for percpu_net_cnt, not much
> churn (and all pretty localized). But I honestly don't care, just
> wanted to note that you don't need this extra nesting.
I might do it since I'm doing another respin anyway.

> > > > +               struct {
> > > > +                       __u64 packets;
> > > > +                       __u64 bytes;
> > > >
> > > > -       __u64 prev_ts;
> > > > +                       __u64 prev_ts;
> > > >
> > > > -       __u64 prev_packets;
> > > > -       __u64 prev_bytes;
> > > > +                       __u64 prev_packets;
> > > > +                       __u64 prev_bytes;
> > > > +               };
> > > > +               __u8 data[PCPU_MIN_UNIT_SIZE];
> > > > +       };
> > > >  };
> > > >
> > > >  struct net_cnt {
> > > > -       __u64 packets;
> > > > -       __u64 bytes;
> > > > +       union {
> >
> > > similarly here
> >
> > > > +               struct {
> > > > +                       __u64 packets;
> > > > +                       __u64 bytes;
> > > > +               };
> > > > +               __u8 data[BPF_LOCAL_STORAGE_MAX_VALUE_SIZE];
> > > > +       };
> > > >  };
> > > >
> > > >  #endif
> > > > diff --git a/tools/testing/selftests/bpf/test_netcnt.c
> > > b/tools/testing/selftests/bpf/test_netcnt.c
> > > > index a7b9a69f4fd5..372afccf2d17 100644
> > > > --- a/tools/testing/selftests/bpf/test_netcnt.c
> > > > +++ b/tools/testing/selftests/bpf/test_netcnt.c
> > > > @@ -33,11 +33,11 @@ static int bpf_find_map(const char *test, struct
> > > bpf_object *obj,
> > > >
> > > >  int main(int argc, char **argv)
> > > >  {
> > > > -       struct percpu_net_cnt *percpu_netcnt;
> > > > +       struct percpu_net_cnt *percpu_netcnt = NULL;
> > > >         struct bpf_cgroup_storage_key key;
> > > > +       struct net_cnt *netcnt = NULL;
> > > >         int map_fd, percpu_map_fd;
> > > >         int error = EXIT_FAILURE;
> > > > -       struct net_cnt netcnt;
> > > >         struct bpf_object *obj;
> > > >         int prog_fd, cgroup_fd;
> > > >         unsigned long packets;
> > > > @@ -52,6 +52,12 @@ int main(int argc, char **argv)
> > > >                 goto err;
> > > >         }
> > > >
> > > > +       netcnt = malloc(sizeof(*netcnt));
> >
> > > curious, was it too big to be just allocated on the stack? Isn't the
> > > thread stack size much bigger than 64KB (at least by default)?
> > I haven't tried really, I just moved it to malloc because it crossed
> > some unconscious boundary for the 'stuff I allocate on the stack'.
> > I can try it out if you prefer to keep it on the stack, let me know.

> Yeah, if it can stay on the stack. Less thinking about freeing memory.
Ack, seems to be working, will resend shortly..
