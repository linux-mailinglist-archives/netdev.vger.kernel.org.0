Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B983378FBC
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242873AbhEJNx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:53:29 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:46087 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbhEJNtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:49:33 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N0G5h-1lLfdo1ZDj-00xKRt; Mon, 10 May 2021 15:48:23 +0200
Received: by mail-wr1-f49.google.com with SMTP id l14so16713460wrx.5;
        Mon, 10 May 2021 06:48:23 -0700 (PDT)
X-Gm-Message-State: AOAM530HjJR00e1D1SpHe/YGpeWfpMUddaFkeSILCIxC4QNMvt2j7lf4
        6784kgs1/9oRhaN6Uius+lDni6dUuuv4JWqMdLo=
X-Google-Smtp-Source: ABdhPJzhdQBDlhT58nLl3h+XLT/UqmHJplz9FuYPvm+qQhsgtun8Lu+7pwAmSvZbZqpU0vPp87OqpWOs4lalxUp57AM=
X-Received: by 2002:a5d:4452:: with SMTP id x18mr31726656wrr.286.1620654503046;
 Mon, 10 May 2021 06:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210510085339.1857696-4-schnelle@linux.ibm.com> <202105102014.AoEdJzot-lkp@intel.com>
In-Reply-To: <202105102014.AoEdJzot-lkp@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 10 May 2021 15:47:29 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1uTgFyPL+m2Ts3vigVc1V=BNLhMpF5UtJdnd+-FQy2_g@mail.gmail.com>
Message-ID: <CAK8P3a1uTgFyPL+m2Ts3vigVc1V=BNLhMpF5UtJdnd+-FQy2_g@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] asm-generic/io.h: warn in inb() and friends with
 undefined PCI_IOBASE
To:     kernel test robot <lkp@intel.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, kbuild-all@lists.01.org,
        Networking <netdev@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:uHVF2moNEazkR1sM7C0E7phB6weUmPvi/AeYEAsVfrztihAOvxf
 uLyrkn5T/nohnVaJBHtFPBjnSA7WeT5AFIPw8sDspbp4NbDqHsxmJTPGmedJgqNkE0mWExD
 Ofi0oXIl9j7AtpPtyXf8O0Hu42FkAmsn+K/gKhgU+LFiLzzuPn9fmUEnLVFQRZwhCdMp/aG
 fcbSctRaEziImPEy9gXpw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CHE0vqSUXy4=:U5G1QWDa28vF8mW1Sbd1Z6
 bhHCN5AitegTOT6kQIE66VIil3MNb/MkqMaGFSjt9I/oPITqCIZbxlC+Jn+s5uDvWtBKaWnOi
 7XTuWen/1g/yFjpzQesimo4vthb6ekipZ/7a8ULePkd8TTDRi4932Bi7GpdVEIyeP9kKI762x
 eCuQbqM3Zs8xsS92VM9+xntvwHZzkBH7WKWBqyucWSbqmqfUnJ+1+yY7AJjTiWENQIBbW1iVA
 haxBdalKsTlGFlc/kTP1GcVEijSF0DKX5FAOvg/pWMB3ptWHyK4tgvR9lgRc/giaq4MWq/amQ
 DfHjgHWLnueJWJtPf/vXpHgqwleziaRArLZW67eovxYaQaIGtMZfPrY2b71jUM4kHKW3IDDa8
 2dGTgUxg2mh4VDhAa4QyKRLmUbjf0Yk9CpSi6CztviEpFES8butW+BKbVcGaOSJIG7CNBPnJ4
 GMLlQIw5AR4bEW176NyRgh5fO2R8Ts+W6PBY3wkonr6tDK5oQZo8Hvz6i8WOjn9+dW0q3/8AM
 AdPhGSWF+q7XUJr5HtWqvaYA9RYFnUatlm3OYqD+HBQF43Y10lf1iFftmHHLMoyejpGbKhKw5
 gOW8TeqL67bbqKecRNJanq5nianY40HEDswqBVyFpH00IPjzuiUvcZ+sDOBz2gQWJfSsU47CA
 vhKY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 3:08 PM kernel test robot <lkp@intel.com> wrote:
>
>    In file included from include/linux/kernel.h:10,
>                     from drivers/media/rc/nuvoton-cir.c:25:
>    include/linux/scatterlist.h: In function 'sg_set_buf':
>    include/asm-generic/page.h:89:50: warning: ordered comparison of pointer with null pointer [-Wextra]
>       89 | #define virt_addr_valid(kaddr) (((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
>          |                                                  ^~
>    include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>       78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>          |                                          ^
>    include/linux/scatterlist.h:137:2: note: in expansion of macro 'BUG_ON'
>      137 |  BUG_ON(!virt_addr_valid(buf));
>          |  ^~~~~~
>    include/linux/scatterlist.h:137:10: note: in expansion of macro 'virt_addr_valid'
>      137 |  BUG_ON(!virt_addr_valid(buf));
>          |          ^~~~~~~~~~~~~~~
>    drivers/media/rc/nuvoton-cir.c: In function 'nvt_get_rx_ir_data':
> >> drivers/media/rc/nuvoton-cir.c:761:15: warning: iteration 32 invokes undefined behavior [-Waggressive-loop-optimizations]
>      761 |   nvt->buf[i] = nvt_cir_reg_read(nvt, CIR_SRXFIFO);

I think you can ignore this one, it's a preexisting issue with this
driver that gets uncovered by your patch: if "fifocount" is read from
a broken device as 0xff, the loop causes a buffer overflow.

The code is already unreachable because the interrupt handler
will have aborted already, so the compiler's dead code elimination
should have shut up that warning, but adding a range check
before the loop would address this as well.

As far as I can tell, this warning only shows up when building with
"make W=1".

       Arnd
