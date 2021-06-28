Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C03B5B80
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 11:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhF1JoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 05:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhF1JoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 05:44:16 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979EAC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 02:41:50 -0700 (PDT)
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id F2C8182D8F;
        Mon, 28 Jun 2021 11:41:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624873307;
        bh=hoBYd6CWV9YH4xCQWXnMhTZi/vXy5/C5GrXBVN0L3CY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RqrOjUxRZFmcLYzW1xVXLVPyFzqGVyuYk2NBXszW8+ZvyCz9pK4rjCUGW4llzGGTL
         xol9ylCvcOz+cW3wSF0aCsu7wVoUjA9SkdlB5p+Bon+xJYAAHpyI6OY/zYV/HeaW24
         4rJzvld2lC/VGTp2DIYO0lY0uMWBqwzhpFGmtwHGUp9M4Ic34MBjtrj7cHXRA8UNVb
         pqVAu9/etzHO2tPH328A4wU1ad6vwjdoMhkYPu3IYPjdZzMtL3MEAVEE2gDJYzZOq/
         jwpYs7x1pG1FOQ4eDCEpS0TH8gMx0Ll/US1mLROGcMlgH/PiGS2rdc73iS1zTHYtdh
         O8F/EONw6LbLA==
Date:   Mon, 28 Jun 2021 11:41:39 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org
Subject: Re: [RFC 0/3] net: imx: Provide support for L2 switch as switchdev
 accelerator
Message-ID: <20210628114139.51d0efc2@ktm>
In-Reply-To: <20210625220432.lg2plfzkudoxbeer@skbuf>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210625220432.lg2plfzkudoxbeer@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/=ybwOgpd8uIRqN3e=sw/NJL"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=ybwOgpd8uIRqN3e=sw/NJL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Tue, Jun 22, 2021 at 04:41:08PM +0200, Lukasz Majewski wrote:
> > This patch series is a followup for the earlier effort [1]
> > to bring support for L2 switch IP block on some NXP devices.
> >
> > This time it augment the fec driver, so the L2 switch is treated
> > as a HW network accelerator. This is minimal, yet functional
> > driver, which enables bridging between imx28 ENET-MAC ports.
> >
> > Links:
> > [1] -
> > https://lwn.net/ml/linux-kernel/20201125232459.378-1-lukma@denx.de/
> > =20
>=20
> On which tree are these patches supposed to apply?
>=20
> Patch 1 doesn't apply on today's net-next.
> git am ~/incoming/*
> Applying: ARM: dts: imx28: Add description for L2 switch on XEA board
> error: arch/arm/boot/dts/imx28-xea.dts: does not exist in index
> Patch failed at 0001 ARM: dts: imx28: Add description for L2 switch
> on XEA board hint: Use 'git am --show-current-patch' to see the
> failed patch When you have resolved this problem, run "git am
> --continue". If you prefer to skip this patch, run "git am --skip"
> instead. To restore the original branch and stop patching, run "git
> am --abort".
>=20
> Patch 2 doesn't apply on today's linux-next.
> git am ~/incoming/*
> Applying: ARM: dts: imx28: Add description for L2 switch on XEA board
> Applying: net: Provide switchdev driver for NXP's More Than IP L2
> switch error: patch failed: drivers/net/ethernet/freescale/Makefile:27
> error: drivers/net/ethernet/freescale/Makefile: patch does not apply
> Patch failed at 0002 net: Provide switchdev driver for NXP's More
> Than IP L2 switch hint: Use 'git am --show-current-patch' to see the
> failed patch When you have resolved this problem, run "git am
> --continue". If you prefer to skip this patch, run "git am --skip"
> instead. To restore the original branch and stop patching, run "git
> am --abort".

Please use following repos:

- RFC v1 for switchdev (sent now):
https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12-L2-=
upstream-switchdev-RFC_v1

- RFC v1 for DSA:
https://source.denx.de/linux/linux-imx28-l2switch/-/commits/imx28-v5.12-L2-=
upstream-DSA-RFC_v1


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/=ybwOgpd8uIRqN3e=sw/NJL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDZmVMACgkQAR8vZIA0
zr3QiQgA2deLIxPI8IRbDZOZaYgrbcajPpz5VPSpHZ5AQxsS/muD2juH3JuaCMtm
BM5E+oi1DIBNeaMb2fwVaHi+fdOMDlslxAeT8sz0xmLygeqtBmentmF0KMaV4sTL
RPQN0xzebm+GeOG/D3TGbDWKgWt1oUZuPyXWpAauGbBziLRnIXBdHRNRNJWUiYJb
WDbBb+5nZrRNx/fVAPZHvx8u2/iEXro3beBuCG8wVsXblNDr9MKVoj6a7FY1ULyv
oUmCXGEgCMRyVvQ3dwns172hD5uxgSsJCCz5aXCLeweMO5NtlCnLMvtpAcoxLFRj
5JLu41ofEwYkENlM6aEtygZxXt6PxQ==
=l3wa
-----END PGP SIGNATURE-----

--Sig_/=ybwOgpd8uIRqN3e=sw/NJL--
