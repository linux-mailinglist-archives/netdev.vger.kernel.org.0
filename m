Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B64258848F
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 00:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiHBWuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 18:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiHBWuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 18:50:09 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F0D20BE2;
        Tue,  2 Aug 2022 15:50:07 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i14so9679299ejg.6;
        Tue, 02 Aug 2022 15:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=rfkpQPKLu8SRWjwd0TtH906xz9zr70rSua/GjZiwncg=;
        b=Wd9p1qEtwQHVZWLVEbEMe3AQ+JCAwPYfU8jdUH2cHOQEwIoc1XBAzHbodO0B1fCYD0
         UpBuoEJyV1B0swkybzR4KdVJh5tDDZVM3DsIIzGVNZegMkRuMLIbpXUxJqJqox4nPtAz
         rRWzbMeRgQHivrhL138vGSActPpKv3yaatrB4cc28uHLqdkf74oLyfAXJ+c4BAOjM7W+
         N7dCjmcV95QE8WQI3Fkci/w9EhIRvn7/02u3gGmdJxm5MjadOgEeFRbwNK1aOM38bsqL
         zosSX19Qs0DqQGyX/LfQC0BeULRaR2n062yl92ATmp/+Jx/196u5ABsd3GGX60Je93tM
         eABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=rfkpQPKLu8SRWjwd0TtH906xz9zr70rSua/GjZiwncg=;
        b=ItLxDkMDOEUqUB1TqARA3M9dLMNp5JLfG+RbHBOVpxPiN3T+0lggx/KG5IFAhwhH9Y
         lVYDTiqUI9y/QXP70lQngl2Ui7gblJFjx7VQluleDkrEf1vQ1C0+GgrCrnbfDt2KubGs
         tnjtjTbnPfMnLVNLmXNW7OUd4A+cFJCFzVFfjhcJTxWs9GW4Y/VsO2U5AvZoOZbTLDCN
         qMRK7/Fs68Eq67qSjQ6Sk81B5an1fWlIXCLgrb2efD6bdoa7KHQh3Boprbfu340KCTwh
         +7TicffX395p+2HFH0uQ/tMrQxFMyvkxtsCOiXEIyPBEXXK+jrR4e9Ny3KoUn38Zk6qY
         SuYQ==
X-Gm-Message-State: AJIora+D8lkvIk2p9zCJcH96D6tz9I1rUuu8o2awsXAJA9F826cBHnqM
        +EpM3pJh8uGxmB1YtgN5G82XmrGPhSg/zFWbju0=
X-Google-Smtp-Source: AGRyM1tVilscQlMqtuCjMqxEiWukkme1VpEV5t4XIMIpZ1DFVec4hXV3fVO69UAWvoV0Jq0YQhqQQLe/Odo9MSKricE=
X-Received: by 2002:a17:907:6e1d:b0:72f:20ad:e1b6 with SMTP id
 sd29-20020a1709076e1d00b0072f20ade1b6mr18321344ejc.545.1659480605949; Tue, 02
 Aug 2022 15:50:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <CAEf4BzbD38XFVxMy5crO-=+Xg7U3Vc_fB4Ntug4BEbmdLpvuDQ@mail.gmail.com>
 <CA+khW7jftQikVsc8moM6rNRqBerUHDM6WRDjb33exdbogDc7aQ@mail.gmail.com>
