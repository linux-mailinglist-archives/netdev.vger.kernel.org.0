Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DBB1AABAD
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 17:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414664AbgDOPSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 11:18:44 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56625 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1414655AbgDOPSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 11:18:41 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mi23L-1il1DD0uZt-00e37A; Wed, 15 Apr 2020 17:18:38 +0200
Received: by mail-qk1-f181.google.com with SMTP id c63so17606965qke.2;
        Wed, 15 Apr 2020 08:18:37 -0700 (PDT)
X-Gm-Message-State: AGi0PuYQ7iQhk/BikuN6BKO+BL3lPwjdOlvL37MtOvCFqqOG4wui5OGn
        0cIjB+fYfemUFnWfZ5APRYOtoJstcXL1jjQMy9o=
X-Google-Smtp-Source: APiQypKR0HaZQKe1NU2qEEDNoosGf+Eiif2YA3+bZv4o1jlLLMUkDmtAFRquqje/5krjrQpj3uXRFFr+JLm/a3RbNKI=
X-Received: by 2002:a37:ba47:: with SMTP id k68mr15682834qkf.394.1586963916750;
 Wed, 15 Apr 2020 08:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <20200408202711.1198966-6-arnd@arndb.de>
 <20200414201739.GJ19819@pendragon.ideasonboard.com> <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
 <20200414205158.GM19819@pendragon.ideasonboard.com> <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
 <CAMuHMdUb=XXucGUbxt26tZ1xu9pdyVUB8RVsfB2SffURVVXwSg@mail.gmail.com>
In-Reply-To: <CAMuHMdUb=XXucGUbxt26tZ1xu9pdyVUB8RVsfB2SffURVVXwSg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 15 Apr 2020 17:18:20 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1uasBFg9dwvPEcokrRhYE2qh6iwOMW1fDTY+LBZMrTjg@mail.gmail.com>
Message-ID: <CAK8P3a1uasBFg9dwvPEcokrRhYE2qh6iwOMW1fDTY+LBZMrTjg@mail.gmail.com>
Subject: Re: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:LcT7bwGznqc8gtfgF2bfiglIsjD0HReWu/nHchEwDxrf+9vm5BH
 rmdjTk0uOUNkmKoP4TP/efPp6Sd4lGmapqbt1l63xHODdE9k8x8ilzOIS4zVIE7rJAwPgP9
 nv14ZKTD64pSJNEWvMGnfnTFEl7qLpGkCgk1VSBIzOAG5FvyjqcFClevQUtWagaxdqe70Vi
 puR68X7pu8N6lETJMiAIw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rJ5/p8u5JGQ=:gVqEX27W8WlhhlVVuppYhw
 JyqF3pScGR9U4BjvZeVFBDID+rUE2rQ0KuPuwkLy+zaw8dkwKT5TBF2enfoMg5vPY7VwZWvP9
 vfupHu/mPvuaiLi1AKTCDKPzUSIdaiApiIOh3cEMybo46gLRfZmBqZ/J/hZSqRsIS+vLmPuwg
 sMXQ7c2s00DUvGHbdT3j7a7Rgn0/+wtM0hti3hxDOh+gKrjqemtVQKhCFesKpkAKm1YdytiX0
 0hhKtlq0AQmQdMh1tQ7lU1agyr75LwPnoXOO9VBvFEe3k1xMXZDde8z9s7EQSyBan6D4m2tVf
 6L1x0HOk2oRxloiZEceJ4uwAnbk2RyNEa52eKzpKWAIjAElLRCIM+vt8eQx7KsVVGoT+v/LfR
 ed2ShkBR9f75Jdr81/tnXf9pVh6q8aG3m+0qvRHX4Bl0vVLFJO08jbmWUqOkNLEF7zMTXcajM
 upeHDmBLR0mWFlBJ3j6dNwuzla/nOE5IC0pjp9HzM7062i2ioS8SK6Ymzs/QcOrJ9mq8aAH+h
 AHk8r/ZfXxAZpMf8LASeNLo+0cluDkYIgGv2USXQEYAF8Dd1/ke3ZE+YhDbXlm2r5HDaDJHzx
 pfnDCCgLnHJFCfiuJeoydljGjjVg6Ke3S9NWPk74dJgsTLy4SfNVJ6GHEwKVtmu6fcmV/+KGv
 YiEUm4b0yF9GbqOytoeONWGo/bbkaH4BkXZjHbHSGjbKv6YLJKWFoghy7b/Hwd6TZNdOUH8nh
 L9XmRJrRDca56ZO3dVfd8ZYxPOMI0iCDISUZ4RCvho8beBrx9uaeU/i+QvlIcN3QhP25d1+Aj
 YWRg42iGcwguhIE/rxMHGkxFeTHXMtCrANnjYw5JzNGBBef0rg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 4:13 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Apr 15, 2020 at 3:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tue, Apr 14, 2020 at 10:52 PM Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > > Doesn't "imply" mean it gets selected by default but can be manually
> > > disabled ?
> >
> > That may be what it means now (I still don't understand how it's defined
> > as of v5.7-rc1), but traditionally it was more like a 'select if all
> > dependencies are met'.
>
> That's still what it is supposed to mean right now ;-)
> Except that now it should correctly handle the modular case, too.

Then there is a bug. If I run 'make menuconfig' now on a mainline kernel
and enable CONFIG_DRM_RCAR_DU, I can set
DRM_RCAR_CMM and DRM_RCAR_LVDS to 'y', 'n' or 'm' regardless
of whether CONFIG_DRM_RCAR_DU is 'm' or 'y'. The 'implies'
statement seems to be ignored entirely, except as reverse 'default'
setting.

> >
> > In that case, a Makefile trick could also work, doing
> >
> > ifdef CONFIG_DRM_RCAR_CMM
> > obj-$(CONFIG_DRM_RCAR_DU) += rcar-cmm.o
> > endif
> >
> > Thereby making the cmm module have the same state (y or m) as
> > the du module whenever the option is enabled.
>
> What about dropping the "imply DRM_RCAR_CMM", but defaulting to
> enable CMM if DU is enabled?
>
>     config DRM_RCAR_CMM
>             tristate "R-Car DU Color Management Module (CMM) Support"
>             depends on DRM_RCAR_DU && OF
>             default DRM_RCAR_DU

That doesn't work because it allows DRM_RCAR_DU=y with
DRM_RCAR_CMM=m, which causes a link failure.

         Arnd
