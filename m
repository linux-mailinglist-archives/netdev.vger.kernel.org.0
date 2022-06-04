Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9E053D718
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbiFDNzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 09:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiFDNzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 09:55:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C0A32EC3
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 06:55:47 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxUFj-0005mi-Gv; Sat, 04 Jun 2022 15:55:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 922688C38A;
        Sat,  4 Jun 2022 13:55:42 +0000 (UTC)
Date:   Sat, 4 Jun 2022 15:55:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
 <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lkovggqhyysuu6pm"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
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


--lkovggqhyysuu6pm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.06.2022 22:05:09, Vincent MAILHOL wrote:
> On Sat. 4 juin 2022 at 20:46, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > Hello Vincent,
> >
> > wow! This is a great series which addresses a lot of long outstanding
> > issues. Great work!
>=20
> Thanks.
>=20
> > As this cover letter brings so much additional information I'll ask
> > Jakub and David if they take pull request from me, which itself have
> > merges. This cover letter would be part of my merge. If I get the OK,
> > can you provide this series as a tag (ideally GPG signed) that I can
> > pull?
>=20
> Fine, but I need a bit of guidance here. To provide a tag, I need to
> have my own git repository hosted online, right?

That is one option.

> Is GitHub OK or should I create one on https://git.kernel.org/?

Some maintainers don't like github, let's wait what Davem and Jakub say.
I think for git.kernel.org you need a GPG key with signatures of 3 users
of git.kernel.org.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lkovggqhyysuu6pm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbZFsACgkQrX5LkNig
010Y2wgAgxX8kYnVNKwoELlD65lF2BcHtTg0rpzAub5ezX3z0ZPXIg9i+sPMoU39
MXFnw/ls0+5D/YJr32LpaQ49sczmlcFhjITON6FqZcIu3D4NXkHQtk14a1GDN4Ca
/ze876Z3Uw1xSnid0RmsrH/W0ZKoIgRbmy/mFGD5IF7OQ1BtrGa7NrpJXxjuzRR8
rja6rI7RygDSkseIDDb0iz6LgzzWUqQzeebp/KSn0KUCX5WxqIOey4d03CyNtcSj
/Qty4+kaJK6iDgJwBG6bdoJcqXNASSyzd8Y/O90qtAoMzY90NLsS5EA3iTJtuD2n
VTBLKbUQWOr//Xap2JUFSKSK1hXpsg==
=w8Ar
-----END PGP SIGNATURE-----

--lkovggqhyysuu6pm--