In-Reply-To: <CA+khW7jftQikVsc8moM6rNRqBerUHDM6WRDjb33exdbogDc7aQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Aug 2022 15:49:54 -0700
Message-ID: <CAEf4BzYDqaTQr-S8TuLkysQ+FhT+6qMS0z=Sp_7+-wk84_4h6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
To:     Hao Luo <haoluo@google.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Kui-Feng Lee <kuifeng@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 2, 2022 at 3:27 PM Hao Luo <haoluo@google.com> wrote:
>
> Hi Andrii,
>
> On Mon, Aug 1, 2022 at 8:43 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jul 22, 2022 at 10:48 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> > >
> > > From: Hao Luo <haoluo@google.com>
> > >
> > > Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> > >
> > >  - walking a cgroup's descendants in pre-order.
> > >  - walking a cgroup's descendants in post-order.
> > >  - walking a cgroup's ancestors.
> > >
> > > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > > created from attaching. This cgroup is passed as a file descriptor and
> > > serves as the starting point of the walk. If no cgroup is specified,
> > > the starting point will be the root cgroup.
> > >
> > > For walking descendants, one can specify the order: either pre-order or
> > > post-order. For walking ancestors, the walk starts at the specified
> > > cgroup and ends at the root.
> > >
> > > One can also terminate the walk early by returning 1 from the iter
> > > program.
> > >
> > > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > > program is called with cgroup_mutex held.
> > >
> > > Currently only one session is supported, which means, depending on the
> > > volume of data bpf program intends to send to user space, the number
> > > of cgroups that can be walked is limited. For example, given the current
> > > buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > > cgroup, the total number of cgroups that can be walked is 512. This is
> > > a limitation of cgroup_iter. If the output data is larger than the
> > > buffer size, the second read() will signal EOPNOTSUPP. In order to work
> > > around, the user may have to update their program to reduce the volume
> > > of data sent to output. For example, skip some uninteresting cgroups.
> > > In future, we may extend bpf_iter flags to allow customizing buffer
> > > size.
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > > ---
> > >  include/linux/bpf.h                           |   8 +
> > >  include/uapi/linux/bpf.h                      |  30 +++
> > >  kernel/bpf/Makefile                           |   3 +
> > >  kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++++++++
> > >  tools/include/uapi/linux/bpf.h                |  30 +++
> > >  .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
> > >  6 files changed, 325 insertions(+), 2 deletions(-)
> > >  create mode 100644 kernel/bpf/cgroup_iter.c
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index a97751d845c9..9061618fe929 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -47,6 +47,7 @@ struct kobject;
> > >  struct mem_cgroup;
> > >  struct module;
> > >  struct bpf_func_state;
> > > +struct cgroup;
> > >
> > >  extern struct idr btf_idr;
> > >  extern spinlock_t btf_idr_lock;
> > > @@ -1717,7 +1718,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
> > >         int __init bpf_iter_ ## target(args) { return 0; }
> > >
> > >  struct bpf_iter_aux_info {
> > > +       /* for map_elem iter */
> > >         struct bpf_map *map;
> > > +
> > > +       /* for cgroup iter */
> > > +       struct {
> > > +               struct cgroup *start; /* starting cgroup */
> > > +               int order;
> > > +       } cgroup;
> > >  };
> > >
> > >  typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index ffcbf79a556b..fe50c2489350 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
> > >         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> > >  };
> > >
> > > +enum bpf_iter_cgroup_traversal_order {
> > > +       BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
> > > +       BPF_ITER_CGROUP_POST,           /* post-order traversal */
> > > +       BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
> >
> > I've just put up my arguments why it's a good idea to also support a
> > "trivial" mode of only traversing specified cgroup and no descendants
> > or parents. Please see [0].
>
> cc Kui-Feng in this thread.
>
> Yeah, I think it's a good idea. It's useful when we only want to show
> a single object, which can be common. Going further, I think we may
> want to restructure bpf_iter to optimize for this case.
>
> > I think the same applies here, especially
> > considering that it seems like a good idea to support
> > task/task_vma/task_files iteration within a cgroup.
>
> I have reservations on these use cases. I don't see immediate use of
> iterating vma or files within a cgroup. Tasks within a cgroup? Maybe.
> :)
>

iter/task was what I had in mind in the first place. But I can also
imagine tools utilizing iter/task_files for each process within a
cgroup, so given iter/{task, task_file, task_vma} share the same UAPI
and internals, I don't see why we'd restrict this to only iter/task.

> > So depending on
> > how successful I am in arguing for supporting task iterator with
> > target cgroup, I think we should reuse *exactly* this
> > bpf_iter_cgroup_traversal_order and how we specify cgroup (FD or ID,
> > see some more below) *as is* in task iterators as well. In the latter
> > case, having an ability to say "iterate task for only given cgroup" is
> > very useful, and for such mode all the PRE/POST/PARENT_UP is just an
> > unnecessary nuisance.
> >
> > So please consider also adding and supporting BPF_ITER_CGROUP_SELF (or
> > whatever naming makes most sense).
> >
>
> PRE/POST/UP can be reused for iter of tree-structured containers, like
> rbtree [1]. SELF can be reused for any iters like iter/task,
> iter/cgroup, etc. Promoting all of them out of cgroup-specific struct
> seems valuable.

