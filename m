Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AC7322918
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhBWKyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:54:04 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:44357 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhBWKxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 05:53:17 -0500
Received: by mail-ot1-f46.google.com with SMTP id f33so1831291otf.11;
        Tue, 23 Feb 2021 02:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p921Adf2pfxJ4CIGcX2NJ7Shi4YJTy9/PyaI82TeK30=;
        b=a/VXrDkexY/eTcfOncH2GpzEl1WIxL5RxvJgLDH3kaT29dzfkSssnOQHmMD5XhFoGJ
         zfhhIM0vhiCJrihbHkvzXRsR8zHzG7XymjIB31TuXSiqiJHcLno8vJyPOJ8PS3pRXUkt
         CEoGNY3NNUKIXbdGM0mbEXzmw2mqfctQ2u/fgsl9pWyGbEcQ9eiPvYyH+Zpz0+a2Tk2x
         ewaWrAzvl5DA5/iGGaBQooruAr0KrXNePbCOIcv0ggq/nf+U7y9N9P5s6jO+bp13wOrF
         vQyRkHpMGfqdutQEGLkXB44pwsO8ZUczZonv2sytPjK/z3x4HST/5l9N8oCFc0hAd+ZE
         x7+g==
X-Gm-Message-State: AOAM531umUww8ELZRsfDV47CpeAQHROsG7SeU5w0FScNZom9tn2Xe76H
        Q1uocjG5jG2XflTj+BoSatvmkwdqIzI++ffikVo=
X-Google-Smtp-Source: ABdhPJxU6D1gioqnTsFkXieuOJkzEKf3pB6me3Sv4iD1CvDI5JK99ZkQTh9GaKwYtfiKO1loGNvRjzdw7QaKOWbjb/A=
X-Received: by 2002:a05:6830:148d:: with SMTP id s13mr19810419otq.250.1614077556046;
 Tue, 23 Feb 2021 02:52:36 -0800 (PST)
MIME-Version: 1.0
References: <1614012946-23506-3-git-send-email-sharathv@codeaurora.org> <202102230358.bmAq2nwP-lkp@intel.com>
In-Reply-To: <202102230358.bmAq2nwP-lkp@intel.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 23 Feb 2021 11:52:24 +0100
Message-ID: <CAMuHMdUTVaRSEt2a_sJSEYX0TCH73xspSXkd--=913dpeSzv0Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: rmnet: Support for
 downlink MAPv5 checksum offload
To:     kernel test robot <lkp@intel.com>
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kernel Test Robot,

On Mon, Feb 22, 2021 at 10:02 PM kernel test robot <lkp@intel.com> wrote:
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Sharath-Chandra-Vurukala/net-qualcomm-rmnet-Enable-Mapv5/20210223-010109
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d310ec03a34e92a77302edb804f7d68ee4f01ba0
> config: m68k-allmodconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/a96da20e1028049cc3824b52bb5293376c0868ce
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Sharath-Chandra-Vurukala/net-qualcomm-rmnet-Enable-Mapv5/20210223-010109
>         git checkout a96da20e1028049cc3824b52bb5293376c0868ce
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/kernel.h:10,
>                     from include/linux/list.h:9,
>                     from include/linux/timer.h:5,
>                     from include/linux/netdevice.h:24,
>                     from drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c:7:
>    include/linux/scatterlist.h: In function 'sg_set_buf':
>    arch/m68k/include/asm/page_mm.h:174:49: warning: ordered comparison of pointer with null pointer [-Wextra]
>      174 | #define virt_addr_valid(kaddr) ((void *)(kaddr) >= (void *)PAGE_OFFSET && (void *)(kaddr) < high_memory)
>          |                                                 ^~
>    include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>       78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>          |                                          ^
>    include/linux/scatterlist.h:137:2: note: in expansion of macro 'BUG_ON'
>      137 |  BUG_ON(!virt_addr_valid(buf));
>          |  ^~~~~~
>    include/linux/scatterlist.h:137:10: note: in expansion of macro 'virt_addr_valid'
>      137 |  BUG_ON(!virt_addr_valid(buf));
>          |          ^~~~~~~~~~~~~~~

Note that the warning is unrelated. I've sent a patch to quiten it.
[PATCH] m68k: Fix virt_addr_valid() W=1 compiler warnings
https://lore.kernel.org/linux-m68k/20210223104957.2209219-1-geert@linux-m68k.org/

>    In file included from drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h:7,
>                     from drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c:14:
>    include/linux/if_rmnet.h: At top level:
> >> include/linux/if_rmnet.h:66:2: error: expected ',', ';' or '}' before 'u8'
>       66 |  u8  hw_reserved:7;
>          |  ^~

That's a real one, though.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
