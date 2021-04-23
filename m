Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2C2369C1A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhDWVjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDWVjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 17:39:37 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D327C061574;
        Fri, 23 Apr 2021 14:38:59 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 82so57285285yby.7;
        Fri, 23 Apr 2021 14:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l729HMdhgRfdan4GldI4MviqHBVE4/h3UaSgCT0jtXA=;
        b=gLktoMHz/zB131BgS1KtCLFetFUD0k6BiQpdiUgTqUCtHr8zZdgsX4QRZesIqDEJf1
         akCs4ednXJmmMQ/eIkJ/nzjAT+VNcIhuirDdPsZe57Ia6b59DU27TvwYVRkj9L7Ihpgc
         1OCX+a4ZPk9vanM3MlZrlicjzrVjQ3CDpaYygZEZZsUFu2AYEsewzZmfyShf93uQ8UzQ
         BuXxtIUmpxJhiLoC2M1zMGk3BMC5FPbJb4On+HDr+6oesKUK9kABJthWIBnBlqRSKglN
         mwfM/E8yjtttduJGF0LroCk8OV3syUgpY3Qb36f7+QaoT5MvrPzDQmSGL29S4XeyhTvz
         2Iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l729HMdhgRfdan4GldI4MviqHBVE4/h3UaSgCT0jtXA=;
        b=RtKgw+mazCBdEBC1VBUOYpaeY2BQsJWhulGicR8y3LwFN335p9uK42iAdamhTGtYkk
         Jsm4BTiFfTbpsV1CUJx3HxqJrAdy7r21lKgVV7fhEBKm0DqpApGABBCg87aUrrNNER4E
         2EyCWozPhFLa1A4XK5aMh88YCml7E7um6qZ1kKGFoZAAYEi0f6rMAC5zjq8NGsvBid1O
         uzOR0fqgoVjL//1PDfOvFVtaGkRfMrbhEr4wvSpedh4PwaMg2L2owmoNF9BRtXQvFVQZ
         K1k/WGc0to4YbvKL0eIblcqmKTHwAGryZ5tpq4fyZtYHIVHxMs5sKIX6RHAjcwRyrnA2
         dyUg==
X-Gm-Message-State: AOAM531Rba3YYk8IqMXnMbtjHR1WclP5wwE+40qhEich6PL9felW2RJy
        sxHq+0+NDVy5ba8uibEqpt/veoPhiCdoXHWcpT0=
X-Google-Smtp-Source: ABdhPJx0Ox+YnHfGAfmCw01nkPRckcleVBxfN2dDBsXcSEL+f1+YbWpXfymxcGMkg6NCa/Pyy7NcFxguSxNoFV/m4tI=
X-Received: by 2002:a25:9942:: with SMTP id n2mr8644188ybo.230.1619213938741;
 Fri, 23 Apr 2021 14:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-1-andrii@kernel.org> <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
In-Reply-To: <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Apr 2021 14:38:47 -0700
Message-ID: <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 1:24 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> > Prepend <obj_name>.. prefix to each static variable in BTF info during static
> > linking. This makes them uniquely named for the sake of BPF skeleton use,
> > allowing to read/write static BPF variables from user-space. This uniqueness
> > guarantee depends on each linked file name uniqueness, of course. Double dots
> > separator was chosen both to be different (but similar) to the separator that
> > Clang is currently using for static variables defined inside functions as well
> > as to generate a natural (in libbpf parlance, at least) obj__var naming pattern
> > in BPF skeleton. Static linker also checks for static variable to already
> > contain ".." separator and skips the rename to allow multi-pass linking and not
> > keep making variable name ever increasing, if derived object name is changing on
> > each pass (as is the case for selftests).
> >
> > This patch also adds opts to bpf_linker__add_file() API, which currently
> > allows to override object name for a given file and could be extended with other
> > per-file options in the future. This is not a breaking change because
> > bpf_linker__add_file() isn't yet released officially.
> >
> > This patch also includes fixes to few selftests that are already using static
> > variables. They have to go in in the same patch to not break selftest build.
>
> "in in" => "in"

heh, I knew this would be confusing :) it's "go in" a verb and "in the
same patch" as where they go into. But I'll re-phrase in the next
version.

>
> > Keep in mind, this static variable rename only happens during static linking.
> > For any existing user of BPF skeleton using static variables nothing changes,
> > because those use cases are using variable names generated by Clang. Only new
> > users utilizing static linker might need to adjust BPF skeleton use, which
> > currently will be always new use cases. So ther is no risk of breakage.
> >
> > static_linked selftests is modified to also validate conflicting static variable
> > names are handled correctly both during static linking and in BPF skeleton.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >   tools/bpf/bpftool/gen.c                       |   2 +-
> >   tools/lib/bpf/libbpf.h                        |  12 +-
> >   tools/lib/bpf/linker.c                        | 121 +++++++++++++++++-
> >   .../selftests/bpf/prog_tests/skeleton.c       |   8 +-
> >   .../selftests/bpf/prog_tests/static_linked.c  |   8 +-
> >   .../selftests/bpf/progs/bpf_iter_test_kern4.c |   4 +-
> >   .../selftests/bpf/progs/test_check_mtu.c      |   4 +-
> >   .../selftests/bpf/progs/test_cls_redirect.c   |   4 +-
> >   .../bpf/progs/test_snprintf_single.c          |   2 +-
> >   .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
> >   .../selftests/bpf/progs/test_static_linked1.c |   6 +-
> >   .../selftests/bpf/progs/test_static_linked2.c |   4 +-
> >   12 files changed, 151 insertions(+), 28 deletions(-)
> >

