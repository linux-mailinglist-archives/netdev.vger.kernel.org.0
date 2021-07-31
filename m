Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DAC3DC3D9
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 08:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbhGaGNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 02:13:24 -0400
Received: from condef-04.nifty.com ([202.248.20.69]:51870 "EHLO
        condef-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbhGaGNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 02:13:23 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jul 2021 02:13:22 EDT
Received: from conssluserg-04.nifty.com ([10.126.8.83])by condef-04.nifty.com with ESMTP id 16V63FAC005419;
        Sat, 31 Jul 2021 15:03:15 +0900
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 16V62rkF031113;
        Sat, 31 Jul 2021 15:02:54 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 16V62rkF031113
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1627711374;
        bh=LWga7esoyndTXDvF0XQrO+vJSaL7iFQWmNBogYT4sq8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o9+5X1SvbKPA2o86uIvsZmNKz7uw3ZKipq2egDDNyfQXwyelhjvU/vkhbyAnsomP1
         5k90nSNWCPkOokpYdxNV9xh8CcY6kQ35iP6HdLl9wubIhvlVOZTUq71HQdDkvAyK8q
         HBICHZxRbtx7wkuoK7pg7QmDz8OA3mj7plkm01+n70w0+vDizjN21pwZNNs4ZBhVFc
         gVi/0GRxgNpN/OT6c42x1SM6V7TX9vEgrMZbwnM5LfizxpqF3Sjc17/qXt6WKfdnqY
         R3Mgt2d0hIVQuanDe4cKkC9BFLah6M2yjCWPCrPGkZ2m4r33etqmo8n/FgX52e7vUt
         pTv1R8CueOVQw==
X-Nifty-SrcIP: [209.85.216.41]
Received: by mail-pj1-f41.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso17420195pjf.4;
        Fri, 30 Jul 2021 23:02:54 -0700 (PDT)
X-Gm-Message-State: AOAM530I4qVbIB0CrPpKUEzB6fncQPvhkcqBxO4iNZ0ETSRJZNm3/l5K
        TR5TlMhSDPTRbSJ3QeGeVqxsxkULlh165lUPYMA=
X-Google-Smtp-Source: ABdhPJzxLT+VYMsbrrrUfBrOvhroV7QceyySrzxnrMoK+CQLQXj71gGswBHbIPxUKhjhWKEfixEolyP5TyUd8ncd048=
X-Received: by 2002:a05:6a00:26d0:b029:32d:7d40:5859 with SMTP id
 p16-20020a056a0026d0b029032d7d405859mr6056229pfw.76.1627711373301; Fri, 30
 Jul 2021 23:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210528180140.176257-1-masahiroy@kernel.org>
In-Reply-To: <20210528180140.176257-1-masahiroy@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 31 Jul 2021 15:02:16 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ5x55oCYRQbbC6fCE6qP5cp1Jdw+9SH-BNFuN=bqntFw@mail.gmail.com>
Message-ID: <CAK7LNAQ5x55oCYRQbbC6fCE6qP5cp1Jdw+9SH-BNFuN=bqntFw@mail.gmail.com>
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

On Sat, May 29, 2021 at 3:02 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> All of these are unneeded. The directories to descend are specified
> by obj-$(CONFIG_...).
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>


Ping?




> ---
>
>  security/Makefile | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/security/Makefile b/security/Makefile
> index 47e432900e24..18121f8f85cd 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -4,16 +4,6 @@
>  #
>
>  obj-$(CONFIG_KEYS)                     += keys/
> -subdir-$(CONFIG_SECURITY_SELINUX)      += selinux
> -subdir-$(CONFIG_SECURITY_SMACK)                += smack
> -subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
> -subdir-$(CONFIG_SECURITY_APPARMOR)     += apparmor
> -subdir-$(CONFIG_SECURITY_YAMA)         += yama
> -subdir-$(CONFIG_SECURITY_LOADPIN)      += loadpin
> -subdir-$(CONFIG_SECURITY_SAFESETID)    += safesetid
> -subdir-$(CONFIG_SECURITY_LOCKDOWN_LSM) += lockdown
> -subdir-$(CONFIG_BPF_LSM)               += bpf
> -subdir-$(CONFIG_SECURITY_LANDLOCK)     += landlock
>
>  # always enable default capabilities
>  obj-y                                  += commoncap.o
> @@ -36,5 +26,4 @@ obj-$(CONFIG_BPF_LSM)                 += bpf/
>  obj-$(CONFIG_SECURITY_LANDLOCK)                += landlock/
>
>  # Object integrity file lists
> -subdir-$(CONFIG_INTEGRITY)             += integrity
>  obj-$(CONFIG_INTEGRITY)                        += integrity/
> --
> 2.27.0
>


-- 
Best Regards
Masahiro Yamada
