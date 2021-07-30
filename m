Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9178C3DB5B1
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbhG3JNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230336AbhG3JNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 05:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 182DC61042
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 09:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627636425;
        bh=b2rPBhxnsvP5PqwgROacO8G+Brnoevs6cupV4zyY0zo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cUJ5PBeH013SAEVCELArrnHQ0KOjQQKoYLYYfdNY93xCp0MzLQh1fdhZoxSCusyAH
         8CJ2OXMeDL65+uOlRNLkJmJio185My23yhxs0icwyD3QtRwP9wWkbTEOmul8eGcVJJ
         jm04ySaXmozBuq5BvOTMMDL2fq2WZR7aSKf30+7D4rY7bNNNm/VLNJR3WQlnUtmwJn
         BJZQfBcpYbUvowSnW/NFag/D1lXEl8prW108xK0WWlBMMcEoh8XZCJ+vkrRBTBslYq
         h0Xe0IUnTEu18awTAJG6PUO1g3+O2Tq2XkH2hxuboT4Kn6XzkM0x7yyD4rI5roAsYO
         cC5SQjEDRxolg==
Received: by mail-pl1-f173.google.com with SMTP id u2so2071303plg.10
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 02:13:45 -0700 (PDT)
X-Gm-Message-State: AOAM531Xc4eeeSH8cdVp2GQvVQqaZtqOd/AhonEBVzZnF02BTCPPud1l
        nY3Ojl3M5sjh8pJgVuT2RKG+fieG4CuoFAL2QUY=
X-Google-Smtp-Source: ABdhPJzJSewqqEnkZPcVl/633Y5bFjNmWjFRfvBSe4xxYzmpiL3lBJ0iT/GBz37XcYD1wycXSDZ2bYA3V3kLtBDjfWk=
X-Received: by 2002:aa7:848e:0:b029:333:4742:edb3 with SMTP id
 u14-20020aa7848e0000b02903334742edb3mr1698275pfn.12.1627636424709; Fri, 30
 Jul 2021 02:13:44 -0700 (PDT)
MIME-Version: 1.0
References: <202107300426.FDSTqdJt-lkp@intel.com>
In-Reply-To: <202107300426.FDSTqdJt-lkp@intel.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 30 Jul 2021 11:13:32 +0200
X-Gmail-Original-Message-ID: <CAJKOXPf1NpW1AW7yFJo6pTnaSC9KiiQ4cjnGkhygLcxFXhHy_g@mail.gmail.com>
Message-ID: <CAJKOXPf1NpW1AW7yFJo6pTnaSC9KiiQ4cjnGkhygLcxFXhHy_g@mail.gmail.com>
Subject: Re: [net-next:master 469/495] drivers/nfc/fdp/fdp.c:116:67: sparse:
 sparse: incorrect type in argument 4 (different modifiers)
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Jul 2021 at 22:07, kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> head:   88ea96f8c14e39f7ee397b815de622ea5e1481ab
> commit: 3d463dd5023b5a58b3c37207d65eeb5acbac2be3 [469/495] nfc: fdp: constify several pointers
> config: ia64-randconfig-s032-20210728 (attached as .config)
> compiler: ia64-linux-gcc (GCC) 10.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.3-341-g8af24329-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=3d463dd5023b5a58b3c37207d65eeb5acbac2be3
>         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>         git fetch --no-tags net-next master
>         git checkout 3d463dd5023b5a58b3c37207d65eeb5acbac2be3
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-10.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=ia64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> sparse warnings: (new ones prefixed by >>)
> >> drivers/nfc/fdp/fdp.c:116:67: sparse: sparse: incorrect type in argument 4 (different modifiers) @@     expected unsigned char [usertype] *payload @@     got char const *data @@
>    drivers/nfc/fdp/fdp.c:116:67: sparse:     expected unsigned char [usertype] *payload
>    drivers/nfc/fdp/fdp.c:116:67: sparse:     got char const *data
> >> drivers/nfc/fdp/fdp.c:116:67: sparse: sparse: incorrect type in argument 4 (different modifiers) @@     expected unsigned char [usertype] *payload @@     got char const *data @@
>    drivers/nfc/fdp/fdp.c:116:67: sparse:     expected unsigned char [usertype] *payload
>    drivers/nfc/fdp/fdp.c:116:67: sparse:     got char const *data
>

This is known and already fixed in:
https://lore.kernel.org/lkml/20210726145224.146006-1-krzysztof.kozlowski@canonical.com/
https://lore.kernel.org/linux-nfc/20210730065625.34010-1-krzysztof.kozlowski@canonical.com/T/#t


Best regards,
Krzysztof
