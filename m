Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20B32C6174
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgK0JQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:16:57 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:51681 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgK0JQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:16:57 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4Cj8C92TpMz1qtdL;
        Fri, 27 Nov 2020 10:16:52 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4Cj8C84Tq9z1sy8T;
        Fri, 27 Nov 2020 10:16:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id Hlz0i54BBvVV; Fri, 27 Nov 2020 10:16:50 +0100 (CET)
X-Auth-Info: dpfPVe1hPmNWlW+Q/vLI2GSLKIjsjgRdBsMJ0e9s11A=
Received: from jawa (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Nov 2020 10:16:50 +0100 (CET)
Date:   Fri, 27 Nov 2020 10:16:15 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on
 i.MX28 SoC
Message-ID: <20201127101615.7349b35f@jawa>
In-Reply-To: <20201127005502.GQ2075216@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126123027.ocsykutucnhpmqbt@skbuf>
        <20201127003549.3753d64a@jawa>
        <20201127005502.GQ2075216@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/BICa7OL/1Ul3q5t3kEEq_yA"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/BICa7OL/1Ul3q5t3kEEq_yA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > (A side question - DSA uses switchdev, so when one shall use
> > switchdev standalone?) =20
>=20
> DSA gives you a framework for an Ethernet switch connected to a host
> via Ethernet for the data plane. Generally, that Ethernet link to the
> switch is a MAC to MAC connection. It can be PHY to PHY. But those are
> just details. The important thing is you use an Ethernet driver on the
> host.
>=20
> If you look at pure switchdev devices, they generally DMA frames
> directly into the switch. There is either one DMA queue per switch
> port, or there is a way to multiplex frames over one DMA queue,
> generally by additional fields in the buffer descriptor.
>=20
> For this device, at the moment, it is hard to say which is the best
> fit. A lot will depend on how the FEC driver works, if you can reuse
> it, while still having the degree of control you need over the DMA
> channel. If you can reuse the FEC driver, then a DSA driver might
> work. If the coupling it too loose, and you have to take control of
> the DMA, then a pure switchdev driver seems more appropriate.
>=20
>     Andrew
>=20

Thanks for the detailed explanation.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/BICa7OL/1Ul3q5t3kEEq_yA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl/Aw98ACgkQAR8vZIA0
zr1EVAf+PndkSAVobok+I5hCS6pcZwgjc9jS944Kx4NLmKOd3Ckv/bebz9TUDuou
P6veKuA53l3aUKaOjdCNntFPdVA1zntozoogSGA63O+LWjnxkqrkLqXUqzAjULmT
Oo3QX7LctuMmrFPOWm7LVvETNx4BgSkuC8pBtjF1zUbp6H7O6uTFdhY7dBn1xmS6
onIfzHulhLPY6s+VDjIVvFJRtpNXfDBXBufcxDMTZ6sH/qs3CDk+9NWPb/f1FHRd
P4+MSy7NV8FXFlZOqR2SeMPWzylGFVfJAiOcrl+3dl0/0IHP9gVkTOPt7bE3krda
q7kXFFbpJRkLDPPwzF7AfBHvw2yxzw==
=vIQY
-----END PGP SIGNATURE-----

--Sig_/BICa7OL/1Ul3q5t3kEEq_yA--
