Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A678012DCD4
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 02:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgAABKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 20:10:32 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53721 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 20:10:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id m24so2830943wmc.3
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 17:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BMVACOLyhCuv9p4CVdepD/sdEmDNfTie/NP95io9W9A=;
        b=uc/ULnnRYCm5WBeT1oIBvc8Y5ifhEZTtSwr2SOGGmtUv3xaHmO5DwWRZRcPL2ooit6
         dD3SgHCt79KdsqOwMi378ae131QF37Jpryz+AgoYiwd4ojqGYCDPTTKhSXnVrPcbg1Q2
         iy7nd02m2Yg1zWjev8UfyapAFRONF0sjnPLctp1yNWr1fKTuEi+pwXd4WN750sv4W3rs
         hoMbyfmLlPFU42c9/iO5GXKlkfhejCu0T0LXCWnGyQOgYq6IPiB7Il3Cpc5xpvNgZe7X
         Z7TMN+DPDSarps+4EcCMT8Cntb1kQvTsj0oz1U51qsKnkJ2gBDhOzNFOygHltrhXGrbe
         c/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BMVACOLyhCuv9p4CVdepD/sdEmDNfTie/NP95io9W9A=;
        b=tSn5epPsmQaF6adeVYnii/PkwVacfWGtVO2hl41t4yRrmNDHV8EGGC8uXXRoYMdBqH
         ec4ucaSa75LMTIGbZpus6//6egP+bIJjF1pt1a6fV744lLhTKc9qI8unor1PsFYT/uqn
         HQQOubPc5VkrBqyph6rAVM2ZFQOX/WlFpAwRd0WGAIHq3FIi9NDjAoLWWOqRX8Upr5XS
         /GRbVL3fpD8AW/ud365AbPOWjwI37SxOIsLK3IbjfCkJAOI0bNXiCsfKEuL9p+hnnGj/
         BB+Q69+Dwt6U0/FckOzpPfzvAA90K7NA78q1jyE0jfogQzp66S4Bj2nDiYaXh+sFyVYu
         Ayjg==
X-Gm-Message-State: APjAAAXzrwBQ7dHtILef9HL1ZUyY9b91h+JNCyCFjhd0BvmKh6CAc66l
        qoF476NADmXehQ4+OJo5nAE=
X-Google-Smtp-Source: APXvYqzrPc2LwANzX7zQaqqZs7uVNBLW5eQNXV2ID3Zqs5CDcjgRNX1aunBykntAz1/GdZcpIyZphw==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr6200219wmi.166.1577841029838;
        Tue, 31 Dec 2019 17:10:29 -0800 (PST)
Received: from pali ([2a02:2b88:2:1::5cc6:2f])
        by smtp.gmail.com with ESMTPSA id z11sm51206087wrt.82.2019.12.31.17.10.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Dec 2019 17:10:28 -0800 (PST)
Date:   Wed, 1 Jan 2020 02:10:27 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200101011027.gpxnbq57wp6mwzjk@pali>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali>
 <20191231180614.GA120120@splinter>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="phnrv7jhts2jnaxk"
Content-Disposition: inline
In-Reply-To: <20191231180614.GA120120@splinter>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--phnrv7jhts2jnaxk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tuesday 31 December 2019 20:06:14 Ido Schimmel wrote:
> On Tue, Dec 31, 2019 at 05:10:20PM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 22 December 2019 19:22:35 Russell King - ARM Linux admin wrot=
e:
> > > Hi,
> > >=20
> > > I've been trying to configure DSA for VLANs and not having much succe=
ss.
> > > The setup is quite simple:
> > >=20
> > > - The main network is untagged
> > > - The wifi network is a vlan tagged with id $VN running over the main
> > >   network.
> > >=20
> > > I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying =
to
> > > setup to provide wifi access to the vlan $VN network, while the switch
> > > is also part of the main network.
> >=20
> > Hello, I do not know if it is related, but I have a problem with DSa,
> > VLAN and mv88e6085 on Espressobin board (armada-3720).
> >=20
> > My setup/topology is similar:
> >=20
> > eth0 --> main interface for mv88e6085 switch
>=20
> This is the DSA master interface?

Yes.

