Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA76281225
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgJBMVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:21:10 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49521 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBMVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 08:21:09 -0400
Received: from mail-qv1-f53.google.com ([209.85.219.53]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MGQ85-1kBxa22Raf-00GsQI; Fri, 02 Oct 2020 14:21:07 +0200
Received: by mail-qv1-f53.google.com with SMTP id cr8so621533qvb.10;
        Fri, 02 Oct 2020 05:21:07 -0700 (PDT)
X-Gm-Message-State: AOAM533XZ8cnBZ/4wXixpgsU7RGm9oR8rYHTjKey/B1+lNMouiky6BLQ
        NhEzcl+Y9yIuWg+19W4dPh6J4vxOsTrQfh7Y984=
X-Google-Smtp-Source: ABdhPJz0eKnAvkbZXpwFJNin53rQKPZGSywGjwoF0WUP1OjoKv3Ogknfk7vi81wEgFcObp8PWEHrJDVodtO7u8EOglA=
X-Received: by 2002:ad4:4594:: with SMTP id x20mr1871401qvu.4.1601641266141;
 Fri, 02 Oct 2020 05:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com> <20201002014411.GG4067422@lunn.ch>
In-Reply-To: <20201002014411.GG4067422@lunn.ch>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 2 Oct 2020 14:20:50 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
Message-ID: <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
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
X-Provags-ID: V03:K1:f+Dt1ozBODaXT0k/OftcqvEY75p2g8e6dtYs3/9mf/LsLQndOaq
 K9GgOx3e4SIHiH7ebuupsDaR1MQTXam8q0maohr3aMcUndC9Rp/oftWWbrQrExPcIbdQUTd
 8n+5RoOfNm/34A9/LuCTf8Dw7gF0c6incj1UH9ENaz264S7/3H1ljRD4Lmxho1h/km09VHk
 k2sPtow/XYq9vutS1Waaw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xl6LdsPsphc=:4HHvWWKp5k0Abacsh/NswJ
 mh84zS4EJL3Tj/o4GgMyzQPTOO0dOHkWiBKCrMLYyeyKi64D6l5JtycyDlelN8FFHAjxpIwzu
 yJR5N6OubjZHvWBlohKEllgMBaUkHAC4POEcVotnMFHt9I45yqlJFuai/WRFNtsTge7mmpuWx
 DVMK9xuLC0fh6X0nKr0JemNGB97WgpI1Krr+QgCWmUTzC567gL3Xv5PxbDRNoiFlg/xLMjWpZ
 qmCiLpiy4VvvPRiAJGEisb2iLGhrC9HtSLrwsLqEflT2nte7ma6Rlhn7jLK/Om6bTj+VKdUio
 15YL0MiusmS+l9jpFfxf2r5E5Ongln/W2+qL1eio7+eBmlRxFEMVMFmCS0brjoovmzpkLaCGq
 s7SXz/I6BSGusoQBy8RhCByNxYaZ1/fz2DZwYZrppMjw8N/Otv9hwou4L/4kfkx8KSFCMsJ6z
 lMJGaaHFFGgXJO1TD9xL6lXrGm65aocknaVOgdjaglvGdfi6Uy3jzbQyPvOq9D09ODO2EVaXV
 OJwVBu7kdHbJOrLwaPeFPyo1ynww9ME88BDEKk+lIKX3HxNHHrT3UJ12M4PHGimtfk7HU9oC/
 O8Bu1U+8mMa0hJiffjP2HaUEsZTGZ56SeRIy4F7/AWze4loOmW9NCieD+jCTso7x+mybyVr9c
 es7++c74opKGPQLStS/xYvG8LcxuJGCYPjulV/njXTPrrHyuae1NquKFe6rYA705FGHnVUsEe
 ci/mzUzkvHBPWxa7tp+66qESESZd1ARY3DAf3wDQ3jdJ0EZaXoam4EFd+kd5XgGyPYPGIOKQt
 txQP0eU17jQQr/3G3E0sLhkm98hZonsEesvHGaX8cFUGLxQ3A1H+J9JNQVnW/9k5Omq0wTBID
 qynxr2EOau5+xTIl0WF5rQkS0Us7ENixqh+UJCSma9Cec9m/iJEZJ1G8GzTfN9FJRM6JUsNow
 Oqon3X52hYKGIq56ko6ETDWi1V7exNjxxaClG6gQlBD+Q20kcpx3e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 3:44 AM Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Oct 01, 2020 at 04:09:43PM -0700, Nick Desaulniers wrote:
> > On Wed, Sep 30, 2020 at 6:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > There is a movement to try to make more and more of /drivers W=1
> > > clean. But it will only stay clean if new warnings are quickly
> > > detected and fixed, ideally by the developer adding the new code.

Nice, I think everyone agrees that this is a good goal.

> > > To allow subdirectories to sign up to being W=1 clean for a given
> > > definition of W=1, export the current set of additional compile flags
> > > using the symbol KBUILD_CFLAGS_W1_20200930. Subdirectory Makefiles can
> > > then use:
> > >
> > > subdir-ccflags-y := $(KBUILD_CFLAGS_W1_20200930)
> > >
> > > To indicate they want to W=1 warnings as defined on 20200930.
> > >
> > > Additional warnings can be added to the W=1 definition. This will not
> > > affect KBUILD_CFLAGS_W1_20200930 and hence no additional warnings will
> > > start appearing unless W=1 is actually added to the command
> > > line. Developers can then take their time to fix any new W=1 warnings,
> > > and then update to the latest KBUILD_CFLAGS_W1_<DATESTAMP> symbol.
> >
> > I'm not a fan of this approach.  Are DATESTAMP configs just going to
> > keep being added? Is it going to complicate isolating the issue from a
> > randconfig build?  If we want more things to build warning-free at
> > W=1, then why don't we start moving warnings from W=1 into the
> > default, until this is no W=1 left?  That way we're cutting down on
> > the kernel's configuration combinatorial explosion, rather than adding
> > to it?

I'm also a little sceptical about the datestamp.

> Hi Nick
>
> I don't see randconfig being an issue. driver/net/ethernet would
> always be build W=1, by some stable definition of W=1. randconfig
> would not enable or disable additional warnings. It to make it clear,
> KBUILD_CFLAGS_W1_20200930 is not a Kconfig option you can select. It
> is a Makefile constant, a list of warnings which define what W=1 means
> on that specific day. See patch 1/2.

It won't change with the configuration, but it will change with the
specific compiler version. When you enable a warning in a
particular driver or directory, this may have different effects
on one compiler compared to another: clang and gcc sometimes
differ in their interpretation of which specific forms of an expression
to warn about or not, and any multiplexing options like -Wextra
or -Wformat may turn on additional warnings in later releases.

> I see a few issues with moving individual warnings from W=1 to the
> default:
>
> One of the comments for v1 of this patchset is that we cannot
> introduce new warnings in the build. The complete tree needs to clean
> of a particularly warning, before it can be added to the default list.
> But that is not how people are cleaning up code, nor how the
> infrastructure is designed. Those doing the cleanup are not take the
> first from the list, -Wextra and cleanup up the whole tree for that
> one warnings. They are rather enabling W=1 on a subdirectory, and
> cleanup up all warnings on that subdirectory. So using this approach,
> in order to move a warning from W=1 to the default, we are going to
> have to get the entire tree W=1 clean, and move them all the warnings
> are once.

I think the two approaches are orthogonal, and I would like to
see both happening as much as possible:

- any warning flag in the W=1 set (including many things implied
  by -Wextra that have or should have their own flags) that
  only causes a few lines of output should just be enabled by
  default after we address the warnings

- Code with maintainers that care should have a way to enable
  the entire W=1 set per directory or per file after addressing all
  the warnings they do see, with new flags only getting added to
  W=1 when they don't cause regressions.

There are more things that we might want to do on top of this:

- identify additional warning flags that we be good to add to W=1

- identify warning flags that are better off being turned into errors,
  like we do with -Werror=strict-prototypes

- Fix the warnings in W=2 that show up in common header files,
  to actually make it realistic to build specific drivers with W=2
  and not have interesting issues drowned out in the noise.

- ensure that any warning flag we turn *off* in W=1 or by default
  is turned on again in one of the higher levels

> People generally don't care about the tree as a whole. They care about
> their own corner. The idea of fixing one warning thought the whole
> tree is 'slicing and dicing' the kernel the wrong way. As we have seen
> with the recent work with W=1, the more natural way to slice/dice the
> kernel is by subdirectories.

I do care about the tree as a whole, and I'm particularly interested in
having -Wmissing-declarations/-Wmissing-prototypes enabled globally
at some point in the future.

        Arnd
