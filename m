Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42B31E4245
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 14:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgE0M2b convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 May 2020 08:28:31 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54951 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbgE0M2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 08:28:30 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N2E9e-1isAKI1XpO-013aAV; Wed, 27 May 2020 14:28:28 +0200
Received: by mail-qk1-f175.google.com with SMTP id w1so649129qkw.5;
        Wed, 27 May 2020 05:28:27 -0700 (PDT)
X-Gm-Message-State: AOAM532osS/AFq3CkigcS15Y6Sv7PR6JWzFoZ1tv+w478Legne8yYC2Q
        IUOGoI5OcwuDIDsny3PqaE5aIM+BZAlJ4cXL924=
X-Google-Smtp-Source: ABdhPJwaAgzroHfp7pJ7RNhUPIcAie1aEFqd1EprpZ9PmXq2JihQh/b6bzG/FLdwRDsYzWluddqdrXxjIL6hkdgwLDI=
X-Received: by 2002:a37:bc7:: with SMTP id 190mr3695944qkl.286.1590582507016;
 Wed, 27 May 2020 05:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200522120700.838-1-brgl@bgdev.pl> <20200522120700.838-7-brgl@bgdev.pl>
 <20200527073150.GA3384158@ubuntu-s3-xlarge-x86> <CAMRc=MevVsYZFDQif+8Zyv41sSkbS8XqWbKGdCvHooneXz88hg@mail.gmail.com>
 <CAK8P3a3WXGZpeX0E8Kyuo5Rkv5acdkZN6_HNS61Y1=Jh+G+pRQ@mail.gmail.com> <CAMRc=Md1w_6+dU9gCwiiB5R+dMcYMPFLPrA++RBkKp5zaY6Riw@mail.gmail.com>
In-Reply-To: <CAMRc=Md1w_6+dU9gCwiiB5R+dMcYMPFLPrA++RBkKp5zaY6Riw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 27 May 2020 14:28:10 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3L6aGtKqv4ikNJc3or_mX2VvRE1sgaZZ9esD6jx+Hyug@mail.gmail.com>
Message-ID: <CAK8P3a3L6aGtKqv4ikNJc3or_mX2VvRE1sgaZZ9esD6jx+Hyug@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:42xuInEhqB0LXEINV+ATzXFlSMMIjNK510ngCJoHuhHdNsuqk4w
 68JRv4VvYzZWx1vsiWvmeFS+1NeUsk0M37H9qQ5WgGs8IVw2uVu/a5xFALDPbCNQ3zFm+2P
 508dd+urfo1iRHl5MaflH+JN9p90uLD3a8C+zj9c2lLetniKhTImGSr4IDkMFlKnaCpNRgn
 MoXoURCWf2iSPksOB9qmQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xAdFMfLVBtI=:DTxMeHJVSg8YjC8fXbe+DT
 s/o+xcigouZHqnyFyjG0dXlhkLJhSljvBRxoAP2CKpCv7v2VYsLxsRWMubVGv7YM9R9XINm/x
 8OwWsm7+k9eP5KKUkjlkFQCWYYR7sdSiYnAEq27LrYFH2e7goybUfvb6DLuXt6Xa9xEQq7+LT
 aghXQDp7gK4F20sj/yU1wagnazrG2B1n23nJp6jwWL5WTWAmU2JTL7Q0MJn//OL0Z1MIHbMqa
 qPQCpCQXQ6hOTIC7QAleQT8agF21K/s0hmxSd4Cblf/YYQKFA4oDXlRlDPrCSvK5BdcgAYuVL
 XcVKOGQD0gL5IO7iUBciV4qqU6g+yMWKsaDhbfev6Y/Km7aGlGnz4RezjxC8XAbj9vwJYDE74
 SCbfl5UcsTncNSM929NBgl0JS9WNUe0gdhBx6l40zflwRPUeVdM3WnUyLTVwAJ+E90hwQrsRr
 0sGSfKf/cFJJEYkNweUDOsKw2RkooDS11SQwXFS+eDHCzS4LPS2Fkipg7UySi0pvfKKBUbEuO
 Qt/reNs/nYwY0+PXJhJ0y71lKGLvQYFRrs9ZaeaTOyaQWrCqhiYKfPlXrpnqbKuCwtQjYXqWu
 /8SSP+3rFjdn8EUupqi9rVdMQ+GMkJEv9BWKpcZSVGQtV8rKveRiwSpYOJlUXj52Xl1Z6TFiV
 SgWLNjzPVwryybtSrCy4nzmjkR4uqqvcmvEhedUROHoypouBP6rKQCGXzaBFXYyuQVQcoIYuE
 +46SpmkItW5PUP2nM1lj5CezoKiJUq+m4AN579NyOyVhsnl0ZLAEOafo1IrbNwjr7x1t8Xrd6
 RfSQdrBOK2LJRkq7b+AmrJAeitmOCj/ltItIMg6rHg8qeDUcy4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 1:49 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> śr., 27 maj 2020 o 13:33 Arnd Bergmann <arnd@arndb.de> napisał(a):
> >
> > On Wed, May 27, 2020 at 10:46 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> > > Thanks for reporting this! I have a fix ready and will send it shortly.
> >
> > I already have a workaround for this bug as well as another one
> > in my tree that I'll send later today after some more testing.
> >
> > Feel free to wait for that, or just ignore mine if you already have a fix.
> >
>
> I already posted a fix[1]. Sorry for omitting you, but somehow your
> name didn't pop up in get_maintainers.pl.

I'm not a maintainer for this, I just do a lot of build fixes on the side,
as I verify the stuff that I merge myself ;-)

> [1] https://lkml.org/lkml/2020/5/27/378

Ok, perfect, that is indeed the correct fix and mine was wrong. I'll
just send a fix for the other bug (unused-function warning) then.

     Arnd
