Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A6F1AB34E
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 23:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442368AbgDOVWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 17:22:34 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:36329 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438888AbgDOVWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 17:22:30 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N1Oft-1jHQcr3hHv-012qsn; Wed, 15 Apr 2020 23:22:27 +0200
Received: by mail-qt1-f177.google.com with SMTP id f13so14596167qti.5;
        Wed, 15 Apr 2020 14:22:26 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ/kP3WUi2Zz6ULx+o2pAu96VKtRUBR8fUCGcJY7ystCJZsMkRw
        zrxJ/j/RyhHK86Nl0vfliQkJrBXBrW0FVZE0QIg=
X-Google-Smtp-Source: APiQypINvvbbsDvc+K5sPwo+K7MzKlFLIqVVyQJIWMYe8UMUC3pk7MCSaMVSsYr2RgizX7z/824mZq3G5jLNLnmv4G8=
X-Received: by 2002:ac8:6757:: with SMTP id n23mr10344447qtp.304.1586985745338;
 Wed, 15 Apr 2020 14:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <20200408202711.1198966-6-arnd@arndb.de>
 <20200414201739.GJ19819@pendragon.ideasonboard.com> <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
 <20200414205158.GM19819@pendragon.ideasonboard.com> <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
 <CAMuHMdUb=XXucGUbxt26tZ1xu9pdyVUB8RVsfB2SffURVVXwSg@mail.gmail.com>
 <CAK8P3a1uasBFg9dwvPEcokrRhYE2qh6iwOMW1fDTY+LBZMrTjg@mail.gmail.com>
 <CAK8P3a0CoPUTSJp6ddDnmabo59iE73pugGSYayoeB5N57az9_w@mail.gmail.com> <20200415211220.GQ4758@pendragon.ideasonboard.com>
In-Reply-To: <20200415211220.GQ4758@pendragon.ideasonboard.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 15 Apr 2020 23:22:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1rDZO4cuL6VAXgu9sOiedcHqOSL7ELhpvULz+YYRaGbA@mail.gmail.com>
Message-ID: <CAK8P3a1rDZO4cuL6VAXgu9sOiedcHqOSL7ELhpvULz+YYRaGbA@mail.gmail.com>
Subject: Re: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
X-Provags-ID: V03:K1:Hl+rud1vypg7WIK8rDk9bs6uEnKqs/OlTWu3wzR5saWRjBD2o1i
 sL9990cHNVajheAgk5GS3bAYMQUtGpvsvpjtOzaElo36GexxoCKsxoZeKWIVzFmAhQUCtWH
 lUMDSZh8/C5w7dTadNUhv4YFRrIsngQEXk4iG6am1FbeMtT7/JNWXNTCzMQRJ69ZkORLyh9
 ntoyAIuVbcm+InOBYwqFQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qOHnPyy+am0=:uITFvpA/Fajo3jltuWYdlR
 GaZr+ZFb1wAIjLmDNChn3eRBDUUyw3bYQjjMM0a+H6bWI6gobydrADxfR1wMfEZsx56vkqcV9
 v6VqiF/LJdqtVfxs4dullK+MquZ9JjSGa7HNzpoGZ2Ls1VwPZdvTOThRpuJcX2EI4c02LFRTJ
 +T906lbY7T151zn3rUEwnkMZpFpc5HcE3DuClNb82b3yY3bSuaEYoAODAsyuGDiZh6aRxPwwI
 RXeuoSqQITjA/YEthYZVnfc6wOKPOY/tAoUsjNuxjte6QqTJF7UoPtTKnHK/f37T9FPqa+owN
 Xh5u/6sn6A4EN4ZGQ7ODxa+WRaDbqnVjtRiX8vlqtDqIPs7bCYltuFtOB+oAvwMyYGAENMwem
 C//9cwWQvOSuUJEjt7o6noKtcn0fBQsHZ8W7vaqPgS2pToyFSUoC4V9A1cIieKxb6ZOIcP97i
 PxR1Ock7v6EEetygPWimJAPhEUI7qGcpDb9FW9LVpFIE6WcBG8EH89mUJwwUhf7hNA9PVjSWo
 NpU02HU0u+yHyHIRFfgijTEvi1FNZgk1BcHE/vA0ZgNnuvRvWHeMXcBYK1iGEfbYvs322+ApI
 /CqNjVekqJuozSqmFlETgm7YeWa4mMIa4RLVNoDmG0MX0BGVyqZdh5u5X9pT4bqiONlPT4opr
 rjJdgb7QDas1d1Srz9yW49g9w+IlTqwj0MnR2kQgItr740zsUoHvj7g4JII+3cn/Fq0Xb3NT7
 suepIOWTjOcWbOTpnUN6hEhI6COhr8TXYhYKlY34hqdH7ocHCRHCBskSA0yOleXmlEPsEpZ6m
 3j4Iyc/qhvz9nt9djkgQqgZYWejrCE2nvcUix0tZcSnWfFGVwE=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 11:12 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wed, Apr 15, 2020 at 09:07:14PM +0200, Arnd Bergmann wrote:
> > On Wed, Apr 15, 2020 at 5:18 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Wed, Apr 15, 2020 at 4:13 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On Wed, Apr 15, 2020 at 3:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > > On Tue, Apr 14, 2020 at 10:52 PM Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > > > > > Doesn't "imply" mean it gets selected by default but can be manually
> > > > > > disabled ?
> > > > >
> > > > > That may be what it means now (I still don't understand how it's defined
> > > > > as of v5.7-rc1), but traditionally it was more like a 'select if all
> > > > > dependencies are met'.
> > > >
> > > > That's still what it is supposed to mean right now ;-)
> > > > Except that now it should correctly handle the modular case, too.
> > >
> > > Then there is a bug. If I run 'make menuconfig' now on a mainline kernel
> > > and enable CONFIG_DRM_RCAR_DU, I can set
> > > DRM_RCAR_CMM and DRM_RCAR_LVDS to 'y', 'n' or 'm' regardless
> > > of whether CONFIG_DRM_RCAR_DU is 'm' or 'y'. The 'implies'
> > > statement seems to be ignored entirely, except as reverse 'default'
> > > setting.
> >
> > Here is another version that should do what we want and is only
> > half-ugly. I can send that as a proper patch if it passes my testing
> > and nobody hates it too much.
>
> This may be a stupid question, but doesn't this really call for fixing
> Kconfig ? This seems to be such a common pattern that requiring
> constructs similar to the ones below will be a never-ending chase of
> offenders.

Maybe, I suppose the hardest part here would be to come up with
an appropriate name for the keyword ;-)

Any suggestions?

This specific issue is fairly rare though, in most cases the dependencies
are in the right order so a Kconfig symbol 'depends on' a second one
when the corresponding loadable module uses symbols from that second
module. The problem here is that the two are mixed up.

The much more common problem is the one where one needs to
wrong

config FOO
       depends on BAR || !BAR

To ensure the dependency is either met or BAR is disabled, but
not FOO=y with BAR=m. If you have any suggestions for a keyword
for that thing, we can clean up hundreds of such instances.

        Arnd
