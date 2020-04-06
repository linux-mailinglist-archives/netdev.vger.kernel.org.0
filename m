Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67AFF19FDB6
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgDFS7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:59:12 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38757 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgDFS7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:59:12 -0400
Received: by mail-qk1-f195.google.com with SMTP id h14so17376503qke.5;
        Mon, 06 Apr 2020 11:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FhUQ50FJvXYerE7pqAuRjsCvJDWVfozWW+eGdNz7xZQ=;
        b=aRANXusIKKNeeo7jgBmhY2mVLHTDoMLOGfoHDsjtEW6CFXnpoJvZxPz4JP4ENOcfQV
         4TwPan8+foQceR6E6RPEplumd90QlwBcbNpy14QCQFI7ijLZ1yIO8VGf8jdI80VtiFu4
         2B5VmCDFSiN4W+2ilZss7V9C0sBEnemfvwi3tx4mNeV+u6Oov9WKRTcA2dIE6GC4yOWB
         IxccjZKlj8g30+sSrxsO7wf5AfEWA2YWsXels26EE9un2Y19bXfNCStDLlB212CwqvMS
         Cmy85/LKCFEBkL72dV8O8pt8Bvkci5NTGRtFBkri7Eqfc/4KL7wyeOwe311IniT7VkJi
         URAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FhUQ50FJvXYerE7pqAuRjsCvJDWVfozWW+eGdNz7xZQ=;
        b=sTe5Xz+IqoSgZOiltEtuapXPN/Vlex4JYoFP26uuSfJY+GF1WHp7ho4eO95JcOLSl0
         GCTCRLKP5m6ks6JD1q4MtvEt887UrpozXLRW4SDQf1lYIvEdkZlBcFxR+uesTw17LgjW
         WM5J0ZuZX/2XyCm7FL0NOuaDSNOhWrfFowq5ZzFtI2TOBNq73H6+qztu6W/jSdEOLKop
         4PLLc2LzhjSkofgR6cmK+OYJP2ggNJxc1DTB6bRxR4vGzTFQ44uuvTC5yA61kOy7Og7a
         WcKRGBlUv9ovJOsXAIhfP/UKhcYA19olhEq+pW4tHNxSZVJ1FajrlCoQ55SH+bwxb13E
         G4UA==
X-Gm-Message-State: AGi0PubAtkB/YtndEQr2L5r+8vZrmcKwkQWmufa+Ein9quzYlg2aZlsg
        zr3yV22SDnB0TbDkXQ5ZatlV+/vAojbOXED8MTM=
X-Google-Smtp-Source: APiQypLtpX2icgkBe8ouZNdaYrAwxzV8qylfkHVt0sfQpctCU1ItcWB+JQ7sx+xgHI1UkQ+cnGyOaB6LWILlDEoy0wM=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr802447qka.449.1586199550490;
 Mon, 06 Apr 2020 11:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-6-andriin@fb.com>
 <87o8s4c0fo.fsf@toke.dk>
In-Reply-To: <87o8s4c0fo.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Apr 2020 11:58:59 -0700
Message-ID: <CAEf4BzZAkdc-=_jGB=hOL4zPRa_Q7G=BCgDgt=_in53hjWJ-2w@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 5/8] bpf: add support for BPF_OBJ_GET_INFO_BY_FD
 for bpf_link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 4:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Add ability to fetch bpf_link details through BPF_OBJ_GET_INFO_BY_FD co=
