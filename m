Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB85BECAD3
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfKAWJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:09:02 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36069 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAWJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:09:02 -0400
Received: by mail-lj1-f195.google.com with SMTP id x9so6859286lji.3;
        Fri, 01 Nov 2019 15:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EuosfU8HVrK4UuVI81P9UOcJin2WH4zGeZ+/Zcb3V38=;
        b=nNXFqEqGqbaNlIu6WrdEL+7SvusL9DNvty+w93L4B27sn0GGw6YCqwYSX1l0i13+kV
         QFxm6AAIPJTF2Jw6/be5mc6MUoSvvz14Fjn0AeCKhmTvpIv428tjYPDegDArExl2tWoy
         pTCVSZQ7+yFQtHtw5O16/slOy5Mlr3EQB7r+bpQgLuG2N54kcS4cSsxa9SCwtKGl2QZJ
         9FKGGW2vj9jANzraUWeBEhVU5MnE5fRNo6nXI2t60ZqYydmqrgkM05HvfHrmHdGRlXD8
         1JZNTCO4ohhzsjHF3IiDmiNS9VRREdojYisBRw8fmNvOuuxTh/ORz3PBjk4v2RYhIECD
         LH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EuosfU8HVrK4UuVI81P9UOcJin2WH4zGeZ+/Zcb3V38=;
        b=igTpeSgxa5cCYsEIaX6yhRGvb4tfpjoWNYULszTfoaP2kbULnBtTRIFu1Vn10/Q6jJ
         8nf386XTCVPlzkaQN+NUqM+9HuOFuhiRncb7gRuMTYkunRjRSYqkgeI1mG3jqTioyZzH
         WB0mwBPsFrKY4S8VTEaiN/muI6vL/NwZjhSdq16E4TU6qP51Nb8ixpfcbZrcJ5r2vtPl
         17L5WFJ4feLg6HszCyFexVi0egvp6NYN5PWRqiriCtyQ9eO6Rn9FCKCo4vu1z+MisdiB
         vxAKdEUlSWUXuwIMIWLdPbycancl2XxQgcdLbZedCvFyBwJoYonFfYZYpch9xuZnL+K3
         7lrQ==
X-Gm-Message-State: APjAAAXXJeXV90O2UYkshJkYOTEwdf7Zw60IPzOJQIAB6lJx7WwllLPI
        yj1PiJpJ4nVtueO5aC/LzDN2zkA1//ZulRyTPYY=
X-Google-Smtp-Source: APXvYqx45yQi4Nn8NsMYE4x5+AdevvWz2o9Ylm5bp3roKx7oscc6/pR0BrgHniM7wZzzuqrGyzOCV/FI/Z3HtVa7Aak=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr9436923ljn.188.1572646138880;
 Fri, 01 Nov 2019 15:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk> <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
 <20191031174208.GC2794@krava> <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
 <20191031191815.GD2794@krava> <CAADnVQJdAZS9AHx_B3SZTcWRdigZZsK1ccsYZK0qUsd1yZQqbw@mail.gmail.com>
 <20191101072707.GE2794@krava> <CAADnVQJnTuADcPizsD+hFx4Rvot0nqiX83M+ku4Nu_qLh2_vyg@mail.gmail.com>
 <87bltvmlsr.fsf@toke.dk> <CAADnVQJJcx8NszLBMSN0wiR43UEgGki38u0etnWvpMVG=8+ngg@mail.gmail.com>
 <878sozmfzk.fsf@toke.dk>
In-Reply-To: <878sozmfzk.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 1 Nov 2019 15:08:47 -0700
Message-ID: <CAADnVQL8XT1ejAxzaV2TZHu8fhyYZ6nKSg1mtzX33ZSooar27Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 2:41 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> >> The only concern with this is that without a flow of bugfixes into the
> >> 'bpf' tree (and stable), users may end up with buggy versions of libbp=
f.
> >> Which is in no one's interest. So how do we avoid that?
> >
> > As I explained earlier. There is no 'bpf' tree for libbpf. It always
> > moves forward.
>
> Yes, you did. And I was just pointing out that this means that there
> will be no bug fixes in older versions. So the only way to update is to
> move to an entirely new version of libbpf, including updating all the
> headers in /usr/include. And when that is not feasible, then the only
> choice left is to ship a buggy libbpf... Unless you have a third option
> I'm missing?

I'm not seeing the problem still.
Say there is a bug in installed libbpf package.
A bunch of services are using it as libbpf.so
The admin upgrades libbpf package. New libbpf.so is installed
and services should continue work as-is, since we're preserving
api binary compatibility.
Now if you're a developer you install libbpf-devel and the first thing
you'll hit is that /usr/include is so old that it doesn't have basic things
to start writing bpf progs. So recent linux-api-headers package
would have to be installed.
You keep developing stuff. Few month passes by. New libbpf is released.
At the current pace of the development one release contains
a bunch of features and a bunch of fixes.
If you're upgrading it you'd need to refresh api-headers too.
So where is the problem?

Of course there is an option to branch existing libbpf releases, but let's
cross that bridge when we actually need to do that.
