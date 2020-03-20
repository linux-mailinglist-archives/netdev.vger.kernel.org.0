Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D20818CBCD
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgCTKiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:38:18 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34611 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgCTKiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 06:38:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id i24so6590457eds.1
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 03:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7k3nkUjgecM2FJJfUkQBF+yIvdhRiFYkaeJ0JmJrL/Y=;
        b=EXFpC3Xyshgr9t2kSb+VhDPQLG2EXsxEQxgQ3ZGuvdUPtgovnwEOVhqPr4nm+AuiXr
         SWzfQ1FaSzczdyHGCqcmTie3aTx3B9VttUQJ+UdVyMBm3lq2ioHL55hWVrtFo6vI+tft
         JgzJzmIaU7Og7LIkSzjRPtjtgxu5S4lyIs+CgHEs619jlzuI/lcyi3qcJaOV/UU5vaVc
         3c3NBcagKgTocR1apcW5n7Q798G5d9YnK+5Gl17v7HmR4xutaP32BSgOgljiaz6Bdl6Z
         +X+ayoo8xDn3Sgrv5u+azpY9cZdbEfZObyDOUZkuM/s++38gYMRDt8IJshffptyHA1SQ
         Biyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7k3nkUjgecM2FJJfUkQBF+yIvdhRiFYkaeJ0JmJrL/Y=;
        b=DBiTlM5f6a7DuNYi0nuXhBjaxkKweXocHvJTzuinqyhQxlNjLHjrDHvWM2s0XlsHKd
         ikAvtK8uOswVTMYpJne7CliSio3g4GOd//PqICN6myGuDg9bMFqKiuggBCEdJREgJmaD
         B2Wydv0T6F0Rq91BcYEi/9NW8o37J3b8NrHViL1ESVDYUgBkBpmPMb6xyxPkJiQJ4jpR
         CQmbTcVmSa53wjBBZ/BcRkOyjZ5YngueKQRzkbM3Xb/IJSE4YyI+oQaGDBCLXwhydFQA
         uftvLdkOmfDSFscKlt0WauwXq80FP6Ys45ySoxWS5hqz7/W9JNemW0OdTrXu43rwlUb+
         TN2Q==
X-Gm-Message-State: ANhLgQ2HrkmgLwmA2Wxx1T/w4P+4z66cin8ewztg3d7wrbgiXL9LCC7d
        rtAMvQgK7yo0HbZxXHe6v0MJ4QTKJ579QiRYmiU=
X-Google-Smtp-Source: ADFU+vvJHjKFj72zPTx2nh7U00GegH+dileNmxgPTPJrraTnnnb4OTKFA9acLcTY/deU5ZTzmlieKKxlXfD0t0xPOSg=
X-Received: by 2002:a17:906:c294:: with SMTP id r20mr7434573ejz.239.1584700696040;
 Fri, 20 Mar 2020 03:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200319211649.10136-1-olteanv@gmail.com> <20200319211649.10136-2-olteanv@gmail.com>
 <20200320100925.GB16662@lunn.ch>
In-Reply-To: <20200320100925.GB16662@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 20 Mar 2020 12:38:05 +0200
Message-ID: <CA+h21hrvsfwspGE6z37p-fwso3oD0pXijh+fZZfEEUEv6bySHQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: phy: mscc: rename enum
 rgmii_rx_clock_delay to rgmii_clock_delay
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, 20 Mar 2020 at 12:09, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Mar 19, 2020 at 11:16:46PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > There is nothing RX-specific about these clock skew values. So remove
> > "RX" from the name in preparation for the next patch where TX delays are
> > also going to be configured.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/phy/mscc/mscc.h      | 18 +++++++++---------
> >  drivers/net/phy/mscc/mscc_main.c |  2 +-
> >  2 files changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> > index 29ccb2c9c095..56feb14838f3 100644
> > --- a/drivers/net/phy/mscc/mscc.h
> > +++ b/drivers/net/phy/mscc/mscc.h
> > @@ -12,15 +12,15 @@
> >  #include "mscc_macsec.h"
> >  #endif
> >
> > -enum rgmii_rx_clock_delay {
> > -     RGMII_RX_CLK_DELAY_0_2_NS = 0,
> > -     RGMII_RX_CLK_DELAY_0_8_NS = 1,
> > -     RGMII_RX_CLK_DELAY_1_1_NS = 2,
> > -     RGMII_RX_CLK_DELAY_1_7_NS = 3,
> > -     RGMII_RX_CLK_DELAY_2_0_NS = 4,
> > -     RGMII_RX_CLK_DELAY_2_3_NS = 5,
> > -     RGMII_RX_CLK_DELAY_2_6_NS = 6,
> > -     RGMII_RX_CLK_DELAY_3_4_NS = 7
> > +enum rgmii_clock_delay {
> > +     RGMII_CLK_DELAY_0_2_NS = 0,
> > +     RGMII_CLK_DELAY_0_8_NS = 1,
> > +     RGMII_CLK_DELAY_1_1_NS = 2,
> > +     RGMII_CLK_DELAY_1_7_NS = 3,
> > +     RGMII_CLK_DELAY_2_0_NS = 4,
> > +     RGMII_CLK_DELAY_2_3_NS = 5,
> > +     RGMII_CLK_DELAY_2_6_NS = 6,
> > +     RGMII_CLK_DELAY_3_4_NS = 7
> >  };
>
> Can this be shared?
>
> https://www.spinics.net/lists/netdev/msg638747.html
>
> Looks to be the same values?
>
> Can some of the implementation be consolidated?
>
>     Andrew

2 issues:
- I don't quite understand that patch. I searched for VSC8584
documentation but I don't find any RGMII PHY? Just a SGMII/QSGMII one.
- That patch is writing to MSCC_PHY_RGMII_SETTINGS (defined to 18).
This one is writing to MSCC_PHY_RGMII_CNTL (defined to 20). And since
I have no documentation to understand why, I'm back to square 1.

Thanks,
-Vladimir
