Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309EA3E4BEF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 20:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhHISOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 14:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbhHISOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 14:14:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A39BC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:14:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mD9mc-0005xR-Ht; Mon, 09 Aug 2021 20:13:54 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:b60e:a8cd:6ec5:c321])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E3D6C6637A3;
        Mon,  9 Aug 2021 18:13:49 +0000 (UTC)
Date:   Mon, 9 Aug 2021 20:13:48 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
Message-ID: <20210809181348.w64v6dryf7qlill5@pengutronix.de>
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210809132605.m76mnxkp6bdcn77c@pengutronix.de>
 <CA+V-a8uDPn83W6wi2Jq8VFrBeGSVMPMiFmXGV2z=L8xxZteFNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="72xgtvpkmtrh6noj"
Content-Disposition: inline
In-Reply-To: <CA+V-a8uDPn83W6wi2Jq8VFrBeGSVMPMiFmXGV2z=L8xxZteFNQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--72xgtvpkmtrh6noj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.08.2021 16:48:20, Lad, Prabhakar wrote:
> > > +    interrupt-names:
> > > +      items:
> > > +        - const: ch_int
> > > +        - const: g_int
> >
> > Are you adding the new interrupt-names to the existing DTs, too?
> > Otherwise this patch will generate more warnings in the existing DTs.
> >
> For non RZ/G2L family interrupt-names property is not marked as
> required property so dtbs_check won't complain. Once we have added
> interrupt names in all the SoC DTSI's we will mark it as required
> property for the rest of the SoC's.

That makes sense! Thanks for the explanation.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--72xgtvpkmtrh6noj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmERcFkACgkQqclaivrt
76nhoQf/YSZrrJlQSc6xA1DIfF9Xf3lM4xEP4c2GLVkZ80rSvPtqpWyxJSZQhXcC
Z6eSYnmrcO6idAF4JvZKE9TgwYwHdnCtTSE3DxlHrcqcWnMYHwSkpwrlb5C4uaqK
TK8AqbC1UeHG1kycIx36l3rsXrDAweEALgh4CHE2ozyUhJEVUurPCDjECBpHpuAN
VSWwiFSgfK9/aXzD/s6/4//CEeJh0cBpNWVvyAlYo92Wv+W1q63/jbJJFtWNDl/G
kwB2FMk+vvYDHbLThauRZJIVlO2P5JLgLYPt/iJ9h7Vjw0XU/dg2vp3FqAqM9VmZ
Mmc2g1OppHVtjYZZGYlfD03jYVzpGg==
=M9dG
-----END PGP SIGNATURE-----

--72xgtvpkmtrh6noj--
