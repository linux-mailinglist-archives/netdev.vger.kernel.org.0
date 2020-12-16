Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88E72DC994
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgLPXaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgLPXaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 18:30:13 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FDFC061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 15:29:33 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i24so26670396edj.8
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 15:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=oHW20Y04wvGVk9UmyRRlDNomzN5I2m9VJ+tYDy3fSD0=;
        b=uahCANzXwA5aCIUV6du8D8u6wNGaEy7y9ykhpmdKEcXYF11CilccpIgDGEdpo3gDev
         1N/k435DAd3SBeFjdznGM3iO3j4rMGhaRkTTRuWHb7Kw82JlJDOFzQ87kn4OrrUb3el4
         LgqZ7KhFPoAvKDRZf6L72NIua03MMQeIut7Vtb2MRck0p+eKvMLUFoG5aTudi825ssJm
         OvVulup8uximjKksGN9xl2bXbmdmiP6gwV7G3s/sOzcAGU3jSGcEbw375s+gnFle4UOO
         zE+rJthMK9IW0RuFoelWkbyzBORcgLQXB3JxbEcZR6j42R/CpKp/qYx7/yHPRU2WKfHn
         X7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=oHW20Y04wvGVk9UmyRRlDNomzN5I2m9VJ+tYDy3fSD0=;
        b=sE/I2lRaxTbs6JmCe/3E7AyMdWUwC0wBxvBv7NbPd2SiwEpvklTxq6de3ZpFG/6dlc
         dhHiRQZ6n9R+fc7ViZf9SHZqzd1MdD0YGJBqTT/uOoSFfiwMdmmQerQBptnk1HrKXEPJ
         rosnvw55w2cRJl302lnTdooBw8w/B2gDh7XQ3OzzsE6dyn8Ogorp5yYC9lbuyoRqHJAc
         U9VDrJCKecZf1GW2k+IdW3P23+vBjAiigwtFGkI/hY1j3k8CZ1Md0umlndU7aY5p6VOi
         HuduXR5KkL/H65Y+TLaeNZd7Q5+5IJssA2l9A13OYueCItkC2+TcVUXvQw0YM/p5oZJp
         aMUg==
X-Gm-Message-State: AOAM530h3hibyYw3Tq4Mu7rvNAkb18m4I0qPXvO8uNKv5lZBa7JRrxR0
        2DZO8Z3zcgxXkMlRDm74Lhp0RcgSubeFgKYb/lfS4w==
X-Google-Smtp-Source: ABdhPJx0xf/MWmTSvAGM/6rUZqnEOQ282USilJvvQmN0mTdbfyXnWaE8k+maUbAKIG/VOIzjhVa1YVkAW7Xxsw41rc8=
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr35556563edv.181.1608161371798;
 Wed, 16 Dec 2020 15:29:31 -0800 (PST)
MIME-Version: 1.0
References: <20201216180313.46610-2-v@nametag.social> <202012170740.EgQPKuIj-lkp@intel.com>
In-Reply-To: <202012170740.EgQPKuIj-lkp@intel.com>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 16 Dec 2020 23:29:20 +0000
Message-ID: <CAM1kxwiL4dD=X18_Crd813nyt_UWpPP8XmwUf10JZhzV7221Yw@mail.gmail.com>
Subject: Re: [PATCH net-next v4] udp:allow UDP cmsghdrs through io_uring
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

what's to be done about this kernel test robot output, if anything?

On Wed, Dec 16, 2020 at 11:12 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Victor,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Victor-Stewart/udp-allow-UDP-cmsghdrs-through-io_uring/20201217-020451
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9
> config: riscv-randconfig-r031-20201216 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 71601d2ac9954cb59c443cb3ae442cb106df35d4)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install riscv cross compiling tool for clang build
>         # apt-get install binutils-riscv64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/6cce2a0155c3ee2a1550cb3d5e434cc85f055a60
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Victor-Stewart/udp-allow-UDP-cmsghdrs-through-io_uring/20201217-020451
>         git checkout 6cce2a0155c3ee2a1550cb3d5e434cc85f055a60
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=riscv
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    /tmp/leds-blinkm-655475.s: Assembler messages:
> >> /tmp/leds-blinkm-655475.s:590: Error: unrecognized opcode `zext.b s7,a0'
> >> /tmp/leds-blinkm-655475.s:614: Error: unrecognized opcode `zext.b a0,a0'
> >> /tmp/leds-blinkm-655475.s:667: Error: unrecognized opcode `zext.b a2,s2'
>    /tmp/leds-blinkm-655475.s:750: Error: unrecognized opcode `zext.b a2,s2'
>    /tmp/leds-blinkm-655475.s:833: Error: unrecognized opcode `zext.b a2,s2'
>    clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
