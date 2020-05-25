Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421391E13C3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389635AbgEYSES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgEYSES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:04:18 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09AAC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:04:17 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u23so6268370iot.12
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eEynP70sIFAOJv8jBHsPKDv3h+TNVyHKkygdyoGfsNw=;
        b=L5NG6VVA8FcME6ARUGin/7Ce88olaDLWbM+q5NsvIUqKuoTikQqbJrRwQHog0nV46S
         md6MzQhCB1vBA50r9XoEsDZXdzesEM3itQ+04SeaYK0K0FF8wi4Hkdym6B4CJNiPp69q
         7TuI8u1g98D9LKby/sILsyFSswb470rOy+o2CO6q7NGWz4ZJ+2pdrFT1G4vq7ugLnXWM
         +nuZyeWUZxF2W4O7RrE82wiCk5yMzo3jZaWMgpl+YcywzKC11ruCqfg9WWu8LaSZJS3w
         V158kba0iI7SKOGRPbPj6Ed61/n4vwg3biEj+zq5GLO6qHZpiW44vCEal2rAvdpXQv00
         PGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eEynP70sIFAOJv8jBHsPKDv3h+TNVyHKkygdyoGfsNw=;
        b=CcdI8msvSTLMyr5F54Thg8oH9kvk/NNAny8BsDcb2+4itdFNGk2wwFxcEK0cJVuz0n
         1U0M++943dNUmp9EoIraK35mzploDWTz7oBkIHzAQD63JPOOeuZ67Q5qdR9IlfMhF6v5
         QqOX25BHWwFMK/3BpgnO45kujdct8i6TcD4er8LAlmVaZpN0uNcVpX23d2UJRv9LcT2R
         FupKL7TCz7A36lZlItIdBhE8rR2sdDE2t2y6B6z6Y2GbVwwJbJYBjujSCZOjia3yDxhQ
         1z08tyDlUZbBGDrZjhpJo9lrn/D/31EkVKwYDKZqlynpVsNXktKe+nM8FC1irPZJJh/9
         1Exw==
X-Gm-Message-State: AOAM531NI1Txm17wN3fsgb6vwBABZklo9MnjLf1x6fu2vLL3CAUbeSHg
        Oc4rImIFkjFOCZjXghR+++Tsx4fSXmws1wvMARk=
X-Google-Smtp-Source: ABdhPJwz/OeZjyldZy449+0Uzcke2ADcU0xG4IYUEQpDRu6Z5wubFn8IF5FkRJ5Slfj4mbGHrhk9Vdydr4ofVY3Y/Kg=
X-Received: by 2002:a05:6638:3af:: with SMTP id z15mr20162519jap.4.1590429857105;
 Mon, 25 May 2020 11:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200524152747.745893-1-andrew@lunn.ch>
In-Reply-To: <20200524152747.745893-1-andrew@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 25 May 2020 11:03:59 -0700
Message-ID: <CAFXsbZp4jnHHSZob4_dG2FsW5dewtMMZQKyv+xaM93gvDtVWoA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/6] Raw PHY TDR data
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With NXP i.MX51 and Marvell 88E6352 and the referenced ethtool, I
tested this functionality successfully.

Tested-by: Chris Healy <cphealy@gmail.com>

On Sun, May 24, 2020 at 8:28 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Some ethernet PHYs allow access to raw TDR data in addition to summary
> diagnostics information. Add support for retrieving this data via
> netlink ethtool. The basic structure in the core is the same as for
> normal phy diagnostics, the PHY driver simply uses different helpers
> to fill the netlink message with different data.
>
> There is a graphical tool under development, as well a ethtool(1)
> which can dump the data as text and JSON.
>
> A patched ethtool(1) can be found in
> https://github.com/lunn/ethtool.git feature/cable-test-v5
>
> Thanks for Chris Healy for lots of testing.
>
> v2:
> See the individual patches but:
>
> Pass distances in centimeters, not meters
>
> Allow the PHY to round distances to what it supports and report what
> it actually used along with the results.
>
> Make the Marvell PHY use steps a multiple of 0.805 meters, its native
> step size.
>
> Andrew Lunn (6):
>   net: ethtool: Add attributes for cable test TDR data
>   net: ethtool: Add generic parts of cable test TDR
>   net: ethtool: Add helpers for cable test TDR data
>   net: phy: marvell: Add support for amplitude graph
>   net: ethtool: Allow PHY cable test TDR data to configured
>   net : phy: marvell: Speedup TDR data retrieval by only changing page
>     once
>
>  Documentation/networking/ethtool-netlink.rst |  81 ++++++
>  drivers/net/phy/marvell.c                    | 286 ++++++++++++++++++-
>  drivers/net/phy/nxp-tja11xx.c                |   2 +-
>  drivers/net/phy/phy.c                        |  67 ++++-
>  include/linux/ethtool_netlink.h              |  25 +-
>  include/linux/phy.h                          |  17 ++
>  include/uapi/linux/ethtool_netlink.h         |  67 +++++
>  net/ethtool/cabletest.c                      | 209 +++++++++++++-
>  net/ethtool/netlink.c                        |   5 +
>  net/ethtool/netlink.h                        |   1 +
>  10 files changed, 747 insertions(+), 13 deletions(-)
>
> --
> 2.27.0.rc0
>
