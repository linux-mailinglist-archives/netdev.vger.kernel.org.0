Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFE63EF303
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhHQUCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbhHQUCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 16:02:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADB7C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 13:01:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mG5H4-0008Vq-GQ; Tue, 17 Aug 2021 22:01:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:4c82:b09e:fec8:3248])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E577966923E;
        Tue, 17 Aug 2021 20:01:24 +0000 (UTC)
Date:   Tue, 17 Aug 2021 22:01:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Message-ID: <20210817200123.4wcdwsdfsdjr3ovk@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
 <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
 <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <20210816134342.w3bc5zjczwowcjr4@pengutronix.de>
 <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fgszt33qh4cysmqa"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fgszt33qh4cysmqa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.08.2021 00:49:35, Vincent MAILHOL wrote:
> > We have 4 operations:
> > - tdc-mode off                  switch off tdc altogether
> > - tdc-mode manual tdco X tdcv Y configure X and Y for tdco and tdcv
> > - tdc-mode auto tdco X          configure X tdco and
> >                                 controller measures tdcv automatically
> > - /* nothing */                 configure default value for tdco
> >                                 controller measures tdcv automatically
>=20
> The "nothing" does one more thing: it decides whether TDC should
> be activated or not.
>=20
> > The /* nothing */ operation is what the old "ip" tool does, so we're
> > backwards compatible here (using the old "ip" tool on an updated
> > kernel/driver).
>=20
> That's true but this isn't the real intent. By doing this design,
> I wanted the user to be able to transparently use TDC while
> continuing to use the exact same ip commands she or he is used
> to using.

Backwards compatibility using an old ip tool on a new kernel/driver must
work. In case of the mcp251xfd the tdc mode must be activated and tdcv
set to the automatic calculated value and tdco automatically measured.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fgszt33qh4cysmqa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEcFZAACgkQqclaivrt
76kISAgArgGcU281RHaeyZUy9SjeALqqLzwDzBizUD8/TDKXcOCcPAALwCUcvm9x
bl9gCKZ1o74Fpgy5zWW7j5i45oMSqjZjsc28uCm6jilOufzgFlYF1BZRCBe3RU4h
kXfhw2QOVFbC4Oj8ms6Ef9rhBy4yZWG6yHXP+kha/DtK2aQYRHJaAUcaZsO0svBI
24ZUrdpfE/JVzKYSEeyJ+kqPQ1dasfA8YTS+3fUAnrGCNqRSwy+l5airszziNzqn
IPBK5faP6XsyeHlVDXSGImq51A75TCpYweaNJwuiJTJg9AByOed2G/v2XVOju0UO
0tedqIa4SpxwS0LtH3xsJmKV6O0l5A==
=cADg
-----END PGP SIGNATURE-----

--fgszt33qh4cysmqa--