mmand.
> > Also enhance show_fdinfo to potentially include bpf_link type-specific
> > information (similarly to obj_info).
> >
> > Also introduce enum bpf_link_type stored in bpf_link itself and expose =
it in
> > UAPI. bpf_link_tracing also now will store and return bpf_attach_type.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/bpf-cgroup.h     |   2 -
> >  include/linux/bpf.h            |  10 +-
> >  include/linux/bpf_types.h      |   6 ++
> >  include/uapi/linux/bpf.h       |  28 ++++++
> >  kernel/bpf/btf.c               |   2 +
> >  kernel/bpf/cgroup.c            |  45 ++++++++-
> >  kernel/bpf/syscall.c           | 164 +++++++++++++++++++++++++++++----
> >  kernel/bpf/verifier.c          |   2 +
> >  tools/include/uapi/linux/bpf.h |  31 +++++++
> >  9 files changed, 266 insertions(+), 24 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index d2d969669564..ab95824a1d99 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -57,8 +57,6 @@ struct bpf_cgroup_link {
> >       enum bpf_attach_type type;
> >  };
> >
> > -extern const struct bpf_link_ops bpf_cgroup_link_lops;
> > -
> >  struct bpf_prog_list {
> >       struct list_head node;
> >       struct bpf_prog *prog;
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 67ce74890911..8cf182d256d4 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1026,9 +1026,11 @@ extern const struct file_operations bpf_prog_fop=
s;
> >       extern const struct bpf_verifier_ops _name ## _verifier_ops;
> >  #define BPF_MAP_TYPE(_id, _ops) \
> >       extern const struct bpf_map_ops _ops;
> > +#define BPF_LINK_TYPE(_id, _name)
> >  #include <linux/bpf_types.h>
> >  #undef BPF_PROG_TYPE
> >  #undef BPF_MAP_TYPE
> > +#undef BPF_LINK_TYPE
> >
> >  extern const struct bpf_prog_ops bpf_offload_prog_ops;
> >  extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
> > @@ -1086,6 +1088,7 @@ int bpf_prog_new_fd(struct bpf_prog *prog);
> >  struct bpf_link {
> >       atomic64_t refcnt;
> >       u32 id;
> > +     enum bpf_link_type type;
> >       const struct bpf_link_ops *ops;
> >       struct bpf_prog *prog;
> >       struct work_struct work;
> > @@ -1103,9 +1106,14 @@ struct bpf_link_ops {
> >       void (*dealloc)(struct bpf_link *link);
> >       int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_pr=
og,
> >                          struct bpf_prog *old_prog);
> > +     void (*show_fdinfo)(const struct bpf_link *link, struct seq_file =
*seq);
> > +     int (*fill_link_info)(const struct bpf_link *link,
> > +                           struct bpf_link_info *info,
> > +                           const struct bpf_link_info *uinfo,
> > +                           u32 info_len);
> >  };
> >
> > -void bpf_link_init(struct bpf_link *link,
> > +void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
> >                  const struct bpf_link_ops *ops, struct bpf_prog *prog)=
;
> >  int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *prim=
er);
> >  int bpf_link_settle(struct bpf_link_primer *primer);
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index ba0c2d56f8a3..8345cdf553b8 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -118,3 +118,9 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
> >  #if defined(CONFIG_BPF_JIT)
> >  BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> >  #endif
> > +
> > +BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> > +BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> > +#ifdef CONFIG_CGROUP_BPF
> > +BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
> > +#endif
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 407c086bc9e4..d2f269082a33 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -222,6 +222,15 @@ enum bpf_attach_type {
> >
> >  #define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
> >
> > +enum bpf_link_type {
> > +     BPF_LINK_TYPE_UNSPEC =3D 0,
> > +     BPF_LINK_TYPE_RAW_TRACEPOINT =3D 1,
> > +     BPF_LINK_TYPE_TRACING =3D 2,
> > +     BPF_LINK_TYPE_CGROUP =3D 3,
> > +
> > +     MAX_BPF_LINK_TYPE,
> > +};
> > +
> >  /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
> >   *
> >   * NONE(default): No further bpf programs allowed in the subtree.
> > @@ -3601,6 +3610,25 @@ struct bpf_btf_info {
> >       __u32 id;
> >  } __attribute__((aligned(8)));
> >
> > +struct bpf_link_info {
> > +     __u32 type;
> > +     __u32 id;
> > +     __u32 prog_id;
> > +     union {
> > +             struct {
> > +                     __aligned_u64 tp_name; /* in/out: tp_name buffer =
ptr */
> > +                     __u32 tp_name_len;     /* in/out: tp_name buffer =
len */
> > +             } raw_tracepoint;
> > +             struct {
> > +                     __u32 attach_type;
> > +             } tracing;
>
> Shouldn't this also include the attach target?

We can store extra stuff in bpf_link for this as well and return it,
I'll take a look what makes sense to return for bpf_tracing_link.

>
> -Toke
>
