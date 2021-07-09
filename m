Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECD13C2910
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhGISe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGISe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 14:34:56 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665E4C0613DD;
        Fri,  9 Jul 2021 11:32:11 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id nd37so17907451ejc.3;
        Fri, 09 Jul 2021 11:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VtJq8ypnKS4eYlxtTrToZVYOT0P02GWDtqg+RJsp0r4=;
        b=Tkbz1Uom9Ksoj+v6zQJZaJuFIwSvZIDFfKaTRmAiXfUIJF2JBtndq+A4uppjsoWdUM
         GM0vQw7OtRYmvhAxcCTe45AImdH9fkmBjEKQnnSxvPH5UM32Z3vluY9iTVVYPk0OHGR4
         +f9zEGyZs2xqSUb2cF7f6OpBum34xUfQ7G5oRSDmPZLJEMKInJIsfnHaS8CHGdpJ7DIO
         1fxk6MANgtgIF3GMTsKSoMwCBhuXzgEM2cP28eBIPucYyD4+P5IK8P2EW0TAMjYWQSld
         9RcievpykfBUz1OgbGkFWmPhIjXMOnpyXQ8tPceb+t8Fn7BdHJBoeBw1P1acSx2r3hr5
         yGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VtJq8ypnKS4eYlxtTrToZVYOT0P02GWDtqg+RJsp0r4=;
        b=DJt+3az8JlGI6arRjbdQAZXCnGEnuuwRqC4vcIGmxyzYgo43KJMqWkMmYLfhPqzox+
         Gcy5podWD9lfdkHtHvNo9b5hFxBhWIp6aGkIm7DTgVS89ar6DekDWuTsa0US5ULUSSVN
         Lf7zPtxzaOcacUhmpzEfsYp8a/TiEFd4umb0//4JE8rQMcQ3lat26AvE4RnGWnbRRQwX
         o3yj3NMXlRZTXb+764rvJgLRn4iXQl/oegF8eyvTaHYG62kEm4gOck+QtW4d/BSb1/1i
         vZiI/s7Yyuv/0f6/ooJJiGAleGxvmnbxNcEGYKP22Gw4XAJXR/NeotHoFuQto5McNn3/
         YUBQ==
X-Gm-Message-State: AOAM533RQBU1hjriWwhul2bimLct5+9hrv4UOJziA+bMkRBnhctFdTS3
        IxDPQ8Jy46koWbD77cAWHRzV+G7DvwrmO91lphE=
X-Google-Smtp-Source: ABdhPJy81KXEn6X3hOLvrxh6D0GLTzilfT6rxFPn5rObGOLN7nn5gQc6vdYFUpHDi1l6cbGuWo99snz99LEm63ljuRY=
X-Received: by 2002:a17:907:d28:: with SMTP id gn40mr39961662ejc.471.1625855529920;
 Fri, 09 Jul 2021 11:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210709164216.18561-1-ms@dev.tdt.de>
In-Reply-To: <20210709164216.18561-1-ms@dev.tdt.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 9 Jul 2021 20:31:59 +0200
Message-ID: <CAFBinCCw9+oCV==1DrNFU6Lu02h3OyZu9wM=78RKGMCZU6ObEA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

overall this is looking good.
A few comments below - I think none of them is a "must change" in my opinion.

On Fri, Jul 9, 2021 at 6:42 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> This adds the posibility to configure the RGMII RX/TX clock skew via
typo: posibility -> possibility

[...]
> +#define XWAY_MDIO_MIICTRL_RXSKEW_MASK  GENMASK(14, 12)
> +#define XWAY_MDIO_MIICTRL_RXSKEW_SHIFT 12
if you use
- FIELD_PREP(XWAY_MDIO_MIICTRL_RXSKEW_MASK, rxskew); (as for example [0] does)
- and FIELD_GET(XWAY_MDIO_MIICTRL_RXSKEW_MASK, val);
below then you can drop the _SHIFT #define
this is purely cosmetic though, so nothing which blocks this from being merged

> +#define XWAY_MDIO_MIICTRL_TXSKEW_MASK  GENMASK(10, 8)
> +#define XWAY_MDIO_MIICTRL_TXSKEW_SHIFT 8
same as above

[...]
> +#if IS_ENABLED(CONFIG_OF_MDIO)
is there any particular reason why we need to guard this with CONFIG_OF_MDIO?
The dp83822 driver does not use this #if either (as far as I
understand at least)

[...]
> +static int xway_gphy_of_reg_init(struct phy_device *phydev)
> +{
> +       struct device *dev = &phydev->mdio.dev;
> +       int delay_size = ARRAY_SIZE(xway_internal_delay);
Some people in the kernel community are working on automatically
detecting and fixing signedness issues.
I am not sure if they would find this at some point suggesting that it
can be an "unsigned int".

> +       s32 rx_int_delay;
> +       s32 tx_int_delay;
xway_gphy14_config_aneg() below defines two variables in one line, so
to be consistent this would be:
    s32 rx_int_delay, tx_int_delay;
another option is to just re-use one "int_delay" variable (as it seems
that they're both used in different code-paths).

> +       u16 mask = 0;
I think this should be dropped and the phy_modify() call below should read:
    return phy_modify(phydev, XWAY_MDIO_MIICTRL,
                                  XWAY_MDIO_MIICTRL_RXSKEW_MASK |
                                  XWAY_MDIO_MIICTRL_TXSKEW_MASK, val);
For rgmii-txid the RX delay might be provided by the MAC or PCB trace
length so the PHY should not add any RX delay.
Similarly for rgmii-rxid the TX delay might be provided by the MAC or
PCB trace length so the PHY should not add any TX delay.
That means we always need to mask the RX and TX skew bits, regardless
of what we're setting later on (as phy_modify is only called for one
of: rgmii-id, rgmii-txid, rgmii-rxid).

[...]
> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +               rx_int_delay = phy_get_internal_delay(phydev, dev,
> +                                                     &xway_internal_delay[0],
I think above line can be simplified as:
    xway_internal_delay,

[...]
> +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +               tx_int_delay = phy_get_internal_delay(phydev, dev,
> +                                                     &xway_internal_delay[0],
same as above


Best regards,
Martin


[0] https://elixir.bootlin.com/linux/v5.13/source/drivers/net/phy/dp83867.c#L438
