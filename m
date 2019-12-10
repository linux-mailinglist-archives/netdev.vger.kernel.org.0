Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55182119D73
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbfLJWiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:38:03 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:44759 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730018AbfLJWdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:33:52 -0500
Received: by mail-qv1-f66.google.com with SMTP id n8so4890765qvg.11;
        Tue, 10 Dec 2019 14:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qVtlYAOtRcz+6F4XJkyiWApaYdPcES7nZQ2donezV0=;
        b=EHa/DmXt++387JQCZzAsAwfAYUEmAL11dzKPQCqQCESvSPxDAp9WeaxtLh+M31rPi7
         +upY71bq8lulevUKjgA6jD7B98vHdo96nfbz27BF1g6vYlBe7uQC+tC6A3/alg+/UZpu
         m5MOJadMJZ+iidQa4Iuvr7I9ngdppnGas9vc4YlJXWqn4rAVM3YG8RGKsYP5fUq6/p46
         o5McgujVuymvluZyoySMIhBOHZMOvwCQlqzd8k69B3hHDYKNRI2ls2ePzzvP3RMksaoc
         M2ZonpR+NP5eAuDzh8vMW11hj3+5T62UnOFoeimk5mjr62yeO0zgCAKv/RVSpZFggohR
         OUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2qVtlYAOtRcz+6F4XJkyiWApaYdPcES7nZQ2donezV0=;
        b=Kc69b3ZBf0WQmNyGi8GD+qGTEwnNobcW6+CcODjsuJKWcxM1PizyIpzjxeXWEnjpcG
         t2F0XmToXszj3xxw7PvCZl8Hxg++OBrPDJnltaFputAkLH0Dz8rBuDBR2rZwWyNycm+3
         eHbW9xZCSr328mCaJaCWk4kYM5J2TKSLc9yTsYujfAlf+2zaUbkluAuU7/tAPwvFxc0/
         Ljq64HxJrBGPmWxmFjLUcLiJz9RAYQkLK8poxjDjMtXkYqX8777++piQxdZThxUXcsWk
         7QGEedFl8DNogY681ZvddWfoSrh5I9Ff1z5PHTsvzkKXGCasrrQIxnO3jDoRJ+q1gqib
         0xAA==
X-Gm-Message-State: APjAAAVayoKRZW28YhSj2wvxfZaFkML5RfjPb1XSjuaHmgpoHuLwSkP4
        5ZeEflpGsCTaIL4SuvfyP8HKghmYoxoPG+/vmCs95A==
X-Google-Smtp-Source: APXvYqzLdU215RBR+lRJDFtX7NSmzsBYhixAzaNonjFfJXAAbiD83HVZkQwNdg4MVVrQyCITIQ0hr3XoBh8Oe4aRaBE=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr204409qvb.163.1576017230745;
 Tue, 10 Dec 2019 14:33:50 -0800 (PST)
MIME-Version: 1.0
References: <20191210011438.4182911-1-andriin@fb.com> <20191210011438.4182911-12-andriin@fb.com>
 <20191209175745.2d96a1f0@cakuba.netronome.com> <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
 <20191210100536.7a57d5e1@cakuba.netronome.com> <20191210214407.GA3105713@mini-arch>
In-Reply-To: <20191210214407.GA3105713@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Dec 2019 14:33:39 -0800
Message-ID: <CAEf4BzbSwoeKVnyJU7EoP86exNj3Eku5_+8MbEieZKt2MqrhbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
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