you mean just define them as generic tree traversal orders? Sure, I
guess makes sense. No strong feelings.

>
> [1] https://lwn.net/Articles/902405/
>
> >
> > Some more naming nits. I find BPF_ITER_CGROUP_PRE and
> > BPF_ITER_CGROUP_POST a bit confusing. Even internally in kernel we
> > have css_next_descendant_pre/css_next_descendant_post, so why not
> > reflect the fact that we are going to iterate descendants:
> > BPF_ITER_CGROUP_DESCENDANTS_{PRE,POST}. And now that we use
> > "descendants" terminology, PARENT_UP should be ANCESTORS. ANCESTORS_UP
> > probably is fine, but seems a bit redundant (unless we consider a
> > somewhat weird ANCESTORS_DOWN, where we find the furthest parent and
> > then descend through preceding parents until we reach specified
> > cgroup; seems a bit exotic).
> >
>
> BPF_ITER_CGROUP_DESCENDANTS_PRE is too verbose. If there is a
> possibility of merging rbtree and supporting walk order of rbtree
> iter, maybe the name here could be general, like
> BPF_ITER_DESCENDANTS_PRE, which seems better.

it's not like you'll be typing this hundreds of type, so verboseness
doesn't seem to be too problematic, but sure, BPF_ITER_DESCENDANTS_PRE
is fine with me

>
> >   [0] https://lore.kernel.org/bpf/f92e20e9961963e20766e290ee6668edd4bacf06.camel@fb.com/T/#m5ce50632aa550dd87a99241efb168cbcde1ee98f
> >
> > > +};
> > > +
> > >  union bpf_iter_link_info {
> > >         struct {
> > >                 __u32   map_fd;
> > >         } map;
> > > +
> > > +       /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > > +        * ancestors of a given cgroup.
> > > +        */
> > > +       struct {
> > > +               /* Cgroup file descriptor. This is root of the subtree if walking
> > > +                * descendants; it's the starting cgroup if walking the ancestors.
> > > +                * If it is left 0, the traversal starts from the default cgroup v2
> > > +                * root. For walking v1 hierarchy, one should always explicitly
> > > +                * specify the cgroup_fd.
> > > +                */
> > > +               __u32   cgroup_fd;
> >
> > Now, similar to what I argued in regard of pidfd vs pid, I think the
> > same applied to cgroup_fd vs cgroup_id. Why can't we support both?
> > cgroup_fd has some benefits, but cgroup_id is nice due to simplicity
> > and not having to open/close/keep extra FDs (which can add up if we
> > want to periodically query something about a large set of cgroups).
> > Please see my arguments from [0] above.
> >
> > Thoughts?
> >
>
> We can support both, it's a good idea IMO. But what exactly is the
> interface going to look like? Can you be more specific about that?
> Below is something I tried based on your description.
>
> @@ -91,6 +91,18 @@ union bpf_iter_link_info {
>         struct {
>                 __u32   map_fd;
>         } map;
> +       struct {
> +               /* PRE/POST/UP/SELF */
> +               __u32 order;
> +               struct {
> +                       __u32 cgroup_fd;
> +                       __u64 cgroup_id;
> +               } cgroup;
> +               struct {
> +                       __u32 pid_fd;
> +                       __u64 pid;
> +               } task;
> +       };
>  };
>

So I wouldn't combine task and cgroup definition together, let's keep
them independent.

then for cgroup we can do something like:

struct {
    __u32 order;
    __u32 cgroup_fd; /* cgroup_fd ^ cgroup_id, exactly one can be non-zero */
    __u32 cgroup_id;
} cgroup

Similar idea with task, but it's a bit more complicated because there
we have target that can be pid, pidfd, or cgroup (cgroup_fd and
cgroup_id). I haven't put much thought into the best representation,
though.

> > > +               __u32   traversal_order;
> > > +       } cgroup;
> > >  };
> > >
> > >  /* BPF syscall commands, see bpf(2) man-page for more details. */
> >
> > [...]
