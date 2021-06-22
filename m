Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF393B0EFE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhFVUyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVUyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:54:05 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EDDC061574;
        Tue, 22 Jun 2021 13:51:49 -0700 (PDT)
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 7A85B82958;
        Tue, 22 Jun 2021 22:51:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624395103;
        bh=UGQSxDCJVHD985fZkE4LY5R1JFavM/jcz7y/vooACM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZFcrtbwe+yoX0nGjX/keJJkQu3FpUawVBfyzVQRCyG/81ihDXTpLLz7aOgoi7lXVl
         J676vdA9KnnwgvsGW6doZqXsHu7vNVoII61cGXOrORC5kin18MjkdOet0NPh70fmao
         T3biEyn3WEmsYG6KQIlZttVSdlcWhD1cDd/cK4wxcG39+PtoR+dRX1JGUSXckzqTTU
         Mo9EYg1/M6mowwy8wIbc71N7HPZoTJ6A4/a3PWM4U6sFGc600P3tnh2PKiMkZGyaPL
         R1SX95SPDDBcZPEMN6CZ6zXBoVYmWtd21NCHVDUXzpVbtFUqAMlDyYIhkviVOOolyl
         abyXvi9pmB/kg==
Date:   Tue, 22 Jun 2021 22:51:34 +0200
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
Subject: Re: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Message-ID: <20210622225134.4811b88f@ktm>
In-Reply-To: <YNH3mb9fyBjLf0fj@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-2-lukma@denx.de>
        <YNH3mb9fyBjLf0fj@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/0ciD4Jn3iAhV8jMTp1q0XYL"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/0ciD4Jn3iAhV8jMTp1q0XYL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, Jun 22, 2021 at 04:41:09PM +0200, Lukasz Majewski wrote:
> > The 'eth_switch' node is now extendfed to enable support for L2
> > switch.
> >=20
> > Moreover, the mac[01] nodes are defined as well and linked to the
> > former with 'phy-handle' property. =20
>=20
> A phy-handle points to a phy, not a MAC! Don't abuse a well known DT
> property like this.

Ach.... You are right. I will change it.

Probably 'ethernet' property or 'link' will fit better?


>=20
>   Andrew
>=20



Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/0ciD4Jn3iAhV8jMTp1q0XYL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDSTVYACgkQAR8vZIA0
zr3wEwf+OHIgqiJP60VV3awR0B5lu4awGcOFGqK5MEB+Zhddu4xs1J7Hp6FcYMxa
m6hLxvWMgQW2c07AOFabjSwyAy6YsrZeWp4EejnlnyGAS79QQUYglCtmfq+Mkgwm
4pXZIYQlSz2mxGlauZeD8TFEAQUNkqtyaEL2umFcxhOj31IRTaM3WMfo0w5p1zoJ
c4ndU0zn3zJgQo5ohk3y3R/l5MfHu0SrexUSLfy0tGlv3ED4ZjsMn2zgBMuBe1Qh
rXjQO84IW1XYLWZme+XCd9B0n9lPlw/uz48v4vVFHDgwAH5Z65qONfQ+LxQOBy/9
KIjP6WqdJaV3eEQJhCq7B5IbJiSGeQ==
=T/Td
-----END PGP SIGNATURE-----

--Sig_/0ciD4Jn3iAhV8jMTp1q0XYL--
