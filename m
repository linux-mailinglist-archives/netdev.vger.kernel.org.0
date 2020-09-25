Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA227944A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgIYWj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgIYWj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:39:27 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48EEC0613CE;
        Fri, 25 Sep 2020 15:39:26 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i26so681687ejb.12;
        Fri, 25 Sep 2020 15:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqcW3rl891dr3qudKSLhS4tM1nPfMjp/6k/SFPe8aho=;
        b=rX5DrMgl45l4foK7sUE7lDf1V4ef0f/JWh2cBca7Eg9SfMIt9B6IzyokAhBP4qxsWq
         W8nojKscvzMqKBkOb/KfvVzK1y3wg3w4qzAXy3mkXeagrLF/X+ih8t+adz3pWMEfA5K3
         go118JTDfgio6nvFtY/0Cw/RQiaYrlzn8xcUlduyu2WcImRls2t5v91UmcCxlCbY+aOZ
         eKokjTkFno08KvKc4DjaiwejdCHgC2/+LfszJHvEStNijjxaDXXNK9bssJkuDdAsFfK7
         /otOJFfZ9vWQf+FdYyqtF2hpy3jI9syz917xlAXIOA0+/86psRguFOBN8lDBEJGeiPOQ
         Zl7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqcW3rl891dr3qudKSLhS4tM1nPfMjp/6k/SFPe8aho=;
        b=cfmE144kAWUEOu6ds1w3oJT3VQzfbp42eSlW8HTGv1SNw+WN3tuigBRPpqyKHupVJA
         E3fmQSVwEFjZGsirkk5GwBY2DpmdRObKQ4q5ODvDr+Yh+pnT9y9bsd61tbqrAlSILfqD
         SiBYFwfWB/C7Xynyb0yG0Jo4fiFhNPmwNX7HYIXqPsRSbKgMn++V4OVpO0KZEl2gzR8s
         k4Gyu5MBW+4KYoleoKV+Bq7PXyMu2AmFF3JofP/Hl23wgBmvATvJSGXrVdEIrg47/jIo
         GUCoU62w8VxPH+k9QXjQ2jF6fieeWUbuhKUbwRMbMtNUzJQ9H/NnTkybtEKO6w++wwuy
         tL+g==
X-Gm-Message-State: AOAM530FtFkWMEfcN2NGYLdgX4fnENvK7NTvSzxZQw5WeTpcYnNbIRdz
        41J952LktmhY+MHzhg2qb/2ONfuTUmo8FrBQWk0=
X-Google-Smtp-Source: ABdhPJwBDw1ys7C5G/etJuJ74bio79gE0vxTaamvelT5Kj77dUcSW09e2b0vXr1hy05/QOK1InVs9GRY7IMSc+Grlts=
X-Received: by 2002:a17:906:7b87:: with SMTP id s7mr1062698ejo.328.1601073565571;
 Fri, 25 Sep 2020 15:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
 <20200925221403.GE3856392@lunn.ch>
In-Reply-To: <20200925221403.GE3856392@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Sep 2020 00:39:14 +0200
Message-ID: <CAFBinCC4VuLJDLqQb+m+h+qnh6fAK2aBLVtQaE15Tc-zQq=KSg@mail.gmail.com>
Subject: Re: RGMII timing calibration (on 12nm Amlogic SoCs) - integration
 into dwmac-meson8b
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        alexandre.torgue@st.com, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, joabreu@synopsys.com, kuba@kernel.org,
        peppe.cavallaro@st.com, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sat, Sep 26, 2020 at 12:14 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Sep 25, 2020 at 11:47:18PM +0200, Martin Blumenstingl wrote:
> > Hello,
> >
> > Amlogic's 12nm SoC generation requires some RGMII timing calibration
> > within the Ethernet controller glue registers.
> > This calibration is only needed for the RGMII modes, not for the
> > (internal) RMII PHY.
> > With "incorrect" calibration settings Ethernet speeds up to 100Mbit/s
> > will still work fine, but no data is flowing on 1Gbit/s connections
> > (similar to when RX or TX delay settings are incorrect).
>
> Hi Martin
>
> Is this trying to detect the correct RGMII interface mode:
>         PHY_INTERFACE_MODE_RGMII,
>         PHY_INTERFACE_MODE_RGMII_ID,
>         PHY_INTERFACE_MODE_RGMII_RXID,
>         PHY_INTERFACE_MODE_RGMII_TXID,
>
> In general, we recommend the MAC does not insert any delay, we leave
> it up to the PHY. In DT, you then set the correct phy-mode value,
> which gets passed to the PHY when the MAC calls the connect function.
yes and no.
The reference code I linked tries to detect the RGMII interface mode.
However, for each board we know the phy-mode as well as the RX and TX
delay - so I'm not trying to port the RGMII interface detection part
to the mainline driver.

on X96 Air (which I'm using for testing) Amlogic configures phy-mode
"rgmii" with a 2ns TX delay provided by the MAC and 0ns RX delay
anywhere (so I'm assuming that the board adds the 2ns RX delay)
I am aware that the recommendation is to let the PHY generate the delay.
For now I'm trying to get the same configuration working which is used
by Amlogic's vendor kernel and u-boot.

> Is there any documentation as to what the calibration values mean?  I
> would just hard code it to whatever means 0uS delay, and be done. The
> only time the MAC needs to add delays is when the PHY is not capable
> of doing it, and generally, they all are.
This calibration is not the RGMII RX or TX delay - we have other
registers for that and already know how to program these.

This new calibration only exists on 12nm SoCs so I assume (but have no
proof) that they need to solve some challenge that comes with the
advanced node (previous SoCs were manufactured using a 28nm process).
In the old days the vendors put calibration data into the eFuse.
However I think for mass-production of cheap boards this is not nice
for the manufacturers (because they need this eFuse programming step).
So I think Amlogic added a calibration circuit to handle tolerances
within the SoC manufacturing as well as the "environment" of the SoC
(there are some TI SoCs where the MMC controller's clock calibration
depends on the SoC temperature for example. For these Amlogic SoCs I
don't know the factors that influence this calibration though - one
guess however is cost-cutting).

All of that said: I don't have any scope that's fast enough to see the
clock-skew on such high-speed signals so I cannot tell for sure what
problem they are solving.
What I can say is that u-boot programs calibration value 0xf (the
maximum value) on my X96 Air board. With this I cannot get Ethernet
working - regardless of how I change the RX or TX delays.
If I leave everything as-is (2ns TX delay generated by the MAC, 0ns RX
delay, ...) and change the calibration value to 0x0 or 0x3 (the latter
is set by the vendor kernel) then Ethernet starts working.


Best regards,
Martin
