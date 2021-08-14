Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B633EC4AE
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 21:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhHNTJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 15:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbhHNTJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 15:09:26 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE7EC061764;
        Sat, 14 Aug 2021 12:08:57 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v2so9888280edq.10;
        Sat, 14 Aug 2021 12:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qn4GvlYQZobCtErWEed4YL0Byg/5djbyOa0HzbMWBys=;
        b=boZRjvM7xpxdS0E1QfjU5IZ9WLtxktShHeHdvt18Moj9gGCOwNQprZv7maryrLov3v
         9FNWG933qdVw7mri3DelTJqveBRtWjBv2HenahVTzAztDqQL+UMsp8rw/QALe6qJneqv
         44qWWPpg+r4/bpRpvQTuw9OVSxq4WhBTuMhEMvy7xSpR+B1Jacv407xPfiwxBOCzpg8i
         jUMboy4uGbGXF9Qv4uWyMSECqHDcZ+T6etOeMj1UgZTKXnwnv7KxqwyWrYiFzQuah8O6
         Vmkwwqg+pNIlXqqXGgrA50Xp4ruK+7LtWOVZC7HA3Q6iDiJXd4VDY6Gg8wmYrO9TWQnW
         l2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qn4GvlYQZobCtErWEed4YL0Byg/5djbyOa0HzbMWBys=;
        b=QJBN3WluhK/U4o3OC2nLqEgdNGZ+CdKYhk4/zRESEo6USrEOy5k0HDutHFbD+17xlw
         bgEgFizvW5qfr0vWeTxBuC1XJT3/eK8kUvOIpqNcJbEQMN4SGDN+mHHtHE2irdRLVaQ7
         KAiLxIcsxZ35+CBZlJImZUAeRZDQZz10s+ksfk/2wWyb6hA1W/kEBuFrH0A0K1OeRCvw
         +sK/DnV2QHkHTHJXLAhHmw/Q/prfUdgCEjPSvPStZoNbemBF0cTO0bYme75DUp22pECv
         QeiT19g4CcmadI7VDDgzapl8TW+ViiiwgBZ6Mmlyv+GzCOLbP/c7Fw3AwO3llBTtdcsS
         /ScA==
X-Gm-Message-State: AOAM533Gm23MG1TbrTTnS7LK/2YLcOIuwnUI3vhkzhgNR9GTM5ap+fOF
        35aBZ0Yw37wkNYgq9Reouqk=
X-Google-Smtp-Source: ABdhPJwSLCyFZTPzB5aTk1qDwj19iWfjv8VIB6T8Hr/6xelhT/gNQ/uoG7h4MyNQwJh9RkEBBcbbSg==
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr10540742edd.47.1628968136529;
        Sat, 14 Aug 2021 12:08:56 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id n15sm2531680edw.70.2021.08.14.12.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 12:08:56 -0700 (PDT)
Date:   Sat, 14 Aug 2021 22:08:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 10/10] docs: devicetree: add
 documentation for the VSC7512 SPI device
Message-ID: <20210814190854.z6b33nfjd4wmlow3@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-11-colin.foster@in-advantage.com>
 <20210814114721.ncxi6xwykdi4bfqy@skbuf>
 <20210814184040.GD3244288@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210814184040.GD3244288@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 11:40:40AM -0700, Colin Foster wrote:
> On Sat, Aug 14, 2021 at 02:47:21PM +0300, Vladimir Oltean wrote:
> > On Fri, Aug 13, 2021 at 07:50:03PM -0700, Colin Foster wrote:
> > > +* phy_mode =3D "sgmii": on ports 0, 1, 2, 3
> >=20
> > > +			port@0 {
> > > +				reg =3D <0>;
> > > +				ethernet =3D <&mac>;
> > > +				phy-mode =3D "sgmii";
> > > +
> > > +				fixed-link {
> > > +					speed =3D <100>;
> > > +					full-duplex;
> > > +				};
> > > +			};
> >=20
> > Your driver is unconditionally setting up the NPI port at gigabit and
> > you claim it works, yet the device tree sees a 100Mbps fixed-link? Which
> > one is right, what speed does the port operate at?
>=20
> Good catch!
>=20
> I made the change to ocelot_spi_vsc7512 yesterday to set it up as
> gigabit, tested it, and it still works. Previously for my testing I'd
> had it hard-coded to 100, because the Beaglebone I'm using only supports
> 100Mbps on eth0.
>=20
> # phytool print swp1/0