[...]

> > +static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
> > +                             const struct bpf_linker_file_opts *opts,
> > +                             struct src_obj *obj)
> >   {
> >   #if __BYTE_ORDER == __LITTLE_ENDIAN
> >       const int host_endianness = ELFDATA2LSB;
> > @@ -549,6 +613,14 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
> >
> >       obj->filename = filename;
> >
> > +     if (OPTS_GET(opts, object_name, NULL)) {
> > +             strncpy(obj->obj_name, opts->object_name, MAX_OBJ_NAME_LEN);
> > +             obj->obj_name[MAX_OBJ_NAME_LEN - 1] = '\0';
>
> Looks we don't have examples/selftests which actually use this option.
> The only place to use bpf_linker__add_file() is bpftool which did not
> have option to overwrite the obj file name.
>
> The code looks fine to me though.

Right, I was a bit lazy in adding this to bpftool, but I'm sure we'll
want to support overriding obj file name, at least to resolve object
file name conflicts. One other problem is syntax, I haven't thought
through what's the best way to do this with bpftool. Something like
this would do it:

bpftool gen object dest.o input1.o=custom_obj_name
path/to/file2.o=another_custom_obj_name

But this is too bike-shedding a topic which I want to avoid for now.

>
> > +     } else {
> > +             get_obj_name(obj->obj_name, filename);
> > +     }
> > +     obj->obj_name_len = strlen(obj->obj_name);
> > +
> >       obj->fd = open(filename, O_RDONLY);
> >       if (obj->fd < 0) {
> >               err = -errno;
> > @@ -2264,6 +2336,47 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
> >                               obj->btf_type_map[i] = glob_sym->btf_id;
> >                               continue;
> >                       }
> > +             } else if (btf_is_var(t) && btf_var(t)->linkage == BTF_VAR_STATIC) {
> > +                     /* Static variables are renamed to include
> > +                      * "<obj_name>.." prefix (note double dots), similarly
> > +                      * to how static variables inside functions are named
> > +                      * "<func_name>.<var_name>" by compiler. This allows to
> > +                      * have  unique identifiers for static variables across
> > +                      * all linked object files (assuming unique filenames,
> > +                      * of course), which BPF skeleton relies on.
> > +                      *
> > +                      * So worst case static variable inside the function
> > +                      * will have the form "<obj_name>..<func_name>.<var_name"
> <var_name  => <var_name>

good catch, will fix

> > +                      * and will get sanitized by BPF skeleton generation
> > +                      * logic to a field with <obj_name>__<func_name>_<var_name>
> > +                      * name. Typical static variable will have a
> > +                      * <obj_name>__<var_name> name, implying arguably nice
> > +                      * per-file scoping.
> > +                      *
> > +                      * If static var name already contains '..', though,
> > +                      * don't rename it, because it was already renamed by
> > +                      * previous linker passes.
> > +                      */
> > +                     name = btf__str_by_offset(obj->btf, t->name_off);
> > +                     if (!strstr(name, "..")) {
> > +                             char new_name[MAX_VAR_NAME_LEN];
> > +
> > +                             memcpy(new_name, obj->obj_name, obj->obj_name_len);
> > +                             new_name[obj->obj_name_len] = '.';
> > +                             new_name[obj->obj_name_len + 1] = '.';
> > +                             new_name[obj->obj_name_len + 2] = '\0';
> > +                             /* -3 is for '..' separator and terminating '\0' */
> > +                             strncat(new_name, name, MAX_VAR_NAME_LEN - obj->obj_name_len - 3);
> > +
> > +                             id = btf__add_str(obj->btf, new_name);
> > +                             if (id < 0)
> > +                                     return id;
> > +
> > +                             /* btf__add_str() might invalidate t, so re-fetch */
> > +                             t = btf__type_by_id(obj->btf, i);
> > +
> > +                             ((struct btf_type *)t)->name_off = id;
> > +                     }
> >               }
> >

[...]

> > diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
> > index ee49493dc125..43bf8ec8ae79 100644
> > --- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
> > +++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
> > @@ -9,8 +9,8 @@ __u32 map1_id = 0, map2_id = 0;
> >   __u32 map1_accessed = 0, map2_accessed = 0;
> >   __u64 map1_seqnum = 0, map2_seqnum1 = 0, map2_seqnum2 = 0;
> >
> > -static volatile const __u32 print_len;
> > -static volatile const __u32 ret1;
> > +volatile const __u32 print_len = 0;
> > +volatile const __u32 ret1 = 0;
>
> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
> this is not in a static link test, right? The same for a few tests below.

All the selftests are passed through a static linker, so it will
append obj_name to each static variable. So I just minimized use of
static variables to avoid too much code churn. If this variable was
static, it would have to be accessed as
skel->rodata->bpf_iter_test_kern4__print_len, for example.

>
> >
> >   SEC("iter/bpf_map")
> >   int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
> > diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> > index c4a9bae96e75..71184af57749 100644
> > --- a/tools/testing/selftests/bpf/progs/test_check_mtu.c
> > +++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> > @@ -11,8 +11,8 @@
> >   char _license[] SEC("license") = "GPL";
> >

[...]
