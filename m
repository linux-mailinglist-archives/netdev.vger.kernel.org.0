Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F973B2D2A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhFXLFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:05:25 -0400
Received: from phobos.denx.de ([85.214.62.61]:59514 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhFXLFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 07:05:24 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 2414F8295B;
        Thu, 24 Jun 2021 13:03:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624532584;
        bh=fGm0T8Lbml34Qr9AAhqKQL63kLABeHqysjK/Yo91Ga8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j6UMUqtNHAsp37BhkwS1I4m7ZyxFMN2gvlGLEu3988FvoHhmSnbeeRM1Hy28WIAuv
         ES7KNIbMnh4a+W9jTqvBBr+YNaVFAtPh8P21j5kwL7ZpEf2Tm2OoG8NYOPiKbWtMWf
         4qJ/0I/MxoLcwzyv29+y1Wxe9/HkWDURky4tui3BtZHxhXABBf9DR/MBp6MxhH3pRZ
         1MlzGqkCCmDpefQumYOMddx1ljcSyiUUS5B9dEGg+eP/vlljla8I7L1gEC3HUc+zV0
         u577hvPtHjDmOGKjE9FDp60sajRI7kUMwm/4maNjf+LjnhF9LHGBAbQWQKvlrQ8fRJ
         BzZWr6L4Xt22g==
Date:   Thu, 24 Jun 2021 13:03:03 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Message-ID: <20210624130303.69234c5f@ktm>
In-Reply-To: <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-2-lukma@denx.de>
        <YNH3mb9fyBjLf0fj@lunn.ch>
        <20210622225134.4811b88f@ktm>
        <YNM0Wz1wb4dnCg5/@lunn.ch>
        <20210623172631.0b547fcd@ktm>
        <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/dBIl/ADP18V9J//d45PAqlF"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/dBIl/ADP18V9J//d45PAqlF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Jun 2021 17:36:59 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> On 6/23/2021 8:26 AM, Lukasz Majewski wrote:
> > Hi Andrew,
> >  =20
> >> On Tue, Jun 22, 2021 at 10:51:34PM +0200, Lukasz Majewski wrote: =20
> >>> Hi Andrew,
> >>> =20
> >>>> On Tue, Jun 22, 2021 at 04:41:09PM +0200, Lukasz Majewski wrote:
> >>>> =20
> >>>>> The 'eth_switch' node is now extendfed to enable support for L2
> >>>>> switch.
> >>>>>
> >>>>> Moreover, the mac[01] nodes are defined as well and linked to
> >>>>> the former with 'phy-handle' property. =20
> >>>>
> >>>> A phy-handle points to a phy, not a MAC! Don't abuse a well known
> >>>> DT property like this. =20
> >>>
> >>> Ach.... You are right. I will change it.
> >>>
> >>> Probably 'ethernet' property or 'link' will fit better? =20
> >>
> >> You should first work on the overall architecture. I suspect you
> >> will end up with something more like the DSA binding, and not have
> >> the FEC nodes at all. Maybe the MDIO busses will appear under the
> >> switch?
> >>
> >> Please don't put minimal changes to the FEC driver has your first
> >> goal. We want an architecture which is similar to other switchdev
> >> drivers. Maybe look at drivers/net/ethernet/ti/cpsw_new.c. =20
> >=20
> > I'm a bit confused - as I thought that with switchdev API I could
> > just extend the current FEC driver to add bridge offload.
> > This patch series shows that it is doable with little changes
> > introduced. =20
>=20
> Regardless of how you end up implementing the switching part in the=20
> driver, one thing that you can use is the same DT binding as what DSA=20
> uses as far as representing ports of the Ethernet controller. That
> means that ports should ideally be embedded into an 'ethernet-ports'
> container node, and you describe each port individually as sub-nodes
> and provide, when appropriate 'phy-handle' and 'phy-mode' properties
> to describe how the Ethernet PHYs are connected.

I see. Thanks for the explanation.

>=20
> >=20
> > However, now it looks like I would need to replace FEC driver and
> > rewrite it in a way similar to cpsw_new.c, so the switchdev could be
> > used for both cases - with and without L2 switch offload.
> >=20
> > This would be probably conceptually correct, but i.MX FEC driver has
> > several issues to tackle:
> >=20
> > - On some SoCs (vf610, imx287, etc.) the ENET-MAC ports don't have
> > the same capabilities (eth1 is a bit special)
> >=20
> > - Without switch we need to use DMA0 and DMA1 in the "bypass" switch
> >    mode (default). When switch is enabled we only use DMA0. The
> > former case is best fitted with FEC driver instantiation. The
> > latter with DSA or switchdev.
> >  =20
> >> The cpsw
> >> driver has an interesting past, it did things the wrong way for a
> >> long time, but the new switchdev driver has an architecture
> >> similar to what the FEC driver could be like.
> >>
> >> 	Andrew =20
> >=20
> > Maybe somebody from NXP can provide input to this discussion - for
> > example to sched some light on FEC driver (near) future. =20
>=20
> Seems like some folks at NXP are focusing on the STMMAC controller
> these days (dwmac from Synopsys), so maybe they have given up on
> having their own Ethernet MAC for lower end products.

For example, the imx287 SoC is still active product and is supposed
to be produced for at least 15 years after release.=20

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/dBIl/ADP18V9J//d45PAqlF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDUZmcACgkQAR8vZIA0
zr0riAgAmguR7l9mkDSlLUcd2kv7qDGfA2yM3+qNNMWQe4dsNuyQbHAkp/snyQ2g
Cnk6x6K0YJJrFLSIQ8B0id3xxtAC9tHUKXortj0orb1ut7p62I40ZgPjbjqIs+Je
1tJfklU1Zzs3REnPD/VhKjZ5pl4ZgWrU1pUQL178eniMEecQpnTTiIoHhwyoURDg
LUZp7lmb3QTwGZQIyzL3MhqA2jb7XUC0MEv+MlJJIooDeTPNfdxr9GzUOy+DJGxw
16/YJpIsHDU9XH8Fyxue4DOC7e4k3JXlLFcRZTMdr9e+mljEp/wDv8yqBQHajRGl
3VSbL4Nzv5VKJpmTTRpOu1RdJHDIyQ==
=m1KK
-----END PGP SIGNATURE-----

--Sig_/dBIl/ADP18V9J//d45PAqlF--
