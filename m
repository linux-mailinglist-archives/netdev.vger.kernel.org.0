Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A0031330B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhBHNPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhBHNPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:15:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE432C06178C
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 05:14:23 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l96Mk-0001oz-EI; Mon, 08 Feb 2021 14:14:10 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:291f:f238:66b7:a1f0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 837DB5D950A;
        Mon,  8 Feb 2021 13:14:07 +0000 (UTC)
Date:   Mon, 8 Feb 2021 14:14:06 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: can: rcar_canfd: Group tuples in pin
 control properties
Message-ID: <20210208131406.rslj5pjijgerbky2@hardanger.blackshift.org>
References: <20210204125937.1646305-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w7uyeyiofkeeex2j"
Content-Disposition: inline
In-Reply-To: <20210204125937.1646305-1-geert+renesas@glider.be>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w7uyeyiofkeeex2j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.02.2021 13:59:37, Geert Uytterhoeven wrote:
> To improve human readability and enable automatic validation, the tuples
> in "pinctrl-*" properties should be grouped using angle brackets.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--w7uyeyiofkeeex2j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAhORsACgkQqclaivrt
76mS8wf+LIfsAtf78toTh4zBnPrAiGt8exLZ8mvpZzt/Vu2pCGi3X/a9aEI2Z/HR
lHsIQQHC3b0bY/Drv2EnOBnJ0cLFC98U95pyu8T2b8+zQEjDY18OQW9nxVagzsrV
Cmut0pQ1V12tezmeD1QdxTTTxUPJKevu2RJLCiIhtA2Q+QAqU8BgMZYi/zbBAGaL
/tNi5ffyVqXCdXoHIR77nt3bul9JJnyo/yrj1WQI6zTtTeC2uAI+21/K9E3nLK9r
oEVUiO2bDgJn2gvxyY80rj9xHSz+Mw6zWqz3MrXsOqcSig78S+tZHH+i+Ft5p1yl
x92lUCIqQvPlBYPuamYhmcFTm3qotQ==
=oc1f
-----END PGP SIGNATURE-----

--w7uyeyiofkeeex2j--
