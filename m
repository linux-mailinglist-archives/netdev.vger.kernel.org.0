Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92181516737
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbiEASy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 14:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiEASyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 14:54:55 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660E015A12
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 11:51:29 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id hh4so9872219qtb.10
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 11:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mPu1WP9igmks4pKhN4JROwozVohWmQCOkIYHcib/0Gg=;
        b=oCo/6kN0G4wiZNp1uPmg9tts0+eetFFoHxmCQrmBGCtnWyJqjkuEGO+eU8T3xEZZkK
         XZ/wPC5l1/9aT5ho6ipYqI4wNs7xXKw0DK5GFvgQ0n0YimADSVetmt2VKmUyWQKx7Ci/
         VGj5lTYSyq1N8+QsvYYhcaLtZsqmDIm5oo5avpJbC0DZhcmLQedFPOICQ3eC+RFxJ0qr
         msVbUyNerZXYyUTD4Zhrr1bgIUylF8kow7UogTCqwlKFDFIxFoguAbTurgZ0XqewUZ/0
         hzP1uS7rJw3ilb3v4ViAJ4/GVxqFm8DUOE7Xbj2G7OLrRUjWVCaxbMbltTgG4HshgkVU
         ORjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mPu1WP9igmks4pKhN4JROwozVohWmQCOkIYHcib/0Gg=;
        b=dG3FntyCuwiw2j8JVYfv1NE/aeXRE2PWEzJXAQPAvbT0C7TTmNaEIDD3ijTPyc4onM
         C8jwuDTEHiLzwHIU2qBiJGjsWWfNLY0x75nt+qIg51f6van40ssAyNMVRO7eiZAhrn22
         OKQOwDwHvuDsYlOuiZtzAnXICnwAI1kZaUx+aLJXLNknUWubkeKfM7wYaby61FLz2PMU
         CjuWgCcgfdjtNBj9BoqUbktsI8rwNHiI4PHpKo99a6ccSGhVXtUNlmSX4LoPNcDE/eI2
         sPuW9eeLp2SAUPXR6Hz547ts7czVTM13bPnQ1z1TijjiaCEdJSHGpcA+OX0873kh/WAS
         VQeA==
X-Gm-Message-State: AOAM530k0smnBEGMqusHMij2gnO8ifsOnAxPq8jVM9tdYCkGdceEEHW9
        stSK6RbSSIuNfw7ntWLedULfw29bGxHLdeufuEk=
X-Google-Smtp-Source: ABdhPJw5AHP9eyWwGx1wrZkDlEf9T4MmZH6DzyMsxlf3YMOhUlyZd8v+SgYS6rmo53ThOcZsWhUxFW2ECyPtaR0sCrw=
X-Received: by 2002:a05:622a:1707:b0:2f3:9d49:8731 with SMTP id
 h7-20020a05622a170700b002f39d498731mr5919819qtk.245.1651431088309; Sun, 01
 May 2022 11:51:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQFVGYURjcCA741koGF5aeRoymwh-h+_evP5cqAxE4U8UVnbA@mail.gmail.com>
 <Yl04ttYN95VCXan4@shell.armlinux.org.uk> <CAEQFVGZnyyCT7F-Jud-o+5OWzxDTgztbZT2Sm+ixtQ1yKOS2+g@mail.gmail.com>
In-Reply-To: <CAEQFVGZnyyCT7F-Jud-o+5OWzxDTgztbZT2Sm+ixtQ1yKOS2+g@mail.gmail.com>
From:   Mauro Rossi <issor.oruam@gmail.com>
Date:   Sun, 1 May 2022 20:51:17 +0200
Message-ID: <CAEQFVGYF_0KhkWEGWrMEZCKBEoEL71DgyAV3a6gCDAA=PNf+kA@mail.gmail.com>
Subject: Re: FYI: net/phy/marvell10g: android kernel builing error due to
 modpost error
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        masahiroy@kernel.org, michal.lkml@markovi.net
Cc:     netdev@vger.kernel.org, kabel@kernel.org,
        Chih-Wei Huang <cwhuang@android-x86.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 6:39 PM Mauro Rossi <issor.oruam@gmail.com> wrote:
>
> Hi Russell,
>
> On Mon, Apr 18, 2022 at 12:08 PM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > On Mon, Apr 18, 2022 at 11:22:12AM +0200, Mauro Rossi wrote:
> > > At the final stage of building  Linux 5.18-rc3 with the necessary AOSP
> > > changes, I am getting the following building error:
> > >
> > >   MODPOST modules-only.symvers
> > > ERROR: modpost: "__compiletime_assert_344"
> > > [drivers/net/phy/marvell10g.ko] undefined!
> > > make[2]: *** [/home/utente/r-x86_kernel/kernel/scripts/Makefile.modpost:134:
> > > modules-only.symvers] Error 1
> > > make[2]: *** Deleting file 'modules-only.symvers'
> > > make[1]: *** [/home/utente/r-x86_kernel/kernel/Makefile:1749: modules] Error 2
> > > make[1]: *** Waiting for unfinished jobs....
> > >
> > > It never happened before throughout all my previous android-x86 kernel
> > > rc cycle build tests, which spanned from linux version 5.10 to linux
> > > version 5.18rc
> >
> > As far as I'm aware, with mainline kernels, marvell10g builds fine.
>
> Thanks for response, I will also check that when
> https://android.googlesource.com/kernel/common-patches/ becomes
> available for kernel-5.18rc(s)
>
> > I'm not sure how to work back from "__compiletime_assert_344" to
> > where the problem could be. The "344" appears to be generated by
> > the __COUNTER__ macro - and I don't know how that macro works (debian
> > annoyingly don't package the GCC info docs, and the info files I have
> > are out of date.)
>
> Looking at the error printout, it seams indeed that modpost parsed
> modules-only.symvers file line-by-line
> and (my assumption, correct me if I may be wrong) encountered some
> 'undefined!' symbol at line 344 of  modules-only.symvers and pointed
> out that marvell10g.ko module is the one associated with the missing
> symbol
>
> I have tried to copy
> $OUT/target/product/x86_64/obj/kernel/modules-only.symvers to be able
> to inspect which symbol is listed at line 344,
> but even with "watch -n 0.1 cp ..." command I am not able to save the
> generated modules-only.symvers before it is deleted, therefore I am
> not able to inspect line 344
>
> Is there a way to have modpost modified for printing the symbol
> instead of the "indirection" of "__compiletime_assert_344" ?
>
> As other info, I had to cross compile using prebuilt clang 11.0.2
> (kernel version constraint) and set  LLVM_IAS=0 to disable the llvm
> integrated assembler to be able to build, but I don't think that
> should cause the missing symbol as I don't see any assembler code is
> needed to build marvell10g.ko module
>
> KR
> Mauro

Hello,

I am adding script/mod/modpost.c mantainers to consult them, as I am
not much familiar with the meaning of the error

I am building the kernel with Android Build System as part of our
iso_img target build, gcc based build has always been successful,
while llvm based build is not working and generates the following
error, which we are not able to interpret.

ERROR: modpost: "__compiletime_assert_344"
[drivers/net/phy/marvell10g.ko] undefined!

"__compiletime_assert_344" is obviously not a symbol
used/needed/exported by marvell10g.ko

I have also tried with different build machines and different kernel
versions i.e. 5.17 and 5.16
the 344 number changes, but the modpost error at marvell10g.ko is always there.

This is how to reproduce:

CONFIG_MARVELL_PHY=m
CONFIG_MARVELL_10G_PHY=m

Could you please help us to understand the reason for the error and
how to avoid it?
Thank you

Mauro
android-x86 team
