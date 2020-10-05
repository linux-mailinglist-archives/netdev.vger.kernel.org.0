Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8F7283D51
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 19:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgJERcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgJERcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 13:32:08 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B28CC0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 10:32:08 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i3so194549pjz.4
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 10:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Htxoj4DaPCPw1cEp7kynonjuidcBDrm2IFv1RoI9pXE=;
        b=t3bjIhsR7/XIujfSmVGkLJwWGn7zVArg+PhxfELAVL6HGcsXVQx3Oe1cm7r1U9flch
         C0KzX94ahcoRpK5VmIYbF7M9150cVPj/42JrZDQLn/VaE4FTtXWawYYVHMJgRgFyGdWp
         EdkwMkdYe5AsQifdFykX8kYpdsyBmtRjH4I7YefP6/TJLJ98i2en63CiXtfCbuJpb2hT
         0B8hPYtznaBKtk9hQZqY7WTsEqolbepexHOuqcTAMhZSEOXLheLW9MM1iwC+UQEdZUhL
         aA9pUMMZnmFDNWI2nlCvYoAVUpBZxyIJfKeLlv6U+Ux20l+oMTnc/qV0HEbkGuZnTryX
         heDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Htxoj4DaPCPw1cEp7kynonjuidcBDrm2IFv1RoI9pXE=;
        b=QmfpUbeHCUyaVoAL0kseodX1Cukw0naLcJUlU2V8KuBvIg68DTqcZ71l0tJmAvCbtu
         HxgJAIipJVEb/ffuK7ZGNZJuCydmmNh8J+FhpTWTH5iGeTvHBCWkvcC0r1RyKqeGdrSr
         R1ZxwBOD6D7OgK5OjKh3G0jXLnygJwwiBzAGLejePDlv0DVRgTPT5QdGu0QZue0Gja9j
         CJTjnXGYyPRByLd3oa7gquOgT6gghXDjK8vKk4FR+zsGW62xn3BAPJWsfM4uaDx6Hslz
         YOG5UWYGKL0rLXNo/HZ4bnrx2TdZ3GmnggkQc23MnncgpuVCNgCDfZDvrvMLNwKRGvFr
         nUSw==
X-Gm-Message-State: AOAM533LPNE/tcHRCkPff0ffpKnXrpku/qoMc2iTq7iN4PYEPiJnzk2i
        znjkSdL2AFEWaBhNyuU8ucJNr5ywMkeKyTUHf7FLdg==
X-Google-Smtp-Source: ABdhPJxWmcDMAtPD4+Xw7wkKskniMTu7T/NjhfmseiAjEso3zM1XgQ4+WDk7GzYI6fGPs72VmD7wb3CoA1EZsu39ARo=
X-Received: by 2002:a17:90a:3b48:: with SMTP id t8mr523485pjf.32.1601919127643;
 Mon, 05 Oct 2020 10:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com> <20201002014411.GG4067422@lunn.ch>
In-Reply-To: <20201002014411.GG4067422@lunn.ch>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 5 Oct 2020 10:31:57 -0700
Message-ID: <CAKwvOdmdfwWsRtJHtJ16B0RMyoxUi1587OKnyunQd5gfwmnGsA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 1, 2020 at 6:44 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Oct 01, 2020 at 04:09:43PM -0700, Nick Desaulniers wrote:
> > On Wed, Sep 30, 2020 at 6:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > There is a movement to try to make more and more of /drivers W=1
> > > clean. But it will only stay clean if new warnings are quickly
> > > detected and fixed, ideally by the developer adding the new code.
> > >
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
>
> Hi Nick
>
> I don't see randconfig being an issue. driver/net/ethernet would
> always be build W=1, by some stable definition of W=1. randconfig
> would not enable or disable additional warnings. It to make it clear,
> KBUILD_CFLAGS_W1_20200930 is not a Kconfig option you can select. It
> is a Makefile constant, a list of warnings which define what W=1 means
> on that specific day. See patch 1/2.
>
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

Sorry, to be more specific about my concern; I like the idea of
exporting the W=* flags, then selectively applying them via
subdir-ccflags-y.  I don't like the idea of supporting W=1 as defined
at a precise point in time via multiple date specific symbols.  If
someone adds something to W=1, then they should need to ensure subdirs
build warning-free, so I don't think you need to "snapshot" W=1 based
on what it looked like on 20200930.

>
> People generally don't care about the tree as a whole. They care about
> their own corner. The idea of fixing one warning thought the whole
> tree is 'slicing and dicing' the kernel the wrong way. As we have seen
> with the recent work with W=1, the more natural way to slice/dice the
> kernel is by subdirectories.

I'm not sure I agree with this paragraph. ^  If a warning is not
enabled by default implicitly, then someone would need to clean the
tree to turn it on.  It's very messy to apply it on a child directory,
then try to work up.  We've done multiple tree wide warning cleanups
and it's not too bad.

>
> I do however understand the fear that we end up with lots of
> KBUILD_CFLAGS_W1_<DATESTAMP> constants. So i looked at the git history
> of script/Makefile.extrawarn. These are historically the symbols we
> would have, if we started this idea 1/1/2018:
>
> KBUILD_CFLAGS_W1_20200326    # CLANG only change
> KBUILD_CFLAGS_W1_20190907
> KBUILD_CFLAGS_W1_20190617    # CLANG only change
> KBUILD_CFLAGS_W1_20190614    # CLANG only change
> KBUILD_CFLAGS_W1_20190509
> KBUILD_CFLAGS_W1_20180919
> KBUILD_CFLAGS_W1_20180111
>
> So not too many.

It's a useful visualization.  I still would prefer W=1 to get enabled
by default if all of the CI systems have flushed out the existing
warnings.  That way we have one less combination of things to test;
not more.
--
Thanks,
~Nick Desaulniers
