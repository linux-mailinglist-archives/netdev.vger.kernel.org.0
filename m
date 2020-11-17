Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005FB2B72C0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 00:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgKQX47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 18:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgKQX47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 18:56:59 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD655C0613CF;
        Tue, 17 Nov 2020 15:56:58 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id o71so20349492ybc.2;
        Tue, 17 Nov 2020 15:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cQoAHZZx8waShIFkq4ckodhg6bz4M2II3k6qw4OLlhg=;
        b=ToTHsrCraHhGGHerk/KLH2bbjhEi5jwCeZXmgR7dQfNNEJZ7jG/VIAvQko73VQtVh/
         9hPrbECJG4iqZbF+lG0Ga79u1o/Kfpt4uSyV7e8teR5E1S2mdZ0wVGYFgREqDXwYkDoE
         JEZ8b0/iZCNMzhvUdiVbfe1mgeqTKB2/GPIboLaaehAFbLKOlSpOJG2hG0IcSil0EDA0
         npkQkwoU1wTvV4uOs5zaaxfcno0/v6ZW7yw+qNbIpP0k0jyw623YetDGXPJXbqeNqDie
         4hyMG/opQYvSLLu6pn6vHFJKyJomt9J1zqZnV0WQG+AR5KD2Nt7wyZzw7D7t6Xrevw8c
         khYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQoAHZZx8waShIFkq4ckodhg6bz4M2II3k6qw4OLlhg=;
        b=fMmeI942mXxHtJaML59XnlEOPuu/9GywgRdam08ueleMjoJhEI9gEVdjuzgWEeQ+zd
         RvDCENnXa0CWrXbredVmXoIlxXxV5EZ1lbUBv7rn90Afj/Z+rZBhmvvko3kTRPyKL6/b
         iHjMkbEAJmgy9dCZMyMobxU/DFgy07aHqpsDyZ6gP5+ipI0ly9mJF3TYBCKGd+XKWbOo
         yNBM4pxhcQ3svkTyfm2iExRR6Wq+0nLNaBRa0WojZIxKEgOli2t7FcgHC36Dj0YFmiVa
         74AYUrNGysb/iSHDdH3cxLuDO798jfd0S5ykxqEutL+7n/sCg+rdsqSDSyhvBW4Psyfb
         ylQA==
X-Gm-Message-State: AOAM530q4DPIKvlTFfkYhN/u4sitCHbbsYbcy4Qok14n+E7Ba/soZW2q
        mY5Cgu5JC0D6zYTwucvw3Wuss+6/A2aj3ZPvOtVk+bsgSO7Nzp+r
X-Google-Smtp-Source: ABdhPJz9WHJZE10jJciNNWvDwgszlENJ/BSMD7r5wy6jwexrZryN4nZNaoGHnwKyhzYPO5txV+kUwz9ZJlbzILpWO0c=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr2866036ybg.230.1605657418095;
 Tue, 17 Nov 2020 15:56:58 -0800 (PST)
MIME-Version: 1.0
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
 <1605291013-22575-2-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzaaUdMnfADQdT=myDJtQtHoQ_aW7T8XidrCkYZ=pGXuaQ@mail.gmail.com>
 <CAADnVQK6PFAHQMBgQ=Xp7tUFkUBg5yUgBM+r5mi-Kd5UWNWHzw@mail.gmail.com>
 <778cc9b5-2358-e491-1085-2a5c11dbbf57@fb.com> <alpine.LRH.2.21.2011151047410.2244@localhost>
