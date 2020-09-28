Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49927B3A9
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgI1Rvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgI1Rvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:51:31 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21F4C061755;
        Mon, 28 Sep 2020 10:51:30 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id f70so1535487ybg.13;
        Mon, 28 Sep 2020 10:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qTP8d6dwLkAh+M4ApAYeMXWqLPV1jTHesAupoc2kHSY=;
        b=E4fi1zAHUeotTp0Z1r5nI7mQsi3gxEL5SyafmaJ1/GlQ6KNNGQCfsT+51gs6ePjSkc
         LlE2AkVyA10UVrMw4hQj4Ax1kjhWapYFsqdBGXKOOuQgI7k+jnByZ6iF+jUMiG0VS/yz
         PpPEWhEruvtoyS6SDZndOGZC++A/KfE7OVVisrDH5iJ2iOveP80Ayf2Wn3PYVtU5W3sh
         Ug+Ejwii/v+3kCRCpcqf+eKyC45hZiq0Paaeu6HAgz9RNaaQcF4ldOUpZ3Gg7TRUrp6+
         Q9dWuccPrdz7PnVyCWkzwU06s8flWWPDI/cZ69cqaKbsnLeHtTjWvt4/FVb7uAKR50Lb
         KJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qTP8d6dwLkAh+M4ApAYeMXWqLPV1jTHesAupoc2kHSY=;
        b=miQEotDMH5cP3oyAC4NU+AsD4D4EUnAj5u6IdiRJoSC0MMCv88O+WmG4oiZasttge6
         Fm3QbUT62noY2KmYs1M152NJ1zKu0llNDLi9fiOKYAkX19T4Nnw9VXfAeeHQQhtZZM2V
         dTWQ3CjXym8mi4ss80aJ09IcMFqoKuF44tGDrqOTTVREqee2iMXneCASxfVfr+F8srOP
         B28IHm34aP0CFMCVKP6cbAnt4G9swGgFtmFykep89RqTA7bvOb5p1rRKPJfDHReUq0d1
         VzM+/NlJjjKeKYPLXQhubYT2kLBeFQiCsQ+NaCjgc2E1mE/GenV/uACmA5ExohY8aF/N
         YBog==
X-Gm-Message-State: AOAM533d1WEE6SUinGy2HU1XRJuU5wDaW6gNVcTou1/cs/5VVnzwi2V+
        /WXunzASWI1mwIMeSQnGisXCwy9c9W8hgyAyIl0=
X-Google-Smtp-Source: ABdhPJzb4iP1Y4Z4wPLox10qrUF6c/jCk5f9w7mRUTEZzUpGrHN35vSBQ4T21G8uAgOHZ7AZHiNAaeVff+gm2HvX/7w=
X-Received: by 2002:a25:2687:: with SMTP id m129mr906465ybm.425.1601315490150;
 Mon, 28 Sep 2020 10:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
 <1600883188-4831-7-git-send-email-alan.maguire@oracle.com>
 <20200925012611.jebtlvcttusk3hbx@ast-mbp.dhcp.thefacebook.com> <alpine.LRH.2.21.2009281500220.13299@localhost>
In-Reply-To: <alpine.LRH.2.21.2009281500220.13299@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Sep 2020 10:51:19 -0700
Message-ID: <CAEf4Bzb2JE_V7cQ=LGto6jHbiKUAg+A5MuqQ0LGb9L8qTUk6yg@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/6] selftests/bpf: add test for
 bpf_seq_printf_btf helper
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        andriy.shevchenko@linux.intel.com, Petr Mladek <pmladek@suse.com>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Andrey Ignatov <rdna@fb.com>, scott.branden@broadcom.com,
        Quentin Monnet <quentin@isovalent.com>,
        Carlos Neira <cneirabustos@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 7:14 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
