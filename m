Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6515C3B2DBB
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 13:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhFXLX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 07:23:58 -0400
Received: from phobos.denx.de ([85.214.62.61]:51020 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232005AbhFXLX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 07:23:57 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 39BF58295B;
        Thu, 24 Jun 2021 13:21:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624533696;
        bh=WZ94MCj4P+1Tk4h3F6uSezgDTShoq+YXMzbRU4lNdl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PQljBxM3U7Mwv1StnBH3q2AmOPZ3PGkD6TS8yT3nkYx9SZVR5O4K7ITVan/aSo8Ee
         CWOik36TaaA2kTppomLMpshRTtqwtmzgircbjHrVMAnmz4VSXEiIulzI0BLFNDZCEK
         7OdMhkg26Ge0LTHvdz6rz99rTvMO17wFbmSRb4vycBjd7V2HJA1ROp3CP7773T7iDR
         7ih48a4UnB9YT2r2eq9EFRfryEpq02rw31Xnq69pw7+mnQaLGWhTdRk1C9I4bo8pzu
         UngHAd4NdV5y3RxgW8QXx/GrH1XNVctHG7nwmBIyl5quSX54yJYU/IPfnf76mda+Wt
         cV3wS6JvSRKCg==
Date:   Thu, 24 Jun 2021 13:21:29 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Message-ID: <20210624132129.1ade0614@ktm>
In-Reply-To: <DB8PR04MB679567B66A45FBD1C23E7371E6079@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-2-lukma@denx.de>
        <YNH3mb9fyBjLf0fj@lunn.ch>
        <20210622225134.4811b88f@ktm>
        <YNM0Wz1wb4dnCg5/@lunn.ch>
        <20210623172631.0b547fcd@ktm>
        <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
        <DB8PR04MB679567B66A45FBD1C23E7371E6079@DB8PR04MB6795.eurprd04.prod.outlook.com>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/kZDyde/N75IDMut=SSq/AH7"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kZDyde/N75IDMut=SSq/AH7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Joakim,

> Hi Lukasz, Florian, Andrew,
>=20
> > > Maybe somebody from NXP can provide input to this discussion - for
> > > example to sched some light on FEC driver (near) future. =20
> >=20
> > Seems like some folks at NXP are focusing on the STMMAC controller
> > these days (dwmac from Synopsys), so maybe they have given up on
> > having their own Ethernet MAC for lower end products. =20
>=20
> I am very happy to take participate into this topic, but now I have
> no experience to DSA and i.MX28 MAC, so I may need some time to
> increase these knowledge, limited insight could be put to now.

Ok. No problem :-)

>=20
> Florian, Andrew could comment more and I also can learn from it :-),
> they are all very experienced expert.

The main purpose of several RFCs for the L2 switch drivers (for DSA [1]
and switchdev [2]) was to gain feedback from community as soon as
possible (despite that the driver lacks some features - like VLAN, FDB,
etc).

>=20
> We also want to maintain FEC driver since many SoCs implemented this
> IP, and as I know we would also use it for future SoCs.
>  =20

Florian, Andrew, please correct me if I'm wrong, but my impression is
that upstreaming the support for L2 switch on iMX depends on FEC driver
being rewritten to support switchdev?

If yes, then unfortunately, I don't have time and resources to perform
that task - that is why I have asked if NXP has any plans to update the
FEC (fec_main.c) driver.


Joakim, do you have any plans to re-factor the legacy FEC driver
(fec_main.c) and introduce new one, which would support the switchdev?

If NXP is not planning to update the driver, then maybe it would be
worth to consider adding driver from [2] to mainline? Then I could
finish it and provide all required features.


Links:
[1] -
https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12-L2-=
upstream-DSA-RFC_v1
[2] -
https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12-L2-=
upstream-switchdev-RFC_v1

> Best Regards,
> Joakim Zhang




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/kZDyde/N75IDMut=SSq/AH7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDUarkACgkQAR8vZIA0
zr06nwf9G3OmyXuWlJdIM3Nl2cegkp7d1CLCHKra/d6RG6rtaMZEoF/bWU6XLAf2
+F+8UwamTxsqNgH0MYQ28KYoGjOTdq6fhN5tJbwin30oUkTfMzsWfANVSaZL3WLL
LR9EOWZ2e9qzFnq5608+WIwEe8VPg3TxmeiDctM7vZ0cOqL9jOeMcoI73DTfNTRB
wOEu6Pu6NjQeXEPJQ/+JJfw1KGHinFXc2RJRpPM5cW6QM+3FbmIe5y8KhEu8tD2x
UFPOfYSi9dck8IeFVk40Eo/2OXpSi0arPJMoH7K2Pxtcg8zreXLAjsU+0azNBfl6
Y85uaWBHWTBnPPiLLqY2WCgX8rBwZg==
=zkQk
-----END PGP SIGNATURE-----

--Sig_/kZDyde/N75IDMut=SSq/AH7--
