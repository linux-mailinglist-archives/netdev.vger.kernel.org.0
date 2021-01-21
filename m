Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7B2FE6A4
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbhAUJpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbhAUJpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:45:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E9EC0613C1
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:44:34 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2WVt-0007QS-Bo; Thu, 21 Jan 2021 10:44:25 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:37fb:eadb:47a3:78d5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 634405C98FE;
        Thu, 21 Jan 2021 09:44:23 +0000 (UTC)
Date:   Thu, 21 Jan 2021 10:44:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Su <suyanjun218@gmail.com>
Cc:     manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: mcp251xfd: replace sizeof(u32) with val_bytes in
 regmap
Message-ID: <20210121094422.h5tjjyhsn7gvhlrm@hardanger.blackshift.org>
References: <20210121091005.74417-1-suyanjun218@gmail.com>
 <20210121092115.dasphwfzfkthcy64@hardanger.blackshift.org>
 <5ed3d488-3ea6-cc07-a04d-73a6678d772a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zrug2yvgvouevx6t"
Content-Disposition: inline
In-Reply-To: <5ed3d488-3ea6-cc07-a04d-73a6678d772a@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zrug2yvgvouevx6t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 05:33:40PM +0800, Su wrote:
> The sizeof(u32) is hardcoded. IMO it's better to use the config value in
> regmap.

I got why you want to change this. Please update the patch description, com=
ment
on the increase of the object size and address the other issues I pointed o=
ut.
I think it makes no sense to have the function mcp251xfd_get_val_bytes() as=
 you
have to use several regmaps anyways.

> > > No functional effect.
> > Not quite:
> >=20
> > scripts/bloat-o-meter shows:
> >=20
> > add/remove: 0/0 grow/shrink: 3/0 up/down: 104/0 (104)
> > Function                                     old     new   delta
> > mcp251xfd_handle_tefif                       980    1028     +48
> > mcp251xfd_irq                               3716    3756     +40
> > mcp251xfd_handle_rxif_ring                   964     980     +16
> > Total: Before=3D20832, After=3D20936, chg +0.50%

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zrug2yvgvouevx6t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAJTPQACgkQqclaivrt
76kmLAf/Yexh9D+O2IOdOK2R9xP9k0PGIxsk6HhUz2wMqvIP8HBRd/Tuqj+5hFQU
NO17xotVj9XVvvYHSI4mp8zfMyLVz7rylzimdLuxrGDaKmeMA+txcEU6BASpkXpy
OadMbHTaor2CZt4blUVeeQcTGKhwH35cSIaRfXLcDr5dZADwwQcz5l1TkNe4dxEw
9qFaWENDjwoqnkwFVjQGVCM04kthvcQA8kRtwq0ne3VpoiyY1phSbzYO784CO3+F
+uj0zJUNqUwpa5zA2HG6zby4h4af2hca8mdZQNlAmgyJzTCmQ9rjpPGHKiBuSZ+A
PPN08M3HNARYwFYda7Qwhs9XW2t36Q==
=stZm
-----END PGP SIGNATURE-----

--zrug2yvgvouevx6t--
