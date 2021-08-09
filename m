Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC533E466B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhHINWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:22:40 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:48199 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbhHINWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:22:23 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N0WLC-1n0o5p203g-00wTwj; Mon, 09 Aug 2021 15:21:57 +0200
Received: by mail-wr1-f47.google.com with SMTP id z4so21434557wrv.11;
        Mon, 09 Aug 2021 06:21:57 -0700 (PDT)
X-Gm-Message-State: AOAM532BvkF3fCxklp8+n4ewXggk/INBd2ipbzViDrFrLKXJ8xS/FRYd
        TCjRh3kvdEHDinpJ8PdFHjtbPlKoy6q5OuJOQuk=
X-Google-Smtp-Source: ABdhPJy16990ho4qpaTAmbDTUFeqQ/A0wIjvh9as86tRp9Mkq8co1Vb/ON23QRD87IMks8uku7CxYKSzhHKXaR/99pw=
X-Received: by 2002:adf:a309:: with SMTP id c9mr7600369wrb.99.1628515317048;
 Mon, 09 Aug 2021 06:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210809202046.596dad87@canb.auug.org.au>
In-Reply-To: <20210809202046.596dad87@canb.auug.org.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 9 Aug 2021 15:21:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a103SSaMmFEKehPQO0p9idVwhfck-OX5t1_3-gW4ox2tw@mail.gmail.com>
Message-ID: <CAK8P3a103SSaMmFEKehPQO0p9idVwhfck-OX5t1_3-gW4ox2tw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:nRo0NssWTaHIckkiOOW6M6iRtbxvF9MxcMIP4z3c/ABpnuJNra4
 SYOatWYBUamU60cy+ljuBDmYQitchtOAiDL2fLXOhIjdykDDo59yIFGc6XuY8Xmw4oOqU2o
 x7fQPXJEAbHS5Aj0Bz2S3cYbADxLkJjQrhc2MlTRWMLh/vDZmd0eglWwsWnu8+fae/M7ZHm
 VLbPxx9a1Y9tctUruqalA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:x/xcfGnN9Mc=:jBHmHL/MQhSZ4mnIDnIhx+
 s5HMze53RsAAvrWcmHuYbNoKqf3xYe1bqP2fSaxEWzOA+BzYm72pANl/vfUhcBynU3LZ+aoju
 1MQIUXYroZgM/pgb8Kz9pH9CKDqC9Dui2YE1JgY1FQrZYkpHQAdv9GO+ooVw7OcwFySPMxeH9
 ek1EWRqgmKiF3ZARwdFIDbZkihCSOAJAW1OfNRjbOtz9/jWjYPLsO5PW5KsAS21upiZNW53oa
 z5qDqNJ10ZdhNXd41dzLby4a6w7RcgUDJtUVGyp9ep8Vgaodah9gTWjEkqxSic2pZBGwGN5w0
 UN4bEPs8dPrQBbxzrskio0GikvJ8RxIA69K4Hvv48GLA/824JyA5DuhMGl/aqgjbzCVDtQZRp
 1zO9dW+RDFKHhW4JZd3KbhgC7OZaAQHQURoaJPSseKHrY+MNm1ZyoYR5XpU6JddF79wGj7SOM
 AYRtuH5xtgU/y1mZ/bDz/QjNFouToOWvqT5AIAX84BA0OFPKUE9EOiGefLe+ijdbRMQP5vHwO
 s40bjgBmsJTM25bkSO8j3+du6THpapBYccgisE1PKv4ZC7bYQYgAMLgZwHrnIDQIM44THe8RG
 S3cEEr1Encivn4ilGxtGGwLNYU6wx1jXYSRvkf52WIuwMyobDRUdhBxnRFedX9wA8trQuOXIg
 /kFVe5Kg/Xyj5CI1o5IupXpJjt9Qwdqq3jkugzkC0pkFIeyi2g7WAsjbGiVLkV3gvlxHi47Ff
 +vsoLM6xdPFBzZsCVnDlYAUylblJXEw0EYjRVFdLHOyeJOzm2W5eHGve9RVCKvH9N7vSAhK7E
 eZQaXuctUFutRUFnHhkzJdApg/JwV2gSRlk/6fORuKZNnHObD4lkQ/q/DCR75RpaC+jnX5i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 12:20 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/net/ethernet/cirrus/cs89x0.c: In function 'net_open':
> drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declaration of function 'isa_virt_to_bus' [-Werror=implicit-function-declaration]
>   897 |     (unsigned long)isa_virt_to_bus(lp->dma_buff));
>       |                    ^~~~~~~~~~~~~~~

Thank you for the report! I already sent a patch for m68knommu running into
this issue, but it seems there are other architectures that still have it.

The driver checks CONFIG_ISA_DMA_API at compile time to determine
whether isa_virt_to_bus(), set_dma_mode(), set_dma_addr(), ... are all
defined.

It seems that isa_virt_to_bus() is only implemented on most of the
architectures that set ISA_DMA_API: alpha, arm, mips, parisc and x86,
but not on m68k/coldfire and powerpc.

Before my patch, the platform driver could only be built on ARM,
so maybe we should just go back to that dependency or something
like

         depends on ARM || ((X86 || !ISA_DMA_API) && COMPILE_TEST)

for extra build coverage. Then again, it's hard to find any machine
actually using these: we have a couple of s3c24xx machines that
use the wrong device name, so the device never gets probed, the imx
machines that used to work are gone, and the ep7211-edb7211.dts
is missing a device node for it. Most likely, neither the platform nor
the ISA driver are actually used by anyone.

     Arnd
