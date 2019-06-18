Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0A14AD6D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfFRVhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:37:38 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40990 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbfFRVhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:37:38 -0400
Received: by mail-qk1-f194.google.com with SMTP id c11so9595036qkk.8;
        Tue, 18 Jun 2019 14:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gf/ADOukO8s2rc/qgf4iND024eGfzgHmJw0NxKA2ghc=;
        b=gDSJXMQVC/6sBxdg726MwAWXzxPZ0yAwvdJe1ArAAntOV1ZWkYBwm7JI95HkyKsQAf
         a+HZEUvFiGfsTdgu+9sA7GuYHj4Hc5gd1U9otzYY5+8V7KSrZ4T5sXZhIG7mk8gn+L5H
         OzvQyL4MmHXfRUvg9TPB1c3QLPm/bM2uT9qQTvwO6VpumFPE6a498dq6Nc3Ncm2cgeJ9
         0PDJFLtRMxmEY7U+m5USPhmZKp6Vm225kX5pu1nRiyRmxvyyHNd/Rgv9gUtxbFyRLUZV
         ZjnmIcPMadjzq8alo31MClljT7cVc7HeIrX0n4f8mdbupD78uXzRxO0GulKztiaiiWXC
         +7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gf/ADOukO8s2rc/qgf4iND024eGfzgHmJw0NxKA2ghc=;
        b=UY+QU3CDHZjkYJqEXfDgldFaBCjCK2+u+jZAZ8ZaaTNTEJ48REVKsCrtV5Xp9tLUbI
         aP3MC5lR7u5lSr9LfixZ9kxhjteh3rS73qQ+wX2Ball2UOilL4VP283CDZtP3u7m/N+z
         kr/PvPqB9lEcRT2XFA08+YqeAoHHgxip0IEsSz+FzugVPKXxshp3Jjpk/x1Dmlm317jR
         DGjtS+cniEqWalReMZ05acHZfoOJLWJpJ4DwzqJoyjV6hKwldljm4zmqt7RlO3rXPt9B
         r6HjqsvNuHOtM/FCvUxYD70Y0PlYotpa91f0pRt5RqrIqvyguKVQeiULQ/nddRWcLaBB
         OCiA==
X-Gm-Message-State: APjAAAWTRmYMyfdXMOHyQJFGbCzWYiTntVGVv2ETAL33ejnCkUdhuWeO
        1rd5X4tCzOWe3GnhRUlMsMdrluiYpqrH9qpZ8KMJPc+7Hgo=
X-Google-Smtp-Source: APXvYqw/LKg0ZjJR9qvzjsv1mvngjpnk11Q7Ap0vHNZvpjxsbcTiqyJ6L5H8xN7P3L1/BwLPEHmVyXNXb9e9BDP0E/0=
X-Received: by 2002:ae9:eb53:: with SMTP id b80mr68020806qkg.172.1560893856596;
 Tue, 18 Jun 2019 14:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190617192700.2313445-1-andriin@fb.com> <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
In-Reply-To: <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Jun 2019 14:37:25 -0700
Message-ID: <CAEf4Bzae1CPDkhPrESa2ZmiOH8Mqf0KA_4ty9z=xnYn=q7Frhw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/11] BTF-defined BPF map definitions
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 2:17 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/17/2019 09:26 PM, Andrii Nakryiko wrote:
> > This patch set implements initial version (as discussed at LSF/MM2019
> > conference) of a new way to specify BPF maps, relying on BTF type information,
> > which allows for easy extensibility, preserving forward and backward
> > compatibility. See details and examples in description for patch #6.

Thanks for applying! Sorry for a bit of delayed in replying.

