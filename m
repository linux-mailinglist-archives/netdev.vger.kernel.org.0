Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7201AB16C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441772AbgDOTQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:16:54 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:40171 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440357AbgDOTHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:07:36 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1M9nlN-1jJ0U50zTR-005qez; Wed, 15 Apr 2020 21:07:32 +0200
Received: by mail-qv1-f52.google.com with SMTP id v38so694771qvf.6;
        Wed, 15 Apr 2020 12:07:31 -0700 (PDT)
X-Gm-Message-State: AGi0PuYqovIjqXz2qd1he3wjA1+p9EOIVHRC83vREbjlypu5Eij56d+6
        aukOuawtA0X3gF5w3edRrX0Hr6K5E3UxaRccKh8=
X-Google-Smtp-Source: APiQypJX6+zh0Hk9cZgHIA/HI7dJ0HZA699mCplxjoSE0/kbYbrN5LgCPWe0a2KpM5wIklHmQkE+zGG0ajKUcBeJ1kM=
X-Received: by 2002:a0c:9e2f:: with SMTP id p47mr6000391qve.211.1586977650774;
 Wed, 15 Apr 2020 12:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <20200408202711.1198966-6-arnd@arndb.de>
 <20200414201739.GJ19819@pendragon.ideasonboard.com> <CAK8P3a0hd5bsezrJS3+GV2nRMui4P5yeD2Rk7wQpJsAZeOCOUg@mail.gmail.com>
 <20200414205158.GM19819@pendragon.ideasonboard.com> <CAK8P3a1PZbwdvdH_Gi9UQVUz2+_a8QDxKuWLqPtjhK1stxzMBQ@mail.gmail.com>
 <CAMuHMdUb=XXucGUbxt26tZ1xu9pdyVUB8RVsfB2SffURVVXwSg@mail.gmail.com> <CAK8P3a1uasBFg9dwvPEcokrRhYE2qh6iwOMW1fDTY+LBZMrTjg@mail.gmail.com>
In-Reply-To: <CAK8P3a1uasBFg9dwvPEcokrRhYE2qh6iwOMW1fDTY+LBZMrTjg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 15 Apr 2020 21:07:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0CoPUTSJp6ddDnmabo59iE73pugGSYayoeB5N57az9_w@mail.gmail.com>
Message-ID: <CAK8P3a0CoPUTSJp6ddDnmabo59iE73pugGSYayoeB5N57az9_w@mail.gmail.com>
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
X-Provags-ID: V03:K1:4b8EYsOhlpxPK7pigxEr6ENytFkJTUlOn65DgSqaoGVE4mhFOVD
 QcxKAXWkIC/EjC2fjH2zFctAHyK6mjXQANuW5qhqhnOrB39r8JJVSe68xBi7ZSFf2mjAGxs
 VV9iaKU3flgC991QNdyH9+oukWipUW9v1tTl5jlCwT9gVLYyC/THngPjyw40G8b8DKccp41
 EebvW/ikBPYtAFWcBr6DQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:s1iU6JwyX0k=:qF3wmkBt4XF94HD66/LOjx
 QQaUujg7RD8vwUT7IA4urdkYEgskCcbP4QA7rFWrrMbi8eKCfOezI/5sFlLCN5MXk10ru0rll
 GkGCENRfsLJbRHh/e4Wr2JzDuotT4oNh0K4KaiNl7aEi4rLRnSoET5mH20dC1zL0vpjtMNBfh
 /Q4ks7R/2rW+lgPXQnE2xO8L6uEqEiU+Xs1QqmhSBQTLsm0WGie40UfcmfYUII8FiWRsVR0xq
 kFA905uOMsrS6oJtJINFvcdEq6flmEFPaMMgG2xY7FT/CwxdYzCuU23LKWdw1SDwCg1KW4/sR
 SGSirwbzqoHKqhvoJ82BpZYql/nQ2kIqzF/0L1e6ghinNBQA0z5Rbq5m1sAUim6bODATFlAO2
 a0ol9rIZ6lihW9det7W0z5ZptW42n1EZlcNgvMyFnMGHtrzAv5iyLtltrQyYbFITEZpoPAm0Z
 Zk7v4JwxtEZB+Os2TJztAcEpPpQig7/6m45cqhvTRNodywOKzAqkew5B6MsTQXnaApA06i0Ov
 A8A6o2AypYt2VK0Nm/PZSeIrtX9y2yN0TEn5+BVk4+VKW2Qfro6gvtWWzo1jVjSltcF48WM55
 Tn/X8udAui6asxFoxR6D1WOADi7hCI0rCZK1Cd7N8J+9KLFSoT8u0kbIJT8p79CYpAsZCWnn4
 2a+3NlqlITmkuSoIG+6kmlf61ktRhkr7S8Rca0bKhovGraT4PmQI9oKzSb3IJ+Z5UBNX7bCF2
 VEwbPF6SvmUq3yOeYOu/WvuBUYTIqU7xL2JRi/aEytq3iOyBTA9m0pZt42g4tFKwMp148zBj0
 +I7nj2DBc+euzSDrJvK0rBWrq6cA96QuD7Iv98+JEVNqHeJqnU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 5:18 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Apr 15, 2020 at 4:13 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, Apr 15, 2020 at 3:47 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Tue, Apr 14, 2020 at 10:52 PM Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > > > Doesn't "imply" mean it gets selected by default but can be manually