> > wan --> first RJ45 port from eth0
> > lan0 --> second RJ45 port from eth0
> > wan.10 --> unpacked VLAN with id 10 packets from wan
> >=20
> > Just one note, wan and wan.10 uses different MAC addresses.
>=20
> Is this something you configured?

Yes. My configuration is:

  ip link set dev wan address <address1>
  ip link add link wan name wan.10 type vlan id 10
  ip link set dev wan.10 address <address2>

Just to note that same setup on Raspberry PI is working fine. Here on
Raspberry PI for second RJ45 port I'm using external USB based network
adapter, so DSA on RPI is not used at all. Which means that Linux kernel
does not have any problem with setting / using two different MAC
addresses on one physical network adapter.

> By default the MAC address of the VLAN
> device should be inherited from the real device. What happens if they
> have the same MAC address?

I do not know. I have not tested this scenario. Currently I have my
Espressobin with mv88e6085 out of my hands and is disconnected from
internet, so I cannot do this test right now.

> > Also lan0 has another MAC address.
> >=20
> > Basically on upstream wan are two different/separated networks. First
> > one is untagged, second one is tagged with vlan id 10 and tagged packets
> > should come on wan interface (linux kernel then pass untagged packets to
> > wan and vlan id 10 tagged as "untagged" to wan.10). lan0 is downstream
> > network and in this configuration Espressobin works as router. So there
> > is no switching between RJ45 ports, all packets should come to CPU and
> > Linux's iptables do all stuff.
> >=20
> > And now the problem. All (untagged) traffic for first network on wan
> > works fine (incoming + outgoing). Also all outgoing packets from wan.10
> > interface are correctly transmitted (other side see on first RJ45 port
> > that packets are properly tagged by id 10). But for unknown reason all
> > incoming packets with vlan id 10 on first RJ45 port are dropped. Even
> > tcpdump on eth0 does not see them.
> >=20
> > Could be this problem related to one which Russel described? I tried to
> > debug this problem but I give up 2 days before Russel send this email
> > with patches, so I have not had a chance to test it.
>=20
> I'm not sure. I believe Russel was not able to receive tagged packets at
> all and he was using a bridged setup, unlike you (IIUC). Also, below you
> write that sometimes you're able to receive packets with VLAN 10.

Yes, sometimes I was able to receive packets, but I run this setup for
about 4 hours (or more) and only few times (for 5 minutes) it worked.

> > One very strange behavior is that sometimes mv88e6085 starts accepting
> > those vlan id 10 packets and kernel them properly send to wan.10
> > interface and userspacee applications see them. And once they start
> > appearing it works for 5 minutes, exactly 300s. After 300s they are
> > again silently somehow dropped (tcpdump again does not see them). I was
> > not able to detect anything which could cause that kernel started seeing
> > them. Looks for me it was really random. But exact time 300s is really
> > strange.
>=20
> 300 seconds is the default ageing time the Linux bridge uses, so maybe
> the problem is the hardware FDB table and not the VLAN filter.
>=20
> Andrew / Vivien, how routed traffic is handled on this platform? Is it
> possible that the FDB table is consulted first and the expectation is
> that it would direct the packet towards the CPU port? If so, I guess
> that the FDB entry with {VID 10, wan.10's MAC} is aged-out and flooding
> towards the CPU is disabled?

Hm... that is interesting.

When run was running tcpdump I did not passed -p flag, so tcpdump
automatically was listening in promiscuous mode.

And I was trying those tests also with setting "promisc" mode via ip
link and nothing was changed.

So if above is truth then also promiscuous mode is broken and filtered.

(I expect that network adapter in promiscuous mode receive also packets
which target MAC address is not same as MAC address configured for
network interface.)

> >=20
> > I used default Debian Buster kernel (without any custom patches). Also
> > one from Debian Buster backports, but behavior was still same.
> >=20
> > --=20
> > Pali Roh=C3=A1r
> > pali.rohar@gmail.com
>=20
>=20

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--phnrv7jhts2jnaxk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCXgvxgQAKCRCL8Mk9A+RD
UtUKAKCqAAE1ysrL8b+iqVV6GxC1YONIaACfUmx9F9Yhh3YA9B2tUMx4PN46who=
=R7mU
-----END PGP SIGNATURE-----

--phnrv7jhts2jnaxk--
