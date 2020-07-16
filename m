Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FD422194F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgGPBLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGPBLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 21:11:51 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2AAC061755;
        Wed, 15 Jul 2020 18:11:51 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id t7so1941890qvl.8;
        Wed, 15 Jul 2020 18:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BFNPS8sk4dAYPl5BupqcCH5qBi2l0pAaLxk3GdcaEME=;
        b=dcbkVHM0WW+bXUqbdkP2gXpMo64HBK8I9lmFmqfCffSTTfjsP2I9jflHUAMaLATMwi
         /yh6yq6WsDQVWOZ9tMINPzFuPC3hG/wgMdsa/fDKtTLgvsRXb8/THktrW1QaQt1G05i7
         /HbNCV/nVVa793CjtIWhHsM7qF9WB2TVp+JnVjVl2UcU6XU+yIbOnVZpVLygNsEMyCGV
         aaf2pC26Utov3qEwqKBYj3SVzt5ojNczRnFYv5gK+hoy+3HfslPAtCDh0IJo9UUxJQ2J
         iiUX9Q5/cgpi8cPnV8U4jhmDQgcaSVoPRzHL8gpFjyIzGwujIDjDFrWlODysOAplNqFg
         jOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BFNPS8sk4dAYPl5BupqcCH5qBi2l0pAaLxk3GdcaEME=;
        b=Kgnf/U4hJyWFAP4CYe8+doDgloIf1SX0aKWfGJFiFwbUEhzq9yQ96sCbPLu2g5KWoP
         K6AVRlXpdyWQc8UEYfTkDRCCWDiAHKCg/ED7JYUoa4D/exnCs23YsV5dCmlOAF0UHSz/
         KFv/2jyLRrcVxbWsTghJJWzUVxCleN/9mo7mtcuZsJczJ5DAHY88/8xCzaNK+niV/I0N
         uaoVLwN2cF0wBMgwwxrE27lDxAuj7Up7MNt1nXtnv6Prdfq5Q10bu4+AXqsEsnXq4156
         aRTNYUBv2EtJMqQzSLrRrZfM8jsGX+lRGmfMTj3uSuCtvftXGSGzkSR/H6VCJoUibeXu
         pLUg==
X-Gm-Message-State: AOAM5317dI6hTP6yhjZhV0NyOwI45PVGbS5MpDQHp3MAbIsDOYQ1u4IQ
        xW0bmqBjSWobtdXpaWveL694Q57j3Zhk35mZKEs=
X-Google-Smtp-Source: ABdhPJyHR0V049mewYQLe3IYTzxBgifGxjHnP1nlL+D7Io/Vfjuqv1sdhdMFoxqD2pRVucRrFy8yb1Q9wgpzv9+AbHg=
X-Received: by 2002:ad4:4645:: with SMTP id y5mr2060166qvv.163.1594861910592;
 Wed, 15 Jul 2020 18:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
 <159467114405.370286.1690821122507970067.stgit@toke.dk> <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
 <87r1tegusj.fsf@toke.dk> <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk> <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk> <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk> <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 18:11:39 -0700
Message-ID: <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 4:41 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 15, 2020 at 02:56:36PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > On Wed, Jul 15, 2020 at 12:19:03AM +0200, Toke H=C3=83=C6=92=C3=82=C2=
=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
> > >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> > >>
> > >> >> However, assuming it *is* possible, my larger point was that we
> > >> >> shouldn't add just a 'logging struct', but rather a 'common optio=
ns
> > >> >> struct' which can be extended further as needed. And if it is *no=
t*
> > >> >> possible to add new arguments to a syscall like you're proposing,=
 my
> > >> >> suggestion above would be a different way to achieve basically th=
e same
> > >> >> (at the cost of having to specify the maximum reserved space in a=
dvance).
> > >> >>
> > >> >
> > >> > yeah-yeah, I agree, it's less a "logging attr", more of "common at=
tr
> > >> > across all commands".
> > >>
> > >> Right, great. I think we are broadly in agreement with where we want=
 to
