Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959F436E596
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 09:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbhD2HJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 03:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239542AbhD2HJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 03:09:13 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD36BC06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 00:08:25 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id v20so11372978qkv.5
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 00:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WoQazlo32EMfyVfFXbSdibosb/wnX4jkFYop7JuM2ng=;
        b=FABwoLqf+i151+vVTwZZD34LbJoDh/Tx0rBk0GaBr6h+FeRIujXYyEflLsNBB6hWuI
         41Wq2TjlOEA7jOZ8KxRH3AIMkoT5kfCZqrQx+/Rru806HRoOm6/upk72vzBLAMh57gKn
         fpdOcFCr0NYaMi4BBtqJmi3zoPShqrt42JVMC8lGOYlPQ75+pVm1vkianrhhuBEgCwY/
         bhfJRVJWt9a+k9WX079eTvJ/BBOZxidLfz997etTjrxvj8FCpG6xBSIpncxSnILKspH8
         KqfL7wADqokS+7BuwMqLQKff7NlUCGILRndNJX/WNVWBsrTNgLPcaflU/GjxARAfi/6f
         J6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WoQazlo32EMfyVfFXbSdibosb/wnX4jkFYop7JuM2ng=;
        b=Vs6orYvBmwDeLVAbibAfADujUxZIRMiSLdOUJ/2VZpWcHt04V8B55iERvLeUlnYEoE
         DE0J9ORgt/1Q6YXcXVzYw39nvmYHIUR4zqIf1bpDYkJeYm+mNhya4poyrNEoapdr+nVO
         l8iTP/WwEhHS1Vd/rCXbnih78TImaKTRwUAdmYDmIlBlr4edo1X+Vc0FT1z7igo984iH
         gXEoPXmo+qFfVgU3tndOaOxza4Zyu/GQfsi3zxUPxCK4+YddRyWdpJpNIPli7hkxmGoT
         +wrO35UjJRp5srnh6TCeInGgjgo1B5hWFYUc0Iuj0acQYtlSDuHBCrfMP4cm1JVlIfGT
         1uqg==
X-Gm-Message-State: AOAM532cPgIjqH5FHFvfE1R3SItud64O7bEv4ZFIO/FDjr0pUtDmhF90
        19os+tnmeOV6yyXSgZz0ZtFeYnbfhwaiQcoqwkMVee8MC3E=
X-Google-Smtp-Source: ABdhPJzIEL/Yv+MNxB5ek/NFi3R0iHQCndo+YKTKfq5X27COY1Srtz+s3llgKTGr+53nOP+pYSyYkcPIF0YqoWwKQ7E=
X-Received: by 2002:a37:7d84:: with SMTP id y126mr32096792qkc.155.1619680104996;
 Thu, 29 Apr 2021 00:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200417004120.GA18080@ubuntu-s3-xlarge-x86> <YImjw3eypUdhkp88@archlinux-ax161>
In-Reply-To: <YImjw3eypUdhkp88@archlinux-ax161>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 29 Apr 2021 09:08:13 +0200
Message-ID: <CAPv3WKeHcq+viBHR=ok+AytrNWLFudWJ8qHoShs3r4LOj7qD0w@mail.gmail.com>
Subject: Re: -Wconstant-conversion in drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nathan,


=C5=9Br., 28 kwi 2021 o 20:04 Nathan Chancellor <nathan@kernel.org> napisa=
=C5=82(a):
>
> On Thu, Apr 16, 2020 at 05:41:20PM -0700, Nathan Chancellor wrote:
> > Hi all,
> >
> > I was building s390 allyesconfig with clang and came across a curious
> > warning:
> >
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:580:41: warning:
> > implicit conversion from 'unsigned long' to 'int' changes value from
> > 18446744073709551584 to -32 [-Wconstant-conversion]
> >         mvpp2_pools[MVPP2_BM_SHORT].pkt_size =3D MVPP2_BM_SHORT_PKT_SIZ=
E;
> >                                              ~ ^~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/marvell/mvpp2/mvpp2.h:699:33: note: expanded from
> > macro 'MVPP2_BM_SHORT_PKT_SIZE'
> > #define MVPP2_BM_SHORT_PKT_SIZE MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FR=
AME_SIZE)
> >                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
> > drivers/net/ethernet/marvell/mvpp2/mvpp2.h:634:30: note: expanded from
> > macro 'MVPP2_RX_MAX_PKT_SIZE'
> >         ((total_size) - NET_SKB_PAD - MVPP2_SKB_SHINFO_SIZE)
> >                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> > 1 warning generated.
> >
> > As far as I understand it, the warning comes from the fact that
> > MVPP2_BM_SHORT_FRAME_SIZE is treated as size_t because
> > MVPP2_SKB_SHINFO_SIZE ultimately calls ALIGN with sizeof(struct
> > skb_shared_info), which has typeof called on it.
> >
> > The implicit conversion probably is fine but it would be nice to take
> > care of the warning. I am not sure what would be the best way to do tha=
t
> > would be though. An explicit cast would take care of it, maybe in
> > MVPP2_SKB_SHINFO_SIZE since the actual value I see is 320, which is abl=
e
> > to be fit into type int easily.
> >
> > Any comments would be appreciated, there does not appear to be a
> > dedicated maintainer of this driver according to get_maintainer.pl.
>
> Sorry for the necrobump, I am doing a bug scrub and it seems like this
> driver now has maintainers so keying them in in case they have any
> comments/suggestions.
>

Thank you for your interest. Are you still reproducing the issue? With
clang 10.0.0 the compilation passes in my setup:
$ ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-gnu- make CC=3Dclang
drivers/net/ethernet/marvell/mvpp2/
  SYNC    include/config/auto.conf.cmd
  CC      scripts/mod/empty.o
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/modpost.o
  CC      scripts/mod/devicetable-offsets.s
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  CC      kernel/bounds.s
  CC      arch/arm64/kernel/asm-offsets.s
  UPD     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  LDS     arch/arm64/kernel/vdso/vdso.lds
  CC      arch/arm64/kernel/vdso/vgettimeofday.o
  AS      arch/arm64/kernel/vdso/note.o
  AS      arch/arm64/kernel/vdso/sigreturn.o
  LD      arch/arm64/kernel/vdso/vdso.so.dbg
  VDSOSYM include/generated/vdso-offsets.h
  OBJCOPY arch/arm64/kernel/vdso/vdso.so
  CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_main.o
  CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.o
  CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.o
  CC      drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.o
  AR      drivers/net/ethernet/marvell/mvpp2/built-in.a

Best regards,
Marcin
