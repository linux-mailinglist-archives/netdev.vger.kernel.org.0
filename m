Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6ED1A7FBC
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390767AbgDNO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:28:06 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:36921 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbgDNO2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 10:28:01 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MD9nd-1jWvFP2Anh-009C6B; Tue, 14 Apr 2020 16:27:58 +0200
Received: by mail-lj1-f177.google.com with SMTP id q22so25016ljg.0;
        Tue, 14 Apr 2020 07:27:58 -0700 (PDT)
X-Gm-Message-State: AGi0PuaRQXbMmCTgmEEnEb/R9FUHvsfmglePzaD0ekKdenILs7G4cm3a
        DHZm8iz7FHO2+uen8UH3MPC1E9b0I7sebtqyhSo=
X-Google-Smtp-Source: APiQypIehfRw4bnzZDiYQ9rbmdjkvSpz2iHh0P7VLnhHPaYn8R1IT4hVMubviwCCAbF8Hb+k1UqXmIWLLXlwy3kW8AM=
X-Received: by 2002:a2e:b446:: with SMTP id o6mr305063ljm.80.1586874477781;
 Tue, 14 Apr 2020 07:27:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200408202711.1198966-1-arnd@arndb.de> <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
 <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
 <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
 <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
 <20200410171320.GN11886@ziepe.ca> <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
 <20200414132900.GD5100@ziepe.ca>
In-Reply-To: <20200414132900.GD5100@ziepe.ca>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Apr 2020 16:27:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
Message-ID: <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
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
X-Provags-ID: V03:K1:UprGL/M9NyjdOlqLrDoplNxPEwHDZvVhDmyY7ZnnsVwKVvzBIuU
 872FrhcPWiFVDXV1uXzAPPLKxXmpV7w/Qie1lMaYqxlaS2t/GOzpFdTsFaYEUlVWJrQRNIB
 hQ5UIav82JCFvQA41tpt568Xn01dmTrwxVcbhRWNPuIOgOO7ck0DXIlvzBv3RjFBg8dKPEA
 x+oIM19zXsRwa0dt9gybg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dy4oC+QyOyk=:panXrZzItC+VIEfVeOEAGf
 gyNkrwHX1ighk2WHgomIh2o2rVWvWqTGzrTw4Q9Z187SDWEdTvnK7V7a79u7m8/qg+N1r3VyM
 GNM/oHmNbGI72Ufc4xIBf5uhBgVe3ELLrOihKXe+9QxmS5y20peflkz2Qh13+Nn8ZJ+W00sm5
 Zp+IdHK5OqnxO9jBz7R2L7yCrgVkxR9vM2N4gOKEUJEsebABxQj1tSqHXp1EqJWhlht+Os1Hq
 NIWuYzz3jzSV1IGvb/d1dP5yWKMbdSkr6jYX9BYCOVzZXfPmhhgC1YJcJdWYx/mgUu9ZNXpST
 UIi9N5x5pGl/WLzMdg9QLfQwFJEtKIepYf0SjoMNdXaLSyb8Wo8Pup/8jmBbZlT5kjUPP07Ao
 5KCQNBoNwI6vjtxduR2bcTEU9BH6tvViJ7avWKvyudklU1JtwgrhVviwu1sllM1MJkXXblp5Q
 FVApCP4AZp7MM94Npsw51iDei4kH+2hVfLx0B/p9ns4uF7fe8vUl2lcl93OZLueVsQ2pcQDd5
 UbWBRzkVezXrPWdvkUpPvjZLV0NEFJTtYuwT9L+sPz/i+cBtrYA1aXWjjt6M3ad/ZkYQ0Zbb3
 YFjQUvPbyZ3oqo3LVt9pwa1svhHlLCyANvGbx7bxV5HTXMM3id0c8ZpiDvt2xtIRoI+9uxn0O
 uhhDiigGAUhJQqBDLEj1LdZ85tYuVK3cMOi5IrgvYNieXEz6JAyOrazQHC+qXg9piY6T9liVu
 Q+hXSfP4XXOR1t88QeldnmT3UgR5JNBKg5C0j69ZgnNHKUqyg6fDO3t720QL/HttSjZm0dJ6j
 HngZOppaFsBD9cIu/XQ2OCgAuJcrc7656xEDYj+ECZ53hDVowQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 3:29 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Fri, Apr 10, 2020 at 07:04:27PM +0000, Saeed Mahameed wrote:
> > On Fri, 2020-04-10 at 14:13 -0300, Jason Gunthorpe wrote:
> > > On Fri, Apr 10, 2020 at 02:40:42AM +0000, Saeed Mahameed wrote:
> > >
> > > > This assumes that the module using FOO has its own flag
> > > > representing
> > > > FOO which is not always the case.
> > > >
> > > > for example in mlx5 we use VXLAN config flag directly to compile
> > > > VXLAN related files:
> > > >
> > > > mlx5/core/Makefile:
> > > >
> > > > obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
> > > >
> > > > mlx5_core-y := mlx5_core.o
> > > > mlx5_core-$(VXLAN) += mlx5_vxlan.o
> > > >
> > > > and in mlx5_main.o we do:
> > >
> > > Does this work if VXLAN = m ?
> >
> > Yes, if VXLAN IS_REACHABLE to MLX5, mlx5_vxlan.o will be
> > compiled/linked.
>
> So mlx5_core-m does the right thing somehow?

What happens with CONFIG_VXLAN=m is that the above turns into

mlx5_core-y := mlx5_core.o
mlx5_core-m += mlx5_vxlan.o

which in turn leads to mlx5_core.ko *not* containing mlx5_vxlan.o,
and in turn causing that link error against
mlx5_vxlan_create/mlx5_vxlan_destroy, unless the IS_ENABLED()
is changed to IS_REACHABLE().

> > > > if (IS_ENABLED(VXLAN))
> > > >        mlx5_vxlan_init()
> > > >
> > > > after the change in imply semantics:
> > > > our options are:
> > > >
> > > > 1) use IS_REACHABLE(VXLAN) instead of IS_ENABLED(VXLAN)
> > > >
> > > > 2) have MLX5_VXLAN in mlx5 Kconfig and use IS_ENABLED(MLX5_VXLAN)
> > > > config MLX5_VXLAN
> > > >   depends on VXLAN || !VXLAN
> > > >   bool
> > >
> > > Does this trick work when vxlan is a bool not a tristate?
> > >
> > > Why not just put the VXLAN || !VXLAN directly on MLX5_CORE?
> > >
> >
> > so force MLX5_CORE to n if vxlan is not reachable ?
>
> IIRC that isn't what the expression does, if vxlan is 'n' then
>   n || !n == true

It forces MLX5_CORE to 'm' or 'n' but not 'y' if VXLAN=m,
but allows any option if VXLAN=y

> The other version of this is (m || VXLAN != m)

Right, that should be the same, but is less common.

I later found that I also needed this one for the same
kind of dependency on PTP:

--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -7,7 +7,7 @@ config MLX5_CORE
        tristate "Mellanox 5th generation network adapters (ConnectX
series) core driver"
        depends on PCI
        select NET_DEVLINK
-       imply PTP_1588_CLOCK
+       depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
        depends on VXLAN || !VXLAN
        imply MLXFW
        imply PCI_HYPERV_INTERFACE