> > >> go with this, actually :)
> > >
> > > I really don't like 'common attr across all commands'.
> > > Both of you are talking as libbpf developers who occasionally need to
> > > add printk-s to the kernel. That is not an excuse to bloat api that w=
ill be
> > > useful to two people.
> >
> > What? No, this is about making error messages comprehensible to people
> > who *can't* just go around adding printks. "Guess the source of the
> > EINVAL" is a really bad user experience!
> >
> > > The only reason log_buf sort-of make sense in raw_tp_open is because
> > > btf comparison is moved from prog_load into raw_tp_open.
> > > Miscompare of (prog_fd1, btf_id1) vs (prog_fd2, btf_id2) can be easil=
y solved
> > > by libbpf with as nice and as human friendly message libbpf can do.
> >
> > So userspace is supposed to replicate all the checks done by the kernel
> > because we can't be bothered to add proper error messages? Really?
>
> That's not what I said. The kernel can report unique errno for miscompare
> and all nice messages can and _should be_ be printed by libbpf.
>
>
> On Wed, Jul 15, 2020, Andrii Nakryiko wrote:
> >
> > Inability to figure out what's wrong when using BPF is at the top of
> > complaints from many users, together with hard to understand logs from
> > verifier.
>
> Only the second part is true. All users are complaining about the verifie=
r.
> No one is complaing that failed prog attach is somehow lacking string mes=
sage.

Ok, next time I'll be helping someone to figure out another -EINVAL,
I'll remember to reassure them that it's not really frustrating, not a
guess game, and not a time sink at all.

> The users are also complaing about libbpf being too verbose.

Very well might be, but apart from your complaints on that patch
adding program loading debug message, I can't remember a single case
when someone complained about that. Do you have a link for me to get
some context?

> Yet you've refused to address the verbosity where it should be reduced an=
d

It's open-source, everyone is welcome to submit their patches. Just
because I don't think we need to remove some log messages and thus not
am creating such patches, doesn't mean it can't be done by someone
else.

> now refusing to add it where it's needed.

Can you point to or quote where I refused to add a helpful message to libbp=
f?

> It's libbpf job to explain users kernel errors.

To the best of its ability, yes. Unfortunately there were many times
where I, as a human, couldn't figure it out without printk'ing my way
around the kernel. If I can't do that, I can't teach libbpf to do it.
Error codes are just not granular enough to allow distinguishing a lot
of error conditions, either by humans or automatically by libbpf.

>
> The same thing is happening with perf_event_open syscall.
> Every one who's trying to code it directly complaining about the kernel. =
But
> not a single user is complaing about perf syscall when they use libraries=
 and
> tools. Same thing with bpf syscall. libbpf is the interface. It needs to =
clear
> and to the point. Right now it's not doing it well. elf dump is too verbo=
se and
> unnecessary whereas in other places it says nothing informative where it
> could have printed human hint.
>
> libbpf's pr_perm_msg() hint is the only one where libbpf cares about its =
users.
> All other messages are useful to libbpf developers and not its users.

"Couldn't load trivial BPF program. Make sure your kernel supports BPF
(CONFIG_BPF_SYSCALL=3Dy) and/or that RLIMIT_MEMLOCK is set to big enough
value."
"kernel doesn't support global data"
"can't attach BPF program w/o FD (did you load it?)"
"specified path %s is not on BPF FS"
"vmlinux BTF is not found" -- we should clearly add "you need a kernel
built with CONFIG_DEBUG_INFO_BTF=3Dy"
"invalid relo for \'%s\' in special section 0x%x; forgot to initialize
global var?.."

And so on. Sure, we can have more and better error messages, no one is
claiming libbpf is perfect or done.

That doesn't mean, though, that the kernel itself can't do better in
terms of error reporting. But you clearly don't think it's a real
problem, so I'll let it rest, thank you.

>
> The kernel verifier messages suck as well. They need to be improved.
> But this thread 'lets add strings everywhere and users will be happy' is
> completely missing the mark.
