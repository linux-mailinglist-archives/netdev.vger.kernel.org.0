Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711E211DE30
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 07:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbfLMGXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 01:23:22 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37674 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLMGXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 01:23:21 -0500
Received: by mail-qt1-f195.google.com with SMTP id w47so1415115qtk.4;
        Thu, 12 Dec 2019 22:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqaOUzgKRCQS6i8M72Lp+GqkFLfAFdGSpItK/jP+Zjc=;
        b=rM73wQzIGk4vzF0CQQGRsdTJxT+OuVYzRWwGF9WjrrBaidBUUeWHOFYrgLOXG2vrMU
         nTYtmjeAw4YweeNlh5OkTFT6QB7cCDhL1lGo+83wmInuHgRduE9m/SHO0KifzKrPKpA/
         lHo4KwVGmjk2nFJ6WVbVancHVEjU8SHTZq1oT2ZvAuBLycmWviZSfNRiTAWcFDIg7ANu
         pWTdziPYY//X67azzaXbzQeTFhUfEcIVWquFMm1J69u3VRj4WeuPfOgshySPUXcvuK02
         TJGT7UNKW4kZoD9Qw38IF+7rnF2BIsFOikCK+neBortNo9XLWRjKS1qo5WNEWKa5m25P
         +52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqaOUzgKRCQS6i8M72Lp+GqkFLfAFdGSpItK/jP+Zjc=;
        b=I5801gVkI+tj2ctra6WWN5ruxgcA8S8Mtq/SXRyoPSKl+R/bx/1By+Gr04EfofKtXw
         RJk0j02vOogH5J3Oe//k5FLgoM5Dfz2HKF06xDFCsJQuJZgkJ21bADBYszXpsX+VoBrg
         68KabSb2CmB64m0sxGPHDP6nmkY1I1w0ou9WaxU0Me8nixI8mhHwfx99O5xXoIiyRZ3g
         +mCAuaT+0kLZAWp0tfWGPdMaCK+mZ+J/ZFnzipxED+ou8YgKYDvxGBNmQrQ5ySj6v1ti
         Ffn7tYid4k29CNlKhZWONIZc+lToUGCtlz/68iEqpJRShra1bb+81DAfDHtwJ5nN7MVC
         N+yg==
X-Gm-Message-State: APjAAAVUYcyW75xn343xKzCu8BfTzl5lnHY5pnS/uD223OYsfFnYhwbm
        K6Ca5cBWRAUzHoLd3vliwHbO1/6XoN9Ke/KMiYM=
X-Google-Smtp-Source: APXvYqyyWbpl6DwJ5gcq27sRwPe2NgMD72gqKki3YCWdrlUQvVvveYK8V0qaCBn3p86DTWUkRKw6Kpw7U8tKZQIHZd0=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr10963192qtl.171.1576218199688;
 Thu, 12 Dec 2019 22:23:19 -0800 (PST)
MIME-Version: 1.0
References: <20191211191518.GD3105713@mini-arch> <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
 <20191211200924.GE3105713@mini-arch> <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
 <20191212025735.GK3105713@mini-arch> <CAEf4BzY2KHK4h5e40QgGt4GzJ6c+rm-vtbyEdM41vUSqcs=txA@mail.gmail.com>
 <20191212162953.GM3105713@mini-arch> <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
 <20191212104334.222552a1@cakuba.netronome.com> <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
 <20191212214557.GO3105713@mini-arch>
In-Reply-To: <20191212214557.GO3105713@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Dec 2019 22:23:08 -0800
Message-ID: <CAEf4Bzav-hhbM35n7B+xx0Ybhq50k5ZMhgpeO0YOi4QN0dq5pQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andriin@fb.com>,
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

