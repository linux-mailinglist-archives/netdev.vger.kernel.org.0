Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAC6133566
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 23:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgAGWCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 17:02:10 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:45299 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgAGWCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 17:02:09 -0500
Received: from mail-qk1-f174.google.com ([209.85.222.174]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mnq0I-1jV62E0WDK-00pJRv; Tue, 07 Jan 2020 23:02:08 +0100
Received: by mail-qk1-f174.google.com with SMTP id c17so870958qkg.7;
        Tue, 07 Jan 2020 14:02:07 -0800 (PST)
X-Gm-Message-State: APjAAAVmyp6DYZFpIooyRX9xZdKLs52EKWz3pfwPDoteYdmaGUU3lebv
        ScR+3OB84OyVfxU4b2CdI5fATdk7QjwnFVXLwS8=
X-Google-Smtp-Source: APXvYqxUa5xLov61G7xm+YWKKvTkhYFC6JphHNq61xoPNx93avyQNM5C0YyDy1+zQvWClcWhfIrpGJ17Carlg/CFYCg=
X-Received: by 2002:a05:620a:a5b:: with SMTP id j27mr1513012qka.286.1578434526938;
 Tue, 07 Jan 2020 14:02:06 -0800 (PST)
MIME-Version: 1.0
References: <20200107200659.3538375-1-arnd@arndb.de> <20200107124417.5239a6cf@cakuba.netronome.com>
In-Reply-To: <20200107124417.5239a6cf@cakuba.netronome.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 7 Jan 2020 23:01:50 +0100
X-Gmail-Original-Message-ID: <CAK8P3a27tFJpMeEuJDQWCHvGyETjM+XbPKenQwroxjc8Qpw=TQ@mail.gmail.com>
Message-ID: <CAK8P3a27tFJpMeEuJDQWCHvGyETjM+XbPKenQwroxjc8Qpw=TQ@mail.gmail.com>
Subject: Re: [PATCH] netronome: fix ipv6 link error
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        oss-drivers@netronome.com, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:rzlzUU8mzkmleUvVMkVLWK0UMnNe01XsywHdmS48EjSFO8XTmXF
 f2u8Nv4DBDqci4s9VP9LxPmPZmMnFqwb1V2ebGOrvJv3L8jO/XXs7vf5AhdbLJn3vFJOui2
 hE9XALeDuvTGn2v3N7Kc5O64dUuTLsjnkhaKxfM6z9sIzeqMH5hh69MgBaTla+nqiQ/bPCD
 DV5hPs64dkcMoBO8kZIZQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mIzPHufBjyk=:kN0xZSMR54Jg0jHTlHowia
 NqrF6MUpCluK4yjnsWfPLfy/+WLOFzAsbGA52X4aCDWzOaOQWxcB0JGi2OrbyXhVGroRR/79E
 /Mnzw3dcox/WElhgPWwOsl6Xfl78lYQ+SbLdb5YOCZ0W+4eZZMf29QT/zXl9EhpQQLsrljLX3
 DsP/9wk6wnewDYjoarYzJzOQ8DXKorYrUotcBAlWXmnqDhGWwSfR+QV3aAh/ag6PqEkt3GEG5
 AT1DcujCVZt+UeC2FKgdQnbv4hmlzumoIxhpc/AhROKf8M7nMV3cDwQfvy8vTyTA+9D7i6izt
 6dvEsQfdclPtZaB1ausqkmyw94iUSoj7rXQI6rbdTGsbkZSgTeLlDVCWjvKCbtIFRkPMSRaSD
 IUAM++sLQa1sMK7U1QPaYizxc9rwj7rC+8edhl7Rl/Ony7v/5h2dAyxWQEeJF4lpnGL2o3Ku5
 UPsrJdKLldcQFlxyvRkJgzKIeRMn3MIEA7OKB4qAP05JsrbIkoURNi/Py2K345/fe1ux/rJXk
 7PHCRHXaXDKJ9JljEAWxibhGBUULWfxpTq/UAe7qUQb/lAzv5N9KSEZIgAgXS+hHtEy6pNIKo
 AZg3RdLMhMOn2ryocjAc2+I57O0gx/qCunbGGygCfjvtgdqBLDJ9vDJNYU/p836IZDjkWQLas
 qUAEUiVhheraSebD3BfcTIHnbw27/dDmHYmSfZPxNb4qmjJelnl5aRMILbuqgmxePpa3JY0X1
 dgo/p/Z+AydsAOGJN+4HA1jayZ3LsWE0y1bLpi8AVjY2snCdeO7LxNlTy49J16N6qsRxUDOGA
 71gFXIQrJ6u58UA0uMuTVPfM6+LjDsWs5h6/HPKZro61Zu/h/qgJtabwbwbdgeUzk2RAKjOO1
 OLVZka63q2Ffcb24jbWQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 9:44 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue,  7 Jan 2020 21:06:40 +0100, Arnd Bergmann wrote:
> > When the driver is built-in but ipv6 is a module, the flower
> > support produces a link error:
> >
> > drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.o: In function `nfp_tunnel_keep_alive_v6':
> > tunnel_conf.c:(.text+0x2aa8): undefined reference to `nd_tbl'
>
> Damn, I guess the v2 of that patch set did not solve _all_ v6 linking
> issues :/ Thanks for the patch.
>
> > Add a Kconfig dependency to avoid that configuration.
> >
> > Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/net/ethernet/netronome/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
> > index bac5be4d4f43..dcb02ce28460 100644
> > --- a/drivers/net/ethernet/netronome/Kconfig
> > +++ b/drivers/net/ethernet/netronome/Kconfig
> > @@ -31,6 +31,7 @@ config NFP_APP_FLOWER
> >       bool "NFP4000/NFP6000 TC Flower offload support"
> >       depends on NFP
> >       depends on NET_SWITCHDEV
> > +     depends on IPV6 != m || NFP =m
>
> Could we perhaps do the more standard:
>
>         depends on IPV6 || IPV6=n

That would have to be on CONFIG_NFP instead of CONFIG_NFP_APP_FLOWER
then, making the entire driver a module if IPV6=m but always allowing
CONFIG_NFP_APP_FLOWER.

> The whitespace around = and != seems a little random as is..

Yep, my mistake. I can send a fixed version, please let me know which
version you want, or fix it up yourself if you find that easier.

     Arnd