Why are you showing the PHY registers of swp1? Why are these relevant at al=
l?

>=20
> ieee-phy: id:0x00070540
>=20
>    ieee-phy: reg:BMCR(0x00) val:0x1040
>       flags:          -reset -loopback =1B[1m+aneg-enable=1B[0m -power-do=
wn -isolate -aneg-restart -collision-test
>       speed:          1000-half

Also, 1000/half sounds like an odd speed to end negotiation at.

>=20
>    ieee-phy: reg:BMSR(0x01) val:0x796d
>       capabilities:   -100-b4 =1B[1m+100-f=1B[0m =1B[1m+100-h=1B[0m =1B[1=
m+10-f=1B[0m =1B[1m+10-h=1B[0m -100-t2-f -100-t2-h
>       flags:          =1B[1m+ext-status=1B[0m =1B[1m+aneg-complete=1B[0m =
-remote-fault =1B[1m+aneg-capable=1B[0m =1B[1m+link=1B[0m -jabber =1B[1m+ex=
t-register=1B[0m
>=20
>=20
> Of course I understand that "it works" is not the same as "it's correct"
>=20
> What I wanted to accomplish was to use the speed parameter and set up
> the link based on that. I looked through all the DSA drivers and
> couldn't find anything that seems to do that. The closest thing I saw
> was in mt7531_cpu_port_config where they set the speed to either 2500 or
> 1000 based on the interface. But nothing that I saw would explicitly set
> the speed based on this parameter.

As I mentioned in the other email, .phylink_mac_link_up is the function
you are looking for. Phylink parses the fixed-link and calls that
function for fixed-link ports with the speed and duplex specified. Check
and see if felix_phylink_mac_link_up is not in fact called with
link_an_mode =3D=3D MLO_AN_FIXED, speed =3D=3D SPEED_100 and duplex =3D=3D =
DUPLEX_FULL,
then what you are doing with that and if it makes sense for what you are
trying to do.

>=20
> So I think there's something I'm missing. The fixed-link speed should app=
ly to=20
> the CPU port on the switch (port@0)?

Is this a question? It is under port@0, the port with the 'ethernet'
property i.e. the CPU port, so why should it not?

> Then eth0 can be manually set to a specific speed, but if it doesn't
> match the fixed-link speed I'd be out of luck? Or should an ip link or
> ethtool command to eth0 modify the speeds of both sides of the
> connection? It feels like setting port@0 to the fastest speed and
> letting it negotiate down to eth0 makes sense...
>=20
> To ask the same question a different way:
>=20
> I can currently run "ethtool -s eth0 speed 10 duplex full autoneg on"=20
> and the link at eth0 drops to 10Mbps. Pinging my desktop jumps from=20
> about 400us to about 600us when I do that.

If eth0 is also a fixed-link, you should not be able to do that, no.
But the fact that you are able to do that means it's not a fixed-link,
you have a pair of PHYs that freely auto-negotiate the speed between the
BeagleBone and the switch.

>=20
> Should I not be able to do that? It should be fixed at 100Mbps without
> autoneg, end of story? Because in the current configuration it feels
> like the fixed-link settings are more a suggestion than a rule...
>=20

It should describe the hardware configuration, of course. It is
incorrect to describe one side of a copper PHY connection as fixed-link
and the other as having a phy-handle, and it sounds like this is what
you're doing. We need to see the device tree binding for eth0, and
maybe a picture of your setup if that is possible. How do you connect
the switch board to the BeagleBone? Is it an RJ45 cable or some sort of
PCIe-style connector with fingers for an SGMII SERDES lane, in which the
board is plugged?

The device tree says SGMII, the behavior says RJ45.
