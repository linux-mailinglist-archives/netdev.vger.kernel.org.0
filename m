Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB86196FE2
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 22:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgC2UXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 16:23:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35189 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgC2UX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 16:23:29 -0400
Received: by mail-qt1-f193.google.com with SMTP id e14so13467891qts.2;
        Sun, 29 Mar 2020 13:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0ooFEx0smIs0iJyMkZWVdRr5UqX535n3/wmKqmz5Ww4=;
        b=Njaaak7vrTqUH2JK0Yl8DjyOF7DYnVm4xQc4OD/b/ecxtLckjxgX53oV+uUTPEGNMv
         /M1/SIV+mCbKvWfFD0ID3dtXr9oQNi1wnb+Gk5vGzuR48vgc6sbLtPqQXBHDAWfUWp8a
         Fw514q+wbRz9Cf7t/OvbyOvgk6yDqAnKNmBJF0cPTLTNDSqpHmENmFqzwn+PYHIOJT64
         QPZ6f6G4q3kiZY/Lmjn2ytNrODfHUA8wiqBMs/m4bNv75m4q/DISSCexZKoPlyAIgJ0I
         ahxpA2YdjzED9gGF16Pk225ynnRdrvfN+t4S68zYDxhrHkjpK/RoKJImDL+QvsNFeOZd
         3edg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0ooFEx0smIs0iJyMkZWVdRr5UqX535n3/wmKqmz5Ww4=;
        b=LTn2or9yqsmaNUBimrAOTMnuRLw2ROcWVRkxITWq8OqSEHW5eOoKSwxhM6nWRp3YVj
         drCnGLjevf6sVP2xhrDe4NsTm6I8qiFjH0DdgftbAcd3cCBtHCqn4wlQoWSua/Vmgg/8
         KH8cjjOLUvEE4nv3HO+kdltnS22HHoJXHc1NpT/IlQr44ZPmC4EAL3+u1qvaAcq4xggv
         1sf/IlyTDFMpPf1dpLRbowK3k8dMj+i4QAfi+qxc3U+3fHirsWC9JZyaGZ/P9jBsdx6+
         kvhCpuwL8PAwQil0tAf/mA0u90aeqOW1hzlTJVAhxvkPAO0nKvO4FCMKbkuI9LFBwdmm
         DwUA==
X-Gm-Message-State: ANhLgQ1+vZUpF8CIZH40MJKzrQEJA2vPmZnk57wjyxG4J+uxJKZn6zpB
        pWSIF+e1roui0lmmuxFsuW6ZYPGfkbIOyiS9Z9U=
X-Google-Smtp-Source: ADFU+vuIiMwQB1czepeBQQaXrdBUb9B6yt4Qp2Tr/0vkGPyjzlyGGjbxyNZG+uJrL5seihJLsG4VyTlBhKsnZVzK3Io=
X-Received: by 2002:ac8:6918:: with SMTP id e24mr8809075qtr.141.1585513406477;
 Sun, 29 Mar 2020 13:23:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp> <87eetcl1e3.fsf@toke.dk>
In-Reply-To: <87eetcl1e3.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 29 Mar 2020 13:23:14 -0700
Message-ID: <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 12:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Sat, Mar 28, 2020 at 02:43:18AM +0100, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> >>
> >> No, I was certainly not planning to use that to teach libxdp to just
> >> nuke any bpf_link it finds attached to an interface. Quite the contrar=
y,
> >> the point of this series is to allow libxdp to *avoid* replacing
> >> something on the interface that it didn't put there itself.
> >
> > Exactly! "that it didn't put there itself".
> > How are you going to do that?
> > I really hope you thought it through and came up with magic.
> > Because I tried and couldn't figure out how to do that with IFLA_XDP*
> > Please walk me step by step how do you think it's possible.
>
> I'm inspecting the BPF program itself to make sure it's compatible.
> Specifically, I'm embedding a piece of metadata into the program BTF,
> using Andrii's encoding trick that we also use for defining maps. So
> xdp-dispatcher.c contains this[0]:
>
> __uint(dispatcher_version, XDP_DISPATCHER_VERSION) SEC(XDP_METADATA_SECTI=
ON);
>
> and libxdp will refuse to touch any program that it finds loaded on an

But you can't say the same about other XDP applications that do not
use libxdp. So will your library come with a huge warning, e.g.:

WARNING! ANY XDP APPLICATION YOU INSTALL ON YOUR MACHINE THAT DOESN'T
USE LIBXDP WILL BREAK YOUR FIREWALLS/ROUTERS/OTHER LIBXDP
APPLICATIONS. USE AT YOUR OWN RISK.

So you install your libxdp-based firewalls and are happy. Then you
decide to install this awesome packet analyzer, which doesn't know
about libxdp yet. Suddenly, you get all packets analyzer, but no more
firewall, until users somehow notices that it's gone. Or firewall
periodically checks that it's still runinng. Both not great, IMO, but
might be acceptable for some users, I guess. But imagine all the
confusion for user, especially if he doesn't give a damn about XDP and
other buzzwords, but only needs a reliable firewall :)

[...]
