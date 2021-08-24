Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875833F5B20
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhHXJcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:32:12 -0400
Received: from condef-10.nifty.com ([202.248.20.75]:53812 "EHLO
        condef-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbhHXJcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:32:11 -0400
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-10.nifty.com with ESMTP id 17O9S3IG009642;
        Tue, 24 Aug 2021 18:28:03 +0900
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 17O9ReOO014183;
        Tue, 24 Aug 2021 18:27:40 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 17O9ReOO014183
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1629797261;
        bh=U+ETojJLC46giLV0nmFB3HMfhm00P2uQEj6O7D2QdBQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LX8dlc4V1V68ls3dBTGJ4wO/Sez/ReNhciPSQ4lZWQ8oxxcNUpDLIo7s37Kj5WMdn
         jO3+uhXo0lc1d2rlSKkLZlB1gUyXAqHBpzxAaOv43LvIz4E8nBVQ2WkTIe0CKByeO9
         scrXPIGG9zTWXTwSVdBUNt0qcoR4hgfgicIwSiEpprcLEAJSv7HJO+Hvxb+Wko1M91
         gQPADHucP6kGL+lvTrR+oYFGoNLyQQy1HVM1FaEc81EzliCanhrrrohj4W7OwOveEh
         NlPKcIeMcHX/vTsxwGZUpyvBove6xmssFJCroHkQjWjF1Qdrb9Hp1hcV5msK2RMAgw
         dwvm1fPJaLYTQ==
X-Nifty-SrcIP: [209.85.215.181]
Received: by mail-pg1-f181.google.com with SMTP id r2so19209514pgl.10;
        Tue, 24 Aug 2021 02:27:40 -0700 (PDT)
X-Gm-Message-State: AOAM530uU8avtLPCqgC3QE/VgV+LDqLcgKCaVi/so8K+ph/lxn01qQJQ
        X132Acb6LJeSsbWZmk+CxjvsLFvtZN4YzEeEULY=
X-Google-Smtp-Source: ABdhPJxfShD1P0kCObeK6dJf5CZ3KcyG1O2nFtAivI0lNRJ/uey7BF+d+YEH+hMIPYM+yGSuVGc/qhLx0NySiCPwzSs=
X-Received: by 2002:aa7:94ac:0:b0:3e0:f21a:e6ff with SMTP id
 a12-20020aa794ac000000b003e0f21ae6ffmr37132148pfl.76.1629797260039; Tue, 24
 Aug 2021 02:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210528180140.176257-1-masahiroy@kernel.org> <CAK7LNAQ5x55oCYRQbbC6fCE6qP5cp1Jdw+9SH-BNFuN=bqntFw@mail.gmail.com>
In-Reply-To: <CAK7LNAQ5x55oCYRQbbC6fCE6qP5cp1Jdw+9SH-BNFuN=bqntFw@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 24 Aug 2021 18:27:03 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR3NR=u7D0qPVeLUSEiStDvbVUdj4VnFBJ_wHo1UMmcOg@mail.gmail.com>
Message-ID: <CAK7LNAR3NR=u7D0qPVeLUSEiStDvbVUdj4VnFBJ_wHo1UMmcOg@mail.gmail.com>
Subject: Re: [PATCH] security: remove unneeded subdir-$(CONFIG_...)
To:     James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 3:02 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Sat, May 29, 2021 at 3:02 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > All of these are unneeded. The directories to descend are specified
> > by obj-$(CONFIG_...).
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
>
> Ping?
>



Applied to linux-kbuild.




>
>
> > ---
> >
> >  security/Makefile | 11 -----------
> >  1 file changed, 11 deletions(-)
> >
> > diff --git a/security/Makefile b/security/Makefile
> > index 47e432900e24..18121f8f85cd 100644
> > --- a/security/Makefile
> > +++ b/security/Makefile
> > @@ -4,16 +4,6 @@
> >  #
> >
> >  obj-$(CONFIG_KEYS)                     += keys/
> > -subdir-$(CONFIG_SECURITY_SELINUX)      += selinux
> > -subdir-$(CONFIG_SECURITY_SMACK)                += smack
> > -subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
> > -subdir-$(CONFIG_SECURITY_APPARMOR)     += apparmor
> > -subdir-$(CONFIG_SECURITY_YAMA)         += yama
> > -subdir-$(CONFIG_SECURITY_LOADPIN)      += loadpin
> > -subdir-$(CONFIG_SECURITY_SAFESETID)    += safesetid
> > -subdir-$(CONFIG_SECURITY_LOCKDOWN_LSM) += lockdown
> > -subdir-$(CONFIG_BPF_LSM)               += bpf
> > -subdir-$(CONFIG_SECURITY_LANDLOCK)     += landlock
> >
> >  # always enable default capabilities
> >  obj-y                                  += commoncap.o
> > @@ -36,5 +26,4 @@ obj-$(CONFIG_BPF_LSM)                 += bpf/
> >  obj-$(CONFIG_SECURITY_LANDLOCK)                += landlock/
> >
> >  # Object integrity file lists
> > -subdir-$(CONFIG_INTEGRITY)             += integrity
> >  obj-$(CONFIG_INTEGRITY)                        += integrity/
> > --
> > 2.27.0
> >
>
>
> --
> Best Regards
> Masahiro Yamada



-- 
Best Regards
Masahiro Yamada
