Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A747B17810D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733267AbgCCSAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:00:17 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39075 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733249AbgCCSAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:00:16 -0500
Received: by mail-qk1-f193.google.com with SMTP id e16so4296139qkl.6;
        Tue, 03 Mar 2020 10:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhQvd1T146KkjohFRaXEevnYThNA7CvsdsB9dL6DCfc=;
        b=efHA5ATwoWEKr9agC/gjw8iAo22w6qV5ne2qun3QGreq3DA1M+8aIQCMTPOChlLVMq
         9341Tbn9nEunnPMfogCqmZLN8/FhzEPj1r21hqlKtOE21De9//mmyQb8731hWrg5tzBw
         sNrW/nPnP+VYMAqHNri0PtEVQgimUii85k3bt70oULP5NMPh5uLWXFXZZVfMofnloiLm
         Q53JmXbGh2f71LLQ42rK6iU+B19CEAt+O6wXFW6Hk8/udqYmY++yJUGAWgNyIEtK8RLQ
         paVxSKhNmwfEjDeSCeoeJ3wQOG6CPrqQp4sXTVAYyIc6kW717bMMIdsqLLIjjr2qTiSR
         VIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhQvd1T146KkjohFRaXEevnYThNA7CvsdsB9dL6DCfc=;
        b=nSpmARNHSZVK+EbWxAVuTSZjVnUznBFsgpHsDLm62AHuA95NIhY3+8+tiBXHWSWVDB
         uLdZIyEnyXNxEcf6Vfk2kmdgi7ytsjoukqQu5oXprS+Pn8VlRwmDYJmfS4d5gN45S211
         jHJjURDDjKCEheGtfjKgiSkwzMXrmEUi5ntDuJ2Zot+dDMN7mT0RQgsB4y1suXwEvkLO
         QEJVOaOHcnSlRQu8f3EXs7SYhWIqHOEXsxPCBZot7rVek4lRkgGQ0eLmvtjGDEJ7kc1w
         NQAdy+p+ffUI7iBN+hbLHfxpV+T9dXkwTM7eIg9Uu7uSdjN+VPQoqFRG4kK3B79q+2zL
         aMAg==
X-Gm-Message-State: ANhLgQ1Qf0ptzBeKcPnmNviIkDOfwObzLAM09xeZ/zU7x3uh8wGTTnHJ
        bv+Zn9533Jur2c/e2US7yCnMIr6pmOOMhbAfuEk=
X-Google-Smtp-Source: ADFU+vvw+Qmt+XQABhVzsUM2Hu2ShOQTqx/ZqBjFt+cq9iAh9G82uJi8/Sw4Owi7lGeGpr/olZ4hBLfKEBneM3WR+vA=
X-Received: by 2002:a37:6716:: with SMTP id b22mr5417929qkc.437.1583258413678;
 Tue, 03 Mar 2020 10:00:13 -0800 (PST)
MIME-Version: 1.0
References: <20200303140837.90056-1-jolsa@kernel.org> <CAEf4BzY8_=wcL3N96eS-jcSPBL=ueMgQg+m=Fxiw+o0Tc7F23Q@mail.gmail.com>
 <20200303173314.GA74093@krava>
