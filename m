Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E82F1A8A18
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504347AbgDNSrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:47:47 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:43699 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504185AbgDNSrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:47:43 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M597q-1jNK8G2wTc-0019oG; Tue, 14 Apr 2020 20:47:40 +0200
Received: by mail-qt1-f172.google.com with SMTP id w24so11090673qts.11;
        Tue, 14 Apr 2020 11:47:40 -0700 (PDT)
X-Gm-Message-State: AGi0PuaUj0jgMT/pF/Q4T4nB7p2Dvn1GmqpF6LCPz2+76M2w4s/3gzUO
        jX4r+af9LMGBjZaeoAaGHZYqstvl+pWKP6ZPSNU=
X-Google-Smtp-Source: APiQypJkm7YK7DFcAXzV9bKRiTg4ndg9+lnP/bhAkYKcaZ1Yw17IqxDBvH++61J2ztireirhfyoBdFwDtwNvTt2Nro4=
X-Received: by 2002:ac8:d8e:: with SMTP id s14mr17254416qti.204.1586890059307;
 Tue, 14 Apr 2020 11:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
 <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
 <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
 <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
 <20200410171320.GN11886@ziepe.ca> <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
 <20200414132900.GD5100@ziepe.ca> <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca> <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
 <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
In-Reply-To: <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Apr 2020 20:47:22 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
Message-ID: <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
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
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:lz+utpL2BuBOA5D9VOLFoYKJVgXLXYJqK4q5UjrxvDCIrqFf0MS
 3lwqvFNt+ZdhOi6W1+JUOaxRPxnZyz1gFrX8vajN9UA+jAAyTIvKc7WENid2RX/wLJgzjci
 3GOKK0p8/A14FVytNaUGvXPhjxfVlXgYktvK24OOKskHvQiRErMXEilQriSDhYn+fVRhYax
 geT4oFaicC+O6wM54V3xA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BomH8QEDJV4=:ntIuB13EiCR7pWtapSJVge
 J4cB8Aba+rh8/NTD9cEQ5TyuZ84tIDqwWeQCR2YbElbe3TJ36hfx3NBjVDqk5hVrQaaau2UFy
 rV+Z2om/vZpkzaN1YxtH673J0giu8Iu9nVf2BkyqDneRJbm/wyC/modqYfdhHx8UeVZ/had/L
 7XvJ+mGC8pIQH1BRv4urhEgq5L42xPihQ1VfTRMwMNPSxq4ZxZLW2gIIWrxoi9d13XGlEtNFC
 gPba6yESbPZMx7GPuJpDKeKdZeafCnVcNquETNmahkLgBk0Lp3n2YDXhfe6tLzCmgZaFj+Q8v
 vl/Px13mgqBM0sY7qjsRP2SSMBPTHXQnZKR87cheG2H4K7ax+JznLa8fodDmjkcu/jCbbs1Vi
 oVjZad18pJp5Gm1DhfUwpzKJo380efPkKxqaoEB+vV+Cnzvlk+GSu+Lxs1dk+F2wSdC+6uUZ6
 38LyRG2EWJrA+r76L7nVDZrx+YfizZA1LHCgpE1Dfwvj0FdG21nPAzLc+QvaBQM2+G/S+i2mW
 /oR87M6mYgqMJ0ROMQqJp14Cbeo/D8+IpPvF7enJtrNEBOjUCkH7NmaMTvKpTM7WhQrMyjeAF
 m/ltdC70nBsrpz9Wl12UQTV1+nIxVdAXTBeUOBvdiYjWnOU30EwwyF+8RlNKhe4aU0Ibrqu1m
 t0h35AJEarmVsB2e4RIW8japZOHOzURvlmJETW9SqMrvhMj+fZ22/ITLL96vgWIzF9zCrmMOQ
 8yltUSqjVk6KqbMDCoGWMk+87nGvG8O5AmySaraRl5nyi7LUIY0VjpTb47Nax+Y1OLi5AMB3S
 +9wwz0VSlwjQUobM/9/GFsXGCFOaYX2Snjyw5Fhvx65KWWi1M0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 7:49 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> On Tue, 2020-04-14 at 17:25 +0200, Arnd Bergmann wrote:
> > On Tue, Apr 14, 2020 at 5:23 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > Correct.
> >
>
> Great !
>
> Then bottom line we will change mlx5/Kconfig: to
>
> depends on VXLAN || !VXLAN

Ok

> This will force MLX5_CORE to m when necessary to make vxlan reachable
> to mlx5_core.  So no need for explicit use of IS_REACHABLE().
> in mlx5 there are 4 of these:
>
>         imply PTP_1588_CLOCK
>         imply VXLAN
>         imply MLXFW
>         imply PCI_HYPERV_INTERFACE

As mentioned earlier, we do need to replace the 'imply PTP_1588_CLOCK'
with the same

         depends on PTP_1588_CLOCK || !PTP_1588_CLOCK

So far I have not seen problems for the other two options, so I assume they
are fine for now -- it seems to build just fine without PCI_HYPERV_INTERFACE,
and MLXFW has no other dependencies, meaning that 'imply' is the
same as 'select' here. Using 'select MLXFW' would make it clearer perhaps.

      Arnd
