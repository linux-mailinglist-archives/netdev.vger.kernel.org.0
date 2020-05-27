Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A31E4020
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 13:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgE0Ldc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 07:33:32 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54727 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgE0Ldb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 07:33:31 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MwQCb-1imMQ81StB-00sPXK; Wed, 27 May 2020 13:33:29 +0200
Received: by mail-qt1-f177.google.com with SMTP id k22so4043403qtm.6;
        Wed, 27 May 2020 04:33:28 -0700 (PDT)
X-Gm-Message-State: AOAM530RRMcKjDTVH729nVCCqJTL7+y4mrTZI2gvMXtAML0Jweln865p
        BPoR4XL25KrMIUj9BGo50ZFkWPbBrwnuVqt8+P8=
X-Google-Smtp-Source: ABdhPJytr2bjG8wmbrwCUlNw85Yc0YEiejDsr/eUYMM1igF/l+KazWx6+Wav70gPMdZ6TcuTfzx28axhkOZA5yS1Tu0=
X-Received: by 2002:ac8:306d:: with SMTP id g42mr3579966qte.18.1590579208037;
 Wed, 27 May 2020 04:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200522120700.838-1-brgl@bgdev.pl> <20200522120700.838-7-brgl@bgdev.pl>
 <20200527073150.GA3384158@ubuntu-s3-xlarge-x86> <CAMRc=MevVsYZFDQif+8Zyv41sSkbS8XqWbKGdCvHooneXz88hg@mail.gmail.com>
In-Reply-To: <CAMRc=MevVsYZFDQif+8Zyv41sSkbS8XqWbKGdCvHooneXz88hg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 27 May 2020 13:33:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3WXGZpeX0E8Kyuo5Rkv5acdkZN6_HNS61Y1=Jh+G+pRQ@mail.gmail.com>
Message-ID: <CAK8P3a3WXGZpeX0E8Kyuo5Rkv5acdkZN6_HNS61Y1=Jh+G+pRQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] net: ethernet: mtk-star-emac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:xLCVZVJKQytAvbA8rvzmUb8CsvyaiYXOseUJ7GWZPaF0uJkBKS3
 wZqcGEVmdbEivR6kjmvDMEpd7hO3UFwf62hEQ+pS1DvyODLfVZp/8G/He4Cnk7HWkeFc2EK
 KTPG4qQZmde2+O+RhbHGrzznk73F6CZZCakNOkhAvU1ck2Am5iStpPT67qoBizpzWjS6UBU
 HZsRfZeKupTRRySgSMk3A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/X7C0o/PeQs=:y5tIAJrBfNdHDdAaJk2Dm1
 s56FsrM0Dn2f3KSRCbiI0+hHHtQuYV28tcE5by+77pNRvotxBThPTWfgU6HOJeZM5/ySqXNbq
 IXV1xo+ktKJAkGh+Ueb1E/rmvnnnhA68t0BV5bFXayPWlN4a6OavB9f9fi6FN8Pf2SBwKTovC
 EpTXvD1U6Xm8Pa9llDcXlTnGfMPucgcNdLxfalIQapgDdIKmAoti7B22KR/pERJzvaq+mTqd+
 k3AstFS/SJbKtKjU0GlMEejWxa/Svvm0E8aY2a44KVMhODdbiTw+OM0fVZna+GMLbnnweInIw
 E4/3KVlblW6wPR+aOJHXYUhBw93G8UCrZ0Al2q6heb8FOApRbGs108/j/Ztvgy5Ff9Jz/B+2d
 0xTh1O/1keqhjB6Sk+m1nFuxdQ45fZzkpb3sINgZrVE+jG1+MGp+D2b8Qv9FWt/V5nYnr8abs
 gg788k+bsT7BkWiRr8ihTRprdweND8AQb0ZFmrIIpIp79UYPzYWHXpQ1jbzffNt5e4CyrzS/E
 F0bPKQzYTOb9YqN23DFwwIuV1odKcJdyIPRpzERiAHYDpRMz/nXzVM4edyqpyMMRRj/4oWRcx
 /lX45laOFCI3048ND62UOR3EZlq854vatp/rqz375WyBB3ThWSoiiCJ2OPyjAB6SF8nP6RzpH
 Z7/jdeOqmoJabBdSLsYB8OY/LqTRZrzKdMNqQO//yUDkMfUv6y3G+olNDaBPwXDm2h53FqxtL
 YPdTzYIdtSK/7eK3nAZmAJEmM/iRjGulLKU18fa2zxoYomAF792s1dak+1ZNJy5KoDdiSgCXK
 s6H2NMy59a6MFFUm/LW/iG8PijuygUhGGqYpwa4/3O2Wiqy4Yg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 10:46 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:

> > I don't know if there should be a new label that excludes that
> > assignment for those particular gotos or if new_dma_addr should
> > be initialized to something at the top. Please take a look at
> > addressing this when you get a chance.
> >
> > Cheers,
> > Nathan
>
> Hi Nathan,
>
> Thanks for reporting this! I have a fix ready and will send it shortly.

I already have a workaround for this bug as well as another one
in my tree that I'll send later today after some more testing.

Feel free to wait for that, or just ignore mine if you already have a fix.

       Arnd
