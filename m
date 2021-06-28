Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7327D3B5FC1
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 16:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhF1OQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 10:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbhF1OQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 10:16:57 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D4DC061574;
        Mon, 28 Jun 2021 07:14:31 -0700 (PDT)
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0936382D99;
        Mon, 28 Jun 2021 16:14:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624889670;
        bh=cp1cf2Pxe0kBcHekX+WRiiQZeAdeefRnxQtf2HuonEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xs6P4yFI3NFPb9yrY4va3T/lw3IavCIPiqOtiqlGmPIaWIVmmCDhoVeh62mUdavZT
         vcYDTrbAa1fRpAj31o+qEP+1QYpil3RTWBETRH0f6Q1x+XQLIRuDt8SS9KT1JqZytJ
         BaNnfcI0tN383+ioUHuIvEuZfzXeYUgWoBWqxnGsIO9kEb21O+aS+7s/CdJ0DgRdfm
         cvXz3G1G327g30r2n2vdl3sPW2EEXXuIGYb8wzwewQCG5MJwtastp5nLlufTzqFGir
         bmL0zsGkbLZx9sUfOofBVJBsZvdhz8gccAGSG2V47zgQyBZaasrdBRly+jAMitQfyf
         4pOobIQmdIpRg==
Date:   Mon, 28 Jun 2021 16:14:29 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210628161429.5650221e@ktm>
In-Reply-To: <YNnNNkjOiH6hd2l9@lunn.ch>
References: <YNH7vS9FgvEhz2fZ@lunn.ch>
        <20210623133704.334a84df@ktm>
        <YNOTKl7ZKk8vhcMR@lunn.ch>
        <20210624125304.36636a44@ktm>
        <YNSJyf5vN4YuTUGb@lunn.ch>
        <20210624163542.5b6d87ee@ktm>
        <YNSuvJsD0HSSshOJ@lunn.ch>
        <20210625115935.132922ff@ktm>
        <YNXq1bp7XH8jRyx0@lunn.ch>
        <20210628140526.7417fbf2@ktm>
        <YNnNNkjOiH6hd2l9@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/B0oPi=bG/QlkwYJ9VLxnZ_Q"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/B0oPi=bG/QlkwYJ9VLxnZ_Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > The best I could get would be:
> >=20
> > &eth_switch {
> > 	compatible =3D "imx,mtip-l2switch";
> > 	reg =3D <0x800f8000 0x400>, <0x800fC000 0x4000>;
> >=20
> > 	interrupts =3D <100>;
> > 	status =3D "okay";
> >=20
> > 	ethernet-ports {
> > 		port1@1 {
> > 			reg =3D <1>;
> > 			label =3D "eth0";
> > 			phys =3D <&mac0 0>;
> > 		};
> >=20
> > 		port2@2 {
> > 			reg =3D <2>;
> > 			label =3D "eth1";
> > 			phys =3D <&mac1 1>;
> > 		};
> > 	};
> > };
> >=20
> > Which would abuse the "phys" properties usages - as 'mac[01]' are
> > referring to ethernet controllers. =20
>=20
> This is not how a dedicated driver would have its binding. We should
> not establish this as ABI.
>=20
> So, sorry, but no.

Thanks for the clear statement about upstream requirements.

>=20
>     Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/B0oPi=bG/QlkwYJ9VLxnZ_Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDZ2UUACgkQAR8vZIA0
zr0XwggA3Y28inG1uYB+DNwvMI6o/9poYMwW2clfHhSNMw+PDdzCx5tWGs3uHae4
95i1e5vCUJI+6Ja2/C7FlJ5XWywKp2sVQDMR+3j/3qf210rDZMYwmiiJ4zeTGFtP
PGVpUTHhaBK7Jn/zgYSaDOK8HWFvLMcZ/vcS8ubm8SY0cCmqB2Shyohhj7ClD3Mi
bv/SOoPYEqFjNadbCw4PAgw/GYBd7cJKBc9HsCj/kB2DJ2JleNeikqEqND4HVmeC
yPhYpj/MumCZtCUnp+cxdipm56iSbHtK7AuNc3j05YUVt3fT8a4NGmXdfKDH0ItU
8kPvTxmqWhhl+UbgxDvCOeF1mqz5fg==
=Djon
-----END PGP SIGNATURE-----

--Sig_/B0oPi=bG/QlkwYJ9VLxnZ_Q--
