Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CCA2A4585
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 13:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgKCMrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 07:47:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60659 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbgKCMrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 07:47:18 -0500
Received: from mail-ej1-f71.google.com ([209.85.218.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1kZviV-0001IL-Ra
        for netdev@vger.kernel.org; Tue, 03 Nov 2020 12:47:15 +0000
Received: by mail-ej1-f71.google.com with SMTP id c10so5368891ejm.15
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 04:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version;
        bh=CN0s3cU3Oo7295NvHc/B9jnxcznSmKW1csSvnKTiWko=;
        b=dOqnlnK/UWDkbnZVCyNxOe8Kh7oIOnkbcX+aLJFsd+t8WODvEbjqfdk5AZndw1vFbu
         C4FTSwd1wobmchXRi4Jdb5rbG+E+CqpAfn6plu6zdBQcbVdMgVJjmsABLi4Zbqpd75aa
         kxaGOIE3FVNU7dMvgud8SouAmxfEopdSZzQlSPYK407UhajeAIY90ZnZiq8IW6e+3Db0
         QM3QDa09BC47nn9pyXL81mkP7BC5Ol07qoMDZthijGUPnX/9jWaIviHtluFTk/bx4VPu
         hwPqEYFeYK6UKCwYOw+DWoNaTtMdwa3p5qQwK0vodE1rbsJ0NkAqikCtv3npJ4WB2Gv3
         zmIQ==
X-Gm-Message-State: AOAM531r+OHSVnwzbQfrPNEHLGAaBoDHnmopCVyJuah7IjteM+Jzm/om
        WBEF4Nz1eoWUhI2vwB3EJCwLXF94gP6I6G5NnFbDOylfryi9246ArS/sVjWW3U8okE6eRkI+38b
        BcUfXicQEPlzwpi3L8GfIHxwYXaDP+yIs4Q==
X-Received: by 2002:a05:6402:1457:: with SMTP id d23mr20902129edx.311.1604407635303;
        Tue, 03 Nov 2020 04:47:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6ZZNawG3+5kT6rrx4hsRdAhOzxz/FzR7ls78Bl57v5gmXb1CPaDkm5qzRAQzRf396lOQpEQ==
X-Received: by 2002:a05:6402:1457:: with SMTP id d23mr20902109edx.311.1604407635040;
        Tue, 03 Nov 2020 04:47:15 -0800 (PST)
Received: from gollum ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id ok21sm10950656ejb.96.2020.11.03.04.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 04:47:13 -0800 (PST)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
Date:   Tue, 3 Nov 2020 13:47:12 +0100
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Juerg Haefliger <juerg.haefliger@canonical.com>,
        netdev@vger.kernel.org, woojung.huh@microchip.com
Subject: Re: lan78xx: /sys/class/net/eth0/carrier stuck at 1
Message-ID: <20201103134712.6de0c2b5@gollum>
In-Reply-To: <20201023130519.GB745568@lunn.ch>
References: <20201021170053.4832d1ad@gollum>
        <20201021193548.GU139700@lunn.ch>
        <20201023082959.496d4596@gollum>
        <20201023130519.GB745568@lunn.ch>
Organization: Canonical Ltd
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.TdXVSi/3Y4+5OEE1_Mkq=X";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.TdXVSi/3Y4+5OEE1_Mkq=X
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Oct 2020 15:05:19 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, Oct 23, 2020 at 08:29:59AM +0200, Juerg Haefliger wrote:
> > On Wed, 21 Oct 2020 21:35:48 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> > > On Wed, Oct 21, 2020 at 05:00:53PM +0200, Juerg Haefliger wrote: =20
> > > > Hi,
> > > >=20
> > > > If the lan78xx driver is compiled into the kernel and the network c=
able is
> > > > plugged in at boot, /sys/class/net/eth0/carrier is stuck at 1 and d=
oesn't
> > > > toggle if the cable is unplugged and replugged.
> > > >=20
> > > > If the network cable is *not* plugged in at boot, all seems to work=
 fine.
> > > > I.e., post-boot cable plugs and unplugs toggle the carrier flag.
> > > >=20
> > > > Also, everything seems to work fine if the driver is compiled as a =
module.
> > > >=20
> > > > There's an older ticket for the raspi kernel [1] but I've just test=
ed this
> > > > with a 5.8 kernel on a Pi 3B+ and still see that behavior.   =20
> > >=20
> > > Hi J=C3=BCrg =20
> >=20
> > Hi Andrew,
> >=20
> >  =20
> > > Could you check if a different PHY driver is being used when it is
> > > built and broken vs module or built in and working.
> > >=20
> > > Look at /sys/class/net/eth0/phydev/driver =20
> >=20
> > There's no such file. =20
>=20
> I _think_ that means it is using genphy, the generic PHY driver, not a
> specific vendor PHY driver? What does
>=20
> /sys/class/net/eth0/phydev/phy_id contain.

There is no directory /sys/class/net/eth0/phydev.

$ ls /sys/class/net/eth0/
addr_assign_type  broadcast        carrier_down_count  dev_port  duplex    =
         ifalias  link_mode         netdev_group  phys_port_name  proto_dow=
n  statistics    type
addr_len          carrier          carrier_up_count    device    flags     =
         ifindex  mtu               operstate     phys_switch_id  queues   =
   subsystem     uevent
address           carrier_changes  dev_id              dormant   gro_flush_=
timeout  iflink   name_assign_type  phys_port_id  power           speed    =
   tx_queue_len


> > Given that all works fine as long as the cable is unplugged at boot poi=
nts
> > more towards a race at boot or incorrect initialization sequence or som=
ething. =20
>=20
> Could be. Could you run
>=20
> mii-tool -vv eth0

Hrm. Running that command unlocks the carrier flag and it starts toggling on
cable unplug/plug. First invocation:

$ sudo mii-tool -vv eth0
Using SIOCGMIIPHY=3D0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
  registers for MII PHY 1:=20
    1040 79ed 0007 c132 05e1 cde1 000f 0000
    0000 0200 0800 0000 0000 0000 0000 3000
    0000 0000 0088 0000 0000 0000 3200 0004
    0040 a000 a000 0000 a035 0000 0000 0000
  product info: vendor 00:01:f0, model 19 rev 2
  basic mode:   autonegotiation enabled
  basic status: autonegotiation complete, link ok
  capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-H=
D flow-control
  link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-H=
D flow-control

Subsequent invocation:

$ sudo mii-tool -vv eth0
Using SIOCGMIIPHY=3D0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
  registers for MII PHY 1:=20
    1040 79ed 0007 c132 05e1 cde1 000d 0000
    0000 0200 0800 0000 0000 0000 0000 3000
    0000 0000 0088 0000 0000 0000 3200 0004
    0040 a000 0000 0000 a035 0000 0000 0000
  product info: vendor 00:01:f0, model 19 rev 2
  basic mode:   autonegotiation enabled
  basic status: autonegotiation complete, link ok
  capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
  advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-H=
D flow-control
  link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-H=
D flow-control

In the first invocation, register 0x1a shows a pending link-change interrupt
(0xa000) which wasn't serviced (and cleared) for some reason. Dumping the
registers cleared that interrupt bit and things start working correctly
afterwards. Nor sure yet why that first interrupt is ignored.

...Juerg

=20
> in the good and bad case.
>=20
>    Andrew
>=20


--Sig_/.TdXVSi/3Y4+5OEE1_Mkq=X
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEhZfU96IuprviLdeLD9OLCQumQrcFAl+hUVAACgkQD9OLCQum
QrdlbQ//ZC+2nUCXi1POdbs//zcfLTpzvocih21hyS1A4oYj2lEm4mwUhdlJnkBJ
B0MsGhEzZe2e1EhjRrt4uQC3/nt2XEfIhm5UjDTSiJY1Df60z6PyclUs9B3DTHKz
4Tl9gK6zIGxZ9a7hU3SFUFzfrvsfhECrCIgnN7Tcu+rhxFKqRuskkZf4M1xT3b2g
u7rqk0QZMsaNHuY9qq1kUcGlC/Z1fd9seg5kNjjZH1SmkHq7SHll4mKd+2DTag0G
BnDLcCawln8Ra1P6d6n0NsgOgmVPy/zj2rteg5fMIa2h5jVjEWj8dpWCiGenOa6s
UW0cQRZdSqrSJWsMaRCKdJdrLhGjgZOQIkU+RTjPSDfIjthTsuCrm9mDyQGYQxCj
jWm1AxXFfKcGxPcTliPjZD1S2z8XtnvJ2Thlc26tX/I9VeD4JV5wiGB82f2s5Udw
dk2wPFRZ7N3q4X+k1yL0N41uHzDFyFSfpKTMoT/Y2/7dF/5wL1/ChyidopVl7bHy
uBIoso2eyFUTMI4X0BNkUASPrcrfx9JLsgPXzxlyzNPjtG/MeNgl1vuNIcPPP9Uu
w8fO0DiVElpCZkW8DtDaC7Sxb+z0zxRX6wL3G539MM/a5dlzKbCh55ffskfP/ow8
os9BQZ4iLXWXp4pNwVNmbKZw+ejH6ihuuTh0Gkk0nRrCouQKous=
=v7mM
-----END PGP SIGNATURE-----

--Sig_/.TdXVSi/3Y4+5OEE1_Mkq=X--
