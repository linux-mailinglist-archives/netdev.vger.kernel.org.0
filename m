Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159B42A91D5
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgKFI4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:56:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38964 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgKFI4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:56:20 -0500
Received: from mail-ed1-f69.google.com ([209.85.208.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1kaxXd-0008SE-Jn
        for netdev@vger.kernel.org; Fri, 06 Nov 2020 08:56:17 +0000
Received: by mail-ed1-f69.google.com with SMTP id t7so279486edt.0
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 00:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version;
        bh=rHmCemmrzmlpwwWdFuFpagJQbnEzK/XKkZzOsNZYnog=;
        b=bTWIV+7BkRcAuPSbCBO3jdkwNUh5WUA+HazakZH+q13MbkFpeKIiQINIYmIFd/Oo29
         hPE86cD7xfeLfznboX/MC66hSvPUNeepjCkpMaT3+wg1DtGr4JVudIjVR783P8T9BM19
         3vSNuTYtukASk9HsFSyLBfMM7iEPd3tvqrvHeoas3Z8ehrvfZH2pHkFdT+UywGZa8mUa
         oNhrTS8JlsBaAIVmwWYE2MOmkbNs7ilbW/8muBZ6Zpjtl/njZcYUlrJeQjAfPqWmm5y0
         qMwYLPiT5vKZCjEToBBByx7efucuHaIPgb090wNiyGLCkC1OrY8HT+8YjHnFz5fKMg7o
         9Slg==
X-Gm-Message-State: AOAM532i+t/YLZgDw0MIxBYbv54ax2PfYs0ekAgmzQcU2J4JFXMFNZmb
        QhLof2YilPt4ZbRxLerC6vAdLsRp8Jr8Z6hkTRihHTnpkrWQ61DZtcxczwgBZjHDzYlaAwQhOAn
        DZ4lHC8DDj4WWpg6Si+TtXCKxfXtRUee70g==
X-Received: by 2002:aa7:ce8d:: with SMTP id y13mr982922edv.65.1604652976710;
        Fri, 06 Nov 2020 00:56:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9VgEcF6YmQ6Gud7XqdbYa7YAd8x552/W9lKVJh9e13q1ucg8/yb9bSrId8jPpbyz2FDekOQ==
X-Received: by 2002:aa7:ce8d:: with SMTP id y13mr982901edv.65.1604652976385;
        Fri, 06 Nov 2020 00:56:16 -0800 (PST)
Received: from gollum ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id m2sm508318eds.35.2020.11.06.00.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 00:56:15 -0800 (PST)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
Date:   Fri, 6 Nov 2020 09:56:11 +0100
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Juerg Haefliger <juerg.haefliger@canonical.com>,
        netdev@vger.kernel.org, woojung.huh@microchip.com
Subject: Re: lan78xx: /sys/class/net/eth0/carrier stuck at 1
Message-ID: <20201106095611.7e5912a0@gollum>
In-Reply-To: <20201103152723.GK1109407@lunn.ch>
References: <20201021170053.4832d1ad@gollum>
        <20201021193548.GU139700@lunn.ch>
        <20201023082959.496d4596@gollum>
        <20201023130519.GB745568@lunn.ch>
        <20201103134712.6de0c2b5@gollum>
        <20201103152723.GK1109407@lunn.ch>
Organization: Canonical Ltd
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1gRTE80WXPk2eNPWu/pTQFi";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1gRTE80WXPk2eNPWu/pTQFi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Nov 2020 16:27:23 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> On Tue, Nov 03, 2020 at 01:47:12PM +0100, Juerg Haefliger wrote:
> > On Fri, 23 Oct 2020 15:05:19 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> > > On Fri, Oct 23, 2020 at 08:29:59AM +0200, Juerg Haefliger wrote: =20
> > > > On Wed, 21 Oct 2020 21:35:48 +0200
> > > > Andrew Lunn <andrew@lunn.ch> wrote:
> > > >    =20
> > > > > On Wed, Oct 21, 2020 at 05:00:53PM +0200, Juerg Haefliger wrote: =
  =20
> > > > > > Hi,
> > > > > >=20
> > > > > > If the lan78xx driver is compiled into the kernel and the netwo=
rk cable is
> > > > > > plugged in at boot, /sys/class/net/eth0/carrier is stuck at 1 a=
nd doesn't
> > > > > > toggle if the cable is unplugged and replugged.
> > > > > >=20
> > > > > > If the network cable is *not* plugged in at boot, all seems to =
work fine.
> > > > > > I.e., post-boot cable plugs and unplugs toggle the carrier flag.
> > > > > >=20
> > > > > > Also, everything seems to work fine if the driver is compiled a=
s a module.
> > > > > >=20
> > > > > > There's an older ticket for the raspi kernel [1] but I've just =
tested this
> > > > > > with a 5.8 kernel on a Pi 3B+ and still see that behavior.     =
=20
> > > > >=20
> > > > > Hi J=C3=BCrg   =20
> > > >=20
> > > > Hi Andrew,
> > > >=20
> > > >    =20
> > > > > Could you check if a different PHY driver is being used when it is
> > > > > built and broken vs module or built in and working.
> > > > >=20
> > > > > Look at /sys/class/net/eth0/phydev/driver   =20
> > > >=20
> > > > There's no such file.   =20
> > >=20
> > > I _think_ that means it is using genphy, the generic PHY driver, not a
> > > specific vendor PHY driver? What does
> > >=20
> > > /sys/class/net/eth0/phydev/phy_id contain. =20
> >=20
> > There is no directory /sys/class/net/eth0/phydev. =20
>=20
> [Goes and looks at the code]
>=20
> The symbolic link is only created if the PHY is connected to the MAC
> if the MAC has been registered with the core first. lan78xx does it
> the other way around:
>=20
>         ret =3D lan78xx_phy_init(dev);
>         if (ret < 0)
>                 goto out4;
>=20
>         ret =3D register_netdev(netdev);
>         if (ret !=3D 0) {
>                 netif_err(dev, probe, netdev, "couldn't register the devi=
ce\n");
>                 goto out5;
>         }
>=20
> The register dump you show below indicates an ID of 007c132, which
> fits the drivers drivers/net/phy/microchip.c : "Microchip
> LAN88xx". Any mention of that in dmesg, do you see the module loaded?

It's built-in but is being used (as tracing shows).

=20
> >  =20
> > > > Given that all works fine as long as the cable is unplugged at boot=
 points
> > > > more towards a race at boot or incorrect initialization sequence or=
 something.   =20
> > >=20
> > > Could be. Could you run
> > >=20
> > > mii-tool -vv eth0 =20
> >=20
> > Hrm. Running that command unlocks the carrier flag and it starts toggli=
ng on
> > cable unplug/plug. First invocation:
> >=20
> > $ sudo mii-tool -vv eth0
> > Using SIOCGMIIPHY=3D0x8947
> > eth0: negotiated 1000baseT-FD flow-control, link ok
> >   registers for MII PHY 1:=20
> >     1040 79ed 0007 c132 05e1 cde1 000f 0000
> >     0000 0200 0800 0000 0000 0000 0000 3000
> >     0000 0000 0088 0000 0000 0000 3200 0004
> >     0040 a000 a000 0000 a035 0000 0000 0000
> >   product info: vendor 00:01:f0, model 19 rev 2
> >   basic mode:   autonegotiation enabled
> >   basic status: autonegotiation complete, link ok
> >   capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10bas=
eT-HD
> >   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10bas=
eT-HD flow-control
> >   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10bas=
eT-HD flow-control
> >=20
> > Subsequent invocation:
> >=20
> > $ sudo mii-tool -vv eth0
> > Using SIOCGMIIPHY=3D0x8947
> > eth0: negotiated 1000baseT-FD flow-control, link ok
> >   registers for MII PHY 1:=20
> >     1040 79ed 0007 c132 05e1 cde1 000d 0000
> >     0000 0200 0800 0000 0000 0000 0000 3000
> >     0000 0000 0088 0000 0000 0000 3200 0004
> >     0040 a000 0000 0000 a035 0000 0000 0000
> >   product info: vendor 00:01:f0, model 19 rev 2
> >   basic mode:   autonegotiation enabled
> >   basic status: autonegotiation complete, link ok
> >   capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10bas=
eT-HD
> >   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10bas=
eT-HD flow-control
> >   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10bas=
eT-HD flow-control
> >=20
> > In the first invocation, register 0x1a shows a pending link-change inte=
rrupt
> > (0xa000) which wasn't serviced (and cleared) for some reason. Dumping t=
he
> > registers cleared that interrupt bit and things start working correctly
> > afterwards. Nor sure yet why that first interrupt is ignored. =20
>=20
> So, 0x1a is the interrupt status, and 0x19 is the interrupt mask.

Yes.


> This should really be interpreted as a level interrupt. But it appears
> the hardware the interrupt is connected to is actually doing edge. And
> the edge has been missed, and so the interrupt is never serviced.
>=20
> I think the call sequence goes something like this, if i'm reading the
> code correct:
>=20
> lan78xx_probe() calls lan78xx_bind:
>=20
>     lan78xx_bind() registers an interrupt domain. This allows USB
>     status messages indicating an interrupt to be dispatched using the
>     normal interrupt mechanism, despite there not being a proper
>     interrupt as such. The masking of interrupts seems to be part of
>     INT_EP_CTL. This register is read during
>     lan78xx_setup_irq_domain(), but it is not written to disable all
>     interrupts. So it could be, PHY interrupts in the interrupt
>     controller are already enabled at this point.
>=20
>     lan78xx_bind() also registers an MDIO bus. This will cause the bus
>     to be probed and the PHY should be found.=20
>=20
> lan78xx_probe() calls lan78xx_phy_init:
>=20
>     lan78xx_phy_init gets the phydev, and fills in the interrupt
>     number. It then connects the PHY to the MAC using
>     phy_connect_direct(). phy_connect_direct() will request the
>     interrupt from the kernel, meaning it can then service interrupts,
>     and as part of that, it calls into the interrupt domain and
>     enables interrupts in the interrupt controller.  It clears the
>     interrupts in the PHY, which means the PHY interrupt status
>     register is read, clearing it. It then enables interrupts in the
>     PHY by again reading the status register to clear any pending
>     interrupts and then sets the mask to enable interrupts.
>    =20
> So at this point, the PHY is ready to generate interrupts, the
> interrupt controller in the USB device is ready to accept them. The
> kernel itself is read for them, and they should be passed to the PHY
> subsystem. What is not clear to me is if the USB endpoint is correctly
> setup to report interrupts.
>=20
>     Interestingly, the last thing lan78xx_phy_init() does is call
>     genphy_config_aneg(). That configures the PHY to start an
>     auto-neg. That is wrong, on a number of levels. The PHY drivers
>     implementation, lan88xx_config_aneg() sets the mdix before
>     starting autoneg. That gets skipped by directly calling
>     genphy_config_aneg(). However, the interface is not even
>     registered yet, let alone up. It has no business starting an
>     auto-neg. But if the cable is connected and the peer is ready,
>     about 1.5 seconds later, we expect auto-neg to complete and the
>     interrupt to fire.
>=20
> Sometime later, lan78xx_open() is called when the interface is
> configured up. It calls phy_start() which is the correct way to get
> the PHY going. That will call into the PHY driver to start auto-neg.
> I've no idea what happens in this PHY when two auto-negs are going.
>=20
> What lan78xx_open() also does is trigger a delayed work for
> EVENT_LINK_RESET. lan78xx_link_reset() gets called as a result, and
> that writes to the interrupt status register to clear it. Why clear
> interrupts when we have just started auto-neg and we expect it to
> cause an interrupt? The whole of lan78xx_link_reset() looks odd, and
> some of it should be moved to lan78xx_link_status_change() which
> phylib will call when the PHY changes status.
>=20
> O.K. As a start, remove the  in  from
> lan78xx_phy_init(). I don't know if that is enough, but it is clearly
> wrong.

The interface won't come up with that change. FWIW I recorded some traces
(functions phy_*, lan88xx_*, lan78xx_*):
[1] lan78xx built-in.
[2] lan78xx built-in without genphy_config_aneg() in lan78xx_phy_init().
[3] lan78xx as a module.

I've also added some trace_printks that dump the content of the status and
mask registers at the end of lan78xx_probe() (no interrupt pending) and in=
=20
lan78xx_get_drvinfo() which seems to be the next lan78xx function being
called after probing (per the built-in trace). At that time an interrupt
seems to be pending (lan78xx_get_drvinfo LAN88XX_INT_STS =3D 0xa000).

...Juerg

[1] https://kernel.ubuntu.com/~juergh/lp1890487/trace.builtin
[2] https://kernel.ubuntu.com/~juergh/lp1890487/trace.builtin-no-aneg
[3] https://kernel.ubuntu.com/~juergh/lp1890487/trace.module

=20
>     Andrew


--Sig_/1gRTE80WXPk2eNPWu/pTQFi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEhZfU96IuprviLdeLD9OLCQumQrcFAl+lD6sACgkQD9OLCQum
QrcOqhAAghnup/6UX9uA4rB3txcyW/JBKU4vGY8XSm71xgzUBSkYtOEx2tA/7zPT
rckCLji6dIkXF+kkyl6DBcc9aJ73TG0eWCTiL+vPoDfe/XCrfGTz3Vza3kAKD9Ly
M/bsyvyN5QiHASeOJbK39Ri21Mq3MByDYfIF5MqvtNWH4Cxo5hLbQe4exqkTXFqR
nMhyQ3A+A4igCXK0MW39KwGmjIGXzeN2XNIeh58geUJtMMAtQa73jTvsxaSSAvYG
XQKzzASEMyDK7EgtwbX3FOfEx+RuKnrmYPvjl3b+wseyWKCHCiX2sYnhcn7+wIzF
185A+biDrN3LNa4P0uSxZm+MX7ifVgmzOFqISS/98wQI4X7baVU8hv7wpBucg7i9
WuMy6sokdSfag8orxo6+sh9ei9gVskJWDEN3aEgmwXSM8A1e0TD0zijVSoWKkcd1
xPl684kVuISzvDM6MV9VFgbawR2DSTuc6sCK/UUHgIu5HCw4Tb4jVikcGK4X4glx
QcJXJvTpOYAArXGHf0/9k2b+9v5frPppIZFuO4FAE1VoHLlvOSaxs6XHi5ONf4HC
AFOVme84EcqQcWRKH872a/16OSneCKENjokcZKmWZzajZzrFFJAMRz1LC6mvXE/k
TZkUgHxfLClJKvJpX6MLShL9iLy2vv86fdg4pyB8vXSgiXJ9kjM=
=wDPm
-----END PGP SIGNATURE-----

--Sig_/1gRTE80WXPk2eNPWu/pTQFi--