On Tue, Dec 10, 2019 at 1:44 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 12/10, Jakub Kicinski wrote:
> > On Tue, 10 Dec 2019 09:11:31 -0800, Andrii Nakryiko wrote:
> > > On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski wrote:
> > > > On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:
> > > > > struct <object-name> {
> > > > >       /* used by libbpf's skeleton API */
> > > > >       struct bpf_object_skeleton *skeleton;
> > > > >       /* bpf_object for libbpf APIs */
> > > > >       struct bpf_object *obj;
> > > > >       struct {
> > > > >               /* for every defined map in BPF object: */
> > > > >               struct bpf_map *<map-name>;
> > > > >       } maps;
> > > > >       struct {
> > > > >               /* for every program in BPF object: */
> > > > >               struct bpf_program *<program-name>;
> > > > >       } progs;
> > > > >       struct {
> > > > >               /* for every program in BPF object: */
> > > > >               struct bpf_link *<program-name>;
> > > > >       } links;
> > > > >       /* for every present global data section: */
> > > > >       struct <object-name>__<one of bss, data, or rodata> {
> > > > >               /* memory layout of corresponding data section,
> > > > >                * with every defined variable represented as a struct field
> > > > >                * with exactly the same type, but without const/volatile
> > > > >                * modifiers, e.g.:
> > > > >                */
> > > > >                int *my_var_1;
> > > > >                ...
> > > > >       } *<one of bss, data, or rodata>;
> > > > > };
> > > >
> > > > I think I understand how this is useful, but perhaps the problem here
> > > > is that we're using C for everything, and simple programs for which
> > > > loading the ELF is majority of the code would be better of being
> > > > written in a dynamic language like python?  Would it perhaps be a
> > > > better idea to work on some high-level language bindings than spend
> > > > time writing code gens and working around limitations of C?
> > >
> > > None of this work prevents Python bindings and other improvements, is
> > > it? Patches, as always, are greatly appreciated ;)
> >
> > This "do it yourself" shit is not really funny :/
> >
> > I'll stop providing feedback on BPF patches if you guy keep saying
> > that :/ Maybe that's what you want.
> >
> > > This skeleton stuff is not just to save code, but in general to
> > > simplify and streamline working with BPF program from userspace side.
> > > Fortunately or not, but there are a lot of real-world applications
> > > written in C and C++ that could benefit from this, so this is still
> > > immensely useful. selftests/bpf themselves benefit a lot from this
> > > work, see few of the last patches in this series.
> >
> > Maybe those applications are written in C and C++ _because_ there
> > are no bindings for high level languages. I just wish BPF programming
> > was less weird and adding some funky codegen is not getting us closer
> > to that goal.
> >
> > In my experience code gen is nothing more than a hack to work around
> > bad APIs, but experiences differ so that's not a solid argument.
> *nod*
>
> We have a nice set of C++ wrappers around libbpf internally, so we can do
> something like BpfMap<key type, value type> and get a much better interface
> with type checking. Maybe we should focus on higher level languages instead?
> We are open to open-sourcing our C++ bits if you want to collaborate.

Python/C++ bindings and API wrappers are an orthogonal concerns here.
I personally think it would be great to have both Python and C++
specific API that uses libbpf under the cover. The only debatable
thing is the logistics: where the source code lives, how it's kept in
sync with libbpf, how we avoid crippling libbpf itself because
something is hard or inconvenient to adapt w/ Python, etc.

The problem I'm trying to solve here is not really C-specific. I don't
think you can solve it without code generation for C++. How do you
"generate" BPF program-specific layout of .data, .bss, .rodata, etc
data sections in such a way, where it's type safe (to the degree that
language allows that, of course) and is not "stringly-based" API? This
skeleton stuff provides a natural, convenient and type-safe way to
work with global data from userspace pretty much at the same level of
performance and convenience, as from BPF side. How can you achieve
that w/ C++ without code generation? As for Python, sure you can do
dynamic lookups based on just the name of property/method, but amount
of overheads is not acceptable for all applications (and Python itself
is not acceptable for those applications). In addition to that, C is
the best way for other less popular languages (e.g., Rust) to leverage
libbpf without investing lots of effort in re-implementing libbpf in
Rust.

So while having nice high-level language-specific APIs is good, it's not enough.

>
> (I assume most of the stuff you have at fb is also non-c and one of
> c++/python/php/rust/go/whatver).

Yes, C++ using libbpf directly or through very thin wrappers. For
BCC-based stuff, obviously, we rely on C++ parts of BCC. This struct
I'm generating is extremely useful for C++ as well, as it gives very
natural way to access *and initialize* global variables.