In-Reply-To: <alpine.LRH.2.21.2011151047410.2244@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 15:56:47 -0800
Message-ID: <CAEf4BzZ08JHG6ZLU80tM-2_d7geaoFpCW8seuEo6JoUqcH1Z_g@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/3] bpf: add module support to btf display helpers
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 2:53 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Sat, 14 Nov 2020, Yonghong Song wrote:
>
> >
> >
> > On 11/14/20 8:04 AM, Alexei Starovoitov wrote:
> > > On Fri, Nov 13, 2020 at 10:59 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > >>
> > >> On Fri, Nov 13, 2020 at 10:11 AM Alan Maguire <alan.maguire@oracle.com>
> > >> wrote:
> > >>>
> > >>> bpf_snprintf_btf and bpf_seq_printf_btf use a "struct btf_ptr *"
> > >>> argument that specifies type information about the type to
> > >>> be displayed.  Augment this information to include a module
> > >>> name, allowing such display to support module types.
> > >>>
> > >>> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > >>> ---
> > >>>   include/linux/btf.h            |  8 ++++++++
> > >>>   include/uapi/linux/bpf.h       |  5 ++++-
> > >>>   kernel/bpf/btf.c               | 18 ++++++++++++++++++
> > >>>   kernel/trace/bpf_trace.c       | 42
> > >>>   ++++++++++++++++++++++++++++++++----------
> > >>>   tools/include/uapi/linux/bpf.h |  5 ++++-
> > >>>   5 files changed, 66 insertions(+), 12 deletions(-)
> > >>>
> > >>> diff --git a/include/linux/btf.h b/include/linux/btf.h
> > >>> index 2bf6418..d55ca00 100644
> > >>> --- a/include/linux/btf.h
> > >>> +++ b/include/linux/btf.h
> > >>> @@ -209,6 +209,14 @@ static inline const struct btf_var_secinfo
> > >>> *btf_type_var_secinfo(
> > >>>   const struct btf_type *btf_type_by_id(const struct btf *btf, u32
> > >>>   type_id);
> > >>>   const char *btf_name_by_offset(const struct btf *btf, u32 offset);
> > >>>   struct btf *btf_parse_vmlinux(void);
> > >>> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> > >>> +struct btf *bpf_get_btf_module(const char *name);
> > >>> +#else
> > >>> +static inline struct btf *bpf_get_btf_module(const char *name)
> > >>> +{
> > >>> +       return ERR_PTR(-ENOTSUPP);
> > >>> +}
> > >>> +#endif
> > >>>   struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
> > >>>   #else
> > >>>   static inline const struct btf_type *btf_type_by_id(const struct btf
> > >>>   *btf,
> > >>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > >>> index 162999b..26978be 100644
> > >>> --- a/include/uapi/linux/bpf.h
> > >>> +++ b/include/uapi/linux/bpf.h
> > >>> @@ -3636,7 +3636,8 @@ struct bpf_stack_build_id {
> > >>>    *             the pointer data is carried out to avoid kernel crashes
> > >>>    during
> > >>>    *             operation.  Smaller types can use string space on the
> > >>>    stack;
> > >>>    *             larger programs can use map data to store the string
> > >>> - *             representation.
> > >>> + *             representation.  Module-specific data structures can be
> > >>> + *             displayed if the module name is supplied.
> > >>>    *
> > >>>    *             The string can be subsequently shared with userspace via
> > >>>    *             bpf_perf_event_output() or ring buffer interfaces.
> > >>> @@ -5076,11 +5077,13 @@ struct bpf_sk_lookup {
> > >>>    * potentially to specify additional details about the BTF pointer
> > >>>    * (rather than its mode of display) - is included for future use.
> > >>>    * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
> > >>> + * A module name can be specified for module-specific data.
> > >>>   */
> > >>>   struct btf_ptr {
> > >>>          void *ptr;
> > >>>          __u32 type_id;
> > >>>          __u32 flags;            /* BTF ptr flags; unused at present. */
> > >>> +       const char *module;     /* optional module name. */
> > >>
> > >> I think module name is a wrong API here, similarly how type name was
> > >> wrong API for specifying the type (and thus we use type_id here).
> > >> Using the module's BTF ID seems like a more suitable interface. That's
> > >> what I'm going to use for all kinds of existing BPF APIs that expect
> > >> BTF type to attach BPF programs.
> > >>
> > >> Right now, we use only type_id and implicitly know that it's in
> > >> vmlinux BTF. With module BTFs, we now need a pair of BTF object ID +
> > >> BTF type ID to uniquely identify the type. vmlinux BTF now can be
> > >> specified in two different ways: either leaving BTF object ID as zero
> > >> (for simplicity and backwards compatibility) or specifying it's actual
> > >> BTF obj ID (which pretty much always should be 1, btw). This feels
> > >> like a natural extension, WDYT?
> > >>
> > >> And similar to type_id, no one should expect users to specify these
> > >> IDs by hand, Clang built-in and libbpf should work together to figure
> > >> this out for the kernel to use.
> > >>
> > >> BTW, with module names there is an extra problem for end users. Some
> > >> types could be either built-in or built as a module (e.g., XFS data
> > >> structures). Why would we require BPF users to care which is the case
> > >> on any given host?
> > >
> > > +1.
> > > As much as possible libbpf should try to hide the difference between
> > > type in a module vs type in the vmlinux, since that difference most of the
> > > time is irrelevant from bpf prog pov.
> >
>
> All sounds good to me - I've split out the libbpf fix and

yeah, thanks, I've applied yesterday.

> put together an updated patchset for the helpers/test which
> converts the currently unused __u32 "flags" field in
> struct btf_ptr to an "obj_id" field.  If obj_id is > 1 it

I haven't seen your updated patches (you haven't sent them yet?). You
shouldn't assume obj_id == 1 means vmlinux, though. struct btf in
kernel would have kernel_btf == true and its name should be "vmlinux"
for vmlinux BTF, otherwise kernel_btf == true means module BTF. We can
add separate bool just to distinguish vmlinux vs module BTF, if it
makes life easier, I think.

> is presumed to be a module ID.  I'd suggest we could move
> ahead with those changes, using the more clunky methods
> to retrieve the module-specific BTF id, and later fix up
> the test to use Yonghong's __builtin_btf_type_id()
> modification.  Does that sound reasonable?

Yonghong already updated Clang. Corresponding libbpf changes are very
minimal, feel free to add them as well. If not, I'm going to do it
this week anyways. Is there any hurry to land this before the proper
module BTF lands in libbpf, though?

>
> In connection to this, I wonder if libbpf could
> benefit from a simple helper btf__id() (similar
> to btf__fd()), allowing easy retrieval of the
> object ID associated with module BTF?  I suspect
> we will always have cases in general-purpose
> tracers where we need to look up BTF ids of
> objects dynamically, so such a function would
> help in that case.

We can add that as a convenience wrapper on top of
bpf_obj_get_info_by_fd() and cache the result internally, yes.


>
> > I just crafted a llvm patch where for __builtin_btf_type_id(), a 64bit value
> > is returned instead of a 32bit value. libbpf can use the lower
> > 32bit as the btf_type_id and upper 32bit as the kernel module btf id.
> >
> >    https://reviews.llvm.org/D91489
> >
> > feel free to experiment with it to see whether it helps.
> >
> >
>
> Great! I'll give it a try, thanks!
>
> Alan
