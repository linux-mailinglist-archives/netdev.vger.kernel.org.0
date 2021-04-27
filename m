Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D237A36BD3B
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhD0CXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbhD0CXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:23:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45235C061574;
        Mon, 26 Apr 2021 19:22:35 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j6so925800pfh.5;
        Mon, 26 Apr 2021 19:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gm90twWQO8EjKXDc4bLOKXVi/RpCqyKfU16bcHr9z6w=;
        b=tqcBIdLWa1m5NR7KoIwcaIMIHv1Gu7vhdOdYkzkppapPn61Rz95zF8RHbxgdsyuUyK
         6+DDTkND8BbwzLj6s2OiSR0AeGc4PdnwcBSoAaBgGkbcTvzqxGoWh/+VGVD9yZTXtfoE
         hj6RhNjle3bUVIS4TQR8OYugnUjuqv6Xn6z3B12AuyIY9EB1J0RPikYWbrHupA2RRc00
         hH0K5wm6AqZFxu5BQLYX0hMo57N/IFqHkhi38a9AJUmJ6oagj++2ICUPNhHmMW24V/8f
         I+XW2B0CRMlaYtE8CuAHSl9ffK6qXMoUf/BPCHy9x1dY0utUfhrn1gAnuxe7flJ/AOBw
         kwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gm90twWQO8EjKXDc4bLOKXVi/RpCqyKfU16bcHr9z6w=;
        b=OtO1u+E+iG7qGZAs5gyg5Croprg/MakhLO1hcO6n+iXoxdh5bo4Fkk2CVwaNDSKDpv
         EM4QKsghbbSJ1UtMMbTufT91D7rrOBXO1732hslSVZX6sywXLVCc9bOfEhY6CYQq9RoA
         zxFuCaKMsTSrFbncYChWcQM7et1zM6LFds9Y9kxPi7ozGOZ0oOzwrWql1NGvAxKZ2IjS
         XZpHihL+XgpFM7HAQVO0w6+h9OEpL2+/FK82ayFefiPY39OaERD1Z1rTkx4TV0b9bWxg
         1mrZIFRs0fRP6DWBECFiLaCmkXo1HvfzA6pk0FsXT3x+l/xw7ekv4zk4bJz/A/H75Ood
         1OBg==
X-Gm-Message-State: AOAM532kLEockc86+5pMvM1Uefk4XUR/wMuOQ1nW9i/0ljeX2VHEkwP6
        e1fmcEJiAKWbObMeuIIDtnU=
X-Google-Smtp-Source: ABdhPJzveY0t5I8ICZ0gp+VbGKVZzM6v0g0crvollAlM9LVWBl5M1/saj7z96Xd1BTA16s09RUhIFQ==
X-Received: by 2002:a05:6a00:2c9:b029:276:3803:5239 with SMTP id b9-20020a056a0002c9b029027638035239mr8657228pft.25.1619490154568;
        Mon, 26 Apr 2021 19:22:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ad0])
        by smtp.gmail.com with ESMTPSA id e14sm11930821pga.14.2021.04.26.19.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 19:22:33 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:22:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
Message-ID: <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com>
 <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
 <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
 <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
 <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 04:11:23PM -0700, Andrii Nakryiko wrote:
> On Mon, Apr 26, 2021 at 3:34 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Apr 26, 2021 at 08:44:04AM -0700, Andrii Nakryiko wrote:
> > >
> > > >
> > > > > Static maps are slightly different, because we use SEC() which marks
> > > > > them as used, so they should always be present.
> > > >
> > > > yes. The used attribute makes the compiler keep the data,
> > > > but it can still inline it and lose the reference in the .text.
> > >
> > > At least if the map is actually used with helpers (e.g.,
> > > bpf_map_lookup_elem(&map, ...)) it would be invalid for compiler to do
> > > anything crazy with that map reference, because compiler has no
> > > visibility into what opaque helpers do with that memory. So I don't
> > > think it can alias multiple maps, for instance. So I think static maps
> > > should be fine.
> >
> > Yeah. That makes sense.
> >
> > > See above about passing a pointer to map into black box functions. I'd
> > > bet that the compiler can't merge together two different references at
> > > least because of that.
> > >
> > > For static maps, btw, just like for static functions and vars, there
> > > is no symbol, it's an offset into .maps section. We use that offset to
> > > identify the map itself.
> >
> > Ok. Sounds like there is a desire to expose both static and static volatile
> > into skeleton.
> > Sure, but let's make it such the linking step doesn't change the skeleton.
> > Imagine a project that using single .bpf.c file and skeleton.
> > It grows and wants to split itself into multiple .bpf.c.
> > If such split would change the skeleton generated var/map names
> > it would be annoying user experience.
> 
> It's surely not ideal, but it's a one-time step and only when user is
> ready to switch to linker, so I don't see it as such a big problem.

