Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EC31AB9B2
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 09:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439028AbgDPHVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 03:21:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58479 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438244AbgDPHVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 03:21:02 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M8hEd-1jKs5j3Y6j-004k5c; Thu, 16 Apr 2020 09:20:59 +0200
Received: by mail-qt1-f177.google.com with SMTP id 71so15585125qtc.12;
        Thu, 16 Apr 2020 00:20:58 -0700 (PDT)
X-Gm-Message-State: AGi0PuaMlE+7b4MtIkQ7NJeo34K0IZa8nyA8CIjvWWPMxhHiar5nIxSh
        atSlhxjwEf1gKoxy36ck3qzr678uz11jWD+S9eI=
X-Google-Smtp-Source: APiQypLki807vlF5rf3bUb/lMDePEthLpUaUBhHRg0/ZUfeGPkLYlO08Klb1Ee851xvIZfXGDxWFM30tec+bUhtYF5c=
X-Received: by 2002:ac8:6757:: with SMTP id n23mr12043843qtp.304.1587021657410;
 Thu, 16 Apr 2020 00:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
 <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
 <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
 <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
 <20200410171320.GN11886@ziepe.ca> <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
 <20200414132900.GD5100@ziepe.ca> <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca> <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
 <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
 <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com> <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
In-Reply-To: <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 16 Apr 2020 09:20:40 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
Message-ID: <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:+TnTyNKhJDK+dsEpJffyVZIWG0bgsP3O9RWs5SO393nW1uj6vTQ
 6B4ki3fDo1SOTlDXHpTGVfXO7w3tJK4bwvvqhIbv2OQWsPx+mHItzowt6qn4RducloqM6OK
 06S7us5VAjq3qF+ileNWh3OigE9u5MoZjFrGUM5iC5/WT3TyZG0j9T5NmFlcnZLnb2zAS1o
 yVUT+t3yU1oTYmYWmSp3g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7+2vD6+DWY8=:miIyPTnwA9PaTsUep21Rns
 rOP5j2xIr13UIymyAxvzck+Eh1myIl0NLhPsk4d3qEXR4u8ADclGOlTF5/OSfK+W49ef+wT7F
 OS+DJKSZ3FiFaR/eerOPEhLAvtCulxZurxT3IFX0LtlRDW3qDqm/WXN0tame1gRG26vNLluqN
 dt0oiyRbYHeyleFJ3RTbbt9i8WfVZOLBZ4zURWJPYtNJogvHTL1m7StoLm7OQZfZrTz7OvNPc
 kRZMDEhiF7yPfAKC5dOrf32FiqHmca7NEE9W1W2v7ujKRgL0laRT0XcNsHrZDnzynlpJB2myd
 gAbN58YOVt0xViEOQmwKQRgB+ZSiHnKukhA1ouESJhLupY8b0C1HzeJanv/0TsYFkYz5qKDjK
 9wQUcc1V3QWKvdiPL7GRjHCIVYy0ENWLdtfedeCrscEqm8b9yMsE6uB1TSSoMatM8ro8gbQOa
 R3wkYlGN4UKXFiyKv99GhoZcc3xjrq1i43OjLxQnQsoLLsQxdpxbM+X+URmwDt8aGLrLemImO
 epKs6/MoIeqER2kkTGnT/JfJIKFCSUpl4bTtxnHFAsvCrIPteddlO+aoB1JGixp1TVUDdRLe7
 0jYQaveS4iKTiV9+gMPZimUdmR7UeieM/47BJ5NYNPNjpwxsLeHXVGyhyadOIdrlntb/r5J4f
 Hd8LkDBDCsp7wBOvEMWZVrFjjREf4tla96TpgxBhbAH6qB3Y4czDovBX1zPhPysbeZl1fxvKT
 bKhqBpOePQQgFYgLyVeJX1+zsTlY98RFeOTNijiS4EYZVaoULO9KQgZ8OAmbTf7btNLiL7dFV
 S22dm0CGnES9R7UnISu1OcdlXYaIoGe/uDGsH74DjNGYNCioXg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 5:25 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Tue, 2020-04-14 at 20:47 +0200, Arnd Bergmann wrote:
> > On Tue, Apr 14, 2020 at 7:49 PM Saeed Mahameed <saeedm@mellanox.com>
> > wrote:
> > > On Tue, 2020-04-14 at 17:25 +0200, Arnd Bergmann wrote:
> > > > On Tue, Apr 14, 2020 at 5:23 PM Jason Gunthorpe <jgg@ziepe.ca>
> > > > wrote:
> > > > Correct.
> > > >
> > >
> > > Great !
> > >
> > > Then bottom line we will change mlx5/Kconfig: to
> > >
> > > depends on VXLAN || !VXLAN
> >
> > Ok
> >
>
> BTW how about adding a new Kconfig option to hide the details of
> ( BAR || !BAR) ? as Jason already explained and suggested, this will
> make it easier for the users and developers to understand the actual
> meaning behind this tristate weird condition.
>
> e.g have a new keyword:
>      reach VXLAN
> which will be equivalent to:
>      depends on VXLAN && !VXLAN

I'd love to see that, but I'm not sure what keyword is best. For your
suggestion of "reach", that would probably do the job, but I'm not
sure if this ends up being more or less confusing than what we have
today.

> > > This will force MLX5_CORE to m when necessary to make vxlan
> > > reachable
> > > to mlx5_core.  So no need for explicit use of IS_REACHABLE().
> > > in mlx5 there are 4 of these:
> > >
> > >         imply PTP_1588_CLOCK
> > >         imply VXLAN
> > >         imply MLXFW
> > >         imply PCI_HYPERV_INTERFACE
> >
> > As mentioned earlier, we do need to replace the 'imply
> > PTP_1588_CLOCK'
> > with the same
> >
> >          depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
> >
> > So far I have not seen problems for the other two options, so I
> > assume they
> > are fine for now -- it seems to build just fine without
> > PCI_HYPERV_INTERFACE,
> > and MLXFW has no other dependencies, meaning that 'imply' is the
> > same as 'select' here. Using 'select MLXFW' would make it clearer
> > perhaps.
>
> No, I would like to avoid select and allow building mlx5 without MLXFW,
> MLXFW already has a stub protected with IS_REACHABLE(), this is why we
> don't have an issue with it.

So the 'imply MLXFW' should be dropped then?

        Arnd
