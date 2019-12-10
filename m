Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F167711902F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfLJS5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:57:09 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36693 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfLJS5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:57:09 -0500
Received: by mail-qt1-f193.google.com with SMTP id k11so3786799qtm.3;
        Tue, 10 Dec 2019 10:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QvXZfnVU+/+mu4/zkiIZ0MF42uSvALKlbkqfQx+2tVs=;
        b=j8CYRjJ8k96VXVlK9/w2EH3otgBGNUjrlCZvpkJgcmRPjMe4mqoAeCK8x7/bZ1Pein
         WzHI84CwjiVM1qu7JlSp/e0Q7DmtODVUrkyA2TwxxBr8IbudULIMyO/dXin7AkCG8kXy
         9vKq+nR7UzRX3cVQanR6CnpjvXiJkewVWqCcd/2J5keNMNOuZOV71Gp9AqhO5C5icbwU
         ZcXbD91Y3C27Sincdy5CpVcmhDJM5MAxGOGpAE6+gSXc7YoYi0kuWISBJC+BYE3Ot1Gk
         TLqHJeo8DPusw2I/0zV15Hp++BVxKRJ8MTRdhIe/HWpJBKgUxLh2ERdg3g5YuNRSwnkm
         POew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QvXZfnVU+/+mu4/zkiIZ0MF42uSvALKlbkqfQx+2tVs=;
        b=YIHACy972aQ+egQ+kkZgzT8X9+Zl8MiibuKSPEoJ+FRNWX2B0UudoUjtbd6l6xkjYV
         ecw+N7Ha+qO5zUa0dzdtzbb6DuBJcs8tGrQl8hhcFPgZW5IJN4I4+4ft83Pt3xB7hwLv
         P6lwIFqLqvB6J8HhG7vfyT3QCgk3xu2rucTloPf6QQR7oPs4T+tkpYloaQzpK0HquEEh
         j31An5vNc+ShBroSFL0dv5fUaTZectkmWmA3E4zv4o5FJlfgX0nHya6yy+lar0fw+BaI
         ovoebd4mk95GZkYImGZsW3SjLK2Z053G0tYKj8GKX2wunhCW7uzbBVvn9LXTpziMBqTx
         lq+g==
X-Gm-Message-State: APjAAAXOwtVY3zjAtK/zFB7sqVgkgkLhxrlJbk4ewy4cTiwd1xgRorEi
        Gh9ZLGTSI4nWOhP4Q+RrE+tdKjpX2PAuWfh1IVc=
X-Google-Smtp-Source: APXvYqyQVsE/4FXTlEswdwh+TZXh2CtBLsGc82Ys108TfSpvuujOm1txqdNHN4PCUqjBQ4PIh5Kh94wyijRa5M/hq9g=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr18711543qtj.117.1576004228012;
 Tue, 10 Dec 2019 10:57:08 -0800 (PST)
MIME-Version: 1.0
References: <20191210011438.4182911-1-andriin@fb.com> <20191210011438.4182911-12-andriin@fb.com>
 <20191209175745.2d96a1f0@cakuba.netronome.com> <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
 <20191210100536.7a57d5e1@cakuba.netronome.com>
In-Reply-To: <20191210100536.7a57d5e1@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Dec 2019 10:56:56 -0800
Message-ID: <CAEf4BzbeZbmCTOOo2uQXjm0GL0WDu7aLN6fdUk18Nv2g0kfwVg@mail.gmail.com>
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

On Tue, Dec 10, 2019 at 10:05 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 10 Dec 2019 09:11:31 -0800, Andrii Nakryiko wrote:
> > On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski wrote:
> > > On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:
> > > > struct <object-name> {
> > > >       /* used by libbpf's skeleton API */
> > > >       struct bpf_object_skeleton *skeleton;
> > > >       /* bpf_object for libbpf APIs */
> > > >       struct bpf_object *obj;
> > > >       struct {
> > > >               /* for every defined map in BPF object: */
> > > >               struct bpf_map *<map-name>;
> > > >       } maps;
> > > >       struct {
> > > >               /* for every program in BPF object: */
> > > >               struct bpf_program *<program-name>;
> > > >       } progs;
> > > >       struct {
> > > >               /* for every program in BPF object: */
> > > >               struct bpf_link *<program-name>;
> > > >       } links;
> > > >       /* for every present global data section: */
> > > >       struct <object-name>__<one of bss, data, or rodata> {
> > > >               /* memory layout of corresponding data section,
> > > >                * with every defined variable represented as a struct field
> > > >                * with exactly the same type, but without const/volatile
> > > >                * modifiers, e.g.:
> > > >                */
> > > >                int *my_var_1;
> > > >                ...
> > > >       } *<one of bss, data, or rodata>;
> > > > };
> > >
> > > I think I understand how this is useful, but perhaps the problem here
> > > is that we're using C for everything, and simple programs for which
> > > loading the ELF is majority of the code would be better of being
> > > written in a dynamic language like python?  Would it perhaps be a
> > > better idea to work on some high-level language bindings than spend
> > > time writing code gens and working around limitations of C?
> >
> > None of this work prevents Python bindings and other improvements, is
> > it? Patches, as always, are greatly appreciated ;)
>
> This "do it yourself" shit is not really funny :/
>

Everyone has different priorities and limited time/resources. So
deciding for someone else where he/she needs to spend time is what's
not funny. As long as this work doesn't prevent any Python
improvements you'd hope (apparently) someone else to do, I don't see a
problem with addressing real needs for C/C++ applications. What am I
missing?

> I'll stop providing feedback on BPF patches if you guy keep saying
> that :/ Maybe that's what you want.

