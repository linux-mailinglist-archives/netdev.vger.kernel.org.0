Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C967118EA9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfLJRLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:11:44 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44584 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfLJRLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:11:43 -0500
Received: by mail-qt1-f193.google.com with SMTP id g17so3410590qtp.11;
        Tue, 10 Dec 2019 09:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RagCXx4PLk5Qp49HJqKwcJPIWIyspcsm+oNaqdbslM=;
        b=DoyQL4KcMkvz7vmH3s3eQU8CtblHmOfXtg+ZpUXRAFLGVApTwLQ2X4LxuezG4hPs3o
         UKninZ55uaTToohw31YCmCgZZlHWGGXsb6JmJ/SodnaPv9Wc/18KczLZWzqO8YbBodrm
         r8bQr/Rx9Pr5GxFncLGbvR0Y5vRMxfl30/apLikbjSRcHJWYrSJFeuxQ7BmlBCl4xsfv
         YZu+4Ojivyp+JpHhIKmeuIlNKsP699nBFDzXn4u9aBdwOfIosV/TpukkRIEb3g0kUOEg
         570HmX9VOtMunjx6aMrD2R92K+rZJIBoNTBihxii1+T5ac+bLA4c8qoR6neDxOOnPoPS
         F2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RagCXx4PLk5Qp49HJqKwcJPIWIyspcsm+oNaqdbslM=;
        b=C/9UHY8xi4NxIAurarXCrYF15oHUq+OQ81orCLtOTw21ImlzZHtLazkO+CO2Fseqpl
         VKeXqpZZ0AdYTmBZtDC7YNjlUn/EkiQFIfuvGvpumeHRNELOxro8De6GW6GBuy4upXhP
         PYzdgAvOHb3XgCfDEebaXH1EvoNBc/jElsUxEPpXNuh4fX6f4qdepx9UgxefdmiFcgU2
         zmAjxrdBxYPWtFGiZzJSssh7OlXJzO8a274I7LXf5YJ/BKmiJSutnzaHI/rlcl85iowG
         HXO32FGubX+1RkZ5B9lNI+76NcY1fDciany0GF+49tNx1lZP2tc9/Y2xXDR12Q3je0u1
         B5Pw==
X-Gm-Message-State: APjAAAUZwVAK6Px+D7x6xFpvDqR8wlo2VRLYzIeX4+t/YswHiokxoIvt
        hDIVVFjyqL0sviOGA6o16ep5TjQfbicBykYCxTs=
X-Google-Smtp-Source: APXvYqzLPd7xnUCFZQkxfqfcRqMNP+6gooOhxuET6H41wpZU3iX8JkGS1BpXXwXN5CihWts8640sLFUibHQugmhtios=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr29404307qtq.93.1575997901883;
 Tue, 10 Dec 2019 09:11:41 -0800 (PST)
MIME-Version: 1.0
References: <20191210011438.4182911-1-andriin@fb.com> <20191210011438.4182911-12-andriin@fb.com>
 <20191209175745.2d96a1f0@cakuba.netronome.com>
In-Reply-To: <20191209175745.2d96a1f0@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Dec 2019 09:11:31 -0800
Message-ID: <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:
> > struct <object-name> {
> >       /* used by libbpf's skeleton API */
> >       struct bpf_object_skeleton *skeleton;
> >       /* bpf_object for libbpf APIs */
> >       struct bpf_object *obj;
> >       struct {
> >               /* for every defined map in BPF object: */
> >               struct bpf_map *<map-name>;
> >       } maps;
> >       struct {
> >               /* for every program in BPF object: */
> >               struct bpf_program *<program-name>;
> >       } progs;
> >       struct {
> >               /* for every program in BPF object: */
> >               struct bpf_link *<program-name>;
> >       } links;
> >       /* for every present global data section: */
> >       struct <object-name>__<one of bss, data, or rodata> {
> >               /* memory layout of corresponding data section,
> >                * with every defined variable represented as a struct field
> >                * with exactly the same type, but without const/volatile
> >                * modifiers, e.g.:
> >                */
> >                int *my_var_1;
> >                ...
> >       } *<one of bss, data, or rodata>;
> > };
>
> I think I understand how this is useful, but perhaps the problem here
> is that we're using C for everything, and simple programs for which
> loading the ELF is majority of the code would be better of being
> written in a dynamic language like python?  Would it perhaps be a
> better idea to work on some high-level language bindings than spend
> time writing code gens and working around limitations of C?

