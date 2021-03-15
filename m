Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A4F33B8A9
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhCOOEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbhCOOCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:02:46 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C35C06174A;
        Mon, 15 Mar 2021 07:02:44 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id 61so5753457wrm.12;
        Mon, 15 Mar 2021 07:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=k0vn3g0iM9tzN5zs4VgW3rT5nVcEHeJKUw8PGKNq8mo=;
        b=mtxAx5cWs61UGwBM7+LNzs509fgwmcXyFtwBhcyQOKx7rxl7Ym6jPE4w83BBHZHbAV
         dzDpQwf5PYgEsmM1lunArSteDuIRyRT43+3RwcSEkDtTdXoa7iazy9PbnmY6q/7Xj+HT
         NWN149YVOwQ0s285t18yUN5uL0jV8wdZZP/+6ICVKJnUjLfQJJMgeqt2S/1yK3UwDNjV
         tYmg7NFWeX5ibxRGg4MWGSIVchnUfZaC+Zqn6Ymk8+nba/YAB6U02F1JqyaJwjl48P4r
         G40UbXv1xNyTsv970hy5BHpagnp+2Mg5Mw6Atx/0QG+TSyIh7AD27kdx0QYS0LKfMXIc
         gi7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=k0vn3g0iM9tzN5zs4VgW3rT5nVcEHeJKUw8PGKNq8mo=;
        b=UeOVaCHTF/Xp2As0k1BVq1zrenw6puvf1h5V8CcjBagxkc1YvQh2jI6/URlob39A13
         M0cnd29AHHgjO+5RZ85MT4xsxIWA89CyrMhjw75C+VlaEsTaatSeTzhwvIQ02Gy40hqB
         oSsxwrtfyh1LIk2n2zJBJV/EiJ2F/xmXyAYt1z4BD41a6dx9LxUrAAvTZDxPpBFaeXBw
         HWzLKjCRg2olkbODrzSa3pKSa2A5hzO3R43EPS5eZ3uwo53LARWDoD6rpohiWCB0fC+2
         RStIkj8zBH9P0GDTeCAm3fxVZSvRP5vfTCzqQyuq2hy4l+hB5udOtcnsmBZN3SB9IeHB
         xdXQ==
X-Gm-Message-State: AOAM530yu4TMU1SEtp+AjgO2H1FShmrjtxHxexVLhvggmXaLhHubIk6l
        dAl/iHqksqmOsNIbi0bRqJg=
X-Google-Smtp-Source: ABdhPJx28lC8vTBtYr2kHoXQJipgXe7H1XrROX3f9kSupKxCshYAGQmCEA/JKVPb+O6qsghAFI/jNA==
X-Received: by 2002:a5d:6a49:: with SMTP id t9mr28200782wrw.131.1615816961722;
        Mon, 15 Mar 2021 07:02:41 -0700 (PDT)
Received: from macbook-pro-alvaro.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id b131sm12689628wmb.34.2021.03.15.07.02.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Mar 2021 07:02:41 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH 2/2] net: mdio: Add BCM6368 MDIO mux bus controller
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <YEaQdXwrmVekXp4G@lunn.ch>
Date:   Mon, 15 Mar 2021 15:02:37 +0100
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D39D163A-C6B3-4B66-B650-8FF0A06EF7A2@gmail.com>
References: <20210308184102.3921-1-noltari@gmail.com>
 <20210308184102.3921-3-noltari@gmail.com> <YEaQdXwrmVekXp4G@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> El 8 mar 2021, a las 22:00, Andrew Lunn <andrew@lunn.ch> escribi=C3=B3:
>=20
>> +static int bcm6368_mdiomux_probe(struct platform_device *pdev)
>> +{
>> +	struct bcm6368_mdiomux_desc *md;
>> +	struct mii_bus *bus;
>> +	struct resource *res;
>> +	int rc;
>> +
>> +	md =3D devm_kzalloc(&pdev->dev, sizeof(*md), GFP_KERNEL);
>> +	if (!md)
>> +		return -ENOMEM;
>> +	md->dev =3D &pdev->dev;
>> +
>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res)
>> +		return -EINVAL;
>> +
>> +	/* Just ioremap, as this MDIO block is usually integrated into =
an
>> +	 * Ethernet MAC controller register range
>> +	 */
>> +	md->base =3D devm_ioremap(&pdev->dev, res->start, =
resource_size(res));
>> +	if (!md->base) {
>> +		dev_err(&pdev->dev, "failed to ioremap register\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	md->mii_bus =3D devm_mdiobus_alloc(&pdev->dev);
>> +	if (!md->mii_bus) {
>> +		dev_err(&pdev->dev, "mdiomux bus alloc failed\n");
>> +		return ENOMEM;
>> +	}
>> +
>> +	bus =3D md->mii_bus;
>> +	bus->priv =3D md;
>> +	bus->name =3D "BCM6368 MDIO mux bus";
>> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%d", pdev->name, =
pdev->id);
>> +	bus->parent =3D &pdev->dev;
>> +	bus->read =3D bcm6368_mdiomux_read;
>> +	bus->write =3D bcm6368_mdiomux_write;
>> +	bus->phy_mask =3D 0x3f;
>> +	bus->dev.of_node =3D pdev->dev.of_node;
>> +
>> +	rc =3D mdiobus_register(bus);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "mdiomux registration failed\n");
>> +		return rc;
>> +	}
>=20
> So this is different to all the other mux drivers. Normally there is
> an MDIO driver. And there is a mux driver. Two separate drivers. The
> mux driver uses a phandle to reference the MDIO driver. Here we have
> both in one driver.
>=20
> Does this MDIO bus device exist as a standalone device? Without the
> mux? If silicon does exist like that, having two separate drivers
> would be better.

BCM6368 (and newer) SoCs have an integrated ethernet switch controller =
with dedicated internal phys, but it also supports connecting to =
external phys not integrated in the internal switch.
Ports 0-3 are internal, ports 4-7 are external and can be connected to =
external switches or phys and port 8 is the CPU.
This MDIO bus device is integrated in the BCM63xx switch registers, =
which corresponds to the same registers present in =
drivers/net/dsa/b53/b53_regs.h.
As you can see in the source code, registers are the same for the =
internal and external bus. The only difference is that if MDIOC_EXT_MASK =
(bit 16) is set, the MDIO bus accessed will be the external, and on the =
contrary, if bit 16 isn=E2=80=99t set, the MDIO bus accessed will be the =
internal one.

I don=E2=80=99t know if this answers your question, but I think that =
adding it as mdiomux is the way to go.

>=20
>     Andrew

Best regards,
=C3=81lvaro.=
