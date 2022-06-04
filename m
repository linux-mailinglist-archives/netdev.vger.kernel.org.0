Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3F253D774
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 17:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbiFDPTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237603AbiFDPTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 11:19:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DF8377C3
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 08:19:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxVYM-0005PH-1N; Sat, 04 Jun 2022 17:19:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A557A8C3D6;
        Sat,  4 Jun 2022 15:19:00 +0000 (UTC)
Date:   Sat, 4 Jun 2022 17:18:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220604151859.hyywffrni4vo6gdl@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
 <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
 <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de>
 <CAMZ6RqJ7qvXyxNVUK-=oJnK_oq7N94WABOb3pqeYf9Fw3G6J9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yvdsjjm7x6ounrj4"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJ7qvXyxNVUK-=oJnK_oq7N94WABOb3pqeYf9Fw3G6J9A@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yvdsjjm7x6ounrj4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.06.2022 23:59:48, Vincent MAILHOL wrote:
> > > Fine, but I need a bit of guidance here. To provide a tag, I need to
> > > have my own git repository hosted online, right?
> >
> > That is one option.
>=20
> This suggests that there are other options? What would be those other
> options?

2. git.kernel.org (most preferred)
3. github.com (have to ask Davem/Jakub)

> > > Is GitHub OK or should I create one on https://git.kernel.org/?
> >
> > Some maintainers don't like github, let's wait what Davem and Jakub say.
> > I think for git.kernel.org you need a GPG key with signatures of 3 users
> > of git.kernel.org.
>=20
> Personally, I would also prefer getting my own git.kernel.org account.

See https://korg.docs.kernel.org/accounts.html

> It has infinitely more swag than GitHub.

Definitively!

> But my religion does not forbid me from using GitHub :)

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yvdsjjm7x6ounrj4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbd+EACgkQrX5LkNig
0109qggAk9nG3MlGY5XBeC/p+q1J00klbo5dWJ+lsLjiXMB6jjhS7x30hMg3PZ3b
9P/ozQI1bgVM5l/tWLRJ4FWnZRubJn16lhdLtj1X1nswhEH+sxFtZYi+vY/qsWtm
sMHmqZYdQIdMbW8uCmHWYzBgD3S+2cdoETwprx8uWZcGOSb61qRDDIZrvyVL8Do3
PBv5Dmrp5E5KA9QJGJ+LKQ02obWf3CZQNAdcrAAkrB9J3XVl1SZhnXmo2b+J1Jl/
hEHYJJ6eVQVJwhIa3yyJ/+KKNFHPs7iaXFlj7JE9qZvcVn3HA9uWOGdClUn17HnW
+UEvpaL+XTRKJ171OrDBDaZmCnh6BQ==
=SktK
-----END PGP SIGNATURE-----

--yvdsjjm7x6ounrj4--
