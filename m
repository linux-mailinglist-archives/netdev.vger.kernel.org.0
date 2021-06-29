Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1FF3B6F14
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 10:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhF2IMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 04:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbhF2IMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 04:12:15 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95104C061574;
        Tue, 29 Jun 2021 01:09:48 -0700 (PDT)
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E4BBD83121;
        Tue, 29 Jun 2021 10:09:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624954185;
        bh=FAYNqeS6gRGT1P8zbOQz0D0+tAy4ISiTRiBKF07uiQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GLHdqpew3bzBUNovke7LKaB7cbIEq1WsFEPwluQ0YnsIIF90LBjiWx5OlpwJDxRLL
         YNWcxKuSo5YdPtE2sGajLZ3ijq4uewTTWl+MJllYZis15d43iaGY0ClURiuKeMcbuc
         mGGDTYAP7Vgkz9NyqgzKJ1U5AeDqxUEsU6yxZXIUEPej2xDdl6y7QDAIAGtS6cllZz
         QA1TcdGHIHr8JppI+r543IZuvolFYdZSpncVEKTpcaXvfdV8ySdHjJEZsBiymwYvLZ
         LgAEmzjPszd9huv+IGU9cjNVG9SMBMHcAX/uM1Wql3bhdC5yD2FZ8jqkvvRIOeBSIq
         xvdcwZe/RJHow==
Date:   Tue, 29 Jun 2021 10:09:37 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210629100937.10ce871d@ktm>
In-Reply-To: <20210628142329.2y7gmykoy7uh44gd@skbuf>
References: <YNOTKl7ZKk8vhcMR@lunn.ch>
        <20210624125304.36636a44@ktm>
        <YNSJyf5vN4YuTUGb@lunn.ch>
        <20210624163542.5b6d87ee@ktm>
        <YNSuvJsD0HSSshOJ@lunn.ch>
        <20210625115935.132922ff@ktm>
        <YNXq1bp7XH8jRyx0@lunn.ch>
        <20210628140526.7417fbf2@ktm>
        <20210628124835.zbuija3hwsnh2zmd@skbuf>
        <20210628161314.37223141@ktm>
        <20210628142329.2y7gmykoy7uh44gd@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/fL/0X0KY/DOM/P3UCC=9=NJ"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fL/0X0KY/DOM/P3UCC=9=NJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Mon, Jun 28, 2021 at 04:13:14PM +0200, Lukasz Majewski wrote:
> > > > > So before considering merging your changes, i would like to
> > > > > see a usable binding.
> > > > >
> > > > > I also don't remember seeing support for STP. Without that,
> > > > > your network has broadcast storm problems when there are
> > > > > loops. So i would like to see the code needed to put ports
> > > > > into blocking, listening, learning, and forwarding states.
> > > > >
> > > > > 	  Andrew =20
> > >
> > > I cannot stress enough how important it is for us to see STP
> > > support and consequently the ndo_start_xmit procedure for switch
> > > ports. =20
> >
> > Ok.
> > =20
> > > Let me see if I understand correctly. When the switch is enabled,
> > > eth0 sends packets towards both physical switch ports, and eth1
> > > sends packets towards none, but eth0 handles the link state of
> > > switch port 0, and eth1 handles the link state of switch port 1? =20
> >
> > Exactly, this is how FEC driver is utilized for this switch. =20
>=20
> This is a much bigger problem than anything which has to do with code
> organization. Linux does not have any sort of support for unmanaged
> switches.

My impression is similar. This switch cannot easily fit into DSA (lack
of appending tags) nor to switchdev.

The latter is caused by two modes of operation:

- Bypass mode (no switch) -> DMA1 and DMA0 are used
- Switch mode -> only DMA0 is used


Moreover, from my understanding of the CPSW - looks like it uses always
just a single DMA, and the switching seems to be the default operation
for two ethernet ports.

The "bypass mode" from NXP's L2 switch seems to be achieved inside the
CPSW switch, by configuring it to not pass packets between those ports.

> Please try to find out if your switch is supposed to be able
> to be managed (run control protocols on the CPU).

It can support all the "normal" set of L2 switch features:

- VLANs, lookup table (with learning), filtering and forwarding
  (Multicast, Broadcast, Unicast), priority queues, IP snooping, etc.

Frames for BPDU are recognized by the switch and can be used to
implement support for RSTP. However, this switch has a separate address
space (not covered and accessed by FEC address).

> If not, well, I
> don't know what to suggest.

For me it looks like the NXP's L2 switch shall be treated _just_ as
offloading IP block to accelerate switching (NXP already support
dpaa[2] for example).

The idea with having it configured on demand, when:
ip link add name br0 type bridge; ip link set br0 up;
ip link set eth0 master br0;
ip link set eth1 master br0;

Seems to be a reasonable one. In the above scenario it would work hand
by hand with FEC drivers (as those would handle PHY communication
setup and link up/down events).

It would be welcome if the community could come up with some rough idea
how to proceed with this IP block support (especially that for example
imx287 is used in many embedded devices and is going to be in active
production for next 10+ years).


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/fL/0X0KY/DOM/P3UCC=9=NJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDa1UEACgkQAR8vZIA0
zr1otAgApnelllapqfHrULNWTGmc4JtHdczHLbYNZ3aX3DM56WYNVRgs9kTJ3+Pt
fz6pXAGbdGmbqufMiOeATp2Tuj9kT/YJB/W9/hrjUn7Ret6nvCPup/XTjn2UcQPh
8jdtyDYX61vqz/Lzj2Fzlb1tdGUzzKJ0p+aACRz5X63P6nWMsRzmU1L5/hwwUErc
w2tQORjpOQa1CyHfmHpud2g7URlC7yjHoPqcdHVtDwtPDmx3XOHHpJ3fQv+OcTuf
nlWaB/9C2A5jTLwGXN2f9u/UVYe89t21E153rln9wLWwvPcBgGjjmbeq+Oh2XDrf
GflLEKetwCp+7ukQhre3EhVfk4HTug==
=K7rH
-----END PGP SIGNATURE-----

--Sig_/fL/0X0KY/DOM/P3UCC=9=NJ--
