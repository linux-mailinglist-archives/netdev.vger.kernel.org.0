Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95A12698B8
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgINWUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgINWUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:20:03 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F619C06174A;
        Mon, 14 Sep 2020 15:20:01 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x8so1024301ybm.3;
        Mon, 14 Sep 2020 15:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yGFARoPVASh2zARPUnvTQIJesXpA+uisLN9Xh6rSokg=;
        b=VsW83caD1ntRnz/zIusk+CFOTSEG2NH4CdQwk/SbqsXNJUa7aK5+91rNQ3RdETRbsC
         a/KcOxpKky1O1O6ScHe3GzNaOKQzDH0z+f0tdaywuWxd1ikYOVAUad5e6t2X5mTlH8JV
         9063dfE7JDDIJ9hiAvC3xp2FYe0w7BALlONXGGJIuduYh2QYcKRK4k1WyweQTiRiaC8k
         TqMms2zoZsp7BP+Q5u6++zasPLvw2u28/l1SHrKOzVltmsFQT2z+Eh6rnIdDLAxqHN4/
         wvCDdtmiaDp1IoV9h+zZrA+/oZpg6PblUTSD4Yzz8nBNBkySY2WRodn4IU6fBTt1/EeF
         JnCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yGFARoPVASh2zARPUnvTQIJesXpA+uisLN9Xh6rSokg=;
        b=YgYZRmVAcZpb8f3Yda0FxsjGVd18/iXxkUt1Mk6YBZeYCyazVl7lQN6YBEORcvGxbC
         hr5tz7bbDk4Dr3UZy2Ah0RzBZ20Z+trsrNp0pL8xPglsJJ+d5CGQ9ZC5nF5/GundZ1Of
         +1YTa/YlE0bvGtpBGYIypYky2LhDs/Pc2IG5bwlSrmZOdYhxKvBC3qKTsJf/C/Wzc1Uy
         CNFyZi0yG3lCr49xtEOoV/wEedfoEuQo3XfjB6Ln+X6Z0e+I+GHuipUZURpl6Tmu8LVJ
         YHgrCeNJeM66Qc2/7ilC2sQrSbnxNiOtrp9SFL1khM3q1Vk9EQ/K5w5ttG/MYLDcfsKI
         gS9Q==
X-Gm-Message-State: AOAM532gJCK7IE2a6GevsEYamtKnPAuugBk1KhMe0Zyi5/r+f7MiE83x
        +xLDeVkyCA9JlgcqY+HgcjUnMlDa1qNpojLWkMM=
X-Google-Smtp-Source: ABdhPJw7xF2+nYspneRT7HPRWpV5MjpJ6UJEPslkZIs0jKN7RN4N95zDIkGXZXCiOzazYlKzI4ILwvPJPXdxzbgAmEE=
X-Received: by 2002:a25:e655:: with SMTP id d82mr24930234ybh.347.1600122000365;
 Mon, 14 Sep 2020 15:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183110.999906-1-yhs@fb.com>
In-Reply-To: <20200914183110.999906-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 15:19:49 -0700
Message-ID: <CAEf4BzY-ewpt7c602omSqPYvPKArmOBgj-WBAGiMiQ10p+T9eQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] bpftool: fix build failure
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:31 AM Yonghong Song <yhs@fb.com> wrote:
>
> When building bpf selftests like
>   make -C tools/testing/selftests/bpf -j20
> I hit the following errors:
>   ...
>   GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>   <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>   <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>   <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpected unindent.
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8] Error 12
>   make[1]: *** Waiting for unfinished jobs....
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8] Error 12
>   make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8] Error 12
>   ...
>
> I am using:
>   -bash-4.4$ rst2man --version
>   rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>   -bash-4.4$
>
> The Makefile generated final .rst file (e.g., bpftool-cgroup.rst) looks like
>   ...
>       ID       AttachType      AttachFlags     Name
>   \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\
>   (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
>   (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
>   (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
>   (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
>   (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
>   (8),\n\t**bpftool-struct_ops**\ (8)\n
>
> The rst2man generated .8 file looks like
> Literal block ends without a blank line; unexpected unindent.
>  .sp
>  n SEEALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**
>  bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**
>  bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**
>  bpftool\-struct_ops**(8)n
>
> Looks like that particular version of rst2man prefers to have actual new line
> instead of \n.
>
> Since `echo -e` may not be available in some environment, let us use `printf`.
> Format string "%b" is used for `printf` to ensure all escape characters are
> interpretted properly.
>
> Cc: Quentin Monnet <quentin@isovalent.com>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" sections in man pages")
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/Documentation/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
> index 4c9dd1e45244..f33cb02de95c 100644
> --- a/tools/bpf/bpftool/Documentation/Makefile
> +++ b/tools/bpf/bpftool/Documentation/Makefile
> @@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
>  ifndef RST2MAN_DEP
>         $(error "rst2man not found, but required to generate man pages")
>  endif
> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man $(RST2MAN_OPTS) > $@
> +       $(QUIET_GEN)( cat $< ; printf "%b" $(call see_also,$<) ) | rst2man $(RST2MAN_OPTS) > $@
>
>  clean: helpers-clean
>         $(call QUIET_CLEAN, Documentation)
> --
> 2.24.1
>
