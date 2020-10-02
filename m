Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027CD2813DB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 15:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgJBNQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 09:16:13 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:39905 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733260AbgJBNQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 09:16:13 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N5mWp-1kUINs0ZA3-017BP3; Fri, 02 Oct 2020 15:16:11 +0200
Received: by mail-qk1-f176.google.com with SMTP id 16so1236806qkf.4;
        Fri, 02 Oct 2020 06:16:10 -0700 (PDT)
X-Gm-Message-State: AOAM532tc3Tmp5j9DMzjJt3zLV/k5CZe5tjInilnAbqqBfA/wHNk9pvj
        GuKXZCJZqYNggYD7Nf1FEgeeSkOnyLp+NtBEQhs=
X-Google-Smtp-Source: ABdhPJx/URBrT66RPykk/2/6JviDG6WX2uBwK9D+xY5cDLIAI6xy72z4b1ThDmojHWh2eXsGANtl3E59qfGrK6w65tg=
X-Received: by 2002:a37:5d8:: with SMTP id 207mr2089814qkf.352.1601644569794;
 Fri, 02 Oct 2020 06:16:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch> <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
 <20201002125110.GJ4067422@lunn.ch>
In-Reply-To: <20201002125110.GJ4067422@lunn.ch>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 2 Oct 2020 15:15:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1Cyxo4mt2Kug92EvBhZJt2X6ct0_8JbZgo0zf0GSuanA@mail.gmail.com>
Message-ID: <CAK8P3a1Cyxo4mt2Kug92EvBhZJt2X6ct0_8JbZgo0zf0GSuanA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:b2HXCNTVCo22C3h3rxauhO0+/X0QcKiUXkUKqxo+h0krYZjfDYD
 bqX+1mY4D3ve42Ow6RSGrYnhP5ryQPEqh508HjAAehTU1kP6/bVV8GlbFKQt8tVlFEhTSzK
 j5HsTznJ2kjBv+sdm6dkH+KhpGdAobXM7diIQ1G2BU87YRnZimG1nSDRcj3ZOI5cJ0XH0DR
 uMyzXl/55yXJgsL28S0ww==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:GueKqSfYVUg=:QAX3SMFSncv4b3efkXOP8A
 VuPx1GBZnXoTEOmpvb/70zkUQAx/vRVEVm8evuH644m4ZibRthfR90q4xRMEwWxk3rsz1+0cQ
 Z8503+9AWor1QScUMJAkZZoHDFbfdzNke2UJrvvVDmC5H9dkp8/G2EkSj0is3bw61fJOWTbuf
 vC0vBVeF4akyv2C+sd6QCjsvTVRqSnyYk3I245pNO+VgTdaJbUZ0ZX8gQDlFu99GcMYFWwOAa
 QNE1CJd9tQJD96axU7egiZrsF9M/PqYqI5UFBLayl/sgCzl1CBRFX4js6ZqPgsvkWk/NArgkJ
 aHXDoE2/9VS18Z++7cnw8dBs2c2Szzh/M3PTblaHMad10GA6DMFxTAuNQBA5cN2fxqeOcOEoc
 9xhUSZLng7S1egaDl/HBxvGLH5yjThqhwRtdq+HPp09f+pDwI4W0EA4zUc6xQ1hEZ3RWPvkr+
 L88O/pqjCeS/OJN90l1JbjGtS4uWbGJUyQD+Bj+ehvcaM4/MucrNHh8NVVBg3GCO1ar/CZlQt
 +hUP/5o83nquFT2Dbo88yBiP15Sa/OmAEUAA2HhVciKkSQnFH2Yr3ZYcGzif1IyJo9TUcrI8v
 52egwHApNKf5KXERDYg/PFrfL85KgLKQCyuQLXxTXoYmSGEttT7VpS4C4e/JoDqKh1KzxSr7h
 COlL6h6iMicJjAKz/jVix0yl27e9HxZ8+cRy4H+zikNJ/5Wnw8H32mGw0B7ecs2ItCasO84NL
 aa/0d0G8DdIkWhykN5VpH6Cos2jKaKvCcJjodHOsPRPHOkCbeHbuqTlPT0AlmZxCHEj6zpIlL
 t9DaahaJrzTCIIr/ce06hmz0THyICjwniqI9SqDi1tmjRjx+sHtf6/oK/aSeaek+NTBzuaaY7
 9nfkOprlrfm8fIbHM6uWc9FllHS6E4TciCL0LwveGXsl5VZRDHw9WjNsa490CZEvZzbAviYag
 Tx8TBbl9TsPtfF7AE0tdKZ6sMUuN2q4HaCpX9tKh5y7xbGNPSDxqU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 2:51 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Fri, Oct 02, 2020 at 02:20:50PM +0200, Arnd Bergmann wrote:
> > On Fri, Oct 2, 2020 at 3:44 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Thu, Oct 01, 2020 at 04:09:43PM -0700, Nick Desaulniers wrote:
> > > >
> > > > I'm not a fan of this approach.  Are DATESTAMP configs just going to
> > > > keep being added? Is it going to complicate isolating the issue from a
> > > > randconfig build?  If we want more things to build warning-free at
> > > > W=1, then why don't we start moving warnings from W=1 into the
> > > > default, until this is no W=1 left?  That way we're cutting down on
> > > > the kernel's configuration combinatorial explosion, rather than adding
> > > > to it?
> >
> > I'm also a little sceptical about the datestamp.
>
> Hi Arnd
>
> Any suggestions for an alternative?

I think we should deal with it the same way we deal with new
compiler versions: before a new compiler starts getting widely
used, someone has to address the new warnings that show up,
or at the minimum they have to get turned off by default until
they are addressed.

Today, moving a warning flag from W=1 to default requires that
there won't be any regressions in the output. The same should
apply to adding W=1 warnings if there is a way for drivers to
default-enable them.

> > It won't change with the configuration, but it will change with the
> > specific compiler version. When you enable a warning in a
> > particular driver or directory, this may have different effects
> > on one compiler compared to another: clang and gcc sometimes
> > differ in their interpretation of which specific forms of an expression
> > to warn about or not, and any multiplexing options like -Wextra
> > or -Wformat may turn on additional warnings in later releases.
>
> How do we deal with this at the moment? Or will -Wextra and -Wformat
> never get moved into the default?

I think for Wextra, that would likely stay with W=1, though individual
warnings in that set should be enabled by default whenever they
make sense. For -Wformat, we probably want the opposite and
enable the global option by default but make individual sub-options
W=1 or W=2 if there is too much undesired output.

> > I think the two approaches are orthogonal, and I would like to
> > see both happening as much as possible:
> >
> > - any warning flag in the W=1 set (including many things implied
> >   by -Wextra that have or should have their own flags) that
> >   only causes a few lines of output should just be enabled by
> >   default after we address the warnings
>
> Is there currently any simple way to get statistics about how many
> actual warnings there are per warnings flag in W=1? W=1 on the tree as
> a whole does not look good, but maybe there is some low hanging fruit
> and we can quickly promote some from W=1 to default?

I have done this a few times in the past, essentially building a
few hundred randconfig kernels across multiple architectures
and then processing the output in a script. I usually treat a
file:line:warning tuple as a single instance and then count
how many there are.

> > - Code with maintainers that care should have a way to enable
> >   the entire W=1 set per directory or per file after addressing all
> >   the warnings they do see, with new flags only getting added to
> >   W=1 when they don't cause regressions.
>
> Yes, this is what i'm trying to push forward here. I don't
> particularly care how it happen, so if somebody comes up with a
> generally acceptable idea, i will go away and implement it.

I actually have a set of patches that I started a while ago to
move the logic from scripts/Makefile.extrawarn into
include/linux/warnings.h, using '_Pragma("GCC diagnostic ...")'
with some infrastructure around it, to also allow drivers to
set the level as well as individual warnings when needed.

I never managed to get that patch series into a state for submission
so far, with a few things that need to be addressed first:

- any Makefile that changes warning options needs to be
  converted to use macro syntax

- I need to check that the patches don't accidentally disable
  warnings that are currently enabled (this is harder than
  checking the reverse)

- some specific warnings have problems with this new method
  for options that control multiple other options.

        Arnd