On Thu, Dec 12, 2019 at 1:46 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 12/12, Alexei Starovoitov wrote:
> > On Thu, Dec 12, 2019 at 10:43:34AM -0800, Jakub Kicinski wrote:
> > One more point from Stan's email:
> >
> > > You can replace "our build system" with some other project you care about,
> > > like systemd. They'd have the same problem with vendoring in recent enough
> >
> > we've been working with systemd folks for ~8 month to integrate libbpf into
> > their build that is using meson build system and their CI that is github based.
> > So we're well aware about systemd requirements for libbpf and friends.
> Just curious (searching on systemd github for bpftool/libbpf doesn't
> show up any code/issues): are you saying that there will be another ~8 months
> to bring in bpftool or that it's already being worked on as part of
> libbpf integration?
>
> > > bpftool or waiting for every distro to do it. And all this work is
> > > because you think that doing:
> > >
> > >        my_obj->rodata->my_var = 123;
> > >
> > > Is easier / more type safe than doing:
> > >        int *my_var = bpf_object__rodata_lookup(obj, "my_var");
> > >        *my_var = 123;
> >
> > Stan, you conveniently skipped error checking. It should have been:
> >     int *my_var = bpf_object__rodata_lookup(obj, "my_var");
> >     if (IS_ERROR_NULL(my_var))
> >         goto out_cleanup;
> >      *my_var = 123;
> Yeah, but you have a choice, right? You can choose to check the error
> and support old programs that don't export some global var and a new
> program that has it. Or you can skip the error checks and rely on null
> deref crash which is sometimes an option.

So your point is that between

A. Skeleton way:

my_obj->rodata->my_var = 123;

and

B. look up way:

int *my_var = bpf_object__rodata_lookup(obj, "my_var");
*my_var = 123;

B is **better**, because **if you drop error checking** (which
apparently is a choice within "Google distro") then it comes really
close to succinctness of skeleton, is that right?

Let's follow this through to the end with two pretty typical situations.

1. Someone renames my_var into my_var1.
  A. Skeleton: compilation error.
  B. Lookup: NULL deref, core dump. If there is helpful in-program
infra, it will dump stack trace and it should be pretty easy to
pinpoint which variable look up failed (provided binary is built with
debug info). If not - gdb is your friend, you'll figure this out
pretty quickly.

2. Someone changes the type of my_var from u64 to u32.
  A. Skeleton: compiler will warn on too large constant assignment,
but otherwise it's C, baby. But at least we are only going to write
(potentially truncated) 4 bytes.
  B. Lookup: we are happily overwriting 4 bytes of some other variable
(best case -- just padding), without anyone realizing this. Good if we
have exhaustive correctness testing for program logic.

I do think there is a clear winner, it just seems like we disagree which one.

>
> (might be not relevant with the introduction of EMBED_FILE which you
> seem to be using more and more; ideally, we still would like to be able to
> distribute bpf.o and userspace binary separately).

I don't even know what BPF_EMBED_OBJ has to do with skeleton, tbh.
BPF_EMBED_OBJ is just one of the ways to get contents of BPF object
file. You can just as well instantiate skeleton from separate .o file,
if you read its content in memory and create struct bpf_embed_data
with pointer to it (or just mmap() it, which would be even easier). If
this is typical case, we can generate an extra function to instantiate
skeleton from file, of course.

>
> > Take a look at Andrii's patch 13/15:
> > 5 files changed, 149 insertions(+), 249 deletions(-)
> > Those are simple selftests, yet code removal is huge. Bigger project benefits
> > even more.
> Excluding fentry/fexit tests (where new find_program_by_title+attach
> helper and mmap might help), it looks like the majority of those gains come
> from the fact that the patch in question doesn't do any error checking.
> You can drop all the CHECK() stuff for existing
> find_map_by_name/find_prog_by_name instead and get the same gains.

See above. The fact we are not doing error checking with skeleton is
because it can't fail. If programmer screwed up name of variable,
program, or variable -- that's compilation error! That's the reason we
don't check errors, not because it's a cowboy-style "You can choose to
check the error" approach.

>
> [as usual, feel free to ignore me, I don't want to keep flaming about
> it, but it's hard not to reply]

likewise