> > > > disabled ?
> > >
> > > That may be what it means now (I still don't understand how it's defined
> > > as of v5.7-rc1), but traditionally it was more like a 'select if all
> > > dependencies are met'.
> >
> > That's still what it is supposed to mean right now ;-)
> > Except that now it should correctly handle the modular case, too.
>
> Then there is a bug. If I run 'make menuconfig' now on a mainline kernel
> and enable CONFIG_DRM_RCAR_DU, I can set
> DRM_RCAR_CMM and DRM_RCAR_LVDS to 'y', 'n' or 'm' regardless
> of whether CONFIG_DRM_RCAR_DU is 'm' or 'y'. The 'implies'
> statement seems to be ignored entirely, except as reverse 'default'
> setting.

Here is another version that should do what we want and is only
half-ugly. I can send that as a proper patch if it passes my testing
and nobody hates it too much.

       Arnd

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index 0919f1f159a4..d2fcec807dfa 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -4,8 +4,6 @@ config DRM_RCAR_DU
        depends on DRM && OF
        depends on ARM || ARM64
        depends on ARCH_RENESAS || COMPILE_TEST
-       imply DRM_RCAR_CMM
-       imply DRM_RCAR_LVDS
        select DRM_KMS_HELPER
        select DRM_KMS_CMA_HELPER
        select DRM_GEM_CMA_HELPER
@@ -14,13 +12,17 @@ config DRM_RCAR_DU
          Choose this option if you have an R-Car chipset.
          If M is selected the module will be called rcar-du-drm.

-config DRM_RCAR_CMM
-       tristate "R-Car DU Color Management Module (CMM) Support"
-       depends on DRM && OF
+config DRM_RCAR_USE_CMM
+       bool "R-Car DU Color Management Module (CMM) Support"
        depends on DRM_RCAR_DU
+       default DRM_RCAR_DU
        help
          Enable support for R-Car Color Management Module (CMM).

+config DRM_RCAR_CMM
+       def_tristate DRM_RCAR_DU
+       depends on DRM_RCAR_USE_CMM
+
 config DRM_RCAR_DW_HDMI
        tristate "R-Car DU Gen3 HDMI Encoder Support"
        depends on DRM && OF
@@ -28,15 +30,20 @@ config DRM_RCAR_DW_HDMI
        help
          Enable support for R-Car Gen3 internal HDMI encoder.

-config DRM_RCAR_LVDS
-       tristate "R-Car DU LVDS Encoder Support"
-       depends on DRM && DRM_BRIDGE && OF
+config DRM_RCAR_USE_LVDS
+       bool "R-Car DU LVDS Encoder Support"
+       depends on DRM_BRIDGE && OF
+       default DRM_RCAR_DU
        select DRM_PANEL
        select OF_FLATTREE
        select OF_OVERLAY
        help
          Enable support for the R-Car Display Unit embedded LVDS encoders.

+config DRM_RCAR_LVDS
+       def_tristate DRM_RCAR_DU
+       depends on DRM_RCAR_USE_LVDS
+
 config DRM_RCAR_VSP
        bool "R-Car DU VSP Compositor Support" if ARM
        default y if ARM64
