Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A874934235E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 18:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCSR3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 13:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhCSR25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 13:28:57 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BAFC06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 10:28:56 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id u75so7030446ybi.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 10:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UfQ97ZQpQ+3cbVFmfAlrkTjFt0NmXtQEpIyINKUBKbk=;
        b=jRWOkmBZrEaFmQ2LNyeJrH4VoRjb6KR+YFJrGtyGPNv83id9NRfBx4ap/vlj21vRrh
         ZqD7fbQ+oTHwN6riCNj1VB44zcGyhglGOXB10Pe3B9u5OThzwiA9T1G3Kn5BWnQVg5fA
         2WjwVQB8uAuM2Y80p/pyQ98cP2qp67qtn4NDDhSITHDEfvwN74FDV/4/DikMBPs5mAbb
         XLMfPmpZbkux9LGNXVAx/LddwwN3ufItBPA/aPh2BjjCGubkn1FUEipnUeCSU60WXcVQ
         l5+cOlqINPmMbuUzzrBUJevEJDLnfmrRAdMwNHB+3WDm1K0rFIoOuXaz0VKdejwo7Jik
         I32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UfQ97ZQpQ+3cbVFmfAlrkTjFt0NmXtQEpIyINKUBKbk=;
        b=X4V77pfl8u1RpYsKRUoTIAQ4UDRYDKNGngq59yYn9EM/0t9oruToYzkAODFYVLkgkj
         dJfShoesSX71ZT79IbwrMJNUEEwlVFXQfgc5tOmvr2ufeHtYp5XFRPJuHWcdJuZheBDm
         uqHpGkadEiUHb58vPEOo2vYxYpR/QastMDvFrE3AhDSjK3FyfHKS3bXi/cmIxx4aJI9a
         poVD10qnFwf7WRt93cMovVa4VzaVjw0jJHUT6//7BdHHr8MWclEMtAqBW+B72YKDkIn3
         sDPQAxWERCwI/WWnbgy/T0od/YFnnWauHt3ttR2XsXk/0HwCIMY/qat4Jf6HWBJnSHXY
         Ayog==
X-Gm-Message-State: AOAM533BsxNSOAFMKAstC++wHfxkjjjyeloY3AgNbbiURgodCPUYE0zP
        9QhPcI9kplpToiPAQfsevjsu9ZSRTY2Ps+M0eQby3A==
X-Google-Smtp-Source: ABdhPJw4v4CvUYvHsdXsaWU59VknE3MXVMp9J15b6lMGf/i0hTCPLA9GkNwo0TQfa8VX4e25MQnGKlYjWPbb8bDty38=
X-Received: by 2002:a25:b906:: with SMTP id x6mr7947193ybj.504.1616174935909;
 Fri, 19 Mar 2021 10:28:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210319150232.354084-1-eric.dumazet@gmail.com> <202103200159.d1zdEu9Z-lkp@intel.com>
In-Reply-To: <202103200159.d1zdEu9Z-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 19 Mar 2021 18:28:43 +0100
Message-ID: <CANn89iJi6KEsOxUc4Um2D3_ZoA2KE1YitpeVnjbLHWYDc-n9hA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: add CONFIG_PCPU_DEV_REFCNT
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 6:12 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-CONFIG_PCPU_DEV_REFCNT/20210319-230417
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 38cb57602369cf194556460a52bd18e53c76e13d
> config: arm-randconfig-r014-20210318 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project fcc1ce00931751ac02498986feb37744e9ace8de)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm cross compiling tool for clang build
>         # apt-get install binutils-arm-linux-gnueabi
>         # https://github.com/0day-ci/linux/commit/684c34243e0c84e496aa426734df321b7ebc088b
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Eric-Dumazet/net-add-CONFIG_PCPU_DEV_REFCNT/20210319-230417
>         git checkout 684c34243e0c84e496aa426734df321b7ebc088b
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> net/core/dev.c:10752:1: warning: unused label 'free_dev' [-Wunused-label]
>    free_dev:
>    ^~~~~~~~~

Great, I will add the following diff to v2

diff --git a/net/core/dev.c b/net/core/dev.c
index edde830df1a483535372014034d5b1ee1ff6210a..be941ed754ac71d0839604bcfdd8ab67c339d27f
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10748,8 +10748,8 @@ struct net_device *alloc_netdev_mqs(int
sizeof_priv, const char *name,
 free_pcpu:
 #ifdef CONFIG_PCPU_DEV_REFCNT
        free_percpu(dev->pcpu_refcnt);
-#endif
 free_dev:
+#endif
        netdev_freemem(dev);
        return NULL;
 }
