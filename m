Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6992FAAC6
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394148AbhART73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:59:29 -0500
Received: from www.zeus03.de ([194.117.254.33]:58626 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437718AbhART7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 14:59:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=hWC19t01slxsPcNvQ/0kN839uywX
        RCagmir824zkmEQ=; b=2/YkoMLfdsytNzElpmppMLW9n/ojueRuAgpQHZo9BfoT
        YaYAO1FC/wGsjj7QI9rQ9egMSpqx8bAv6vyaHPYy8ZjfwUoNQ9sKaMpzBrlJdXVx
        rGn892+q1nFZD7RKGC5sIywmn4QMphydl51hRcqQBwbSd3eQNR1/hiXm6lRF+D4=
Received: (qmail 828670 invoked from network); 18 Jan 2021 20:58:09 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 18 Jan 2021 20:58:09 +0100
X-UD-Smtp-Session: l3s3148p1@1ZghJDK5BIkgAwDPXwacAOByz8F9Mgm1
Date:   Mon, 18 Jan 2021 20:58:07 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] mdio-bitbang: Export mdiobb_{read,write}()
Message-ID: <20210118195807.GA112457@ninjato>
References: <20210118150656.796584-1-geert+renesas@glider.be>
 <20210118150656.796584-2-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20210118150656.796584-2-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 18, 2021 at 04:06:55PM +0100, Geert Uytterhoeven wrote:
> Export mdiobb_read() and mdiobb_write(), so Ethernet controller drivers
> can call them from their MDIO read/write wrappers.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmAF6EoACgkQFA3kzBSg
Kbb6MQ/8DyjaZqaYekA2sZYyEPLPMI+AaqgnJY/ykPCdtDmBD+ESZ7Jvg6EJ4tKZ
2KSNCHLUxko21/vBj7Le6UycRTxB2G5KfaYvrTq2MRRxaA6KThA2ZNyxW1RTUCbp
Kcus8xuAT2XGw2x7SM7ko1vrEQLm6CwBlq/kzqJShXr56HniuZM7tnNNgz3ynUGW
toAWvjyG76OyuBw4oBeu+NaXbUUdVSSwjbbXUwAUsXCGltgtFWFMdtrLQ1y+HolB
Hm6fGhGG/lywH5gFywC/fl4RfZZgzz+GdtwljZmuPkHQk5jqCPS07a/oGcM/pgh0
GGrwBzcy28vGj3vMT23yzIckCWdgk+4WUSpoOPGNmRg34WTgjjUcRXusY2Tmb6aS
KDy++GH1I3Ch0CgJQg7pr2krYXc2LakfxMRr45775lDjXplQR9L+TNOPa454/Eph
+X13F7ns2ibL1lI5Q0BqxmJsvNz4f8fconEhr7l1MJaKY0HMCTF3tmnYXDXLjmPu
X+ldBatXL71OPQ8sZj8GYDaeNe1BINzj1XV7C/zE1LvO32OQmiBjNMypTeh2apdd
LU6U7YH8YMsEL8jJASJM2xoGMYlY8BwqjpKLBnMT3vMTuSptbyrmM01ZHA/ugDIE
X9bw4pLJlj7xUysI14AZm60LzKD3j8lCy7CJtOsKH7oI0fvpFGM=
=jJzh
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