None of this work prevents Python bindings and other improvements, is
it? Patches, as always, are greatly appreciated ;)

This skeleton stuff is not just to save code, but in general to
simplify and streamline working with BPF program from userspace side.
Fortunately or not, but there are a lot of real-world applications
written in C and C++ that could benefit from this, so this is still
immensely useful. selftests/bpf themselves benefit a lot from this
work, see few of the last patches in this series.

>
> > This provides great usability improvements:
> > - no need to look up maps and programs by name, instead just
> >   my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
> >   bpf_map/bpf_program pointers, which user can pass to existing libbpf APIs;
> > - pre-defined places for bpf_links, which will be automatically populated for
> >   program types that libbpf knows how to attach automatically (currently
> >   tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
> >   tearing down skeleton, all active bpf_links will be destroyed (meaning BPF
> >   programs will be detached, if they are attached). For cases in which libbpf
> >   doesn't know how to auto-attach BPF program, user can manually create link
> >   after loading skeleton and they will be auto-detached on skeleton
> >   destruction:
> >
> >       my_obj->links.my_fancy_prog = bpf_program__attach_cgroup_whatever(
> >               my_obj->progs.my_fancy_prog, <whatever extra param);
> >
> > - it's extremely easy and convenient to work with global data from userspace
> >   now. Both for read-only and read/write variables, it's possible to
> >   pre-initialize them before skeleton is loaded:
> >
> >       skel = my_obj__open(raw_embed_data);
> >       my_obj->rodata->my_var = 123;
> >       my_obj__load(skel); /* 123 will be initialization value for my_var */
> >
> >   After load, if kernel supports mmap() for BPF arrays, user can still read
> >   (and write for .bss and .data) variables values, but at that point it will
> >   be directly mmap()-ed to BPF array, backing global variables. This allows to
> >   seamlessly exchange data with BPF side. From userspace program's POV, all
> >   the pointers and memory contents stay the same, but mapped kernel memory
> >   changes to point to created map.
> >   If kernel doesn't yet support mmap() for BPF arrays, it's still possible to
> >   use those data section structs to pre-initialize .bss, .data, and .rodata,
> >   but after load their pointers will be reset to NULL, allowing user code to
> >   gracefully handle this condition, if necessary.
> >
> > Given a big surface area, skeleton is kept as an experimental non-public
> > API for now, until more feedback and real-world experience is collected.
>
> That makes no sense to me. bpftool has the same backward compat
> requirements as libbpf. You're just pushing the requirements from
> one component to the other. Feedback and real-world use cases have
> to be exercised before code is merged to any project with backward
> compatibility requirements :(

To get this feedback we need to have this functionality adopted. To
have it adopted, we need it available in tool users already know,
have, and use. If you feel that "experimental" disclaimer is not
enough, I guess we can add extra flag to bpftool itself to enable
experimental functionality, something like:

bpftool --experimental gen skeleton <bla>

>
> Also please run checkpatch on your patches, and fix reverse xmas tree.
> This is bpftool, not libbpf. Creating a separate tool for this codegen
> stuff is also an option IMHO.

Sure, will fix few small things checkpatch detected. Will reverse
christmas-ize all the variables, of course :)

As for separate tool just for this, you are not serious, right? If
bpftool is not right tool for this, I don't know which one is.
