Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9C337ED14
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385152AbhELUHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379206AbhELTkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 15:40:37 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740C5C061379;
        Wed, 12 May 2021 12:36:27 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id y2so32072893ybq.13;
        Wed, 12 May 2021 12:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ll76nxeEjbDPqF2nBsv/uCSPT9e00s43w5SBooKrNy4=;
        b=RYg96wfeibG0AROE5e/4sujQjiAs72ZS3ocuIodFTAM7iCZyJnWdjfhGVd9LGrvBfH
         u2K5PJ6s1vlKS1EJrXIQOIg95Qsl4ATmybPQKxFsOL/E7WFBmh6+vNwY5LDl3Mnm0yie
         WDQiVtfN2/XOzWiO13n3VHEjPq7fxm/nKZgAMGvr0tkjH8z+Gg/L9XtXuVDhrNe0WuHi
         6fR5vjxVkeGm4Dlx61Q8gdJJi/x1YZUc2mbXy40/WOpT2MMKlOIheT7BGgaS/jaTeoza
         sXXchY+8rcxdfjis4yy+5q0kXQfmoz98BBaU2JPOw3DQFBzYjX4AkUFIZ+/6apc6tUM0
         0dfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ll76nxeEjbDPqF2nBsv/uCSPT9e00s43w5SBooKrNy4=;
        b=R1boPNhtqN+Kn0MQctDegQRsnaUl3o+8IGxS+WjVd2wVZq87UN9tzp/1vjvQPMFlK6
         qDhX5X0nt9RkocYiuEeBny5BSGdKCZlFHiCwjztKwWs+YzxjYTZw9q/45sxbbGrV2PJ0
         wdEUURpw8kt6fLH5ZEBXlNTs+Fd9NVSLw/acV1BLigGEaBwnpaIGtFiT7Ofb0f0f4jEJ
         KgLKL5UvgyLba8kUpFrwL+6LcySdwLd/C6Sw8WyvIPkAvtWs0kjODR7Vyf0Z3SScL7cg
         z6ihjTKheRdtEu+rFCOO5Z9GXsKwbicXjFdRBPDuU5ntN+Wq6SRjS+yUTgo9TsLThDk0
         R7nQ==
X-Gm-Message-State: AOAM531SNGydA1q0KM59v3QcfzqD/D8J78UMp5MRMDcXuTLwVO0pJzUa
        O7j+11/eB9GPCFh6eXl2gGiZ6VBKGq+7wRhS2x8=
X-Google-Smtp-Source: ABdhPJzkIhz5sD0q5sBazDHr+Ex2m0Nh1xV4wW9MYND3hmvScOvEau49fi3WlvhwM1DodH8H7s4FO+OleAP2lkxkAgU=
X-Received: by 2002:a5b:d4c:: with SMTP id f12mr25755441ybr.510.1620848186756;
 Wed, 12 May 2021 12:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210512065201.35268-1-masahiroy@kernel.org> <20210512065201.35268-2-masahiroy@kernel.org>
In-Reply-To: <20210512065201.35268-2-masahiroy@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 May 2021 12:36:15 -0700
Message-ID: <CAEf4BzbsuivHaX0SHdBBV6+wpdtViFXOw=oWLyytzcRPiq+QSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kbuild: remove libelf checks from top Makefile
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 11:52 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> I do not see a good reason why only the libelf development package must
> be so carefully checked.
>
> Kbuild generally does not check host tools or libraries.
>
> For example, x86_64 defconfig fails to build with no libssl development
> package installed.
>
> scripts/extract-cert.c:21:10: fatal error: openssl/bio.h: No such file or directory
>    21 | #include <openssl/bio.h>
>       |          ^~~~~~~~~~~~~~~
>
> To solve the build error, you need to install libssl-dev or openssl-devel
> package, depending on your distribution.
>
> 'apt-file search', 'dnf provides', etc. is your frined to find a proper
> package to install.
>
> This commit removes all the libelf checks from the top Makefile.
>
> If libelf is missing, objtool will fail to build in a similar pattern:
>
> .../linux/tools/objtool/include/objtool/elf.h:10:10: fatal error: gelf.h: No such file or directory
>    10 | #include <gelf.h>
>
> You need to install libelf-dev, libelf-devel, or elfutils-libelf-devel
> to proceed.
>
> Another remarkable change is, CONFIG_STACK_VALIDATION (without
> CONFIG_UNWINDER_ORC) previously continued to build with a warning,
> but now it will treat missing libelf as an error.
>
> This is just a one-time installation, so it should not matter to break
> a build and make a user install the package.
>
> BTW, the traditional way to handle such checks is autotool, but according
> to [1], I do not expect the kernel build would have similar scripting
> like './configure' does.
>
> [1]: https://lore.kernel.org/lkml/CA+55aFzr2HTZVOuzpHYDwmtRJLsVzE-yqg2DHpHi_9ePsYp5ug@mail.gmail.com/
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
>

resolve_btfids part looks good to me:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  Makefile                  | 78 +++++++++++----------------------------
>  scripts/Makefile.build    |  2 -
>  scripts/Makefile.modfinal |  2 -
>  3 files changed, 22 insertions(+), 60 deletions(-)
>

[...]
