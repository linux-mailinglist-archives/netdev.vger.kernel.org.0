Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67EB1A82A5
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439595AbgDNP0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:26:07 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49335 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729755AbgDNP0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:26:01 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MlfCm-1iyQMg4B2Q-00ihuc; Tue, 14 Apr 2020 17:25:57 +0200
Received: by mail-qt1-f177.google.com with SMTP id w24so10404110qts.11;
        Tue, 14 Apr 2020 08:25:56 -0700 (PDT)
X-Gm-Message-State: AGi0PuYEawHzwf0tXCXIhqzyveDf/fKgTJRq7lmc/+qMlr9Ipu+OaO8G
        0dGxzi9Jeq3U1wcV3mVJHRnr9OgzCouXCMt4z3U=
X-Google-Smtp-Source: APiQypL2bnXf86E03hawsz8pxDqc8oMdZRSmBA+dTNzneuRbxAzCaV1aI5lbgXSqxBtoHIjMy0g/toQKbqbs9h0eD6I=
X-Received: by 2002:aed:20e3:: with SMTP id 90mr16307053qtb.142.1586877955579;
 Tue, 14 Apr 2020 08:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
 <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
 <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
 <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
 <20200410171320.GN11886@ziepe.ca> <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
 <20200414132900.GD5100@ziepe.ca> <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca>
In-Reply-To: <20200414152312.GF5100@ziepe.ca>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Apr 2020 17:25:39 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
Message-ID: <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:RfyQ2xDdl1ZlEgiL+Y7PvwDBC33min6ODLsofcFtD6lUaRExO0j
 r8qU4Oxw/EwZ0jcE7ean97MitHxLRZ048iY3UOXaVjNOSKnU0Y7o523T7uNpODg4HluSYzY
 6Q71sv+dp75ckYuN1gISTUMofFGxPDFRqfpBSObbWeOxdeouDF9GnPoZuP9pCavduX6KCfd
 a2goUqaqWN+WvjFVFe0IQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:H4VJsjCrV9Y=:1ww5YkAP8BYP33jjCBtzZe
 gAO+1ID6L/XYyf25eZrQfum6CG9xfTfdFeSUlx1AGSvB4KRT9QBiyMUC0eMaA8HPHGmLn4BHX
 0JYaYQii3d7kq01oXl+YG5NnH5GQ3seNgthXW7lEo6eNP5s6DTWZ1VpYcN0mJCwu9axrNz1bE
 DuZRztf4DXqT5G5cafsLPex64cjAg7FQIY8C+d2mfrqDcy5s5/cRqIYK77fINjGGP/MNvEZWN
 veDFHLYczUC4KgniBlp/EmkfiWkaADKUlj/8gLr4vqjyUMYwNSj/eSEyYtlCjI29ZV3NQJFbk
 tyPFgS3MZARIorz4Qpc7UYtL4MU6UG1QXVsd1jYci9KBR4Kq0AaLFDLQXBUtR2x8OO8k5V9PH
 6qnQJZZFtfHbP7wObk9LM+CvBpI7XqIlc/n/sTawfpMVPgYNxFnYtmPCbE5UV7UBloLW0YE5c
 /SMOKjNLjRSTsmePktSG4S87NiGZxocpW3wE369nqChe01muVtomXN49usjPyhBdKdz1/B9kT
 VRqIdr4uL8mH0dTF/Ol3WiyHoMClteYldixTsV5nCu+EASX9wduTld5BJNlgT/juwXS1AjceG
 WDIVO/74jqtUbyupvdXS28wWsA4fRaHju9l7oanMXY4SP3h+qoC5baYYdoP6dXOWjl4UWfYKn
 lSEoaKVUaLdHqwHdl1BWYq0xm34uPzZrf6eBiHBkJki6KZjLz+7M2+QjRL6+9JoVWm+9BUJsd
 OEY227ILu/yh2AM0ARpOcVUYyDfSITw00i2yYqNkIAZ5fVlg85b7AfIz7QnwUX9bvO4TMyFFH
 rDilYgJhpmyVd2yS3WJb5TVhbuQyM0NdtEn6Aj9rSTtQH47ahA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 5:23 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Apr 14, 2020 at 04:27:41PM +0200, Arnd Bergmann wrote:
> > On Tue, Apr 14, 2020 at 3:29 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > On Fri, Apr 10, 2020 at 07:04:27PM +0000, Saeed Mahameed wrote:
> > which in turn leads to mlx5_core.ko *not* containing mlx5_vxlan.o,
> > and in turn causing that link error against
> > mlx5_vxlan_create/mlx5_vxlan_destroy, unless the IS_ENABLED()
> > is changed to IS_REACHABLE().
>
> What about the reverse if mlx5_core is 'm' and VLXAN is 'y'?
>
>  mlx5_core-m := mlx5_core.o
>  mlx5_core-y += mlx5_vxlan.o
>
> Magically works out?

Yes, Kbuild takes care of that case.

> > > IIRC that isn't what the expression does, if vxlan is 'n' then
> > >   n || !n == true
> >
> > It forces MLX5_CORE to 'm' or 'n' but not 'y' if VXLAN=m,
> > but allows any option if VXLAN=y
>
> And any option if VXLAN=n ?

Correct.

      Arnd
