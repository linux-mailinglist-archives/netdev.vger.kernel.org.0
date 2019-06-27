Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C92A579E0
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 05:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfF0DNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 23:13:16 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:45788 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfF0DNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 23:13:15 -0400
X-Greylist: delayed 5032 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2019 23:13:13 EDT
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x5R3D6gv018380;
        Thu, 27 Jun 2019 12:13:07 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x5R3D6gv018380
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1561605187;
        bh=hUceC5AeeaszlwO9PeBwDuTy7hRVRhzHLJ1xX0slEKk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2Cyt6p7moE3aTxtO9LVZTLf8Js+TX6msHAzEQc2U3RWhpCafH3zcwX7L6dncx8NZj
         ockSog0czJt3lhCqCbLzNffVlAwojPSytljO9BO73VA05KUuFrmauuPIzOxtzCJyCS
         I5epEv29rqm491WP8MAtiIhEnlmhgxnbyjF+1EaPXAMrOVW0Tp8sy5BrWQ7xi5cIMS
         +la8c2fFA7Qz6Gsxgjb0dJKJI56ggjDPZDYsmLm17g/FfJteYLT0I79YEcy9pHsNwi
         0ZC+277O1XILPZP/vHnTygUbl9mom+Th9NKjBPsENXkyrtFEoxj3NwJvDj2HSBB8DY
         94rFlEoEYBGdQ==
X-Nifty-SrcIP: [209.85.221.176]
Received: by mail-vk1-f176.google.com with SMTP id b69so201659vkb.3;
        Wed, 26 Jun 2019 20:13:07 -0700 (PDT)
X-Gm-Message-State: APjAAAWehBNpZZcasJLpNHxpeuu1T3jlBEFOJDkkJYnr7g20LQEMniEj
        sUmMF15RVz2uhGhAm0IpgSInchZE5juKTN3JMY0=
X-Google-Smtp-Source: APXvYqyrO6AGMiLTE/NsWodSgUDnExRC/7L2ZBLMise97w6CNCIJwXhqUDD88sfQ76DyLQRs9XeF+xyViB4ZUlsc7PQ=
X-Received: by 2002:a1f:4107:: with SMTP id o7mr526475vka.34.1561605185809;
 Wed, 26 Jun 2019 20:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190627014617.600-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190627014617.600-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 27 Jun 2019 12:12:30 +0900
X-Gmail-Original-Message-ID: <CAK7LNARr7mDaDdh0NxUjYHJCz7Gd9-gFdryWtT224U8KpJ9p3w@mail.gmail.com>
Message-ID: <CAK7LNARr7mDaDdh0NxUjYHJCz7Gd9-gFdryWtT224U8KpJ9p3w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Compile-test UAPI and kernel headers
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        linux-riscv@lists.infradead.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        xdp-newbies@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Colin Cross <ccross@android.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:49 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
>
> 1/4: reworked v2.
>
> 2/4: fix a flaw I noticed when I was working on this series
>
> 3/4: maybe useful for 4/4 and in some other places
>
> 4/4: v2. compile as many headers as possible.
>


If you want to test this series,
please check:

git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
 header-test-v2


> Changes in v2:
>  - Add CONFIG_CPU_{BIG,LITTLE}_ENDIAN guard to avoid build error
>  - Use 'header-test-' instead of 'no-header-test'
>  - Avoid weird 'find' warning when cleaning
>   - New patch
>   - New patch
>   - Add everything to test coverage, and exclude broken ones
>   - Rename 'Makefile' to 'Kbuild'
>   - Add CONFIG_KERNEL_HEADER_TEST option
>
> Masahiro Yamada (4):
>   kbuild: compile-test UAPI headers to ensure they are self-contained
>   kbuild: do not create wrappers for header-test-y
>   kbuild: support header-test-pattern-y
>   kbuild: compile-test kernel headers to ensure they are self-contained
>
>  .gitignore                         |    1 -
>  Documentation/dontdiff             |    1 -
>  Documentation/kbuild/makefiles.txt |   13 +-
>  Makefile                           |    4 +-
>  include/Kbuild                     | 1134 ++++++++++++++++++++++++++++
>  init/Kconfig                       |   22 +
>  scripts/Makefile.build             |   10 +-
>  scripts/Makefile.lib               |   12 +-
>  scripts/cc-system-headers.sh       |    8 +
>  usr/.gitignore                     |    1 -
>  usr/Makefile                       |    2 +
>  usr/include/.gitignore             |    3 +
>  usr/include/Makefile               |  133 ++++
>  13 files changed, 1331 insertions(+), 13 deletions(-)
>  create mode 100644 include/Kbuild
>  create mode 100755 scripts/cc-system-headers.sh
>  create mode 100644 usr/include/.gitignore
>  create mode 100644 usr/include/Makefile
>
> --
> 2.17.1
>


-- 
Best Regards
Masahiro Yamada
