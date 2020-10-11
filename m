Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBAC28A777
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 15:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387870AbgJKNJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 09:09:06 -0400
Received: from condef-02.nifty.com ([202.248.20.67]:44587 "EHLO
        condef-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387867AbgJKNJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 09:09:05 -0400
Received: from conssluserg-06.nifty.com ([10.126.8.85])by condef-02.nifty.com with ESMTP id 09BD4mEk009656
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 22:04:48 +0900
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 09BD4Nqp002188;
        Sun, 11 Oct 2020 22:04:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 09BD4Nqp002188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1602421464;
        bh=OMFBsDy/RPXiLiW/3MJoJPAqD+BEbAsFNNhKa91sz2Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t5dUOfQRE9r0F3fw54/CpLc+M39/VjjSxeiA3e/xf0QykiFVBwywTsJNNopN9gark
         5I919YSPuMLccRPNclQRfwq99aC0j0wgP15b2UeULTdtdVZj1d0rn3YtvEZTcmrDCM
         7mdODxmNeqA4QSLGO+inYBaxeXvmx68XmtTpSOPRh+tMdYjtue1AJEq+uaS0KXdyC3
         2IzID1FPEaauL91ae+LZcDBVlW4Dp+mKxN4VtdZEq1f5Z+4qmsb0NPe4G61qE7KlFg
         Wjlcgz3apRXDecrKEIk2MuN3SbtSXLMOZ19Ax7A670LplFd09ULhE2GeB2y3K7BlMx
         juT/8FPhymsVA==
X-Nifty-SrcIP: [209.85.215.169]
Received: by mail-pg1-f169.google.com with SMTP id l18so2320977pgg.0;
        Sun, 11 Oct 2020 06:04:23 -0700 (PDT)
X-Gm-Message-State: AOAM5329+cC8c5W3nd9S6w5snzXfgfTqD/Tf5O+RM4jJDdNw0cV5Rv38
        XQOPkpaRbbbOWPaMYd791qNhPiIfszV75U3owTo=
X-Google-Smtp-Source: ABdhPJy384OdpW7pSrLgM3oeXXtJ/wn1xuM8xgyBEt9StGTLBEh74qkoVeh8iSFsvpYsT54V6B04DTc9DrVV+Phjbwo=
X-Received: by 2002:a63:1b44:: with SMTP id b4mr9858962pgm.175.1602421463085;
 Sun, 11 Oct 2020 06:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch> <CAKwvOdmdfwWsRtJHtJ16B0RMyoxUi1587OKnyunQd5gfwmnGsA@mail.gmail.com>
 <20201005194913.GC56634@lunn.ch> <CAK8P3a1qS8kaXNqAtqMKpWGx05DHVHMYwKBD_j-Zs+DHbL5CNw@mail.gmail.com>
 <20201005210808.GE56634@lunn.ch>
In-Reply-To: <20201005210808.GE56634@lunn.ch>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sun, 11 Oct 2020 22:03:45 +0900
X-Gmail-Original-Message-ID: <CAK7LNASB6ashOzmL5XntkPSq9a+8VoWCowP5CAt+oX0o=0y=dA@mail.gmail.com>
Message-ID: <CAK7LNASB6ashOzmL5XntkPSq9a+8VoWCowP5CAt+oX0o=0y=dA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 6:08 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > It depends a lot on what portion of the kernel gets enabled for W=1.
> >
> > As long as it's only drivers that are actively maintained, and they
> > make up a fairly small portion of all code, it should not be a problem
> > to find someone to fix useful warnings.
>
> Well, drivers/net/ethernet is around 1.5M LOC. The tree as a whole is
> just short of 23M LOC. So i guess that is a small portion of all the
> code.
>
>         Andrew


I am not a big fan of KBUILD_CFLAGS_W1_<timestamp>
since it is ugly.

I'd like to start with adding individual flags
like drivers/gpu/drm/i915/Makefile, and see
how difficult it would be to maintain it.

One drawback of your approach is that
you cannot set KBUILD_CFLAGS_W1_20200930
until you eliminate all the warnings in the
sub-directory in interest.
(i.e. all or nothing approach)

At best, you can only work out from 'old -> new' order
because KBUILD_CFLAGS_W1_20200326 is a suer-set of
KBUILD_CFLAGS_W1_20190907, which is a suer-set of
KBUILD_CFLAGS_W1_20190617 ...



If you add flags individually, you can start with
low-hanging fruits, or ones with higher priority
as Arnd mentions about -Wmissing-{declaration,prototypes}.


For example, you might be able to set
'subdir-ccflags-y += -Wmissing-declarations'
to drivers/net/Makefile, while
'subdir-ccflags-y += -Wunused-but-set-variable'
stays in drivers/net/ethernet/Makefile.



--
Best Regards
Masahiro Yamada
