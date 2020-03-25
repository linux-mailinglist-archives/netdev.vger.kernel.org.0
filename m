Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFD31923A5
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgCYJGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:06:43 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:16700 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgCYJGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:06:42 -0400
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 02P96ZbM027674;
        Wed, 25 Mar 2020 18:06:36 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 02P96ZbM027674
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585127196;
        bh=jQcvOgKqTGSzHXwDHncWQg6w6pf0v6SEzzk1QrsBys8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CMKxaS/UhOBp5QlmO8Ozw/yJ+COqMcOMUEkDDeVpiRe3S+QsviZwQGNCob05lcdoH
         U2JjEB5E9LvP6ep/wAU7PV0nq5l2CoiociIscD4feY9qrLxDV+jso8D31spvbpHkhs
         9W2OQVx5qOCF/kEJOa/AEm0dAaFwj+ZOMS2XsTBmhZcz7OxmNJ7E/v4K4P1TR2EumA
         g23ng5yhxKv40xT3wZwpYQ1Xi3X8qTHXO1MvenNEXtPYuCg8Kg4B4vyq0vzg1ChV89
         IoJbSOLCngwQ8nd1s/jJf/YbPB1OKOvzPv35HQNumb9mwwAi4H3uhdqo0X2mdfHk2y
         LBROyPOCN1Cdg==
X-Nifty-SrcIP: [209.85.222.44]
Received: by mail-ua1-f44.google.com with SMTP id v24so473570uak.0;
        Wed, 25 Mar 2020 02:06:36 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3maYwOtLMk73jjJKqnVVnWwMGI0TAGIuMqZdx5KNWObcQMeylm
        RgwIl6z8hzbJFCcJJvzd4xwUjUb95CUUC2P7bJw=
X-Google-Smtp-Source: ADFU+vt/Lpfs/eZV6L7RPsd8+/+xb6x93eEITtXtqxGfFjCg699gz7SVs829mVoswfcp1CZNlUKl42nEbHZjhnywqQA=
X-Received: by 2002:ab0:3485:: with SMTP id c5mr1479980uar.109.1585127195169;
 Wed, 25 Mar 2020 02:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200324161539.7538-1-masahiroy@kernel.org> <CAMuHMdWPNFRhUVGb0J27MZg2CrWWm06N9OQjQsGLMZkNXJktAg@mail.gmail.com>
 <CAK7LNAQFbcfK=q4eYW_dQUqe-sqbjpxSpQBeCkp0Vr4P3HJc7A@mail.gmail.com> <CAMuHMdXeOUu_zxKHXnNoLwyExy1GTp6N5UP2Neqyc8M3w2B8KQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXeOUu_zxKHXnNoLwyExy1GTp6N5UP2Neqyc8M3w2B8KQ@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 25 Mar 2020 18:05:58 +0900
X-Gmail-Original-Message-ID: <CAK7LNAST-ygeLAAneKRhr-uMdSW0V_V1s9AvN6VJSqfWfN4Otg@mail.gmail.com>
Message-ID: <CAK7LNAST-ygeLAAneKRhr-uMdSW0V_V1s9AvN6VJSqfWfN4Otg@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: wan: wanxl: use $(CC68K) instead of $(AS68K) for
 rebuilding firmware
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kbuild <linux-kbuild@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Wed, Mar 25, 2020 at 4:53 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Yamada-san,
>
> On Wed, Mar 25, 2020 at 4:50 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > On Wed, Mar 25, 2020 at 2:47 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Tue, Mar 24, 2020 at 5:17 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > > > As far as I understood from the Kconfig help text, this build rule is
> > > > used to rebuild the driver firmware, which runs on the QUICC, m68k-based
> > > > Motorola 68360.
> > > >
> > > > The firmware source, wanxlfw.S, is currently compiled by the combo of
> > > > $(CPP) and $(AS68K). This is not what we usually do for compiling *.S
> > > > files. In fact, this is the only user of $(AS) in the kernel build.
> > > >
> > > > Moreover, $(CPP) is not likely to be a m68k tool because wanxl.c is a
> > > > PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
> > > > Instead of combining $(CPP) and (AS) from different tool sets, using
> > > > single $(CC68K) seems simpler, and saner.
> > > >
> > > > After this commit, the firmware rebuild will require cc68k instead of
> > > > as68k. I do not know how many people care about this, though.
> > > >
> > > > I do not have cc68k/ld68k in hand, but I was able to build it by using
> > > > the kernel.org m68k toolchain. [1]
> > >
> > > Would this work with a "standard" m68k-linux-gnu-gcc toolchain, like
> > > provided by Debian/Ubuntu, too?
> > >
> >
> > Yes, I did 'sudo apt install gcc-8-m68k-linux-gnu'
> > It successfully compiled this firmware.
>
> Thanks for checking!
>
> > In my understanding, the difference is that
> > the kernel.org ones lack libc,
> > so cannot link userspace programs.
> >
> > They do not make much difference for this case.
>
> Indeed.
>
> So perhaps it makes sense to replace cc68k and ld68k in the Makefile by
> m68k-linux-gnu-gcc and m68k-linux-gnu-ld, as these are easier to get hold
> of on a modern system?
>
> What do you think?
> Thanks!
>


If desired, I can do like this:


ifeq ($(ARCH),m68k)
  CC_M68K = $(CC)
  LD_M68K = $(LD)
else
  CC_M68K = $(CROSS_COMPILE_M68K)gcc
  LD_M68K = $(CROSS_COMPILE_M68K)ld
endif



-- 
Best Regards
Masahiro Yamada
