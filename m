Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6619B507471
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 18:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354917AbiDSQnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 12:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354935AbiDSQmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 12:42:39 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C706176
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 09:39:55 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id p65so32045522ybp.9
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 09:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jUMpmyyz1q870jNGo8q/qELDjEbutmuL+ZQZKZNpdrw=;
        b=BdDFztFw1+xEkMaLy69YqbGlYKVXJiVCnfg0rdteoE2DTRXJHTkhr8rDq2O76cohRG
         TZlp7c6HhvMoZjLPGAUcXFT7rDlikbyO3m1lDYIvofeRVen97QZY62ZhGJO3CXPzp10J
         ZXfJDIYOiToadpvjUwfxNqCL0beSO93ukYc0e7uU39v5Ut+r3BFgUQEd864JOxDFWKuQ
         RNA0rGovHpkTN9+1G6F1WX3HfLp290+sbqzPq2nHxWXvJaRjQMmHwH7VX0taE71hjDdd
         Y/CMNaCLOZL41yIo0P7peJ/W6ViZsFwymTM62TmoXGVcLFaYVVnNkHNG9ePtwPRZ0ZZJ
         hQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jUMpmyyz1q870jNGo8q/qELDjEbutmuL+ZQZKZNpdrw=;
        b=XAfhYsve9QDVv1JREa3GB6WrPp+g02axJ0WwKO91I0rZljfSmAfvGt4nktWkF7muo9
         oSvVkoe1dbqhBFvhRVlYk0Auf/m/Gck8SNeFTqc4esicUc1BJ6uyytChpHQXHQ5fmEcJ
         lWIdcvWcDpyViO3ka5H7f4LDDWwrxKdIr/HhUVjSHc2HLOFc4+BroCV3gYQ2JamCbHAY
         u8YmMbg38RkFvHJxbM6j7EqqGqYW46XSypwry67ZqQo0JutLfpu/RJbZEEyAe9pkF2Ml
         vuRMUFDK9ksL7R6CwcjO06bo5txf3Xmi//ZGp7wth5zq0cGu24fQmddv+zH1eglWc2jO
         dV+w==
X-Gm-Message-State: AOAM533mxt84wvliQbifLMUBfIiT3Sq9A3jIWVRYfs2/vBDqcgaXQCYb
        bSDcv6YTgY+8SY8YWws291GeLFrBAL9zknlm9dc=
X-Google-Smtp-Source: ABdhPJw71wlGSxdW6UcBAvM//DtnjZ7vuOU+w+7NGCiMVeeR0+MUICu9Pv8bB8MpmaBC7EWAAiWV2EqzJsZDxylk368=
X-Received: by 2002:a05:6902:389:b0:633:31c1:d0f7 with SMTP id
 f9-20020a056902038900b0063331c1d0f7mr15284558ybs.543.1650386394679; Tue, 19
 Apr 2022 09:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQFVGYURjcCA741koGF5aeRoymwh-h+_evP5cqAxE4U8UVnbA@mail.gmail.com>
 <Yl04ttYN95VCXan4@shell.armlinux.org.uk>
In-Reply-To: <Yl04ttYN95VCXan4@shell.armlinux.org.uk>
From:   Mauro Rossi <issor.oruam@gmail.com>
Date:   Tue, 19 Apr 2022 18:39:42 +0200
Message-ID: <CAEQFVGZnyyCT7F-Jud-o+5OWzxDTgztbZT2Sm+ixtQ1yKOS2+g@mail.gmail.com>
Subject: Re: FYI: net/phy/marvell10g: android kernel builing error due to
 modpost error
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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

Hi Russell,

On Mon, Apr 18, 2022 at 12:08 PM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Mon, Apr 18, 2022 at 11:22:12AM +0200, Mauro Rossi wrote:
> > At the final stage of building  Linux 5.18-rc3 with the necessary AOSP
> > changes, I am getting the following building error:
> >
> >   MODPOST modules-only.symvers
> > ERROR: modpost: "__compiletime_assert_344"
> > [drivers/net/phy/marvell10g.ko] undefined!
> > make[2]: *** [/home/utente/r-x86_kernel/kernel/scripts/Makefile.modpost:134:
> > modules-only.symvers] Error 1
> > make[2]: *** Deleting file 'modules-only.symvers'
> > make[1]: *** [/home/utente/r-x86_kernel/kernel/Makefile:1749: modules] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> >
> > It never happened before throughout all my previous android-x86 kernel
> > rc cycle build tests, which spanned from linux version 5.10 to linux
> > version 5.18rc
>
> As far as I'm aware, with mainline kernels, marvell10g builds fine.

Thanks for response, I will also check that when
https://android.googlesource.com/kernel/common-patches/ becomes
available for kernel-5.18rc(s)

> I'm not sure how to work back from "__compiletime_assert_344" to
> where the problem could be. The "344" appears to be generated by
> the __COUNTER__ macro - and I don't know how that macro works (debian
> annoyingly don't package the GCC info docs, and the info files I have
> are out of date.)

Looking at the error printout, it seams indeed that modpost parsed
modules-only.symvers file line-by-line
and (my assumption, correct me if I may be wrong) encountered some
'undefined!' symbol at line 344 of  modules-only.symvers and pointed
out that marvell10g.ko module is the one associated with the missing
symbol

I have tried to copy
$OUT/target/product/x86_64/obj/kernel/modules-only.symvers to be able
to inspect which symbol is listed at line 344,
but even with "watch -n 0.1 cp ..." command I am not able to save the
generated modules-only.symvers before it is deleted, therefore I am
not able to inspect line 344

Is there a way to have modpost modified for printing the symbol
instead of the "indirection" of "__compiletime_assert_344" ?

As other info, I had to cross compile using prebuilt clang 11.0.2
(kernel version constraint) and set  LLVM_IAS=0 to disable the llvm
integrated assembler to be able to build, but I don't think that
should cause the missing symbol as I don't see any assembler code is
needed to build marvell10g.ko module

KR
Mauro

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