We do value feedback, of course, as long as it's constructive. Thanks.

>
> > This skeleton stuff is not just to save code, but in general to
> > simplify and streamline working with BPF program from userspace side.
> > Fortunately or not, but there are a lot of real-world applications
> > written in C and C++ that could benefit from this, so this is still
> > immensely useful. selftests/bpf themselves benefit a lot from this
> > work, see few of the last patches in this series.
>
> Maybe those applications are written in C and C++ _because_ there
> are no bindings for high level languages. I just wish BPF programming
> was less weird and adding some funky codegen is not getting us closer
> to that goal.
>
> In my experience code gen is nothing more than a hack to work around
> bad APIs, but experiences differ so that's not a solid argument.

Agreed about the last point. Look at all sorts of RPC frameworks
(e.g., grpc, Thrift) and tell people relying on them how codegen is a
bad idea.

>
> > > > This provides great usability improvements:
> > > > - no need to look up maps and programs by name, instead just
> > > >   my_obj->maps.my_map or my_obj->progs.my_prog would give necessary
> > > >   bpf_map/bpf_program pointers, which user can pass to existing libbpf APIs;
> > > > - pre-defined places for bpf_links, which will be automatically populated for
> > > >   program types that libbpf knows how to attach automatically (currently
> > > >   tracepoints, kprobe/kretprobe, raw tracepoint and tracing programs). On
> > > >   tearing down skeleton, all active bpf_links will be destroyed (meaning BPF
> > > >   programs will be detached, if they are attached). For cases in which libbpf
> > > >   doesn't know how to auto-attach BPF program, user can manually create link
> > > >   after loading skeleton and they will be auto-detached on skeleton
> > > >   destruction:
> > > >
> > > >       my_obj->links.my_fancy_prog = bpf_program__attach_cgroup_whatever(
> > > >               my_obj->progs.my_fancy_prog, <whatever extra param);
> > > >
> > > > - it's extremely easy and convenient to work with global data from userspace
> > > >   now. Both for read-only and read/write variables, it's possible to
> > > >   pre-initialize them before skeleton is loaded:
> > > >
> > > >       skel = my_obj__open(raw_embed_data);
> > > >       my_obj->rodata->my_var = 123;
> > > >       my_obj__load(skel); /* 123 will be initialization value for my_var */
> > > >
> > > >   After load, if kernel supports mmap() for BPF arrays, user can still read
> > > >   (and write for .bss and .data) variables values, but at that point it will
> > > >   be directly mmap()-ed to BPF array, backing global variables. This allows to
> > > >   seamlessly exchange data with BPF side. From userspace program's POV, all
> > > >   the pointers and memory contents stay the same, but mapped kernel memory
> > > >   changes to point to created map.
> > > >   If kernel doesn't yet support mmap() for BPF arrays, it's still possible to
> > > >   use those data section structs to pre-initialize .bss, .data, and .rodata,
> > > >   but after load their pointers will be reset to NULL, allowing user code to
> > > >   gracefully handle this condition, if necessary.
> > > >
> > > > Given a big surface area, skeleton is kept as an experimental non-public
> > > > API for now, until more feedback and real-world experience is collected.
> > >
> > > That makes no sense to me. bpftool has the same backward compat
> > > requirements as libbpf. You're just pushing the requirements from
> > > one component to the other. Feedback and real-world use cases have
> > > to be exercised before code is merged to any project with backward
> > > compatibility requirements :(
> >
> > To get this feedback we need to have this functionality adopted. To
> > have it adopted, we need it available in tool users already know,
> > have, and use.
>
> Well you claim you have users for it, just talk to them now. I don't
> understand how this is not obvious. It's like saying "we can't test
> this unless it's in the tree"..!?

It is useful right now as is, I never claimed I'm not sure if this
stuff is going to be used/useful. What I'm saying is that as we get
some more applications converted to this and used actively over
prolonged period of time, we might identify a bunch of tweaks we might
want to do. Talking with users without having a code for them to use
is not going to provide more insights beyond what we already
collected.

>
> > If you feel that "experimental" disclaimer is not enough, I guess we
> > can add extra flag to bpftool itself to enable experimental
> > functionality, something like:
> >
> > bpftool --experimental gen skeleton <bla>
>
> Yeah, world doesn't really work like that. Users start depending on
> a feature, it will break people's scripts/Makefiles if it disappears.
> This codegen thing is made to be hard coded in Makefiles.. how do you
> expect people not to immediately become dependent on it.

It's about managing expectations, isn't it? That's why I'm putting an
"experimental" disclaimer (or even extra --experimental flag as
described above) on this. If users is afraid of having a minor
breakage due to the need to add extra argument in source code and
recompile (if necessary), they shouldn't opt in.

>
> > > Also please run checkpatch on your patches, and fix reverse xmas tree.
> > > This is bpftool, not libbpf. Creating a separate tool for this codegen
> > > stuff is also an option IMHO.
> >
> > Sure, will fix few small things checkpatch detected.
>
> Running checkpatch should be part of your upstreaming routine, you're
> wasting people's time. So stop with the amused tone.
>
> > Will reverse christmas-ize all the variables, of course :)
> >
> > As for separate tool just for this, you are not serious, right? If
> > bpftool is not right tool for this, I don't know which one is.
>
> I am serious. There absolutely nothing this tool needs from BPF, no
> JSON needed, no bpffs etc. It can be a separate tool like
> libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
> That way you can actually soften the backward compat. In case people
> become dependent on it they can carry that little tool on their own.

We are trying to make users lives easier by having major distributions
distribute bpftool and libbpf properly. Adding extra binaries to
distribute around doesn't seem to be easing any of users pains.