>
>
> On Thu, 24 Sep 2020, Alexei Starovoitov wrote:
>
> > to whatever number, but printing single task_struct needs ~800 lines and
> > ~18kbytes. Humans can scroll through that much spam, but can we make it less
> > verbose by default somehow?
> > May be not in this patch set, but in the follow up?
> >
>
> One approach that might work would be to devote 4 bits or so of
> flag space to a "maximum depth" specifier; i.e. at depth 1,
> only base types are displayed, no aggregate types like arrays,
> structs and unions.  We've already got depth processing in the
> code to figure out if possibly zeroed nested data needs to be
> displayed, so it should hopefully be a simple follow-up.
>
> One way to express it would be to use "..." to denote field(s)
> were omitted. We could even use the number of "."s to denote
> cases where multiple fields were omitted, giving a visual sense
> of how much data was omitted.  So for example with
> BTF_F_MAX_DEPTH(1), task_struct looks like this:
>
> (struct task_struct){
>  .state = ()1,
>  .stack = ( *)0x00000000029d1e6f,
>  ...
>  .flags = (unsigned int)4194560,
>  ...
>  .cpu = (unsigned int)36,
>  .wakee_flips = (unsigned int)11,
>  .wakee_flip_decay_ts = (long unsigned int)4294914874,
>  .last_wakee = (struct task_struct *)0x000000006c7dfe6d,
>  .recent_used_cpu = (int)19,
>  .wake_cpu = (int)36,
>  .prio = (int)120,
>  .static_prio = (int)120,
>  .normal_prio = (int)120,
>  .sched_class = (struct sched_class *)0x00000000ad1561e6,
>  ...
>  .exec_start = (u64)674402577156,
>  .sum_exec_runtime = (u64)5009664110,
>  .vruntime = (u64)167038057,
>  .prev_sum_exec_runtime = (u64)5009578167,
>  .nr_migrations = (u64)54,
>  .depth = (int)1,
>  .parent = (struct sched_entity *)0x00000000cba60e7d,
>  .cfs_rq = (struct cfs_rq *)0x0000000014f353ed,
>  ...
>
> ...etc. What do you think?

It's not clear to me what exactly is omitted with ... ? Would it make
sense to still at least list a field name and "abbreviated" value.
E.g., for arrays:

.array_field = (int[16]){ ... },

Similarly for struct:

.struct_field = (struct my_struct){ ... },

? With just '...' I get a very strong and unsettling feeling of
missing out on the important stuff :)

>
> > > +SEC("iter/task")
> > > +int dump_task_fs_struct(struct bpf_iter__task *ctx)
> > > +{
> > > +   static const char fs_type[] = "struct fs_struct";
> > > +   struct seq_file *seq = ctx->meta->seq;
> > > +   struct task_struct *task = ctx->task;
> > > +   struct fs_struct *fs = (void *)0;
> > > +   static struct btf_ptr ptr = { };
> > > +   long ret;
> > > +
> > > +   if (task)
> > > +           fs = task->fs;
> > > +
> > > +   ptr.type = fs_type;
> > > +   ptr.ptr = fs;
> >
> > imo the following is better:
> >        ptr.type_id = __builtin_btf_type_id(*fs, 1);
> >        ptr.ptr = fs;
> >
>
> I'm still seeing lookup failures using __builtin_btf_type_id(,1) -
> whereas both __builtin_btf_type_id(,0) and Andrii's
> suggestion of bpf_core_type_id_kernel() work. Not sure what's
> going on - pahole is v1.17, clang is

bpf_core_type_id_kernel() is

__builtin_btf_type_id(*(typeof(type) *)0, BPF_TYPE_ID_TARGET)

BPF_TYPE_ID_TARGET is exactly 1. So I bet it's because of the type
capturing through typeof() and pointer casting/dereferencing, which
preserves type information properly. Regardless, just use the helper,
IMO.


>
> clang version 12.0.0 (/mnt/src/llvm-project/clang
> 7ab7b979d29e1e43701cf690f5cf1903740f50e3)
>

[...]