even small obstacles are obstacles for adoption.

> >
> > I see few options to avoid that:
> > - keeping the btf names as-is during linking
> > The final .o can have multiple vars and maps with the same name.
> > The skeleton gen can see the name collision and disambiguate them.
> > Here I think it's important to give users a choice. Blindly appending
> > file name is not ideal.
> > How to express it cleanly in .bpf.c? I don't know. SEC() would be a bit
> > ugly. May be similar to core flavors? ___1 and ___2 ? Also not ideal.
> 
> ___1 vs ___2 doesn't tell you which file you are accessing static
> variable from, you need to go and figure out the order of linking. If
> you look at bpf_linker__add_file() API, it has opts->object_name which
> allows you to specify what should be used as <prefix>__. Sane default
> seems to be the object name derived from filename, but it's possible
> to override this. To allow end-users customize we can extend bpftool
> to allow users to specify this. One way I was thinking would be
> something like
> 
> bpftool gen object my_obj1.o=my_prefix1 my_obj2.o=my_prefix2
> 
> If user doesn't want prefixing (e.g., when linking multi-file BPF
> library into a single .o) they would be able to disable this as:
> 
> bpftool gen object lib_file1.o= lib_file2.o= and so on

ouch. I think it's quite ugly.
Equally ugly would be to ask users to rename bpf_file.o into different_file.o
just to have a different prefix.

> > - another option is to fail skeleton gen if names conflict.
> > This way the users wold be able to link just fine and traditonal C style
> > linker behavior will be preserved, but if the user wants a skeleton
> > then the static map names across .bpf.c files shouldn't conflict.
> > imo that's reasonable restriction.
> 
> There are two reasons to use static:
> 1. hide it from BPF code in other files (compilation units)
> 2. allow name conflicts (i.e., not care about anyone else accidentally
> defining static variable with the same name)
> 
> I think both are important and I wouldn't want to give up #2. It
> basically says: "no other file should interfere with my state neither
> through naming or hijacking my state". Obviously it's impossible to
> guard from user-space interference due to how BPF maps/progs are
> visible to user-space, so those guarantees are mostly about BPF code
> side.

As far as #2 I think the linker should ignore the naming conflict and
proceed with linking. It's a skeleton gen that cares about different names.
Here we're using 'static' to mean too many things.
The #1 and #2 above is traditional C style semantics which should stay as-is
for .bpf.c code that is being linked.
But we use names as points of reference in the skeleton, so user space .c
would be able to access .bpf.c.
That's the opposite of what 'static' was designed for in C.
The .bpf.c is hiding it, but skeleton makes it sort-of external and
visible to user space .c. That's not really "static" meaning.
That's why I proposed earlier to avoid adding static to skeleton.
And that's the reason we're struggling to define it cleanly.

> Name prefixing only affects BPF skeleton generation and user-space use
> of those static variables, both of which are highly-specific use
> patterns "bridging two worlds", BPF and user-space. So I think it's
> totally reasonable to specify that such variables will have naming
> prefixes. Especially that BPF static variables inside functions
> already use similar naming conventions and are similarly exposed in
> BPF skeleton.

That's clang only style of mangling static vars inside functions.
No one should count on that behavior. clang can change that at any time.
If we see somebody doing it we should discourage such use.

> 
> > - maybe adopt __hidden for vars and maps? Only not hidden (which is default now)
> > would be seen in skeleton?
> 
> This is similar to the above, it gives up the ability to not care
> about naming so much, because everything is forced to be global.

I think the best is to avoid emitting static in skeleton.
imo that's the most accurate definition of 'static' from C pov.
The linker wouldn't care about the name and would have multiple
vars in BTF datasec with the same name.
The other option is to ask users to provide the name
for such 'static' that is still 'external' from .bpf.c into .c
Either SEC() will work or we can use
static int var __attribute__((alias("external_name"))); ?
'var' would stay in BTF datasec, but "external_name" would have
to be unique in skeleton across .o-s.
Or some other way to convey in .bpf.c file that 'static' var
is not quite static but actually visible to a different .c file.
Though it's bridging different worlds.