In-Reply-To: <20200303173314.GA74093@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Mar 2020 10:00:02 -0800
Message-ID: <CAEf4BzYQYJJwLUNhDoKcdgKsMijf9R5vG-vbOBYA-nUAgNs1qA@mail.gmail.com>
Subject: Re: [RFC] libbpf,selftests: Question on btf_dump__emit_type_decl for BTF_KIND_FUNC
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 9:33 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Mar 03, 2020 at 09:09:38AM -0800, Andrii Nakryiko wrote:
> > On Tue, Mar 3, 2020 at 6:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > for bpftrace I'd like to print BTF functions (BTF_KIND_FUNC)
> > > declarations together with their names.
> > >
> > > I saw we have btf_dump__emit_type_decl and added BTF_KIND_FUNC,
> > > where it seemed to be missing, so it prints out something now
> > > (not sure it's the right fix though).
> > >
> > > Anyway, would you be ok with adding some flag/bool to struct
> > > btf_dump_emit_type_decl_opts, so I could get output like:
> > >
> > >   kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
> > >   kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
> > >
> > > ... to be able to the arguments and return type separated,
> > > so I could easily get to something like above?
> > >
> > > Current interface is just vfprintf callback and I'm not sure
> > > I can rely that it will allywas be called with same arguments,
> > > like having separated calls for parsed atoms like 'return type',
> > > '(', ')', '(', 'arg type', 'arg name', ...
> > >
> > > I'm open to any suggestion ;-)
> >
> > Hey Jiri!
> >
> > Can you please elaborate on the use case and problem you are trying to solve?
> >
> > I think we can (and probably even should) add such option and support
> > to dump functions, but whatever we do it should be a valid C syntax
> > and should be compilable.
> > Example above:
> >
> > kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
> >
> > Is this really the syntax you need to get? I think btf_dump, when
> > (optionally) emitting function declaration, will have to emit that
> > particular one as:
> >
> > size_t ksys_read(unsigned int fd, char buf, long unsigned int count);
> >
> > But I'd like to hear the use case before we add this. Thanks!
>
> the use case is just for the 'bpftrace -l' output, which displays
> the probe names that could be used.. for kernel BTF kernel functions
> it's 'kfunc:function(args)'
>
>         software:task-clock:
>         hardware:backend-stalls:
>         hardware:branch-instructions:
>         ...
>         tracepoint:kvmmmu:kvm_mmu_pagetable_walk
>         tracepoint:kvmmmu:kvm_mmu_paging_element
>         ...
>         kprobe:console_on_rootfs
>         kprobe:trace_initcall_start_cb
>         kprobe:run_init_process
>         kprobe:try_to_run_init_process
>         ...
>         kfunc:x86_reserve_hardware
>         kfunc:hw_perf_lbr_event_destroy
>         kfunc:x86_perf_event_update
>
> I dont want to print the return type as is in C, because it would
> mess up the whole output, hence the '= <return type>'
>
>         kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
>         kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
>
> also possible only in verbose mode ;-)
>
> the final shape of the format will be decided in a bpftrace review,
> but in any case I think I'll need some way to get these bits:
>   <args> <return type>
>

Ok, I think for your use case it's better for you to implement it
customly, I don't think this fits btf_dump() C output as is. But you
have all the right high-level APIs anyways. There is nothing irregular
about function declarations, thankfully. Pointers to functions are way
more involved, syntactically, which is already abstracted from you in
btf_dump__emit_type_decl(). Here's the code:

static int dump_funcs(const struct btf *btf, struct btf_dump *d)
{
        int err = 0, i, j, cnt = btf__get_nr_types(btf);
        const struct btf_type *t;
        const struct btf_param *p;
        const char *name;

        for (i = 1; i <= cnt; i++) {
                t = btf__type_by_id(btf, i);
                if (!btf_is_func(t))
                        continue;

                name = btf__name_by_offset(btf, t->name_off);
                t = btf__type_by_id(btf, t->type);
                if (!btf_is_func_proto(t))
                        return -EINVAL;

                printf("kfunc:%s(", name);
                for (j = 0, p = btf_params(t); j < btf_vlen(t); j++, p++) {
                        err = btf_dump__emit_type_decl(d, p->type, NULL);
                        if (err)
                                return err;
                }
                printf(") = ");

                err = btf_dump__emit_type_decl(d, t->type, NULL);
                if (err)
                        return err;

                printf(";\n");
        }
        return 0;
}

Beware, this will crash right now due to NULL field_name, but I'm
fixing that with a tiny patch in just a second.

Also beware, there are no argument names captures for func_protos...

So with the above (and btf_dump__emit_type_decl() fix for NULL
field_name), this will produce output:

kfunc:num_digits(int) = int;
kfunc:copy_from_user_nmi(void *const void *long unsigned int) = long
unsigned int;
kfunc:arch_wb_cache_pmem(void *size_t) = void;
kfunc:__clear_user(void *long unsigned int) = long unsigned int;


>
> thanks,
> jirka
>
