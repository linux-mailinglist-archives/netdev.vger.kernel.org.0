Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949663DD578
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhHBMQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbhHBMQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 08:16:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB46EC06175F;
        Mon,  2 Aug 2021 05:15:53 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id p21so24160102edi.9;
        Mon, 02 Aug 2021 05:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=g6sicWaMVJjqloudI94E/2JlPDwE+Z7jMXMl0fRhNw0=;
        b=ewMZbgdPI2zyQJAs5SyT5VDE8O/dCbhrt3iVxsSQmE9CJch2coeQNM4VwfzGxgvA+B
         YA6WrZ+Kua9jlPIbjRGIZycnSSvO3BkbMgFuxhzmPkfqPBHI+FlV+a25A06hBnNDKiM6
         6VvuPTMd4h9blfO4eg5vty+eeIla6VXAupvIoCk34rITpf/VUf79RVM4oOEyYDfZirmt
         d8Zj/HvBMtEciEI0COsv/jj100Y7PAnS2VOrDSZuxl5mTCnkJIgQ09Ve5FoZTnIxrQQd
         3efh4rEkDX1rrHK3iklKroLx5eqTJUYD+aRQkIFA9r9IighvXSuzliNyYzpRNoN9TRF0
         e+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=g6sicWaMVJjqloudI94E/2JlPDwE+Z7jMXMl0fRhNw0=;
        b=GBlQWXnQYQDtmfRK4FL1SaR6clBLo3vWX1EJ4RtIdZwEG0OmQsiIlzAXboQ9L1qNfH
         fL1ptoRfoF3TuxGj+ZYrSIfekuFmQs+ke9Q7gR+2WimyGWNhsy/O2in0gv5pyX5RCMSO
         MUVtMQt1ax6WqbIAgzMI89FzZ5T3PPEca0QNSmSNNxVFldnNp3vChZg+ikxZENsKuHDT
         G5zhni7OFgxFuMlGZjwYh4DVyezwVCIjN0u2UzxIt+XdrGk/fom+nyl+DZF0l3fZLlzz
         0tXF83UyejHxs3tQpykRUSRQW3yFRqwItPGZUREKIr5D71oFdoh+qrllO2FX8mHAcKOJ
         aHAA==
X-Gm-Message-State: AOAM532e0rotctzhS1eJhEkYgpmmgyE8yq/iwBSoA54bhMGhus4e3H40
        IHhBEwO25HMgSfM+2SZ1B5c=
X-Google-Smtp-Source: ABdhPJzk3RyCDmqdY96tXhSYWpFmvlY3W7H0A21UbdWCNFyVnC6CsKyemEwt6fvLrSq3KgOFfoZjfw==
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr18744111edu.221.1627906552301;
        Mon, 02 Aug 2021 05:15:52 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c6sm4495354eje.105.2021.08.02.05.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 05:15:51 -0700 (PDT)
Date:   Mon, 2 Aug 2021 15:15:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210802121550.gqgbipqdvp5x76ii@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 04:15:08PM +0530, Prasanna Vengateshan wrote:
> On Sat, 2021-07-31 at 18:04 +0300, Vladimir Oltean wrote:
> > > +void lan937x_mac_config(struct ksz_device *dev, int port,
> > > +                     phy_interface_t interface)
> > > +{
> > > +     u8 data8;
> > > +
> > > +     lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> > > +
> > > +     /* clear MII selection & set it based on interface later */
> > > +     data8 &= ~PORT_MII_SEL_M;
> > > +
> > > +     /* configure MAC based on interface */
> > > +     switch (interface) {
> > > +     case PHY_INTERFACE_MODE_MII:
> > > +             lan937x_config_gbit(dev, false, &data8);
> > > +             data8 |= PORT_MII_SEL;
> > > +             break;
> > > +     case PHY_INTERFACE_MODE_RMII:
> > > +             lan937x_config_gbit(dev, false, &data8);
> > > +             data8 |= PORT_RMII_SEL;
> > > +             break;
> > > +     case PHY_INTERFACE_MODE_RGMII:
> > > +     case PHY_INTERFACE_MODE_RGMII_ID:
> > > +     case PHY_INTERFACE_MODE_RGMII_TXID:
> > > +     case PHY_INTERFACE_MODE_RGMII_RXID:
> > > +             lan937x_config_gbit(dev, true, &data8);
> > > +             data8 |= PORT_RGMII_SEL;
> > > +
> > > +             /* Add RGMII internal delay for cpu port*/
> > > +             if (dsa_is_cpu_port(dev->ds, port)) {
> >
> > Why only for the CPU port? I would like Andrew/Florian to have a look
> > here, I guess the assumption is that if the port has a phy-handle, the
> > RGMII delays should be dealt with by the PHY, but the logic seems to be
> > "is a CPU port <=> has a phy-handle / isn't a CPU port <=> doesn't have
> > a phy-handle"? What if it's a fixed-link port connected to a downstream
> > switch, for which this one is a DSA master?
>
> Thanks for reviewing the patches. My earlier proposal here was to check if there
> is no phydev (dp->slave->phydev) or if PHY is genphy, then apply RGMII delays
> assuming delays should be dealt with the phy driver if available. What do you
> think of that?

I don't know what to suggest, this is a bit of a minefield.
A while ago and in a different thread, Russell King said that
PHY_INTERFACE_MODE_RGMII_TXID means that the MAC should behave as if it
is connected to a PHY which has applied RGMII delays in the TX direction,
regardless of whether it is in fixed-link or not. So if the MAC was to
add any internal delays in PHY_INTERFACE_MODE_RGMII_TXID mode, those
would have to be RX delays, because the phy-mode specifies what was
already added and nothing more.
However, that is yet another problem. "what is already added" does not
mean "what more needs to be added". The fact that internal delays were
added in the TX direction doesn't necessarily mean that they still need
to be added in the RX direction. If you have a PHY which can only delay
the clock that it drives (the RX clock), and this is connected to a MAC
that cannot add any delays of its own, then you would end up adding PCB
traces on the board in the TX direction. But if you specify the phy-mode
as "rgmii-rxid", the MAC driver would complain that it can't add delays
in the TX direction (under the assumption that these are needed to work),
and if you specify the phy-mode as "rgmii-id", the PHY driver would
complain that it can't add delays in the TX direction.
So you'd have a system that works from a hardware PoV, but you wouldn't
have any way to describe it to Linux, which sucks.

I think the only way to do things correctly today and have a way to
describe any possible hardware setup is to parse the explicit
rx-internal-delay-ps and tx-internal-delay-ps properties in the MAC
driver, as defined in Documentation/bindings/net/ethernet-controller.yaml.
Then only let the MAC add the internal delays if the device tree has
added those properties, leave nothing down to assumptions.