> >
> > [0] contains an outline of follow up extensions to be added after this basic
> > set of features lands. They are useful by itself, but also allows to bring
> > libbpf to feature-parity with iproute2 BPF loader. That should open a path
> > forward for BPF loaders unification.
> >
> > Patch #1 centralizes commonly used min/max macro in libbpf_internal.h.
> > Patch #2 extracts .BTF and .BTF.ext loading loging from elf_collect().
> > Patch #3 simplifies elf_collect() error-handling logic.
> > Patch #4 refactors map initialization logic into user-provided maps and global
> > data maps, in preparation to adding another way (BTF-defined maps).
> > Patch #5 adds support for map definitions in multiple ELF sections and
> > deprecates bpf_object__find_map_by_offset() API which doesn't appear to be
> > used anymore and makes assumption that all map definitions reside in single
> > ELF section.
> > Patch #6 splits BTF intialization from sanitization/loading into kernel to
> > preserve original BTF at the time of map initialization.
> > Patch #7 adds support for BTF-defined maps.
> > Patch #8 adds new test for BTF-defined map definition.
> > Patches #9-11 convert test BPF map definitions to use BTF way.
> >
> > [0] https://lore.kernel.org/bpf/CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntWAkJt47=FE+km+A@mail.gmail.com/
>
> Quoting above in here for some clarifications on the approach. Basically for
> iproute2, we would add libbpf library support on top of the current loader,
> this means existing object files keep working as-is, and users would have to
> decide whether they want to go with the new format or stick to the old one;
> incentive for the new format would be to get all the other libbpf features
> from upstream automatically. Though it means that once they switch there is
> no object file compatibility with older iproute2 versions anymore. For the
> case of Cilium, the container image ships with its own iproute2 version as
> we don't want to rely on distros that they keep iproute2<->kernel release in
> sync (some really don't). Switch should be fine in our case. For people
> upgrading, the 'external' behavior (e.g. bpf fs interaction etc) would need
> to stay the same to not run into any service disruption when switching versions.
>
> >1. Pinning. This one is simple:
> >  - add pinning attribute, that will either be "no pinning", "global
> >pinning", "object-scope pinning".
> >  - by default pinning root will be "/sys/fs/bpf", but one will be
> >able to override this per-object using extra options (so that
> >"/sys/fs/bpf/tc" can be specified).
>
> I would just drop the object-scope pinning. We avoided using it and I'm not
> aware if anyone else make use. It also has the ugly side-effect that this
> relies on AF_ALG which e.g. on some cloud provider shipped kernels is disabled.
> The pinning attribute should be part of the standard set of map attributes for
> libbpf though as it's generally useful for networking applications.

Sounds good. I'll do some more surveying of use cases inside FB to see
if anyone needs object-scope pinning, just to be sure we are not
short-cutting anyone.

>
> >2. Map-in-map declaration:
> >
> >As outlined at LSF/MM, we can extend value type to be another map
> >definition, specifying a prototype for inner map:
> >
> >struct {
> >        int type;
> >        int max_entries;
> >        struct outer_key *key;
> >        struct { /* this is definition of inner map */
> >               int type;
> >               int max_entries;
> >               struct inner_key *key;
> >               struct inner_value *value;
> >        } value;
> >} my_hash_of_arrays BPF_MAP = {
> >        .type = BPF_MAP_TYPE_HASH_OF_MAPS,
> >        .max_entries = 1024,
> >        .value = {
> >                .type = BPF_MAP_TYPE_ARRAY,
> >                .max_entries = 64,
> >        },
> >};
> >
> >This would declare a hash_of_maps, where inner maps are arrays of 64
> >elements each. Notice, that struct defining inner map can be declared
> >outside and shared with other maps:
> >
> >struct inner_map_t {
> >        int type;
> >        int max_entries;
> >        struct inner_key *key;
> >        struct inner_value *value;
> >};
> >
> >struct {
> >        int type;
> >        int max_entries;
> >        struct outer_key *key;
> >        struct inner_map_t value;
> >} my_hash_of_arrays BPF_MAP = {
> >        .type = BPF_MAP_TYPE_HASH_OF_MAPS,
> >        .max_entries = 1024,
> >        .value = {
> >                .type = BPF_MAP_TYPE_ARRAY,
> >                .max_entries = 64,
> >        },
> >};
>
> This one feels a bit weird to me. My expectation would have been something
> around the following to make this work:
>
>   struct my_inner_map {
>          int type;
>          int max_entries;
>          int *key;
>          struct my_value *value;
>   } btf_inner SEC(".maps") = {
>          .type = BPF_MAP_TYPE_ARRAY,
>          .max_entries = 16,
>   };
>
> And:
>
>   struct {
>          int type;
>          int max_entries;
>          int *key;
>          struct my_inner_map *value;
>   } btf_outer SEC(".maps") = {
>          .type = BPF_MAP_TYPE_ARRAY,
>          .max_entries = 16,
>          .value = &btf_inner,
>   };
>
> And the loader should figure this out and combine everything in the background.
> Otherwise above 'struct inner_map_t value' would be mixing convention of using
> pointer vs non-pointer which may be even more confusing.

There are two reasons I didn't want to go with that approach:

1. This syntax makes my_inner_map usable as a stand-alone map, while
it's purpose is to serve as a inner map prototype. While technically
it is ok to use my_inner_map as real map, it's kind of confusing and
feels unclean.
2. This approach doesn't play well with case where we want to
pre-initialize array-of-maps with links to other maps. E.g., compare
w/ this:

struct {
        int type;
        int max_entries;
        int *key;
        struct my_inner_map *values[];
} btf_outer_initialized SEC(".maps") = {
        .type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
        .max_entries = 16,
        .values = {
            &my_inner_map1,
            &my_inner_map2,
        },
};

In your case inner_map is a template, in this case my_inner_map1 and
my_inner_map2 is assigned to slots 0 and 1, respectively. But they
look deceivingly similar.

But in any case, we got to discussing details of map-in-map
initialization with Alexei, and concluded that for map-in-map cases
this split of key/value types being defined in struct definition and
flags/sizes/type being a compile-time assigned values becomes too much
of error-prone approach.
So we came up with a way to "encode" integer constants as part of BTF
type information, so that *all* declarative information is part of BTF
type, w/o the need to compile-time initialization. We tried to go the
other way (what Jakub was pushing for), but we couldn't figure out
anything that would work w/o more compiler hacks. So here's the
updated proposal:

#define __int(name, val) int (*name)[val]
#define __type(name, val) val (*foo)

struct my_value {
        int a;
        int b;
};

struct my_inner_map {
        __int(type, BPF_MAP_TYPE_ARRAY);
        __int(max_entries, 1000);
        __type(key, int);
        __type(value, struct my_value);
};

struct my_inner_map imap1 SEC(".maps");
struct my_inner_map imap2 SEC(".maps");

static struct {
        __int(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
        __int(max_entries, 1000);
        __type(key, int);
        __type(value, struct my_inner_map);
} my_outer_map SEC(".maps");

static struct {
        __int(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
        __int(max_entries, 1000);
        __type(key, int);
        __type(value, struct my_inner_map);
        struct my_inner_map *values[];
} my_initialized_outer_map SEC(".maps") = {
        .values = {
                &imap1,
                [500] = &imap2,
        },
};

Here struct my_inner_map is complete definition of array map w/ 1000
elements w/ all the type info for k/v. That struct is used as a
template for my_outer_map map-in-map. my_initialized_outer_map is the
case of pre-initialization of array-of-maps w/ instances of existing
maps imap1 and imap2.

The idea is that we encode integer fields as array dimensions + use
pointer to an array to save space. Given that syntax in plain C is a
bit ugly and hard to remember, we hide that behind __int macro. Then
in line with __int, we also have __type macro, that hides that hateful
pointer for key/value types. This allows map definition to be
self-describing w/o having to look at initialized ELF data section at
all, except for special cases of explicitly initializing map-in-map or
prog_array.

What do you think?

>
> >3. Initialization of prog array. Iproute2 supports a convention-driven
> >initialization of BPF_MAP_TYPE_PROG_ARRAY using special section names
> >(wrapped into __section_tail(ID, IDX)):
> >
> >struct bpf_elf_map SEC("maps") POLICY_CALL_MAP = {
> >        .type = BPF_MAP_TYPE_PROG_ARRAY,
> >        .id = MAP_ID,
> >        .size_key = sizeof(__u32),
> >        .size_value = sizeof(__u32),
> >        .max_elem = 16,
> >};
> >
> >__section_tail(MAP_ID, MAP_IDX) int handle_policy(struct __sk_buff *skb)
> >{
> >        ...
> >}
> >
> >For each such program, iproute2 will put its FD (for later
> >tail-calling) into a corresponding MAP with id == MAP_ID at index
> >MAP_IDX.
> >
> >Here's how I see this supported in BTF-defined maps case.
> >
> >typedef int (* skbuff_tailcall_fn)(struct __sk_buff *);
> >
> >struct {
> >        int type;
> >        int max_entries;
> >        int *key;
> >        skbuff_tailcall_fb value[];
> >} POLICY_CALL_MAP SEC(".maps") = {
> >        .type = BPF_MAP_TYPE_PROG_ARRAY,
> >        .max_entries = 16,
> >        .value = {
> >                &handle_policy,
> >                NULL,
> >                &handle_some_other_policy,
> >        },
> >};
> >
> >libbpf loader will greate BPF_MAP_TYPE_PROG_ARRAY map with 16 elements
> >and will initialize first and third entries with FDs of handle_policy
> >and handle_some_other_policy programs. As an added nice bonus,
> >compiler should also warn on signature mismatch. ;)
>
> Seems okay, I guess the explicit initialization could lead people to think
> that /after/ loading completed the NULL entries really won't have anything in
> that tail call slot. In our case, we share some of the tail call maps for different
> programs and each a different __section_tail(, idx), but in the end it's just a
> matter of initialization by index for the above. iproute2 today fetches the map
> from bpf fs if present, and only updates slots with __section_tail() present in
> the object file. Invocation would again be via index I presume (tail_call(skb,
> &policy_map, skb->mark), for example). For the __section_tail(MAP_ID, MAP_IDX),
> we do dynamically generate the MAP_IDX define in some cases, but that MAP_IDX
> would then simply be used in above POLICY_CALL_MAP instead; seems fine.

Yeah I can definitely see some confusion here. But it seems like this
is more of a semantics of map sharing, and maybe it should be some
extra option for when we have automatic support for extern (shared)
maps. E.g., something like

__int(sharing, SHARE_STRATEGY_MERGE) vs __int(sharing, SHARE_STRATEGY_OVERWRITE)

Haven't though through exact syntax, naming, semantics, but it seems
doable to support both, depending on desired behavior.

Maybe we should also unify this w/ pinning? E.g., there are many
sensible ways to handle already existing pinned map:

1. Reject program (e.g., if BPF application is the source of truth for that map)
2. Use pinned as is (e.g., if BPF application wants to consume data
from source of truth app)
3. Merge (what you described above)
4. Replace/reset - not sure if useful/desirable.

I'll need to study existing use cases a bit more though...

>
> >4. We can extend this idea into ARRAY_OF_MAPS initialization. This is
> >currently implemented in iproute2 using .id, .inner_id, and .inner_idx
> >fields.
> >
> >struct inner_map_t {
> >        int type;
> >        int max_entries;
> >        struct inner_key *key;
> >        struct inner_value *value;
> >};
> >
> >struct inner_map_t map1 = {...};
> >struct inner_map_t map2 = {...};
> >
> >struct {
> >        int type;
> >        int max_entries;
> >        struct outer_key *key;
> >        struct inner_map_t value[];
> >} my_hash_of_arrays BPF_MAP = {
> >        .type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
> >        .max_entries = 2,
> >        .value = {
> >                &map1,
> >                &map2,
> >        },
> >};
>
> Yeah, agree.

See above w/ updated proposal. For exactly the same outcome.

>
> > v1->v2:
> > - more BTF-sanity checks in parsing map definitions (Song);
> > - removed confusing usage of "attribute", switched to "field;
> > - split off elf_collect() refactor from btf loading refactor (Song);
> > - split selftests conversion into 3 patches (Stanislav):
> >   1. test already relying on BTF;
> >   2. tests w/ custom types as key/value (so benefiting from BTF);
> >   3. all the rest tests (integers as key/value, special maps w/o BTF support).
> > - smaller code improvements (Song);
> >
> > rfc->v1:
> > - error out on unknown field by default (Stanislav, Jakub, Lorenz);
> >
> > Andrii Nakryiko (11):
> >   libbpf: add common min/max macro to libbpf_internal.h
> >   libbpf: extract BTF loading logic
> >   libbpf: streamline ELF parsing error-handling
> >   libbpf: refactor map initialization
> >   libbpf: identify maps by section index in addition to offset
> >   libbpf: split initialization and loading of BTF
> >   libbpf: allow specifying map definitions using BTF
> >   selftests/bpf: add test for BTF-defined maps
> >   selftests/bpf: switch BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
> >   selftests/bpf: convert tests w/ custom values to BTF-defined maps
> >   selftests/bpf: convert remaining selftests to BTF-defined maps
> >
> >  tools/lib/bpf/bpf.c                           |   7 +-
> >  tools/lib/bpf/bpf_prog_linfo.c                |   5 +-
> >  tools/lib/bpf/btf.c                           |   3 -
> >  tools/lib/bpf/btf.h                           |   1 +
> >  tools/lib/bpf/btf_dump.c                      |   3 -
> >  tools/lib/bpf/libbpf.c                        | 781 +++++++++++++-----
> >  tools/lib/bpf/libbpf_internal.h               |   7 +
> >  tools/testing/selftests/bpf/progs/bpf_flow.c  |  18 +-
> >  .../selftests/bpf/progs/get_cgroup_id_kern.c  |  18 +-
> >  .../testing/selftests/bpf/progs/netcnt_prog.c |  22 +-
> >  .../selftests/bpf/progs/sample_map_ret0.c     |  18 +-
> >  .../selftests/bpf/progs/socket_cookie_prog.c  |  11 +-
> >  .../bpf/progs/sockmap_verdict_prog.c          |  36 +-
> >  .../selftests/bpf/progs/test_btf_newkv.c      |  73 ++
> >  .../bpf/progs/test_get_stack_rawtp.c          |  27 +-
> >  .../selftests/bpf/progs/test_global_data.c    |  27 +-
> >  tools/testing/selftests/bpf/progs/test_l4lb.c |  45 +-
> >  .../selftests/bpf/progs/test_l4lb_noinline.c  |  45 +-
> >  .../selftests/bpf/progs/test_map_in_map.c     |  20 +-
> >  .../selftests/bpf/progs/test_map_lock.c       |  22 +-
> >  .../testing/selftests/bpf/progs/test_obj_id.c |   9 +-
> >  .../bpf/progs/test_select_reuseport_kern.c    |  45 +-
> >  .../bpf/progs/test_send_signal_kern.c         |  22 +-
> >  .../bpf/progs/test_skb_cgroup_id_kern.c       |   9 +-
> >  .../bpf/progs/test_sock_fields_kern.c         |  60 +-
> >  .../selftests/bpf/progs/test_spin_lock.c      |  33 +-
> >  .../bpf/progs/test_stacktrace_build_id.c      |  44 +-
> >  .../selftests/bpf/progs/test_stacktrace_map.c |  40 +-
> >  .../testing/selftests/bpf/progs/test_tc_edt.c |   9 +-
> >  .../bpf/progs/test_tcp_check_syncookie_kern.c |   9 +-
> >  .../selftests/bpf/progs/test_tcp_estats.c     |   9 +-
> >  .../selftests/bpf/progs/test_tcpbpf_kern.c    |  18 +-
> >  .../selftests/bpf/progs/test_tcpnotify_kern.c |  18 +-
> >  tools/testing/selftests/bpf/progs/test_xdp.c  |  18 +-
> >  .../selftests/bpf/progs/test_xdp_noinline.c   |  60 +-
> >  tools/testing/selftests/bpf/test_btf.c        |  10 +-
> >  .../selftests/bpf/test_queue_stack_map.h      |  20 +-
> >  .../testing/selftests/bpf/test_sockmap_kern.h |  72 +-
> >  38 files changed, 1199 insertions(+), 495 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_btf_newkv.c
> >
>
