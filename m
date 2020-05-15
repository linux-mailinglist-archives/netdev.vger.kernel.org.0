Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A105D1D4E8E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgEONMT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 May 2020 09:12:19 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:46405 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgEONMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 09:12:19 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MlsWZ-1irCxX2oex-00j3ld; Fri, 15 May 2020 15:12:16 +0200
Received: by mail-qv1-f52.google.com with SMTP id l3so1010890qvo.7;
        Fri, 15 May 2020 06:12:16 -0700 (PDT)
X-Gm-Message-State: AOAM530LkO6Ejh7NLH/YllxbvXRsA0epdjGiwFt5cehSdCFbS8SzU0dp
        V7p7FUM8Wu4CihVnDBaASbRXTCCbey/Gu5qEqU4=
X-Google-Smtp-Source: ABdhPJzL0kbPaWt/UYw2Uz2rNIXYk/KnlaMI5B0hSICGSdegHY/AByOI15lsImUtudCP8+CPlNhdx49cfpzs91/rvyQ=
X-Received: by 2002:a05:6214:1392:: with SMTP id g18mr3170818qvz.210.1589548335328;
 Fri, 15 May 2020 06:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200514075942.10136-1-brgl@bgdev.pl> <20200514075942.10136-11-brgl@bgdev.pl>
 <CAK8P3a3=xgbvqrSpCK5h96eRH32AA7xnoK2ossvT0-cLFLzmXA@mail.gmail.com>
 <CAMRc=MeypzZBHo6dJGKm4JujYyejqHxtdo7Ts95DXuL0VuMYCw@mail.gmail.com>
 <CAK8P3a0u53rHSW=72CnnbhrY28Z+9f=Yv2K-bbj5OD+2Ds4unA@mail.gmail.com> <CAMRc=Mf_vYt1J-cc6aZ2-Qv_YDEymVoC7ZiwuG9BrXoGMsXepw@mail.gmail.com>
In-Reply-To: <CAMRc=Mf_vYt1J-cc6aZ2-Qv_YDEymVoC7ZiwuG9BrXoGMsXepw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 15 May 2020 15:11:59 +0200
X-Gmail-Original-Message-ID: <CAK8P3a13k+X0XkkX=12x+22qVt_xxTBZr52ONQGdAY2T6XbpyA@mail.gmail.com>
Message-ID: <CAK8P3a13k+X0XkkX=12x+22qVt_xxTBZr52ONQGdAY2T6XbpyA@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:Fbbb/Tu1JEHdbirs7W2eZ4b5soDWkcqrpUNCd5AaHYPNk6HxGy2
 OSilgEREmRLlSUYRmbxeJZ85CkgnfW4dK1joqZ3jpfDTq4NRC0izCAffyT40kiZzV1i9FLq
 A1yhR0K89YColUJjT0UhQ4vNN3yQPnVsQWWCcE6V8NNBW00qi1BgU9sK72ZD8AynvMdl1zz
 ZMyZoFoeBfDDXmQBmG6hQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/aU9I5jDUPI=:U4e6GhX/+tv+OxvqBwcDO/
 b0pfnGyT5+zIonA26dv83VamYMMs3WmnG/ofxiOzpfRB6WRvdJQDM+vbQr4ZeamjIb6kOOXoR
 PWkqIe5XJL8jJBv0cyZ9gfFVqUSVokQel8BQA5G2OA5Lv4M7WDo8UMdAekijVV+xqIMtft+4k
 Coo2Rtdm4vGG3ApnDOa7MsPIXUnHuZI0sPOFn/xgaB1rtHzIcl2sN8xtQPjvtZ33t7Atpk9ht
 djwz+V6SnN1KbXT5HEPYiKXJQ2GPX825lmd/gvjW3V/afKjhqCmhCj7ZRNDvsJ58wLPQqJgev
 Ez0u6D5IsNRXaugy6jHJe5sP0dIGs/cSeNeQJcSZgx2RLIda96pMxCM5E1Jf7Sc7GIBGD9iLP
 fP+hpCBfqjUxbdtp2tpSTtHuHRR0wiV8wUNjqr66UullH+sjzH5EdK6ZVJPNRNKIVuT5za3UU
 sBedh6JGQ325SVv05i/3v5IsjR6YUidCGjVKmUl9AFXMNuXJtfr+bMHBsc4MvdfaQn725yvTt
 CFYobvYhrDZAa/gW4txI9C2/4yppbom8TPCwslmd+kHIRmzqoiQOVtXQBE+Uzw4t4iIKuTdmH
 aLp+0K9DK3L4n+cMiAzH/uKBaFSC8r4+twq62UpOxRlHDcQqloDgwxEzPVn6aMMH/6i5ofFug
 qtEtxxXQB2L39Pi+gevNMvv6iAgtl+S2ZwMjlNDYxc6mnkCLLDOWGLMXtvdzLtKAnqYIEyV9Q
 FyYkH2LOrLxakAQGI9lIER04XlKrtLuC1jXYLJvh6Oav62Jcj51NbJht/gvLaJrn0qjLX8WAp
 UuVCzeHLdEK/xMBQs5hosTYMq/9z7yVIqRZ+qSVl+A5uhx0ZjI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 2:56 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> pt., 15 maj 2020 o 14:04 Arnd Bergmann <arnd@arndb.de> napisał(a):
> > On Fri, May 15, 2020 at 9:11 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:

> > > >
> > > > It looks like most of the stuff inside of the loop can be pulled out
> > > > and only done once here.
> > > >
> > >
> > > I did that in one of the previous submissions but it was pointed out
> > > to me that a parallel TX path may fill up the queue before I wake it.
> >
> > Right, I see you plugged that hole, however the way you hold the
> > spinlock across the expensive DMA management but then give it
> > up in each loop iteration feels like this is not the most efficient
> > way.
> >
>
> Maybe my thinking is wrong here, but I assumed that with a spinlock
> it's better to give other threads the chance to run in between each
> iteration. I didn't benchmark it though.

It depends. You want to avoid lock contention (two threads trying to
get the lock at the same time) but you also want to avoid bouncing
around the spinlock between the caches.

In the contention case, what I think would happen here is that the
cleanup thread gives up the lock and the xmit function gets it, but
then the cleanup thread is spinning again, so you are still blocked
on one of the two CPUs but also pay the overhead of synchronizing
between the two.

Holding the lock the whole time would speed up both the good case
(no contention) and the bad case (bouncing the lock) a little bit
because it saves some overhead. Holding the lock for shorter
times (i.e. not during the cache operations) would reduce the
amount of lock-contention but not help in the good case.

Not needing a lock at all is generally best, but getting it right
is tricky ;-)

      Arnd
